create database olist;
use olist;

-- Orders
SELECT COUNT(*) AS total_orders FROM olist_orders;

-- Order Items
SELECT COUNT(*) AS total_order_items FROM olist_order_items;

-- Products
SELECT COUNT(*) AS total_products FROM olist_products;

-- Customers
SELECT COUNT(*) AS total_customers FROM olist_customers;

-- Payments
SELECT COUNT(*) AS total_payments FROM olist_order_payments;

-- Reviews
SELECT COUNT(*) AS total_reviews FROM olist_order_reviews;

-- Sellers
SELECT COUNT(*) AS total_sellers FROM olist_sellers;

-- Geolocation
SELECT COUNT(*) AS total_geolocations FROM olist_geolocation;

-- Category Translation
SELECT COUNT(*) AS total_translations FROM product_category_translation;

SELECT 'olist_orders' AS table_name, COUNT(*) AS row_count FROM olist_orders
UNION ALL
SELECT 'olist_order_items', COUNT(*) FROM olist_order_items
UNION ALL
SELECT 'olist_products', COUNT(*) FROM olist_products
UNION ALL
SELECT 'olist_customers', COUNT(*) FROM olist_customers
UNION ALL
SELECT 'olist_order_payments', COUNT(*) FROM olist_order_payments
UNION ALL
SELECT 'olist_order_reviews', COUNT(*) FROM olist_order_reviews
UNION ALL
SELECT 'olist_sellers', COUNT(*) FROM olist_sellers
UNION ALL
SELECT 'olist_geolocation', COUNT(*) FROM olist_geolocation
UNION ALL
SELECT 'product_category_translation', COUNT(*) FROM product_category_translation;

ALTER TABLE olist_orders ADD order_purchase_dt DATETIME;

UPDATE olist_orders
SET order_purchase_dt = STR_TO_DATE(order_purchase_timestamp, '%d-%m-%Y %H.%i')
WHERE order_id IS NOT NULL;

SELECT COUNT(*) - COUNT(order_approved_at) AS missing_approvals
FROM olist_orders;

SELECT order_id, order_purchase_timestamp,
       STR_TO_DATE(order_purchase_timestamp, '%d-%m-%Y %H.%i') AS converted_date
FROM olist_orders
LIMIT 10;

ALTER TABLE olist_orders
    ADD COLUMN order_approved_dt DATETIME,
    ADD COLUMN order_delivered_carrier_dt DATETIME,
    ADD COLUMN order_delivered_customer_dt DATETIME,
    ADD COLUMN order_estimated_delivery_dt DATETIME;

SET SQL_SAFE_UPDATES = 0;

UPDATE olist_orders
SET
    order_approved_dt = STR_TO_DATE(order_approved_at, '%d-%m-%Y %H.%i'),
    order_delivered_carrier_dt = STR_TO_DATE(order_delivered_carrier_date, '%d-%m-%Y %H.%i'),
    order_delivered_customer_dt = STR_TO_DATE(order_delivered_customer_date, '%d-%m-%Y %H.%i'),
    order_estimated_delivery_dt = STR_TO_DATE(order_estimated_delivery_date, '%d-%m-%Y %H.%i')
WHERE order_id IS NOT NULL;

SELECT 
    order_id,
    order_purchase_timestamp, order_purchase_dt,
    order_approved_at, order_approved_dt,
    order_delivered_carrier_date, order_delivered_carrier_dt,
    order_delivered_customer_date, order_delivered_customer_dt,
    order_estimated_delivery_date, order_estimated_delivery_dt
FROM olist_orders
LIMIT 10;

SELECT order_id, order_approved_dt, order_delivered_carrier_dt, 
       order_delivered_customer_dt, order_estimated_delivery_dt
FROM olist_orders
WHERE order_approved_dt IS NULL
LIMIT 10;

SELECT 
	count(*) AS total_rows,
    sum(order_approved_dt IS NULL) AS missing_approved_dt,
    SUM(order_delivered_carrier_dt IS NULL) AS missing_carrier_dt,
    SUM(order_delivered_customer_dt IS NULL) AS missing_customer_dt,
    SUM(order_estimated_delivery_dt IS NULL) AS missing_estimated_dt
FROM olist_orders;

SELECT order_id, order_delivered_carrier_date, order_delivered_customer_date
FROM olist_orders
WHERE order_delivered_carrier_dt IS NULL
   OR order_delivered_customer_dt IS NULL
LIMIT 20;

SELECT 
    order_id,
    TIMESTAMPDIFF(DAY, order_approved_dt, order_delivered_customer_dt) AS delivery_days
FROM olist_orders
WHERE order_approved_dt IS NOT NULL
  AND order_delivered_customer_dt IS NOT NULL
LIMIT 20;

SELECT DATE(order_purchase_dt) AS purchase_date, COUNT(*) AS total_orders
FROM olist_orders
GROUP BY purchase_date
ORDER BY purchase_date;

SELECT order_id, 
       TIMESTAMPDIFF(DAY, order_estimated_delivery_dt, order_delivered_customer_dt) AS delay_days
FROM olist_orders
WHERE order_delivered_customer_dt IS NOT NULL
  AND order_estimated_delivery_dt IS NOT NULL
  AND order_delivered_customer_dt > order_estimated_delivery_dt;

-- Order Trends Over Time
SELECT DATE(order_purchase_dt) AS purchase_date, COUNT(*) AS total_orders
FROM olist_orders
GROUP BY purchase_date
ORDER BY purchase_date;

-- Delivery Performance
SELECT 
    DATE(order_approved_dt) AS month,
    AVG(TIMESTAMPDIFF(DAY, order_approved_dt, order_delivered_customer_dt)) AS avg_delivery_days
FROM olist_orders
WHERE order_approved_dt IS NOT NULL AND order_delivered_customer_dt IS NOT NULL
GROUP BY month
ORDER BY month;

-- Late Delivery
SELECT 
    COUNT(*) AS delayed_orders
FROM olist_orders
WHERE order_delivered_customer_dt > order_estimated_delivery_dt;

-- Regional Insight 
SELECT 
    COUNT(*) AS delayed_orders
FROM olist_orders
WHERE order_delivered_customer_dt > order_estimated_delivery_dt;

-- Order status analysis 
SELECT order_status, COUNT(*) AS total_orders
FROM olist_orders
GROUP BY order_status;

-- Geo Exploratory (Customer/Seller Locations)
-- Customer locations
SELECT DISTINCT customer_zip_code_prefix, geolocation_lat, geolocation_lng
FROM olist_customers c
JOIN olist_geolocation g
ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
LIMIT 5000;

-- Seller locations
SELECT DISTINCT seller_zip_code_prefix, geolocation_lat, geolocation_lng
FROM olist_sellers s
JOIN olist_geolocation g
ON s.seller_zip_code_prefix = g.geolocation_zip_code_prefix
LIMIT 5000;

-- Order Data
-- Average Dilivery Days per week
SELECT WEEK(order_approved_dt) AS week_number,
       AVG(DATEDIFF(order_delivered_customer_dt, order_approved_dt)) AS avg_delivery_days
FROM olist_orders
WHERE order_approved_dt IS NOT NULL
GROUP BY week_number
ORDER BY week_number;

-- Top 10 Product
SELECT p.product_id, p.product_category_name, COUNT(*) AS total_orders
FROM olist_orders o
JOIN olist_order_items oi ON o.order_id = oi.order_id
JOIN olist_products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_category_name
ORDER BY total_orders DESC
LIMIT 10;

-- Top 10 Seller
SELECT s.seller_id, COUNT(*) AS total_orders
FROM olist_orders o
JOIN olist_order_items oi ON o.order_id = oi.order_id
JOIN olist_sellers s ON oi.seller_id = s.seller_id
GROUP BY s.seller_id
ORDER BY total_orders DESC
LIMIT 10;

-- Gross payment of tof 5 product
SELECT p.product_id, p.product_category_name, SUM(op.payment_value) AS gross_payment
FROM olist_orders o
JOIN olist_order_items oi ON o.order_id = oi.order_id
JOIN olist_products p ON oi.product_id = p.product_id
JOIN olist_order_payments op ON o.order_id = op.order_id
GROUP BY p.product_id, p.product_category_name
ORDER BY gross_payment DESC
LIMIT 5;















