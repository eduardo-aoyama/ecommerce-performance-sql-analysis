-- =========================================================
-- views.sql
-- Base and reusable business views
-- =========================================================

DROP VIEW IF EXISTS vw_order_lines;
DROP VIEW IF EXISTS vw_completed_order_lines;
DROP VIEW IF EXISTS vw_order_totals;

-- 1. Base view at order-item grain
CREATE VIEW vw_order_lines AS
SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    substr(o.order_date, 1, 7) AS order_month,
    o.channel,
    o.order_status,
    o.shipping_fee,
    p.payment_method,
    p.payment_status,
    pr.product_id,
    pr.product_name,
    pr.category,
    oi.quantity,
    oi.discount_pct,
    pr.price,
    pr.cost,
    oi.quantity * pr.price AS item_gross_revenue,
    oi.quantity * pr.price * (1 - oi.discount_pct) AS item_net_revenue,
    oi.quantity * pr.cost AS item_total_cost,
    (oi.quantity * pr.price * (1 - oi.discount_pct)) - (oi.quantity * pr.cost) AS item_gross_profit
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products pr
    ON oi.product_id = pr.product_id
LEFT JOIN payments p
    ON o.order_id = p.order_id;

-- 2. Only completed orders
CREATE VIEW vw_completed_order_lines AS
SELECT *
FROM vw_order_lines
WHERE order_status = 'Completed';

-- 3. Order-level totals
CREATE VIEW vw_order_totals AS
SELECT
    order_id,
    customer_id,
    order_date,
    order_month,
    channel,
    MAX(shipping_fee) AS shipping_fee,
    SUM(item_net_revenue) AS items_revenue,
    SUM(item_total_cost) AS items_cost,
    SUM(item_gross_profit) AS items_gross_profit,
    SUM(item_net_revenue) + MAX(shipping_fee) AS order_revenue
FROM vw_completed_order_lines
GROUP BY
    order_id,
    customer_id,
    order_date,
    order_month,
    channel;
