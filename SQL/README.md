# SQL Retail Analytics Portfolio

An end-to-end SQL analysis of fashion retail e-commerce data, covering **Sales Performance** and **Financial Analysis**. This project was built as part of my portfolio while transitioning from an Accounting background into Data Analytics.

## Business Problem

A fashion retail company needs better visibility into its sales performance, including best-selling products, revenue trends, and customer contributions, as well as its financial performance, including gross profit margin and the impact of refunds on profitability, to support data-driven business decision-making.

## Dataset

The dataset is structured as a **star schema**, consisting of 1 fact table and 11 dimension/reference tables:

| Table                             | Description                                             |
| --------------------------------- | ------------------------------------------------------- |
| `orders_transaction`              | Fact table containing detailed order transactions       |
| `customers`                       | Customer data, including membership tiers               |
| `products` / `subproducts`        | Product data and variants such as size and color        |
| `city_province_region`            | Geographic data covering cities, provinces, and regions |
| `employees`                       | Employee data, including sales representatives          |
| `payment_methods`, `order_status` | Reference tables for payment methods and order statuses |
| `inventory`                       | Inventory levels by warehouse                           |
| `suppliers`                       | Supplier data                                           |
| `marketing_campaigns`             | Marketing campaign data                                 |
| `return_orders`                   | Product return and refund data                          |
| `date`                            | Date dimension table                                    |

> **Note:** The data used in this repository is synthetic and intended for learning and portfolio purposes. It does not represent data from a real company.

## Tools

* **PostgreSQL** — Database engine
* **DBeaver Community** — SQL client

## Database Schema

<!-- Add the ER Diagram screenshot exported from DBeaver here -->

`screenshots/er_diagram.png`

## Project 1 — Sales Analysis

File: [`SQL/02_sales_analysis.sql`](SQL/02_sales_analysis.sql)

| # | Business Question                                                       | Key Insight                                                                                                                                                                  |
| - | ----------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1 | What are the total revenue, total orders, and average order value?      | 10,000 orders generated **Rp13.73B in revenue**, with an **AOV of Rp1.37M**, providing a baseline for future bundling and cross-selling strategies.                          |
| 2 | How has monthly revenue changed over time, and what is the growth rate? | Monthly revenue remained relatively stable at **Rp250–370M**, with the highest growth in Aug 2023 (+29.15%) and the largest decline in Sep 2024 (-22.65%).                   |
| 3 | Which products are the best-selling by revenue and quantity sold?       | Footwear dominated the top-selling products, with **SportMax Boots** generating the highest revenue at **Rp1.12B**.                                                          |
| 4 | Who are the top 10 customers by revenue contribution?                   | The highest-spending customer contributed only **0.18% of total revenue**, indicating a diversified, volume-driven customer base.                                            |
| 5 | How is revenue distributed across product categories?                   | **Women's Clothing (27.73%)** and **Footwear (26.68%)** contributed over half of total revenue, while Accessories had the lowest share at 5.74%.                             |
| 6 | How are customers and revenue distributed across membership tiers?      | Bronze generated **52.43% of revenue**, but average revenue per customer was similar across tiers, suggesting membership tiers do not strongly differentiate customer value. |
| 7 | Which cities or regions contribute the most revenue?                    | Revenue was geographically diversified; however, **Mataram contributed 41% of Bali & Nusa Tenggara's regional revenue**, showing notable regional concentration.             |

## Project 2 — Financial Analysis

File: [`SQL/03_financial_analysis.sql`](SQL/03_financial_analysis.sql)

| # | Business Question                                                          | Key Insight                                                                                                                                             |
| - | -------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1 | What are the overall revenue, COGS, gross profit, and gross profit margin? | Revenue reached **Rp13.73B**, generating **Rp6.35B gross profit** with a healthy **46.25% gross margin**.                                               |
| 2 | How has the gross profit margin changed month over month?                  | Gross margin remained stable between **43.71% and 48.56%**, indicating a consistent cost structure throughout the period.                               |
| 3 | Which products are the most and least profitable?                          | **Comfort Fit Kemeja** had the highest margin (59.46%), while **Zalora Basics Blouse** had the lowest (28.02%) despite being a top revenue contributor. |
| 4 | How significant is the impact of refunds on profitability?                 | Processed refunds totaled **Rp90.05M**, only **0.66% of revenue and 1.42% of gross profit**, indicating a limited overall profitability impact.         |

## How to Run

1. Create a new PostgreSQL database.
2. Run `sql/01_setup_schema.sql` to create all required tables. The table creation order has been arranged according to foreign key dependencies.
3. Import the CSV files into their respective tables using DBeaver: right-click the table → **Import Data**.
4. Run the queries in `sql/02_sales_analysis.sql` and `sql/03_financial_analysis.sql`.

## About This Project

This project was created as part of my journey learning SQL from the ground up and transitioning into a Data Analyst role.

With an academic background in Accounting, this project demonstrates the combination of **business and financial understanding** with technical SQL skills, including **JOINs, CTEs, window functions, and data aggregation**.
