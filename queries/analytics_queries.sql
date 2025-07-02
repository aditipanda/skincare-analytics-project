use skincare_store;

-- Which skin types are ordering more anti-aging products?

SELECT u.skin_type, COUNT(DISTINCT oi.order_id) AS total_orders
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN anti_aging_products aap ON oi.product_id = aap.product_id
GROUP BY u.skin_type
ORDER BY total_orders DESC;

-- Which Anti-Aging Products Are Being Purchased Most Often?

SELECT aap.name,
    aap.brand,
    COUNT(*) AS times_purchased
FROM anti_aging_products aap
JOIN order_items oi ON aap.product_id = oi.product_id
GROUP BY aap.name, aap.brand
ORDER BY times_purchased DESC
LIMIT 5;

-- Does Price Correlate with Rating for Anti-Aging Products?

SELECT DISTINCT 
    name,
    brand,
    price,
    rating
FROM anti_aging_products
ORDER BY rating DESC;

-- Average rating and product count grouped by rounded price range (nearest 100)
-- Helps identify which price bands are most popular and well-rated

SELECT 
    ROUND(price, -2) AS price_range, 
    ROUND(AVG(rating), 2) AS avg_rating,
    COUNT(DISTINCT product_id) AS products_in_range
FROM anti_aging_products
GROUP BY ROUND(price, -2)
ORDER BY price_range;

-- Price vs rating grouped into 500-rupee intervals (e.g., 0–499, 500–999)
-- Useful for detecting rating trends across price tiers

SELECT 
    FLOOR(price / 500) * 500 AS price_bucket,
    ROUND(AVG(rating), 2) AS avg_rating,
    COUNT(DISTINCT product_id) AS products_in_bucket
FROM anti_aging_products
GROUP BY price_bucket
ORDER BY price_bucket;

-- Query to Search Ingredients by Benefit Keywords
-- We’ll look for: Benefits that mention acne/oil, Low comedogenic rating (< 3)

SELECT *
FROM ingredients
WHERE 
    comedogenic_rating < 3 AND (
        benefits LIKE '%acne%' OR
        benefits LIKE '%oil%' OR
        benefits LIKE '%sebum%' OR
        benefits LIKE '%pore%' OR
        benefits LIKE '%antibacterial%'
    );


-- List all products with acne-fighting ingredients (e.g., containing Salicylic Acid, Tea Tree Oil, Zinc PCA)

SELECT DISTINCT pdi.product_name, pdi.brand, pdi.category, pdi.rating, pdi.ingredient_name
FROM product_details_with_ingredients pdi
WHERE pdi.ingredient_name IN (
    SELECT name 
    FROM ingredients
    WHERE comedogenic_rating < 3 AND (
            benefits LIKE '%acne%' OR
            benefits LIKE '%oil%' OR
            benefits LIKE '%sebum%' OR
            benefits LIKE '%pore%' OR
            benefits LIKE '%antibacterial%'
        )
)
ORDER BY pdi.rating DESC;

-- Top-rated serums (rating > 4.5)

SELECT DISTINCT product_name, brand, rating
FROM product_details_with_ingredients
WHERE category = 'serum' AND rating > 4.5
ORDER BY rating DESC;

-- Most commonly used ingredients

SELECT ingredient_name, COUNT(DISTINCT product_id) AS product_count
FROM product_details_with_ingredients
GROUP BY ingredient_name
ORDER BY product_count DESC
LIMIT 5;

-- Count of anti-aging products by category (e.g., serum, cream, mask)
-- Helps identify which categories dominate the anti-aging segment

SELECT category, COUNT(DISTINCT product_id) AS anti_aging_products
FROM anti_aging_products
GROUP BY category
ORDER BY anti_aging_products DESC;

-- Top Performing Anti-Aging Products

SELECT name, brand, category, rating
FROM anti_aging_products
ORDER BY rating DESC
LIMIT 5;

-- Most Popular Categories for Anti-Aging: Are serums more used than creams for anti-aging?

SELECT category, COUNT(DISTINCT product_id) AS count
FROM anti_aging_products
GROUP BY category
ORDER BY count DESC;

-- Most Common Anti-Aging Ingredients
SELECT ingredient_name, COUNT(DISTINCT product_id) AS usage_count
FROM anti_aging_products
GROUP BY ingredient_name
ORDER BY usage_count DESC;

--  Ingredient Diversity Across Brands

SELECT brand, COUNT(DISTINCT ingredient_name) AS unique_ingredients
FROM anti_aging_products
GROUP BY brand
ORDER BY unique_ingredients DESC;

-- Brand Efficiency: Which brand has the highest-rated anti-aging product?

SELECT brand, name, rating
FROM anti_aging_products
ORDER BY rating DESC
LIMIT 1;
