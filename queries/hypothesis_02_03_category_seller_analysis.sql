-- =============================================================
-- Brazilian E-commerce Sales Growth Analysis
-- Hypothesis 2 & 3: Category Review Analysis + Seller Tier Analysis
-- Dataset: Olist Brazilian E-Commerce (Kaggle)
-- =============================================================


-- =============================================================
-- HYPOTHESIS 2: High-review categories drive higher conversion
-- =============================================================

-- 2-1. Top 10 categories by average review score (with sales data)
WITH products2 AS (
    SELECT pd.*, t.product_category_name_english
    FROM products pd
    JOIN translation t ON pd.product_category_name = t.product_category_name
),
order_reviews_join AS (
    SELECT oi.*, r.review_score
    FROM order_items oi
    JOIN order_reviews r ON oi.order_id = r.order_id
)
SELECT
    p.product_category_name_english,
    COUNT(orj.order_id)    AS total_sales_count,
    SUM(orj.price)         AS total_sales_value,
    AVG(orj.review_score)  AS avg_score
FROM order_reviews_join orj
JOIN products2 p ON orj.product_id = p.product_id
GROUP BY 1
ORDER BY avg_score DESC
LIMIT 10;


-- =============================================================
-- HYPOTHESIS 3: Meaningful performance gap between top and other sellers
-- =============================================================

-- 3-1. Seller count by city (top 20 cities)
SELECT seller_city, COUNT(1) AS seller_count
FROM sellers
GROUP BY 1
ORDER BY 2 DESC
LIMIT 20;


-- 3-2. Revenue and order count by seller city
WITH ois AS (
    SELECT o.*, s.seller_city
    FROM order_items o
    JOIN sellers s ON o.seller_id = s.seller_id
)
SELECT
    seller_city,
    COUNT(1)    AS order_count,
    SUM(price)  AS total_revenue
FROM ois
GROUP BY 1
ORDER BY total_revenue DESC;


-- 3-3. Group sellers: Top 500 (top_seller) vs. rest (other_seller)
--      Metric: Total revenue by group
WITH seller_sales AS (
    SELECT seller_id, COUNT(*) AS order_cnt, SUM(price) AS sum_sales
    FROM order_items
    GROUP BY 1
),
ranked_seller AS (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY sum_sales DESC) AS rnk
    FROM seller_sales
),
seller_group AS (
    SELECT
        seller_id,
        order_cnt,
        sum_sales,
        CASE WHEN rnk <= 500 THEN 'top_seller' ELSE 'other_seller' END AS seller_group
    FROM ranked_seller
),
order_items_join AS (
    SELECT oi.*, r.review_score
    FROM order_items oi
    JOIN order_reviews r ON oi.order_id = r.order_id
)
SELECT
    s.seller_group,
    SUM(o.price) AS total_sales
FROM order_items_join o
JOIN seller_group s ON o.seller_id = s.seller_id
GROUP BY 1;


-- 3-4. Average revenue per order (ARPU) by seller group
WITH seller_sales AS (
    SELECT seller_id, COUNT(*) AS order_cnt, SUM(price) AS sum_sales
    FROM order_items
    GROUP BY 1
),
ranked_seller AS (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY sum_sales DESC) AS rnk
    FROM seller_sales
),
seller_group AS (
    SELECT
        seller_id,
        order_cnt,
        sum_sales,
        CASE WHEN rnk <= 500 THEN 'top_seller' ELSE 'other_seller' END AS seller_group
    FROM ranked_seller
),
order_items_join AS (
    SELECT oi.*, r.review_score
    FROM order_items oi
    JOIN order_reviews r ON oi.order_id = r.order_id
)
SELECT
    s.seller_group,
    AVG(o.price) AS avg_revenue_per_order
FROM order_items_join o
JOIN seller_group s ON o.seller_id = s.seller_id
GROUP BY 1;


-- 3-5. Average review score by seller group
WITH seller_sales AS (
    SELECT seller_id, COUNT(*) AS order_cnt, SUM(price) AS sum_sales
    FROM order_items
    GROUP BY 1
),
ranked_seller AS (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY sum_sales DESC) AS rnk
    FROM seller_sales
),
seller_group AS (
    SELECT
        seller_id,
        order_cnt,
        sum_sales,
        CASE WHEN rnk <= 500 THEN 'top_seller' ELSE 'other_seller' END AS seller_group
    FROM ranked_seller
),
order_items_join AS (
    SELECT oi.*, r.review_score
    FROM order_items oi
    JOIN order_reviews r ON oi.order_id = r.order_id
)
SELECT
    s.seller_group,
    AVG(o.review_score) AS avg_review_score
FROM order_items_join o
JOIN seller_group s ON o.seller_id = s.seller_id
GROUP BY 1;


-- 3-6. Average order count per seller by group
WITH seller_sales AS (
    SELECT seller_id, COUNT(*) AS order_cnt, SUM(price) AS sum_sales
    FROM order_items
    GROUP BY 1
),
ranked_seller AS (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY sum_sales DESC) AS rnk
    FROM seller_sales
),
seller_group AS (
    SELECT
        seller_id,
        order_cnt,
        sum_sales,
        CASE WHEN rnk <= 500 THEN 'top_seller' ELSE 'other_seller' END AS seller_group
    FROM ranked_seller
)
SELECT
    seller_group,
    AVG(order_cnt) AS avg_orders_per_seller
FROM seller_group
GROUP BY 1;


-- 3-7. Average order value (AOV) by seller group
WITH seller_sales AS (
    SELECT seller_id, COUNT(*) AS order_cnt, SUM(price) AS sum_sales, AVG(price) AS avg_price
    FROM order_items
    GROUP BY 1
),
ranked_seller AS (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY sum_sales DESC) AS rnk
    FROM seller_sales
),
seller_group AS (
    SELECT
        seller_id,
        order_cnt,
        avg_price,
        sum_sales,
        CASE WHEN rnk <= 500 THEN 'top_seller' ELSE 'other_seller' END AS seller_group
    FROM ranked_seller
)
SELECT
    seller_group,
    AVG(avg_price) AS avg_order_value
FROM seller_group
GROUP BY 1;


-- 3-8. Top 10 revenue categories by seller group
WITH seller_rank AS (
    SELECT
        seller_id,
        SUM(price) AS sum_sales,
        CASE
            WHEN ROW_NUMBER() OVER (ORDER BY SUM(price) DESC) <= 500 THEN 'top_seller'
            ELSE 'other_seller'
        END AS seller_group
    FROM order_items
    GROUP BY 1
),
order_with_category AS (
    SELECT oi.order_id, oi.seller_id, oi.price, p.product_category_name
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
),
merged AS (
    SELECT owc.product_category_name, sr.seller_group, owc.price
    FROM order_with_category owc
    JOIN seller_rank sr ON owc.seller_id = sr.seller_id
),
category_sales_ranked AS (
    SELECT
        seller_group,
        product_category_name,
        SUM(price) AS total_sales,
        ROW_NUMBER() OVER (PARTITION BY seller_group ORDER BY SUM(price) DESC) AS rnk
    FROM merged
    GROUP BY 1, 2
)
SELECT seller_group, product_category_name, total_sales
FROM category_sales_ranked
WHERE rnk <= 10
ORDER BY seller_group, total_sales DESC;
