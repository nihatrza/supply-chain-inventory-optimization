-- ====================================================================
-- SUPPLY CHAIN ANALYTICS: DATA IMPORT & VERIFICATION
-- Database: PostgreSQL
-- Repository Path: sql/02_data_import.sql
-- ====================================================================

-- 1. Truncate table before import (prevents duplicate key/data entry)
TRUNCATE TABLE fact_inventory_daily;

-- 2. Bulk load data from processed CSV file
-- Note: Replace '/path/to/processed_inventory_data.csv' with your local absolute file path.
COPY fact_inventory_daily (
    date,
    sku_id,
    region,
    warehouse_id,
    supplier_id,
    inventory_level,
    units_sold,
    unit_price,
    unit_cost,
    total_revenue,
    total_cost,
    profit,
    profit_margin,
    lost_revenue,
    demand_forecast,
    forecast_error,
    abs_forecast_error,
    promotion_flag,
    stockout_flag,
    below_reorder_flag,
    supplier_lead_time_days,
    reorder_point,
    safety_stock,
    order_quantity
)
FROM '/path/to/processed_inventory_data.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ',',
    ENCODING 'UTF8'
);

-- ====================================================================
-- DATA INTEGRITY CHECKS
-- ====================================================================

-- Verify total row count loaded
SELECT COUNT(*) AS total_rows_imported FROM fact_inventory_daily;

-- Verify sample records and structure
SELECT 
    date, 
    sku_id, 
    region, 
    total_revenue, 
    profit, 
    profit_margin 
FROM fact_inventory_daily 
LIMIT 5;