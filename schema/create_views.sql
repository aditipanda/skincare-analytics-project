use skincare_store;

CREATE VIEW product_details_with_ingredients AS
SELECT 
    p.product_id,
    p.name AS product_name,
    p.brand,
    p.category,
    p.price,
    p.rating,
    i.ingredient_id,
    i.name AS ingredient_name,
    i.benefits,
    i.comedogenic_rating
FROM 
    products p
JOIN 
    product_ingredients pi ON p.product_id = pi.product_id
JOIN 
    ingredients i ON pi.ingredient_id = i.ingredient_id;

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

SELECT DISTINCT 
    pdi.product_name, pdi.brand, pdi.category, pdi.rating, pdi.ingredient_name
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

CREATE VIEW anti_aging_products AS
SELECT DISTINCT pdi.product_id, pdi.product_name,
    pdi.brand, pdi.category, pdi.rating,
    pdi.ingredient_name, pdi.benefits
FROM product_details_with_ingredients pdi
WHERE pdi.ingredient_name IN (
    SELECT name
    FROM ingredients
    WHERE comedogenic_rating < 3 AND (
            benefits LIKE '%aging%' OR
            benefits LIKE '%fine%' OR
            benefits LIKE '%wrinkle%'
        )
);

drop view anti_aging_products;

SELECT * FROM anti_aging_products ORDER BY rating DESC;

SELECT name, benefits
FROM ingredients
WHERE benefits LIKE '%fine%' OR benefits LIKE '%aging%' OR benefits LIKE '%wrinkle%';

SELECT *
FROM product_ingredients
WHERE ingredient_id = 13;

INSERT INTO product_ingredients (product_id, ingredient_id)
VALUES (13, 13);  -- Retinol to 6 Peptide Complex Serum

INSERT INTO product_ingredients (product_id, ingredient_id) VALUES
(14, 13),
(7, 13),
(10, 13),
(19, 13);

SELECT * FROM anti_aging_products ORDER BY rating DESC;

SELECT category, COUNT(DISTINCT product_id) AS anti_aging_products
FROM anti_aging_products
GROUP BY category
ORDER BY anti_aging_products DESC;

-- Top Performing Anti-Aging Products

SELECT product_name, brand, category, rating
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

SELECT brand, product_name, rating
FROM anti_aging_products
ORDER BY rating DESC
LIMIT 1;

CREATE OR REPLACE VIEW anti_aging_products AS
SELECT DISTINCT 
    pdi.product_id,
    pdi.product_name,
    pdi.brand,
    pdi.category,
    pdi.price,         -- 👈 Add this line
    pdi.rating,
    pdi.ingredient_name,
    pdi.benefits
FROM product_details_with_ingredients pdi
WHERE pdi.ingredient_name IN (
    SELECT name
    FROM ingredients
    WHERE 
        comedogenic_rating < 3 AND (
            benefits LIKE '%aging%' OR
            benefits LIKE '%fine%' OR
            benefits LIKE '%wrinkle%'
        )
);

CREATE OR REPLACE VIEW anti_aging_products AS
SELECT DISTINCT 
    p.product_id,
    p.name,
    p.brand,
    p.category,
    p.price,
    p.rating,
    i.name AS ingredient_name,
    i.benefits
FROM products p
JOIN product_ingredients pi ON p.product_id = pi.product_id
JOIN ingredients i ON pi.ingredient_id = i.ingredient_id
WHERE i.comedogenic_rating < 3
  AND (
    i.benefits LIKE '%aging%' OR
    i.benefits LIKE '%fine%' OR
    i.benefits LIKE '%wrinkle%'
  );

SELECT * FROM anti_aging_products ORDER BY rating DESC;
