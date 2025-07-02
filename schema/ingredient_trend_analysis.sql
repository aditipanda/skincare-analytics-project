use skincare_store;

-- Which skincare ingredients were most frequently used in ordered products, year by year?
-- Year-wise count of ingredient usage in all ordered products
-- Helps identify trending ingredients over time

SELECT 
    YEAR(o.order_date) AS year,
    i.name AS ingredient_name,
    COUNT(*) AS times_used
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN product_ingredients pi ON oi.product_id = pi.product_id
JOIN ingredients i ON pi.ingredient_id = i.ingredient_id
GROUP BY year, ingredient_name
ORDER BY year, times_used DESC;

-- Most popular (most-used) skincare ingredient per year based on orders
-- Shows leading trend driver for each year

WITH ranked_ingredients AS (
    SELECT 
        YEAR(o.order_date) AS year,
        i.name AS ingredient_name,
        COUNT(*) AS times_used,
        ROW_NUMBER() OVER (PARTITION BY YEAR(o.order_date) ORDER BY COUNT(*) DESC) AS rnk
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN product_ingredients pi ON oi.product_id = pi.product_id
    JOIN ingredients i ON pi.ingredient_id = i.ingredient_id
    GROUP BY year, i.name
)

SELECT year, ingredient_name, times_used
FROM ranked_ingredients
WHERE rnk = 1
ORDER BY year;

-- Most purchased skincare product per year based on order frequency
-- Reveals the top-selling product each year

WITH ranked_products AS (
    SELECT 
        YEAR(o.order_date) AS year,
        p.name,
        COUNT(*) AS times_purchased,
        ROW_NUMBER() OVER (PARTITION BY YEAR(o.order_date) ORDER BY COUNT(*) DESC) AS rnk
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY year, p.name
)

SELECT year, name, times_purchased
FROM ranked_products
WHERE rnk = 1
ORDER BY year;

-- Most frequently ordered product category per year (e.g., serum, mask, cream)
-- Helps track user preference shifts in formulation types

WITH ranked_categories AS (
    SELECT 
        YEAR(o.order_date) AS year,
        p.category,
        COUNT(*) AS times_ordered,
        ROW_NUMBER() OVER (PARTITION BY YEAR(o.order_date) ORDER BY COUNT(*) DESC) AS rnk
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY year, p.category
)

SELECT year, category, times_ordered
FROM ranked_categories
WHERE rnk = 1
ORDER BY year;

-- Most frequently ordered brand per year
-- Useful for identifying which skincare brands dominated each year

WITH ranked_brands AS (
    SELECT 
        YEAR(o.order_date) AS year,
        p.brand,
        COUNT(*) AS times_ordered,
        ROW_NUMBER() OVER (PARTITION BY YEAR(o.order_date) ORDER BY COUNT(*) DESC) AS rnk
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY year, p.brand
)

SELECT year, brand, times_ordered
FROM ranked_brands
WHERE rnk = 1
ORDER BY year;

