-- =========================================================
-- analysis.sql
-- Business analysis queries
-- =========================================================

-- 1. Monthly revenue, gross profit and gross margin
SELECT
    order_month,
    ROUND(SUM(order_revenue), 2) AS net_revenue,
    ROUND(SUM(items_gross_profit), 2) AS gross_profit,
    ROUND(SUM(items_gross_profit) / NULLIF(SUM(order_revenue), 0), 4) AS gross_margin
FROM vw_order_totals
GROUP BY order_month
ORDER BY order_month;


-- 2. Revenue, AOV and total orders by channel
SELECT
    channel,
    ROUND(SUM(order_revenue), 2) AS total_revenue,
    ROUND(AVG(order_revenue), 2) AS avg_order_value,
    COUNT(*) AS total_orders
FROM vw_order_totals
GROUP BY channel
ORDER BY total_revenue DESC;


-- 3. Category performance
SELECT
    category,
    ROUND(SUM(item_net_revenue), 2) AS revenue,
    ROUND(SUM(item_gross_profit), 2) AS gross_profit,
    ROUND(SUM(item_gross_profit) / NULLIF(SUM(item_net_revenue), 0), 4) AS gross_margin,
    SUM(quantity) AS units_sold
FROM vw_completed_order_lines
GROUP BY category
ORDER BY revenue DESC;


-- 4. Order status share
SELECT
    order_status,
    COUNT(*) AS total_orders,
    ROUND(COUNT(*) * 1.0 / (SELECT COUNT(*) FROM orders), 4) AS status_share
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;


-- 5. New vs returning customers by month
WITH ranked_orders AS (
    SELECT
        customer_id,
        order_id,
        substr(order_date, 1, 7) AS order_month,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS order_rank
    FROM orders
    WHERE order_status = 'Completed'
)
SELECT
    order_month,
    CASE
        WHEN order_rank = 1 THEN 'New'
        ELSE 'Returning'
    END AS customer_type,
    COUNT(*) AS total_orders
FROM ranked_orders
GROUP BY order_month, customer_type
ORDER BY order_month, customer_type;


-- 6. Top customers by lifetime value
SELECT
    c.customer_name,
    COUNT(DISTINCT v.order_id) AS total_orders,
    ROUND(SUM(v.item_net_revenue), 2) AS lifetime_value
FROM vw_completed_order_lines v
JOIN customers c
    ON v.customer_id = c.customer_id
GROUP BY c.customer_name
ORDER BY lifetime_value DESC
LIMIT 10;


-- 7. Product performance ranked inside category
WITH product_perf AS (
    SELECT
        category,
        product_name,
        SUM(quantity) AS units_sold,
        SUM(item_net_revenue) AS revenue
    FROM vw_completed_order_lines
    GROUP BY category, product_name
)
SELECT
    category,
    product_name,
    units_sold,
    ROUND(revenue, 2) AS revenue,
    RANK() OVER (
        PARTITION BY category
        ORDER BY revenue DESC
    ) AS revenue_rank_in_category
FROM product_perf
ORDER BY category, revenue_rank_in_category;


-- 8. Cohort analysis
SELECT
    substr(c.signup_date, 1, 7) AS cohort_month,
    substr(o.order_date, 1, 7) AS purchase_month,
    COUNT(DISTINCT c.customer_id) AS active_customers
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'Completed'
GROUP BY
    substr(c.signup_date, 1, 7),
    substr(o.order_date, 1, 7)
ORDER BY cohort_month, purchase_month;


-- 9. Payment method performance
WITH payment_perf AS (
    SELECT
        payment_method,
        order_id,
        SUM(item_net_revenue) AS revenue
    FROM vw_completed_order_lines
    WHERE payment_status = 'Paid'
    GROUP BY payment_method, order_id
)
SELECT
    payment_method,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(revenue), 2) AS revenue,
    ROUND(SUM(revenue) / NULLIF(COUNT(DISTINCT order_id), 0), 2) AS revenue_per_order
FROM payment_perf
GROUP BY payment_method
ORDER BY revenue DESC;
