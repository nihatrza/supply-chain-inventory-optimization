-- ====================================================================
-- SUPPLY CHAIN ANALYTICS: AD-HOC ANALYTICAL QUERIES
-- Database: PostgreSQL
-- Table: fact_inventory_daily
-- Repository Path: sql/03_analytical_queries.sql
-- ====================================================================

-- --------------------------------------------------------------------
-- 1. Top 3 Profit-Generating SKUs per Region
-- Business Objective: Identify top-performing products within each geographic 
-- region using dense ranking window functions.
-- --------------------------------------------------------------------
WITH RegionalProfit AS (
    SELECT 
        region,
        sku_id,
        ROUND(SUM(profit), 2) AS total_profit,
        DENSE_RANK() OVER (PARTITION BY region ORDER BY SUM(profit) DESC) AS rank_in_region
    FROM fact_inventory_daily
    GROUP BY region, sku_id
)
SELECT 
    region,
    sku_id,
    total_profit
FROM RegionalProfit
WHERE rank_in_region <= 3
ORDER BY region, rank_in_region;


-- --------------------------------------------------------------------
-- 2. Supplier Risk & Financial Impact Analysis
-- Business Objective: Evaluate supplier fulfillment efficiency, reorder risk 
-- occurrences, average lead time, and total generated revenue.
-- --------------------------------------------------------------------
SELECT 
    supplier_id,
    COUNT(*) AS total_operational_days,
    SUM(below_reorder_flag) AS reorder_risk_events,
    ROUND(AVG(supplier_lead_time_days), 1) AS avg_lead_time_days,
    ROUND(SUM(units_sold), 0) AS total_units_sold,
    ROUND(SUM(total_revenue), 2) AS total_revenue_generated
FROM fact_inventory_daily
GROUP BY supplier_id
ORDER BY reorder_risk_events DESC;


-- --------------------------------------------------------------------
-- 3. Price Tier Segmentation & Margin Dynamics
-- Business Objective: Analyze inventory holding cost, profit contribution, 
-- and profit margins across High, Mid, and Low unit price tiers.
-- --------------------------------------------------------------------
SELECT 
    CASE 
        WHEN unit_price >= 25 THEN 'High Price ($25+)'
        WHEN unit_price >= 15 THEN 'Mid Price ($15-$24)'
        ELSE 'Low Price (<$15)'
    END AS price_category,
    COUNT(DISTINCT sku_id) AS sku_count,
    ROUND(SUM(inventory_level * unit_cost), 2) AS total_holding_cost,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(profit_margin) * 100, 2) AS avg_profit_margin_pct
FROM fact_inventory_daily
GROUP BY 1
ORDER BY total_holding_cost DESC;


-- --------------------------------------------------------------------
-- 4. Monthly Forecast Accuracy & WAPE % Trend
-- Business Objective: Calculate monthly Weighted Absolute Percentage Error 
-- (WAPE %) to evaluate demand forecasting model precision over time.
-- --------------------------------------------------------------------
SELECT 
    TO_CHAR(date, 'YYYY-MM') AS month_year,
    ROUND(SUM(abs_forecast_error), 2) AS total_abs_error,
    ROUND(SUM(units_sold), 2) AS total_actual_sales,
    ROUND((SUM(abs_forecast_error) / NULLIF(SUM(units_sold), 0)) * 100, 2) AS wape_percentage
FROM fact_inventory_daily
GROUP BY 1
ORDER BY month_year;


-- --------------------------------------------------------------------
-- 5. Promotional vs. Regular Sales Performance
-- Business Objective: Assess the financial impact of promotional campaigns 
-- on sales volume, revenue, profit, and margin preservation.
-- --------------------------------------------------------------------
SELECT 
    CASE WHEN promotion_flag = 1 THEN 'Promotional Days' ELSE 'Regular Days' END AS sales_type,
    COUNT(*) AS total_days_count,
    ROUND(SUM(units_sold), 0) AS total_units_sold,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(profit_margin) * 100, 2) AS avg_profit_margin_pct
FROM fact_inventory_daily
GROUP BY promotion_flag;


-- --------------------------------------------------------------------
-- 6. Inventory Velocity & Stock-to-Sales Ratio
-- Business Objective: Measure inventory turnover speed to pinpoint potential 
-- overstocking or slow-moving SKUs based on Stock-to-Sales ratio.
-- --------------------------------------------------------------------
SELECT 
    sku_id,
    ROUND(AVG(inventory_level), 0) AS avg_inventory_held,
    ROUND(SUM(units_sold), 0) AS total_units_sold,
    ROUND(AVG(inventory_level) / NULLIF(SUM(units_sold), 0), 2) AS stock_to_sales_ratio,
    ROUND(SUM(profit), 2) AS total_profit
FROM fact_inventory_daily
GROUP BY sku_id
ORDER BY stock_to_sales_ratio DESC
LIMIT 10;


-- --------------------------------------------------------------------
-- 7. Warehouse Operational & Profitability Matrix
-- Business Objective: Compare logistics hub performance regarding inventory 
-- holding volume, revenue generation, net profit, and reorder risk exposure.
-- --------------------------------------------------------------------
SELECT 
    warehouse_id,
    COUNT(DISTINCT sku_id) AS total_skus_handled,
    ROUND(AVG(inventory_level), 0) AS avg_daily_stock,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    SUM(below_reorder_flag) AS total_reorder_risks
FROM fact_inventory_daily
GROUP BY warehouse_id
ORDER BY total_profit DESC;