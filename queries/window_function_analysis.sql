use skincare_store;

-- Query 1: Products that outperform their category’s average rating
-- For each product, compare its rating with the average rating of its category, and identify which products perform above average.
-- Helps identify top performers or underperformers within each category

SELECT 
    product_id,
    name,
    category,
    rating,
    ROUND(AVG(rating) OVER (PARTITION BY category), 2) AS category_avg_rating,
    ROUND(rating - AVG(rating) OVER (PARTITION BY category), 2) AS rating_diff
FROM products
ORDER BY rating_diff DESC;

-- Products with above-average rating in their category
-- Filters out low or average performers to highlight standout products

WITH product_ratings AS (
    SELECT 
        product_id,
        name,
        category,
        rating,
        ROUND(AVG(rating) OVER (PARTITION BY category), 2) AS category_avg_rating,
        ROUND(rating - AVG(rating) OVER (PARTITION BY category), 2) AS rating_diff
    FROM products
)
SELECT *
FROM product_ratings
WHERE rating > category_avg_rating
ORDER BY rating_diff DESC;

-- Cumulative spend per user over time
-- Shows how much each user has spent, building up across their orders — perfect for loyalty tiers, milestone triggers, or retention strategies.
-- Tracks lifetime value buildup per user across order history
-- Useful for loyalty analysis, milestone rewards, or churn detection

SELECT 
    u.user_id,
    u.name,
    o.order_id,
    o.order_date,
    ROUND(SUM(p.price) OVER (
        PARTITION BY u.user_id 
        ORDER BY o.order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 2) AS cumulative_spend
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
ORDER BY u.user_id, o.order_date;

-- Ingredient Diversity Score per User
-- Measures how many unique skincare ingredients each user has tried — great for identifying “skin explorers” vs “routine loyalists”.
-- Counts how many distinct ingredients a user has tried through their orders
-- Useful for understanding user skincare exploration patterns

SELECT 
    u.user_id,
    u.name,
    COUNT(DISTINCT pi.ingredient_id) AS unique_ingredients_used
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN product_ingredients pi ON oi.product_id = pi.product_id
GROUP BY u.user_id, u.name
ORDER BY unique_ingredients_used DESC;

-- When was each product’s peak ordering year?
-- This tells you the lifecycle of a product: whether it's newly trending, long-term loved, or fading.

WITH product_yearly_orders AS (
    SELECT p.product_id, p.name,
        YEAR(o.order_date) AS year,
        COUNT(*) AS times_ordered,
        ROW_NUMBER() OVER ( PARTITION BY p.product_id ORDER BY COUNT(*) DESC ) AS rnk
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    GROUP BY p.product_id, p.name, year
)
SELECT product_id, name, year AS peak_year, times_ordered
FROM product_yearly_orders
WHERE rnk = 1
ORDER BY peak_year, times_ordered DESC;

-- Which product peaked in each year?
-- In other words: the most frequently ordered product within each year

WITH product_orders_by_year AS (
    SELECT p.product_id, p.name, YEAR(o.order_date) AS year, COUNT(*) AS times_ordered,
        ROW_NUMBER() OVER ( PARTITION BY YEAR(o.order_date) ORDER BY COUNT(*) DESC ) AS rnk
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    GROUP BY p.product_id, p.name, year
)
SELECT 
    year, name, times_ordered
FROM product_orders_by_year
WHERE rnk = 1
ORDER BY year DESC;

-- Peaking year for each ingredient based on order frequency
-- Identifies which year each active or ingredient was most popular in product usage

WITH ingredient_orders_per_year AS (
    SELECT i.ingredient_id, i.name AS ingredient_name, 
		YEAR(o.order_date) AS year, COUNT(*) AS times_used,
        ROW_NUMBER() OVER ( PARTITION BY i.ingredient_id ORDER BY COUNT(*) DESC) AS rnk
    FROM ingredients i
    JOIN product_ingredients pi ON i.ingredient_id = pi.ingredient_id
    JOIN order_items oi ON pi.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    GROUP BY i.ingredient_id, i.name, year
)
SELECT ingredient_name, year AS peak_year, times_used
FROM ingredient_orders_per_year
WHERE rnk = 1
ORDER BY peak_year, times_used DESC;

-- 📅 Peaking ingredient per year
-- Shows the most-used skincare ingredient in ordered products for each year

WITH ingredient_usage_by_year AS (
    SELECT 
        YEAR(o.order_date) AS year,
        i.ingredient_id,
        i.name AS ingredient_name,
        COUNT(*) AS times_used,
        ROW_NUMBER() OVER (
            PARTITION BY YEAR(o.order_date)
            ORDER BY COUNT(*) DESC
        ) AS rnk
    FROM ingredients i
    JOIN product_ingredients pi ON i.ingredient_id = pi.ingredient_id
    JOIN order_items oi ON pi.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    GROUP BY year, i.ingredient_id, i.name
)

SELECT 
    year,
    ingredient_name,
    times_used
FROM ingredient_usage_by_year
WHERE rnk = 1
ORDER BY year;

-- Year-on-Year Ingredient Popularity Change
-- Did this ingredient rise or fall in usage compared to the previous year?
-- Positive diff = trending up, negative = declining
WITH ingredient_usage AS (
    SELECT 
        i.ingredient_id,
        i.name AS ingredient_name,
        YEAR(o.order_date) AS year,
        COUNT(*) AS times_used
    FROM ingredients i
    JOIN product_ingredients pi ON i.ingredient_id = pi.ingredient_id
    JOIN order_items oi ON pi.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    GROUP BY i.ingredient_id, i.name, year
),
ingredient_with_lag AS (
    SELECT 
        *,
        LAG(times_used) OVER (PARTITION BY ingredient_id ORDER BY year) AS prev_year_usage,
        (times_used - LAG(times_used) OVER (PARTITION BY ingredient_id ORDER BY year)) AS year_over_year_diff
    FROM ingredient_usage
)

SELECT 
    ingredient_name,
    year,
    times_used,
    prev_year_usage,
    year_over_year_diff
FROM ingredient_with_lag
ORDER BY ingredient_name, year;

-- Product category usage over time
-- See which categories (e.g., serum, mask, cream) are trending up or down each year.

WITH category_usage AS (
    SELECT 
        p.category,
        YEAR(o.order_date) AS year,
        COUNT(*) AS times_ordered
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    GROUP BY p.category, year
),
category_with_lag AS (
    SELECT 
        *,
        LAG(times_ordered) OVER (PARTITION BY category ORDER BY year) AS prev_year_orders,
        (times_ordered - LAG(times_ordered) OVER (PARTITION BY category ORDER BY year)) AS yoy_diff
    FROM category_usage
)

SELECT 
    category,
    year,
    times_ordered,
    prev_year_orders,
    yoy_diff
FROM category_with_lag
ORDER BY category, year;

-- How many different product categories each user has tried per year
-- This shows how diverse their skincare routine is year by year e.g., cleanser + serum + mask vs just serums
-- Counts how many different product categories a user ordered each year
-- Useful for tracking evolving skincare habits

SELECT 
    u.user_id,
    u.name,
    YEAR(o.order_date) AS year,
    COUNT(DISTINCT p.category) AS unique_categories_used
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY u.user_id, u.name, year
ORDER BY u.user_id, year DESC;

-- 🧬 Ingredient diversity per user per year
-- Tracks how many different skincare ingredients a user tried each year

SELECT 
    u.user_id,
    u.name,
    YEAR(o.order_date) AS year,
    COUNT(DISTINCT pi.ingredient_id) AS unique_ingredients_used
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN product_ingredients pi ON oi.product_id = pi.product_id
GROUP BY u.user_id, u.name, year
ORDER BY u.user_id, year DESC;

-- 🔁 Category set per user per year
-- Helps assess skincare routine stability or evolution across time

SELECT 
    u.user_id,
    u.name,
    YEAR(o.order_date) AS year,
    GROUP_CONCAT(DISTINCT p.category ORDER BY p.category SEPARATOR ', ') AS categories_used
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY u.user_id, u.name, year
ORDER BY u.user_id, year;

