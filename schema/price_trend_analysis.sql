-- Average price of products ordered per year
-- Tracks consumer spend level and brand pricing shifts over time

SELECT 
    YEAR(o.order_date) AS year,
    ROUND(AVG(p.price), 2) AS avg_price_ordered
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY year
ORDER BY year;

-- Average price per product category per year
-- Helps identify premiumization or affordability shifts across skincare types

SELECT 
    YEAR(o.order_date) AS year,
    p.category,
    ROUND(AVG(p.price), 2) AS avg_price
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY year, p.category
ORDER BY year, avg_price DESC;

-- Average product price per brand per year
-- Useful for tracking brand pricing strategy and consumer spend trends

SELECT 
    YEAR(o.order_date) AS year,
    p.brand,
    ROUND(AVG(p.price), 2) AS avg_price
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY year, p.brand
ORDER BY year, avg_price DESC;

-- Product affordability segmentation: Budget, Mid-Tier, Luxury
-- Analyzes how spending behavior shifted over time based on product price

SELECT 
    year,
    price_segment,
    COUNT(*) AS products_ordered
FROM (
    SELECT 
        YEAR(o.order_date) AS year,
        CASE 
            WHEN p.price < 700 THEN 'Budget'
            WHEN p.price BETWEEN 700 AND 1299 THEN 'Mid-Tier'
            ELSE 'Luxury'
        END AS price_segment
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
) AS price_bins
GROUP BY year, price_segment
ORDER BY year, price_segment;

-- Average yearly spend per user
-- Tracks how much each user spends annually and how frequently they order
-- Useful for loyalty or high-value customer segmentation

SELECT 
    YEAR(o.order_date) AS year,
    u.user_id,
    u.name,
    ROUND(SUM(p.price), 2) AS total_spent,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.price) / COUNT(DISTINCT o.order_id), 2) AS avg_spend_per_order
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY year, u.user_id, u.name
ORDER BY year, total_spent DESC;

-- Top 3 spenders per year based on total spend
-- Ranks users yearly by how much they spent on skincare orders

WITH ranked_spenders AS (
    SELECT 
        YEAR(o.order_date) AS year,
        u.user_id,
        u.name,
        ROUND(SUM(p.price), 2) AS total_spent,
        COUNT(DISTINCT o.order_id) AS total_orders,
        ROUND(SUM(p.price) / COUNT(DISTINCT o.order_id), 2) AS avg_spend_per_order,
        ROW_NUMBER() OVER (PARTITION BY YEAR(o.order_date) ORDER BY SUM(p.price) DESC) AS rnk
    FROM users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY year, u.user_id, u.name
)

SELECT year, user_id, name, total_spent, total_orders, avg_spend_per_order
FROM ranked_spenders
WHERE rnk <= 3
ORDER BY year, rnk;

-- Total and average skincare spend per skin type per year
-- Answers: “Do oily-skinned users spend more than dry or sensitive users?”

SELECT 
    YEAR(o.order_date) AS year,
    u.skin_type,
    ROUND(SUM(p.price), 2) AS total_spent,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(oi.product_id) AS total_items,
    ROUND(SUM(p.price) / COUNT(DISTINCT o.order_id), 2) AS avg_spend_per_order
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY year, u.skin_type
ORDER BY year, total_spent DESC;

-- Time-based loyalty: users who appear in top 3 spenders across multiple years
-- Helps identify consistently high-value customers

WITH ranked_spenders AS (
    SELECT 
        YEAR(o.order_date) AS year,
        u.user_id,
        u.name,
        ROUND(SUM(p.price), 2) AS total_spent,
        ROW_NUMBER() OVER (PARTITION BY YEAR(o.order_date) ORDER BY SUM(p.price) DESC) AS rnk
    FROM users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY year, u.user_id, u.name
),
top_spenders AS (
    SELECT * FROM ranked_spenders WHERE rnk <= 3
)

SELECT 
    user_id,
    name,
    COUNT(DISTINCT year) AS years_in_top3,
    GROUP_CONCAT(year ORDER BY year) AS years
FROM top_spenders
GROUP BY user_id, name
HAVING years_in_top3 > 1
ORDER BY years_in_top3 DESC;




