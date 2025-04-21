# 🛒 Building a Scalable E-Commerce Data Pipeline: Driving Growth through Customer, Product, and Operational Insights

This project presents an end-to-end, automated, and scalable data pipeline for an e-commerce platform. It integrates data from multiple sources using Fivetran, transforms the data using dbt, stores it in BigQuery, and visualizes insights with Tableau.

The pipeline is designed to provide actionable insights into **customer behavior**, **product performance**, **sales trends**, and **operational efficiency**, helping the business make faster, smarter, data-driven decisions.

---

## 📌 Project Overview

- **Data Ingestion**: Fivetran automates the ingestion of 8 core datasets from transactional systems into BigQuery.
- **Transformation**: dbt performs modular data modeling using snapshots, star schema design, and incremental materializations.
- **Data Marts**: Business-ready marts enable in-depth analysis across multiple functions.
- **Visualization**: Tableau dashboard present interactive insights to business users.

---

## 🛠️ Tech Stack

- **Fivetran** – Automated data ingestion from multiple sources  
- **BigQuery** – Scalable cloud data warehouse  
- **dbt** – Transformation, testing, documentation, and version control  
- **Tableau** – Business intelligence and dashboarding  

![image](https://github.com/user-attachments/assets/46945d53-3475-43c2-b45a-af9726877da6)


---

## 📂 Ingested Datasets

| Dataset              | Description                                                                 |
|----------------------|-----------------------------------------------------------------------------|
| `customers`          | Customer details including location and unique identifiers                 |
| `geolocation`        | Zip code-level coordinates for regional mapping                             |
| `orders`             | High-level order info, timestamps, and status                               |
| `order_items`        | Line-level order details including product and shipping data                |
| `order_payments`     | Payment method, installments, and values                                    |
| `order_reviews`      | Customer feedback and sentiment                                             |
| `products`           | Product metadata and physical characteristics                               |
| `sellers`            | Seller identities and regional info                                         |

---

## 🧱 dbt Models & Data Warehouse Design

### 🟨 Dimension Tables (`dim_*`)

- **`dim_customers`**  
  Includes customer demographics and location. Enables segmentation into new, repeat, and VIP customers.

- **`dim_products`**  
  Stores product category and physical details. Supports product performance and inventory analysis.

- **`dim_sellers`**  
  Contains seller identity and location data. Used for seller benchmarking and regional delivery trends.

- **`dim_dates`**  
  A rich date dimension table that supports temporal analysis across all fact models.

---

### 🟦 Fact Tables (`fct_*`)

- **`fct_orders`**  
  Core transactional model capturing order status, key timestamps (purchase, delivery), and order volume.  
  Materialized as an **incremental model** to efficiently handle new data without full refresh.

- **`fct_reviews`**  
  Contains review scores, comments, and timestamps. Used to track customer satisfaction.  
  Also materialized as **incremental** to optimize for continuous inflow.

- **`fct_payments`**  
  Captures payment method, installments, and total values. Supports payment trends and cash flow tracking.

- **`fct_products`**  
  Aggregates product-level sales data. Supports insights into bestsellers, category performance, and return rates.

- **`fct_deliveries`**  
  Calculates shipping durations, late deliveries, and SLA adherence. Crucial for operational efficiency analysis.

These fact models follow **star schema design**, optimized for fast querying and dashboard use.

---

## 🧠 Business-Facing Data Marts

### `mart_customer_behaviour`
- Repeat vs new customer trends
- Region-specific purchasing patterns
- VIP customer identification

### `mart_product_performance`
- Top and bottom performing product categories
- Product review correlation with return rates
- Category-level sales and margin analysis

### `mart_revenue_analysis`
- Monthly and quarterly revenue tracking
- Payment method trends
- Sales by region and customer segment

### `mart_operational_efficiency`
- On-time delivery rate
- Resolution time for logistics issues
- Seller shipping performance

### `mart_geographic_analysis`
- City and state-level order heatmaps
- Delivery time by region
- Regional revenue and product category demand

Each mart is curated for direct integration into Tableau dashboard.

---

## 📊 Tableau Dashboard

The following dashboard was built using Tableau to deliver actionable insight like:

- Repeat vs new customer ratio
- State-wise order distribution
- Top-selling products and categories
- Review sentiment by product
- Product return analysis
- Monthly revenue trends
- Payment type distribution
- AOV (Average Order Value) by month
- % On-time deliveries
- Shipping SLA breaches
- Regional delivery delays

![E-commerce_Dashboard](https://github.com/user-attachments/assets/878036a1-199d-407b-833e-72ba5af5b18f)


---

## ✅ Testing & Documentation

- **Tests**  
  Applied across staging, dimension, and fact layers using `dbt`:
  - Uniqueness and not null constraints on keys
  - Accepted values for enums (e.g., payment_type, order_status)
  - Referential integrity between dimensions and facts
  - Freshness checks on `orders` and `reviews` timestamps

- **Documentation**  
  Generated using `dbt docs`, including table-level descriptions, column metadata, and lineage.

---

## 📚 Learn More

For a deep dive into the project architecture, modeling strategy, and the business insights derived, check out the full article:

👉 [Read the full article](https://medium.com/@timmy_tesla/building-a-scalable-e-commerce-data-pipeline-driving-growth-through-customer-product-and-7dd116077a3a)

