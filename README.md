# 📦 Supply Chain & Inventory Optimization Analytics

![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![DAX](https://img.shields.io/badge/DAX-Optimization-blue?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)

An enterprise-grade, end-to-end Analytics Engineering project designed to optimize inventory levels, mitigate reorder risk, evaluate demand forecast accuracy, and streamline supplier logistics using **Python (ETL), PostgreSQL (Data Warehouse), and Power BI (Multi-Page Interactive Dashboard)**.

---

## 📋 Table of Contents
- [Executive Summary](#-executive-summary)
- [System Architecture](#-system-architecture)
- [Key Business Insights](#-key-business-insights)
- [Repository Structure](#-repository-structure)
- [Data Pipeline & ETL Workflow](#-data-pipeline--etl-workflow)
- [Database Schema & SQL Query Library](#-database-schema--sql-query-library)
- [Power BI Dashboard Architecture](#-power-bi-dashboard-architecture)
- [DAX Measure Library](#-dax-measure-library)
- [How to Reproduce](#-how-to-reproduce)
- [Author & Contact](#-author--contact)

---

## 📑 Executive Summary

In global supply chain management, balancing product availability against holding costs is critical. Excess inventory locks up working capital, while unexpected stockouts cause lost revenue and customer attrition.

This project analyzes **91,250 daily operational records** across 50 SKUs, 10 suppliers, and 5 regional distribution warehouses. By building a single-fact data warehouse architecture and an interactive 5-page Power BI dashboard, this solution enables executives to:
- Monitor financial profit margins and capital tie-up across product price tiers.
- Diagnose forecast errors using statistical metrics (**WAPE %** and **Forecast Bias %**).
- Identify reorder risks and supplier lead-time bottlenecks before stockout events occur.
- Evaluate promotional campaign profitability without eroding gross margins.

---

## 🏗 System Architecture

```
                             DATA ARCHITECTURE PIPELINE

┌────────────────────────┐     ┌────────────────────────────┐     ┌───────────────────────────┐
│    Raw Data (CSV)       │     │   Python ETL Pipeline       │     │  PostgreSQL Data Warehouse │
│  - 91,250 Daily Rows    │ ─▶  │  - Cleaning & Null Audits   │ ─▶  │  - Single-Fact Schema      │
│  - 15 Operational Cols  │     │  - Feature Engineering      │     │  - Performance Indexes     │
└────────────────────────┘     │  - 24 Final Columns         │     │  - Analytical SQL Library  │
                                └────────────────────────────┘     └───────────────────────────┘
                                                                                 │
                                                                                 ▼
                                                                  ┌───────────────────────────┐
                                                                  │   Power BI Dashboard       │
                                                                  │  - Dynamic DAX Engine      │
                                                                  │  - 5 Interactive Pages     │
                                                                  │  - C-Level Insights        │
                                                                  └───────────────────────────┘
```

---

## 💡 Key Business Insights

### 1. Financial & Sales Performance

#### 📈 Regional Top-Performing SKUs
- **Universal Bestseller (`SKU_38`):** Ranks as the **#1 profit-generating product** across ALL 4 geographic regions (North, South, East, West). Peak profits were recorded in the South (**$96.1K**) and North (**$94.2K**) regions.
- **Consistent Runner-Up (`SKU_40`):** Holds the **#2 spot** in overall profitability across all regions without exception (**$84.6K – $93.9K** range).
- **Regional Variation:** While `SKU_11` secures #3 rank in East, North, and West regions, `SKU_20` (**$81.8K**) replaces it as the #3 product specifically in the South.

#### 💰 Price Segmentation & Margin Dynamics
- **Profitability Champion (High Price):** High-value products ($25+) yield the highest profitability margin at **37.96%**.
- **Capital Concentration (Mid Price):** Mid-range products ($15–$24) account for the vast majority of tied-up inventory capital (**$255.56M**) and drive the bulk of total profit volume (**$4.80M**) across 49 SKUs.
- **Volume Mobility (Low Price):** Low-cost products ($123.18M holding capital) provide consistent inventory turnover with a stable **30.85% profit margin**.

#### 🎯 Promotional Campaign Efficiency
- **Margin Integrity:** Profit margins on promotional days (**32.13%**) remained almost identical to regular sales days (**32.17%**), showing zero margin erosion.
- **Targeted Volume Lift:** Campaigns successfully increased sales volume (**230.9K units**) and revenue (**$4.23M**) without sacrificing product profitability.

---

### 2. Inventory Control & Forecasting Analytics

#### 🔄 Inventory Velocity & Sales Dynamics (Stock-to-Sales)
- **High Turnover Velocity:** Top SKUs (`SKU_38`, `SKU_40`, `SKU_17`) maintain an aggressive **Stock-to-Sales ratio of 0.01**.
- **Lean Stock Management:** Despite holding an average daily inventory of 438–491 units, annual sales exceed 36K+ units per SKU, proving **zero slow-moving or dead inventory** in the warehouses.

#### 📉 Monthly Forecast Error Dynamics (WAPE % Trend)
- **Optimal High-Volume Months (Jan – Jun):** Forecasting precision is highest during peak sales months, keeping the Weighted Absolute Percentage Error (**WAPE**) low at **7.96% – 10.59%**.
- **Off-Peak Forecast Variance (Sep – Oct):** As sales volumes dip in H2 (peaking at a low of 76.3K units in September), WAPE error spikes to **22.80%**, indicating over-forecasting during low-demand periods.

---

### 3. Supply Chain & Warehouse Logistics

#### 🚚 Supplier Portfolio & Lead-Time Efficiency
- **Revenue Dominant Supplier (`SUP_7`):** Generates the highest total revenue for the company at **$4.45M** across 248.8K units sold.
- **Delivery Velocity:** `SUP_5` delivers the fastest fulfillment cycle with an average lead time of **7.0 days**, while `SUP_4` records the longest cycle (**8.6 days**).
- **Proportional Reorder Risk:** Reorder risk events correlate directly with total operational days, maintaining a stable **~5.5% risk rate** across all active suppliers.

#### 🏭 Warehouse Operational Efficiency Matrix
- **Logistics Hub Leader (`WH_2`):** Generates the highest overall revenue (**$7.40M**) and net profit (**$2.41M**).
- **Balanced Workload Allocation:** All 5 distribution centers manage exactly 50 SKUs each with evenly distributed reorder risks (**~1,000 risk events per warehouse**). `WH_1` recorded the lowest revenue generation (**$6.27M**).

---

## 📂 Repository Structure

```text
supply-chain-inventory-optimization/
│
├── data/
│   ├── raw/                             # Original raw dataset (supply_chain_dataset1.csv)
│   └── processed/                       # Cleaned & modeled CSV files (fact_inventory_daily.csv, dim_date.csv)
│
├── notebooks/
│   ├── 01_data_preprocessing_etl.ipynb   # Python data cleaning, validation & feature engineering
│   └── 02_data_modeling_extraction.ipynb # Dimensional extraction & data schema modeling
│
├── sql/
│   ├── 01_schema.sql                     # PostgreSQL table creation schema & indexes
│   ├── 02_data_import.sql                # Data loading & integrity verification scripts
│   └── 03_analytical_queries.sql         # Advanced SQL query library (Window Functions, CTEs)
│
├── power_bi/
│   ├── Supply_Chain_Analytics.pbix       # Master Power BI report file
│   └── dax_measures.md                   # Full library of custom DAX calculations
│
├── docs/
│   └── screenshots/                      # Dashboard high-resolution exports
│       ├── page1_overview.png
│       ├── page2_inventory.png
│       ├── page3_stock_risk.png
│       ├── page4_demand_forecast.png
│       └── page5_warehouse_supplier.png
│
├── .gitignore                            # Environment & system file exclusion rules
├── LICENSE                               # MIT License
└── README.md                             # Master project documentation
```

---

## 🛠 Data Pipeline & ETL Workflow

**Step 1: Python Processing (`01_data_preprocessing_etl.ipynb`)**
- Conducted duplicate audits (0 duplicates) and missing value verification (0 nulls).
- Standardized schema headers to snake_case for PostgreSQL compatibility.
- Executed Feature Engineering:
  - **Financials:** `total_revenue`, `total_cost`, `profit`, `profit_margin`.
  - **Stock Risks:** `below_reorder_flag` (Inventory ≤ Reorder Point), `lost_sales_units`, `lost_revenue`.
  - **Forecast Variance:** `forecast_error`, `abs_forecast_error`.

**Step 2: Dimensional Modeling (`02_data_modeling_extraction.ipynb`)**
- Extracted a normalized Date Dimension (`dim_date`) featuring calendar hierarchies (year, quarter, month, month_name, day_name, day_of_week).
- Formatted the primary 24-column Fact Table (`fact_inventory_daily`) for optimized data warehouse loading.

---

## 🗄 Database Schema & SQL Query Library

### PostgreSQL Table Schema (`01_schema.sql`)

```sql
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
```

### Sample Analytical Query: Regional Top SKUs (`03_analytical_queries.sql`)

```sql
WITH RegionalProfit AS (
    SELECT 
        region,
        sku_id,
        ROUND(SUM(profit), 2) AS total_profit,
        DENSE_RANK() OVER (PARTITION BY region ORDER BY SUM(profit) DESC) AS rank_in_region
    FROM fact_inventory_daily
    GROUP BY region, sku_id
)
SELECT region, sku_id, total_profit
FROM RegionalProfit
WHERE rank_in_region <= 3
ORDER BY region, rank_in_region;
```

---

## 📊 Power BI Dashboard Architecture

The dashboard features a dark corporate UI theme designed for executive usability and fast diagnostic workflow across 5 pages:

### 1️⃣ Executive Overview
High-level executive scorecard tracking Total Revenue ($33.43M), Profit ($11M), Profit Margin (33.2%), regional performance breakdown, and overall Inventory Health (94.48%).

![Overview](asseets/page1_overview.png)

### 2️⃣ Inventory Performance
Product-level holding costs, unit cost vs. price correlation, price tier segmentation (Low, Mid, High), and revenue drivers.

![Inventory Performance](asseets/page2_inventory.png)

### 3️⃣ Stock & Risk Analysis
Reorder risk trends, stockout occurrences, regional risk allocation, and critical risk matrices.

![Stock & Risk Analysis](asseets/page3_stock_risk.png)

### 4️⃣ Demand & Forecast
Advanced forecasting diagnostics, WAPE % tracking, Forecast Bias, weekly demand patterns, and promotional lift evaluation.

![Demand & Forecast](asseets/page4_demand_forecast.png)

### 5️⃣ Warehouse & Supplier Performance
Fulfillment lead-time analysis, supplier risk evaluation, delayed order tracking, and warehouse profitability equity.

![Warehouse & Supplier Performance](asseets/page5_warehouse_supplier.png)

---

## 📐 DAX Measure Library

Below are key custom DAX measures implemented in the report:

```dax
// 1. Weighted Absolute Percentage Error (WAPE %)
WAPE % = 
DIVIDE(
    SUM(fact_inventory_daily[abs_forecast_error]),
    SUM(fact_inventory_daily[units_sold]),
    0
)

// 2. Forecast Accuracy %
Forecast Accuracy = 1 - [WAPE %]

// 3. Forecast Bias %
Forecast Bias % = 
DIVIDE(
    SUM(fact_inventory_daily[forecast_error]),
    SUM(fact_inventory_daily[units_sold]),
    0
)

// 4. Reorder Risk Rate %
Reorder Risk Rate = 
DIVIDE(
    SUM(fact_inventory_daily[below_reorder_flag]),
    COUNT(fact_inventory_daily[date]),
    0
)

// 5. Inventory Health Score %
Inventory Health Score = 1 - [Reorder Risk Rate]

// 6. Total Capital Value in Inventory
Total Inventory Value = 
SUMX(
    fact_inventory_daily,
    fact_inventory_daily[inventory_level] * fact_inventory_daily[unit_cost]
)
```

---

## 🚀 How to Reproduce

**1. Repository Setup**
```bash
git clone https://github.com/nihatrza/supply-chain-inventory-optimization.git
cd supply-chain-inventory-optimization
```

**2. Python Environment & Data Pipeline**
```bash
pip install -r requirements.txt
jupyter notebook notebooks/01_data_preprocessing_etl.ipynb
```

**3. PostgreSQL Database Import**
- Open pgAdmin or the psql shell.
- Create database `supply_chain_db`.
- Run `sql/01_schema.sql` to instantiate the schema and indexes.
- Run `sql/02_data_import.sql`, updating the file path to load the data.
- Execute `sql/03_analytical_queries.sql` to run ad-hoc queries.

**4. Power BI Dashboard**
- Open `power_bi/Supply_Chain_Analytics.pbix` in Power BI Desktop.
- Update data source credentials under `Transform Data → Data Source Settings`, pointing to your local PostgreSQL instance.

---

## 👤 Author & Contact

**Nihat Rzaguluzada**
Data Analyst / Analytics Engineer

🌐 LinkedIn: [linkedin.com/in/nihat-rzaguluzada](https://linkedin.com/in/nihat-rzaguluzada)
🐙 GitHub: [github.com/nihatrza](https://github.com/nihatrza)
