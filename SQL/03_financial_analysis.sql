-- ============================================================
-- PROJECT 2 — SQL FINANCIAL ANALYSIS
-- ============================================================

-- --------------------------------------------------------------
-- BQ1: Summary of Financial KPIs (revenue, COGS, gross profit, margin)
-- --------------------------------------------------------------
SELECT
    SUM(ot.total_amount) AS total_revenue,
    SUM(p.cost_price * ot.quantity) AS total_cogs,
    SUM(ot.total_amount) - SUM(p.cost_price * ot.quantity) AS gross_profit,
    ROUND(
        (SUM(ot.total_amount) - SUM(p.cost_price * ot.quantity)) / SUM(ot.total_amount) * 100, 2
    ) AS gross_profit_margin
FROM retail.orders_transaction ot
JOIN retail.subproducts sp ON ot.subproduct_id = sp.subproduct_id
JOIN retail.products p ON sp.product_id = p.product_id;

-- --------------------------------------------------------------
-- BQ2: Monthly gross profit margin trend
-- --------------------------------------------------------------
WITH gross_profit_margin_monthly AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        SUM(ot.total_amount) AS total_revenue,
        SUM(p.cost_price * ot.quantity) AS COGS
    FROM retail.orders_transaction ot
    JOIN retail.subproducts sp ON ot.subproduct_id = sp.subproduct_id
    JOIN retail.products p ON sp.product_id = p.product_id
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT
    TO_CHAR(month, 'YYYY Month') AS month_year,
    total_revenue,
    COGS,
    (total_revenue - COGS) AS gross_profit,
    ROUND(((total_revenue - COGS) / total_revenue) * 100, 2) AS gross_profit_margin
FROM gross_profit_margin_monthly
ORDER BY month;

-- --------------------------------------------------------------
-- BQ3: Profitability by product (highest and lowest gross profit margins)
-- --------------------------------------------------------------
WITH gross_profit_margin_products AS (
    SELECT
        p.product_id,
        p.product_name,
        SUM(ot.quantity) AS total_quantity,
        SUM(ot.total_amount) AS total_revenue,
        SUM(p.cost_price * ot.quantity) AS COGS
    FROM retail.orders_transaction ot
    JOIN retail.subproducts sp ON ot.subproduct_id = sp.subproduct_id
    JOIN retail.products p ON sp.product_id = p.product_id
    GROUP BY p.product_id, p.product_name
)
SELECT
    product_name,
    total_quantity,
    total_revenue,
    COGS,
    (total_revenue - COGS) AS gross_profit,
    ROUND(((total_revenue - COGS) / NULLIF(total_revenue, 0)) * 100, 2) AS gross_profit_margin
FROM gross_profit_margin_products
ORDER BY gross_profit_margin DESC;

-- --------------------------------------------------------------
-- BQ4: Impact of returns/refunds on net profit per product
-- Note: Only the “Refund Processed” status is counted as
-- a deduction from actual profit (the money has actually been refunded)
-- --------------------------------------------------------------
WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        SUM(ot.quantity) AS total_quantity,
        SUM(ot.total_amount) AS total_revenue,
        SUM(p.cost_price * ot.quantity) AS COGS
    FROM retail.orders_transaction ot
    JOIN retail.subproducts sp ON ot.subproduct_id = sp.subproduct_id
    JOIN retail.products p ON sp.product_id = p.product_id
    GROUP BY p.product_id, p.product_name
),
product_refunds AS (
    SELECT
        p.product_id,
        SUM(ro.refund_amount) AS total_refund
    FROM retail.return_orders ro
    JOIN retail.orders_transaction ot ON ro.order_id = ot.order_id
    JOIN retail.subproducts sp ON ot.subproduct_id = sp.subproduct_id
    JOIN retail.products p ON sp.product_id = p.product_id
    WHERE ro.status = 'Refund Processed'
    GROUP BY p.product_id
)
SELECT
    ps.product_name,
    ps.total_quantity,
    ps.total_revenue,
    ps.COGS,
    (ps.total_revenue - ps.COGS) AS gross_profit,
    COALESCE(pr.total_refund, 0) AS total_refund_valid,
    ((ps.total_revenue - ps.COGS) - COALESCE(pr.total_refund, 0)) AS net_profit,
    ROUND(
        (((ps.total_revenue - ps.COGS) - COALESCE(pr.total_refund, 0)) / NULLIF(ps.total_revenue, 0)) * 100,
    2) AS net_profit_margin
FROM product_sales ps
LEFT JOIN product_refunds pr ON ps.product_id = pr.product_id
ORDER BY net_profit DESC;
