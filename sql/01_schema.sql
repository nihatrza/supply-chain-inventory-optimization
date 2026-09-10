-- ====================================================================
-- SUPPLY CHAIN ANALYTICS: SCHEMA CREATION
-- Database: PostgreSQL
-- Table: fact_inventory_daily (24 Columns)
-- Repository Path: sql/01_schema.sql
-- ====================================================================

-- Drop table if it already exists to ensure clean execution
DROP TABLE IF EXISTS fact_inventory_daily;

-- Create single-fact table optimized for analytical querying
CREATE TABLE fact_inventory_daily (
    date                    DATE NOT NULL,
    sku_id                  VARCHAR(50) NOT NULL,
    region                  VARCHAR(50) NOT NULL,
    warehouse_id            VARCHAR(50) NOT NULL,
    supplier_id             VARCHAR(50) NOT NULL,
    inventory_level         INT NOT NULL,
    units_sold              INT NOT NULL,
    unit_price              NUMERIC(10, 2) NOT NULL,
    unit_cost               NUMERIC(10, 2) NOT NULL,
    total_revenue           NUMERIC(12, 2) NOT NULL,
    total_cost              NUMERIC(12, 2) NOT NULL,
    profit                  NUMERIC(12, 2) NOT NULL,
    profit_margin           NUMERIC(6, 4) NOT NULL,
    lost_revenue            NUMERIC(12, 2) DEFAULT 0.00,
    demand_forecast         NUMERIC(10, 2) NOT NULL,
    forecast_error          NUMERIC(10, 2) NOT NULL,
    abs_forecast_error      NUMERIC(10, 2) NOT NULL,
    promotion_flag          INT DEFAULT 0,
    stockout_flag           INT DEFAULT 0,
    below_reorder_flag      INT DEFAULT 0,
    supplier_lead_time_days INT NOT NULL,
    reorder_point           INT NOT NULL,
    safety_stock            INT NOT NULL,
    order_quantity          INT NOT NULL
);

-- ====================================================================
-- PERFORMANCE OPTIMIZATION (INDEXES)
-- ====================================================================

-- Index on primary filtering dimension (Date)
CREATE INDEX idx_fact_inventory_date ON fact_inventory_daily(date);

-- Index on primary analysis attributes
CREATE INDEX idx_fact_inventory_sku ON fact_inventory_daily(sku_id);
CREATE INDEX idx_fact_inventory_region ON fact_inventory_daily(region);
CREATE INDEX idx_fact_inventory_supplier ON fact_inventory_daily(supplier_id);
CREATE INDEX idx_fact_inventory_warehouse ON fact_inventory_daily(warehouse_id);