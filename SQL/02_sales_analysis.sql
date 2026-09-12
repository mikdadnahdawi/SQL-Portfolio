-- ============================================================
-- PROJECT 1 — SQL SALES ANALYSIS
-- ============================================================

-- --------------------------------------------------------------
-- BQ1: Total revenue, total order, and average order value
-- --------------------------------------------------------------
SELECT
    SUM(total_amount) AS total_revenue,
    COUNT(order_id) AS total_order,
    ROUND(AVG(total_amount), 2) AS average_revenue
FROM retail.orders_transaction;

-- --------------------------------------------------------------
-- BQ2: Monthly revenue trends + month-over-month growth
-- --------------------------------------------------------------
WITH revenue_monthly AS (
    SELECT DATE_TRUNC('month', order_date) AS month,
           SUM(total_amount) AS total_revenue
    FROM retail.orders_transaction
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT
    TO_CHAR(month, 'YYYY Month') AS month_year,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY month) AS last_month_revenue,
    total_revenue - LAG(total_revenue) OVER (ORDER BY month) AS growth,
    ROUND(
        ((total_revenue - LAG(total_revenue) OVER (ORDER BY month)) /
        LAG(total_revenue) OVER (ORDER BY month)) * 100, 2
    ) AS growth_percentage
FROM revenue_monthly
ORDER BY month;

-- --------------------------------------------------------------
-- BQ3: Top 10 Best-Selling Products (by Revenue and Quantity)
-- --------------------------------------------------------------
SELECT
    p.product_id,
    p.product_name,
    SUM(ot.quantity) AS sell_orders,
    SUM(ot.total_amount) AS products_revenue
FROM retail.orders_transaction ot
JOIN retail.subproducts sp ON ot.subproduct_id = sp.subproduct_id
JOIN retail.products p ON sp.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY products_revenue DESC
LIMIT 10;

-- --------------------------------------------------------------
-- BQ4: Top 10 customers by total spending
-- --------------------------------------------------------------
SELECT
    ot.customer_id,
    c.full_name AS customer_name,
    SUM(total_amount) AS revenue_customer
FROM retail.orders_transaction ot
JOIN retail.customers c ON ot.customer_id = c.customer_id
GROUP BY ot.customer_id, customer_name
ORDER BY revenue_customer DESC
LIMIT 10;

-- --------------------------------------------------------------
-- BQ5: Revenue Breakdown by Product Category + Percentage Contribution
-- --------------------------------------------------------------
WITH category_revenue AS (
    SELECT
        p.category,
        SUM(ot.total_amount) AS total_revenue
    FROM retail.orders_transaction ot
    JOIN retail.subproducts sp ON ot.subproduct_id = sp.subproduct_id
    JOIN retail.products p ON sp.product_id = p.product_id
    GROUP BY p.category
)
SELECT
    category,
    total_revenue,
    ROUND((total_revenue / SUM(total_revenue) OVER ()) * 100, 2) AS persentage_category_revenue
FROM category_revenue
ORDER BY total_revenue DESC;

-- --------------------------------------------------------------
-- BQ6: Customer segmentation based on membership_tier
-- --------------------------------------------------------------
WITH customer_spending AS (
    SELECT
        c.membership_tier,
        COUNT(DISTINCT c.customer_id) AS total_customer,
        SUM(ot.total_amount) AS total_revenue
    FROM retail.orders_transaction ot
    JOIN retail.customers c ON ot.customer_id = c.customer_id
    GROUP BY c.membership_tier
)
SELECT
    membership_tier,
    total_customer,
    total_revenue,
    ROUND((total_revenue / SUM(total_revenue) OVER ()) * 100, 2) AS persentage_revenue
FROM customer_spending
ORDER BY total_revenue DESC;

-- --------------------------------------------------------------
-- BQ7: Revenue by city and region (2-level drill-down)
-- --------------------------------------------------------------
WITH city_region_spending AS (
    SELECT
        cpr.region AS region,
        cpr.city_name AS city_name,
        COUNT(DISTINCT c.customer_id) AS total_city_customer,
        SUM(ot.total_amount) AS total_revenue
    FROM retail.orders_transaction ot
    JOIN retail.customers c ON ot.customer_id = c.customer_id
    JOIN retail.city_province_region cpr ON c.city_id = cpr.city_id
    GROUP BY cpr.region, cpr.city_name
)
SELECT
    city_name,
    region,
    total_city_customer,
    total_revenue,
    ROUND((total_revenue / SUM(total_revenue) OVER ()) * 100, 2) AS percentage_city,
    ROUND((total_revenue / SUM(total_revenue) OVER (PARTITION BY region)) * 100, 2) AS percentage_region
FROM city_region_spending
ORDER BY region ASC, total_revenue DESC;
