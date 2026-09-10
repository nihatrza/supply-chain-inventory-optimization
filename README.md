# 📦 Tədarük Zənciri və Anbar Optimallaşdırması Analitikası

![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![DAX](https://img.shields.io/badge/DAX-Optimization-blue?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)

Anbar səviyyələrini optimallaşdırmaq, yenidən sifariş riskini azaltmaq, tələb proqnozunun dəqiqliyini qiymətləndirmək və təchizatçı logistikasını sadələşdirmək üçün hazırlanmış tam həcmli, uçdan-uca Analytics Engineering layihəsi. Layihə **Python (ETL), PostgreSQL (Data Warehouse) və Power BI (çoxsəhifəli interaktiv dashboard)** üzərində qurulub.

---

## 📋 Mündəricat
- [İcmal](#-icmal)
- [Sistem Arxitekturası](#-sistem-arxitekturası)
- [Əsas Biznes Nəticələri](#-əsas-biznes-nəticələri)
- [Repository Strukturu](#-repository-strukturu)
- [Data Pipeline və ETL Prosesi](#-data-pipeline-və-etl-prosesi)
- [Verilənlər Bazası Sxemi və SQL Sorğu Kitabxanası](#-verilənlər-bazası-sxemi-və-sql-sorğu-kitabxanası)
- [Power BI Dashboard Arxitekturası](#-power-bi-dashboard-arxitekturası)
- [DAX Ölçü Kitabxanası](#-dax-ölçü-kitabxanası)
- [Necə Təkrarlamaq Olar](#-necə-təkrarlamaq-olar)
- [Müəllif və Əlaqə](#-müəllif-və-əlaqə)

---

## 📑 İcmal

Qlobal tədarük zənciri idarəçiliyində məhsul mövcudluğu ilə saxlama xərcləri arasında balans yaratmaq həlledicidir. Artıq anbar dövriyyə kapitalını dondurur, gözlənilməz stok-out isə gəlir itkisinə və müştəri itkisinə səbəb olur.

Bu layihə **50 SKU, 10 təchizatçı və 5 regional distribusiya anbarı** üzrə **91,250 gündəlik əməliyyat qeydini** təhlil edir. Tək-fakt (single-fact) data warehouse arxitekturası və interaktiv 5-səhifəlik Power BI dashboard qurmaqla, bu həll rəhbərliyə imkan verir ki:
- Məhsul qiymət qrupları üzrə maliyyə mənfəət marjasını və dondurulmuş kapitalı izləsin.
- Statistik göstəricilər (**WAPE %** və **Forecast Bias %**) vasitəsilə proqnoz xətalarını diaqnoz etsin.
- Stok-out baş verməzdən əvvəl yenidən sifariş risklərini və təchizatçı çatdırılma müddəti darboğazlarını müəyyən etsin.
- Promo kampaniyaların gəlirliliyini, ümumi mənfəət marjasını aşındırmadan qiymətləndirsin.

---

## 🏗 Sistem Arxitekturası

```
                          DATA ARXİTEKTURA PIPELINE

┌────────────────────────┐     ┌────────────────────────────┐     ┌───────────────────────────┐
│   Xam Data (CSV)        │     │   Python ETL Pipeline       │     │  PostgreSQL Data Warehouse │
│   - 91,250 gündəlik sətir│ ─▶ │  - Təmizləmə & Null Audit   │ ─▶  │  - Single-Fact Sxem        │
│   - 15 operativ sütun   │     │  - Feature Engineering      │     │  - Performans İndeksləri   │
└────────────────────────┘     │  - 24 final sütun           │     │  - Analitik SQL Kitabxanası│
                                └────────────────────────────┘     └───────────────────────────┘
                                                                                 │
                                                                                 ▼
                                                                  ┌───────────────────────────┐
                                                                  │   Power BI Dashboard       │
                                                                  │  - Dinamik DAX Mühərriki   │
                                                                  │  - 5 İnteraktiv Səhifə     │
                                                                  │  - C-Level İçgörülər       │
                                                                  └───────────────────────────┘
```

---

## 💡 Əsas Biznes Nəticələri

### 1. Maliyyə və Satış Performansı

#### 📈 Regional Lider SKU-lar
- **Universal Bestseller (`SKU_38`):** Bütün 4 coğrafi region (Şimal, Cənub, Şərq, Qərb) üzrə **#1 mənfəət gətirən məhsul**dur. Ən yüksək mənfəət Cənub (**96.1K $**) və Şimal (**94.2K $**) regionlarında qeydə alınıb.
- **Sabit İkinci (`SKU_40`):** Bütün regionlar üzrə istisnasız olaraq ümumi gəlirlilikdə **#2 yeri** tutur (**84.6K $ – 93.9K $** aralığında).
- **Regional Fərqlilik:** `SKU_11` Şərq, Şimal və Qərb regionlarında #3 yerdə olsa da, Cənubda bu yeri `SKU_20` (**81.8K $**) tutur.

#### 💰 Qiymət Seqmentasiyası və Marja Dinamikası
- **Mənfəət Çempionu (Yüksək Qiymət):** 25 $ və yuxarı dəyərli məhsullar ən yüksək gəlirlilik marjasını — **37.96%** — göstərir.
- **Kapital Konsentrasiyası (Orta Qiymət):** 15–24 $ aralığındakı məhsullar dondurulmuş anbar kapitalının böyük hissəsini (**255.56M $**) və 49 SKU üzrə ümumi mənfəət həcminin (**4.80M $**) əsas hissəsini təşkil edir.
- **Həcm Mobilliyi (Aşağı Qiymət):** Aşağı qiymətli məhsullar (123.18M $ dondurulmuş kapital) sabit **30.85%** mənfəət marjası ilə davamlı anbar dövriyyəsi təmin edir.

#### 🎯 Promo Kampaniya Effektivliyi
- **Marja Bütövlüyü:** Promo günlərində mənfəət marjası (**32.13%**) adi satış günlərinə (**32.17%**) demək olar ki, eyni qalıb — marja aşınması sıfırdır.
- **Hədəflənmiş Həcm Artımı:** Kampaniyalar məhsul gəlirliliyinə xələl gətirmədən satış həcmini (**230.9K vahid**) və gəliri (**4.23M $**) artırıb.

---

### 2. Anbar Nəzarəti və Proqnozlaşdırma Analitikası

#### 🔄 Anbar Sürəti və Satış Dinamikası (Stock-to-Sales)
- **Yüksək Dövriyyə Sürəti:** Lider SKU-lar (`SKU_38`, `SKU_40`, `SKU_17`) aqressiv **0.01 Stock-to-Sales** nisbətini saxlayır.
- **Səmərəli Anbar İdarəçiliyi:** Orta gündəlik 438–491 vahid anbar olsa da, illik satış hər SKU üzrə 36K+ vahidi ötür — bu, **passiv və ya "ölü" anbarın olmadığını** sübut edir.

#### 📉 Aylıq Proqnoz Xətası Dinamikası (WAPE % Trendi)
- **Optimal Yüksək Həcm Ayları (Yan – İyun):** Proqnoz dəqiqliyi ən pik satış aylarında ən yüksəkdir — Çəkili Mütləq Faiz Xətası (**WAPE**) 7.96% – 10.59% aralığında qalır.
- **Aşağı-Piklik Proqnoz Fərqi (Sen – Okt):** İkinci yarıilin satış həcmi düşdükcə (sentyabrda 76.3K vahidlə minimuma çatır), WAPE xətası **22.80%**-ə qədər sıçrayır — bu, aşağı tələb dövründə həddindən artıq proqnozlaşdırmaya işarədir.

---

### 3. Tədarük Zənciri və Anbar Logistikası

#### 🚚 Təchizatçı Portfeli və Çatdırılma Müddəti Səmərəliliyi
- **Gəlir Lideri Təchizatçı (`SUP_7`):** 248.8K satılmış vahid üzərindən şirkətə ən yüksək ümumi gəliri — **4.45M $** — gətirir.
- **Çatdırılma Sürəti:** `SUP_5` ən sürətli çatdırılma dövrünə malikdir — orta **7.0 gün**, `SUP_4` isə ən uzun dövrə malikdir (**8.6 gün**).
- **Proporsional Yenidən Sifariş Riski:** Yenidən sifariş risk hadisələri ümumi əməliyyat günləri ilə birbaşa korrelyasiya edir, bütün aktiv təchizatçılar üzrə sabit **~5.5% risk dərəcəsini** saxlayır.

#### 🏭 Anbar Əməliyyat Səmərəliliyi Matrisi
- **Logistika Mərkəzi Lideri (`WH_2`):** Ən yüksək ümumi gəliri (**7.40M $**) və xalis mənfəəti (**2.41M $**) göstərir.
- **Balanslaşdırılmış İş Yükü Bölgüsü:** Bütün 5 distribusiya mərkəzi eyni sayda — 50 SKU — idarə edir və yenidən sifariş riskləri bərabər paylanıb (**~1,000 risk hadisəsi hər anbar üzrə**). `WH_1` ən aşağı gəliri (**6.27M $**) qeydə alıb.

---

## 📂 Repository Strukturu

```text
supply-chain-inventory-optimization/
│
├── data/
│   ├── raw/                             # Orijinal xam data (supply_chain_dataset1.csv)
│   └── processed/                       # Təmizlənmiş və modelləşdirilmiş CSV faylları (fact_inventory_daily.csv, dim_date.csv)
│
├── notebooks/
│   ├── 01_data_preprocessing_etl.ipynb   # Python data təmizləmə, validasiya və feature engineering
│   └── 02_data_modeling_extraction.ipynb # Ölçü (dimension) çıxarılması və data sxem modelləşdirilməsi
│
├── sql/
│   ├── 01_schema.sql                     # PostgreSQL cədvəl sxemi və indekslər
│   ├── 02_data_import.sql                # Data yüklənməsi və bütövlük yoxlama skriptləri
│   └── 03_analytical_queries.sql         # Qabaqcıl SQL sorğu kitabxanası (Window Functions, CTE-lər)
│
├── power_bi/
│   ├── Supply_Chain_Analytics.pbix       # Əsas Power BI hesabat faylı
│   └── dax_measures.md                   # Bütün DAX ölçülərinin tam kitabxanası
│
├── docs/
│   └── screenshots/                      # Dashboard yüksək keyfiyyətli ekran görüntüləri
│       ├── page1_overview.png
│       ├── page2_inventory.png
│       ├── page3_stock_risk.png
│       ├── page4_demand_forecast.png
│       └── page5_warehouse_supplier.png
│
├── .gitignore                            # Mühit və sistem faylı istisna qaydaları
├── LICENSE                               # MIT Lisenziyası
└── README.md                             # Əsas layihə sənədləşdirməsi
```

---

## 🛠 Data Pipeline və ETL Prosesi

**Addım 1: Python Emalı (`01_data_preprocessing_etl.ipynb`)**
- Dublikat auditi (0 dublikat) və boş dəyər yoxlaması (0 null) aparılıb.
- Sxem başlıqları PostgreSQL uyğunluğu üçün snake_case formatına salınıb.
- Feature Engineering həyata keçirilib:
  - **Maliyyə:** `total_revenue`, `total_cost`, `profit`, `profit_margin`.
  - **Stok Riskləri:** `below_reorder_flag` (Anbar ≤ Yenidən Sifariş Nöqtəsi), `lost_sales_units`, `lost_revenue`.
  - **Proqnoz Fərqi:** `forecast_error`, `abs_forecast_error`.

**Addım 2: Ölçü Modelləşdirilməsi (`02_data_modeling_extraction.ipynb`)**
- Təqvim ierarxiyaları (`year`, `quarter`, `month`, `month_name`, `day_name`, `day_of_week`) ilə normallaşdırılmış Tarix Ölçüsü (`dim_date`) çıxarılıb.
- Data warehouse-a optimal yüklənmə üçün əsas 24-sütunlu Fakt Cədvəli (`fact_inventory_daily`) formatlaşdırılıb.

---

## 🗄 Verilənlər Bazası Sxemi və SQL Sorğu Kitabxanası

### PostgreSQL Cədvəl Sxemi (`01_schema.sql`)

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

### Nümunə Analitik Sorğu: Regional Top SKU-lar (`03_analytical_queries.sql`)

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

## 📊 Power BI Dashboard Arxitekturası

Dashboard icraçı istifadə rahatlığı və sürətli diaqnostik iş axını üçün nəzərdə tutulmuş **tünd korporativ UI temada** 5 səhifədən ibarətdir:

### 1️⃣ İcmal (Executive Overview)
Ümumi Gəlir (33.43M $), Mənfəət (11M $), Mənfəət Marjası (33.2%) və ümumi Anbar Sağlamlığını (94.48%) izləyən yüksək səviyyəli icraçı skorkartı, region üzrə performans bölgüsü ilə birlikdə.

![Executive Overview](docs/screenshots/page1_overview.png)

### 2️⃣ Anbar Performansı (Inventory Performance)
Məhsul səviyyəsində saxlama xərcləri, vahid dəyəri ilə qiymət korrelyasiyası, qiymət qrupu seqmentasiyası (Aşağı, Orta, Yüksək) və gəlir amilləri.

![Inventory Performance](docs/screenshots/page2_inventory.png)

### 3️⃣ Stok və Risk Təhlili (Stock & Risk Analysis)
Yenidən sifariş riski trendləri, stok-out halları, regional risk bölgüsü və kritik risk matrisləri.

![Stock & Risk Analysis](docs/screenshots/page3_stock_risk.png)

### 4️⃣ Tələb və Proqnoz (Demand & Forecast)
Qabaqcıl proqnozlaşdırma diaqnostikası, WAPE % izlənməsi, Forecast Bias, həftəlik tələb nümunələri və promo təsiri qiymətləndirməsi.

![Demand & Forecast](docs/screenshots/page4_demand_forecast.png)

### 5️⃣ Anbar və Təchizatçı Performansı (Warehouse & Supplier Performance)
Çatdırılma müddəti təhlili, təchizatçı risk qiymətləndirməsi, gecikmiş sifarişlərin izlənməsi və anbarlar arası mənfəət ədaləti.

![Warehouse & Supplier Performance](docs/screenshots/page5_warehouse_supplier.png)

---

## 📐 DAX Ölçü Kitabxanası

Hesabatda tətbiq olunan əsas custom DAX ölçüləri:

```dax
// 1. Çəkili Mütləq Faiz Xətası (WAPE %)
WAPE % = 
DIVIDE(
    SUM(fact_inventory_daily[abs_forecast_error]),
    SUM(fact_inventory_daily[units_sold]),
    0
)

// 2. Proqnoz Dəqiqliyi %
Forecast Accuracy = 1 - [WAPE %]

// 3. Forecast Bias %
Forecast Bias % = 
DIVIDE(
    SUM(fact_inventory_daily[forecast_error]),
    SUM(fact_inventory_daily[units_sold]),
    0
)

// 4. Yenidən Sifariş Risk Dərəcəsi %
Reorder Risk Rate = 
DIVIDE(
    SUM(fact_inventory_daily[below_reorder_flag]),
    COUNT(fact_inventory_daily[date]),
    0
)

// 5. Anbar Sağlamlıq Skoru %
Inventory Health Score = 1 - [Reorder Risk Rate]

// 6. Anbarda Ümumi Kapital Dəyəri
Total Inventory Value = 
SUMX(
    fact_inventory_daily,
    fact_inventory_daily[inventory_level] * fact_inventory_daily[unit_cost]
)
```

---

## 🚀 Necə Təkrarlamaq Olar

**1. Repository Qurulumu**
```bash
git clone https://github.com/nihatrza/supply-chain-inventory-optimization.git
cd supply-chain-inventory-optimization
```

**2. Python Mühiti və Data Pipeline**
```bash
pip install -r requirements.txt
jupyter notebook notebooks/01_data_preprocessing_etl.ipynb
```

**3. PostgreSQL Verilənlər Bazasına İdxal**
- pgAdmin və ya psql shell açın.
- `supply_chain_db` bazasını yaradın.
- Sxem və indeksləri qurmaq üçün `sql/01_schema.sql` işlədin.
- Fayl yolunu yeniləyərək datanı yükləmək üçün `sql/02_data_import.sql` işlədin.
- Ad-hoc sorğuları icra etmək üçün `sql/03_analytical_queries.sql` işlədin.

**4. Power BI Dashboard**
- `power_bi/Supply_Chain_Analytics.pbix` faylını Power BI Desktop-da açın.
- `Transform Data → Data Source Settings` bölməsindən data mənbəyi məlumatlarını yerli PostgreSQL instansınıza uyğun yeniləyin.

---

## 👤 Müəllif və Əlaqə

**Nihat Rzaquluzadə**
Data Analyst / Analytics Engineer

🌐 LinkedIn: [linkedin.com/in/nihat-rzaguluzada](https://linkedin.com/in/nihat-rzaguluzada)
🐙 GitHub: [github.com/nihatrza](https://github.com/nihatrza)
