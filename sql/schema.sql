-- =========================================================
-- schema.sql
-- Table definitions for the e-commerce SQL project
-- Compatible with SQLite
-- =========================================================

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

-- =========================================================
-- 1. Customers
-- =========================================================
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    customer_name TEXT NOT NULL,
    signup_date TEXT NOT NULL,
    country TEXT,
    city TEXT
);

-- =========================================================
-- 2. Products
-- =========================================================
CREATE TABLE products (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category TEXT NOT NULL,
    price REAL NOT NULL,
    cost REAL NOT NULL
);

-- =========================================================
-- 3. Orders
-- =========================================================
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date TEXT NOT NULL,
    channel TEXT NOT NULL,
    order_status TEXT NOT NULL,
    shipping_fee REAL NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- =========================================================
-- 4. Order Items
-- =========================================================
CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    discount_pct REAL NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- =========================================================
-- 5. Payments
-- =========================================================
CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL,
    payment_method TEXT NOT NULL,
    payment_status TEXT NOT NULL,
    payment_date TEXT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
