use skincare_store;

INSERT INTO users (user_id, name, age, gender, skin_type, skin_concerns) VALUES
(1, 'Ananya Iyer', 26, 'female', 'dry', 'pigmentation, dullness'),
(2, 'Léa Dupont', 32, 'female', 'sensitive', 'redness, irritation'),
(3, 'Arjun Mehta', 29, 'male', 'oily', 'acne, large pores'),
(4, 'Émile Bernard', 41, 'male', 'normal', 'fine lines'),
(5, 'Priya Sharma', 22, 'female', 'acne-prone', 'acne, post-acne marks'),
(6, 'Camille Roche', 35, 'female', 'combination', 'pigmentation, fine lines'),
(7, 'Rohan Deshmukh', 27, 'male', 'sensitive', 'irritation, dryness'),
(8, 'Noor Khan', 30, 'female', 'oily', 'blackheads, acne'),
(9, 'Luc Moreau', 38, 'male', 'dry', 'flakiness, dullness'),
(10, 'Meera Nambiar', 25, 'female', 'acne-prone', 'acne, oiliness, dark spots');

select * from skincare_store.users;

INSERT INTO products (product_id, name, brand, category, price, rating) VALUES
(1, 'Hydrating Facial Cleanser', 'CeraVe', 'cleanser', 899.00, 4.6),
(2, 'Vitamin C Glow Serum', 'The Ordinary', 'serum', 1150.00, 4.4),
(3, 'Niacinamide 10% + Zinc 1%', 'The Ordinary', 'serum', 890.00, 4.5),
(4, 'Gentle Skin Cleanser', 'Cetaphil', 'cleanser', 799.00, 4.3),
(5, 'AHA 30% + BHA 2% Peeling Solution', 'The Ordinary', 'exfoliator', 1250.00, 4.1),
(6, 'Rice Water Bright Foaming Cleanser', 'The Face Shop', 'cleanser', 650.00, 4.2),
(7, 'Hyaluronic Acid Moisturizing Cream', 'Neutrogena', 'moisturizer', 1350.00, 4.7),
(8, 'Oil-Free Acne Wash', 'Neutrogena', 'cleanser', 975.00, 4.0),
(9, 'UV Clear Sunscreen SPF 50', 'La Roche-Posay', 'sunscreen', 1450.00, 4.8),
(10, 'Bright Complete Vitamin C Serum', 'Garnier', 'serum', 749.00, 4.2),
(11, 'Advanced Snail 96 Mucin Power Essence', 'COSRX', 'serum', 1450.00, 4.8),
(12, 'Rice Water Toner', 'Tonymoly', 'toner', 850.00, 4.4),
(13, '6 Peptide Complex Serum', 'Some By Mi', 'serum', 1650.00, 4.6),
(14, 'Green Tea Fresh Emulsion', 'Innisfree', 'moisturizer', 1200.00, 4.5),
(15, 'Low pH Good Morning Gel Cleanser', 'COSRX', 'cleanser', 950.00, 4.7),
(16, 'I\'m Real Sheet Mask – Aloe', 'Tonymoly', 'sheet mask', 120.00, 4.3),
(17, 'I\'m Real Sheet Mask – Green Tea', 'Tonymoly', 'sheet mask', 120.00, 4.5),
(18, 'I\'m Real Sheet Mask – Rice', 'Tonymoly', 'sheet mask', 120.00, 4.4),
(19, 'I\'m Real Sheet Mask – Red Wine', 'Tonymoly', 'sheet mask', 120.00, 4.2),
(20, 'I\'m Real Sheet Mask – Avocado', 'Tonymoly', 'sheet mask', 120.00, 4.6);

select * from products;


INSERT INTO ingredients (ingredient_id, name, benefits, comedogenic_rating) VALUES
(1, 'Niacinamide', 'Reduces pores, evens skin tone', 2),
(2, 'Hyaluronic Acid', 'Deep hydration, plumps skin', 0),
(3, 'Salicylic Acid', 'Unclogs pores, treats acne', 2),
(4, 'Glycolic Acid', 'Exfoliates dead skin, smooths texture', 2),
(5, 'Vitamin C', 'Brightens, boosts collagen', 1),
(6, 'Snail Mucin', 'Heals, hydrates, improves elasticity', 0),
(7, 'Rice Extract', 'Brightens, softens, smoothens', 0),
(8, 'Aloe Vera', 'Soothes irritation, hydrates', 0),
(9, 'Green Tea Extract', 'Antioxidant, soothes, controls oil', 1),
(10, 'Tea Tree Oil', 'Fights acne, antibacterial', 2),
(11, 'Lactic Acid', 'Gently exfoliates, hydrates', 2),
(12, 'Zinc PCA', 'Regulates oil, reduces acne', 1),
(13, 'Retinol', 'Anti-aging, smooths fine lines', 2),
(14, 'Avocado Extract', 'Nourishes, softens dry skin', 2),
(15, 'Red Wine Extract', 'Antioxidant, tightens skin', 1);

INSERT INTO product_ingredients (product_id, ingredient_id) VALUES
(1, 2), (1, 8),
(2, 5), (2, 2),
(3, 1), (3, 12),
(4, 2), (4, 8),
(5, 4), (5, 3),
(6, 7), (6, 8),
(7, 2), (7, 1),
(8, 3), (8, 10),
(9, 1), (9, 2),
(10, 5), (10, 1),
(11, 6), (11, 2),
(12, 7), (12, 5),
(13, 1), (13, 2),
(14, 9), (14, 2),
(15, 8), (15, 10),
(16, 8), (16, 2),
(17, 9), (17, 2),
(18, 7), (18, 8),
(19, 15), (19, 5),
(20, 14), (20, 2);

INSERT INTO orders (order_id, user_id, order_date) VALUES
(1, 1, '2024-05-01'),
(2, 2, '2024-05-03'),
(3, 3, '2024-05-04'),
(4, 4, '2024-05-06'),
(5, 5, '2024-05-07'),
(6, 1, '2024-05-10'),
(7, 2, '2024-05-12'),
(8, 3, '2024-05-13'),
(9, 4, '2024-05-15'),
(10, 5, '2024-05-18'),
(11, 1, '2024-05-19'),
(12, 2, '2024-05-21'),
(13, 3, '2024-05-23'),
(14, 4, '2024-05-25'),
(15, 5, '2024-05-28');


INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 3, 1),   -- Niacinamide + Zinc
(1, 7, 1),   -- Moisturizer

(2, 5, 1),   -- Peeling Solution
(2, 13, 1),  -- 6 Peptide Serum

(3, 10, 1),  -- Vitamin C Serum
(3, 14, 1),  -- Green Tea Emulsion

(4, 1, 1),
(4, 2, 1),

(5, 11, 1),  -- Snail Mucin
(5, 12, 1),  -- Rice Toner

(6, 13, 1),
(6, 7, 1),

(7, 19, 1),  -- Red Wine Mask
(7, 20, 1),  -- Avocado Mask

(8, 15, 1),
(8, 6, 1),

(9, 8, 1),
(9, 3, 1),

(10, 4, 1),
(10, 9, 1),

(11, 10, 1),
(11, 13, 1),

(12, 7, 1),
(12, 11, 1),

(13, 5, 1),
(13, 2, 1),

(14, 16, 1),  -- Aloe Mask
(14, 18, 1),  -- Rice Mask

(15, 17, 1),  -- Green Tea Mask
(15, 12, 1);

-- Which skin types are ordering more anti-aging products?

SELECT u.skin_type, COUNT(DISTINCT oi.order_id) AS total_orders
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN anti_aging_products aap ON oi.product_id = aap.product_id
GROUP BY u.skin_type
ORDER BY total_orders DESC;

-- Which Anti-Aging Products Are Being Purchased Most Often?

SELECT aap.product_name,
    aap.brand,
    COUNT(*) AS times_purchased
FROM anti_aging_products aap
JOIN order_items oi ON aap.product_id = oi.product_id
GROUP BY aap.product_name, aap.brand
ORDER BY times_purchased DESC
LIMIT 5;

-- Does Price Correlate with Rating for Anti-Aging Products?

SELECT DISTINCT 
    product_name,
    brand,
    price,
    rating
FROM anti_aging_products
ORDER BY rating DESC;

SELECT 
    ROUND(price, -2) AS price_range, 
    ROUND(AVG(rating), 2) AS avg_rating,
    COUNT(DISTINCT product_id) AS products_in_range
FROM anti_aging_products
GROUP BY ROUND(price, -2)
ORDER BY price_range;

SELECT 
    FLOOR(price / 500) * 500 AS price_bucket,
    ROUND(AVG(rating), 2) AS avg_rating,
    COUNT(DISTINCT product_id) AS products_in_bucket
FROM anti_aging_products
GROUP BY price_bucket
ORDER BY price_bucket;

INSERT INTO products (product_id, name, brand, category, price, rating) VALUES
(21, 'Retinol Youth Renewal Serum', 'Murad', 'serum', 1950, 4.8),
(22, 'Collagen Boosting Night Cream', 'Olay', 'cream', 1350, 4.4),
(23, 'Peptide Firming Eye Serum', 'The Ordinary', 'serum', 950, 4.6),
(24, 'Hyaluronic + Retinol Sheet Mask', 'TONYMOLY', 'mask', 350, 4.1),
(25, 'Bakuchiol Anti-Aging Oil', 'Minimalist', 'oil', 599, 4.3),
(26, 'Coenzyme Q10 Anti-Wrinkle Cream', 'Nivea', 'cream', 799, 3.9),
(27, 'Advanced Lifting Face Serum', 'LOréal', 'serum', 1650, 4.7),
(28, 'Snail Repair Intensive Ampoule', 'Mizon', 'ampoule', 1100, 4.5),
(29, 'Firming & Lifting Sleeping Pack', 'Laneige', 'mask', 1850, 4.9),
(30, 'Age Rewind Peptide Moisturizer', 'Plum', 'cream', 699, 4.2),
(31, 'Night Peptide Concentrate', 'Dot & Key', 'serum', 1199, 4.4),
(32, 'Vitamin E + Retinol Facial Oil', 'The Moms Co', 'oil', 899, 4.0),
(33, 'Retinol Glow Serum', 'WOW Skin Sci', 'serum', 499, 3.8),
(34, 'Peptide Lift Firming Toner', 'CosRx', 'toner', 1050, 4.6),
(35, 'Wrinkle Smoothing Eye Cream', 'The Inkey List', 'cream', 1250, 4.3);

INSERT INTO ingredients (name, benefits, comedogenic_rating) VALUES
('Peptides', 'Anti-aging, firms skin, promotes collagen production', 1),
('Bakuchiol', 'Plant-based alternative to retinol, reduces fine lines', 1),
('Vitamin E', 'Antioxidant, repairs skin, improves elasticity', 2),
('Coenzyme Q10', 'Reduces wrinkles, energizes skin cells', 1),
('Snail Mucin', 'Hydrating, healing, supports anti-aging', 1),
('Collagen', 'Boosts firmness, reduces sagging and wrinkles', 1);

INSERT INTO product_ingredients (product_id, ingredient_id) VALUES
(22, 21),  -- Collagen Boosting Night Cream → Collagen
(23, 16),  -- Peptide Eye Serum → Peptides
(24, 13),  -- Retinol Mask → Retinol
(24, 16),  -- + Peptides
(25, 17),  -- Bakuchiol Oil → Bakuchiol
(26, 19),  -- Coenzyme Q10 Cream → Q10
(27, 16),  -- Lifting Serum → Peptides
(28, 20),  -- Snail Repair Ampoule → Snail Mucin
(29, 16),  -- Firming Sleeping Pack → Peptides
(30, 16),  -- Peptide Moisturizer → Peptides
(31, 16),  -- Peptide Night Concentrate → Peptides
(32, 13),  -- Retinol Oil → Retinol
(32, 18),  -- + Vitamin E
(33, 13),  -- Retinol Glow Serum → Retinol
(34, 16),  -- Peptide Toner → Peptides
(35, 16);  -- Eye Cream → Peptides



select * from products;

select * from ingredients;

SELECT * FROM products WHERE product_id = 21;

SELECT * FROM ingredients WHERE ingredient_id = 13;

SELECT ingredient_id FROM ingredients WHERE name = 'Retinol';

SELECT * FROM ingredients WHERE ingredient_id IS NULL;

DELETE FROM ingredients WHERE ingredient_id IS NULL;

DELETE FROM products WHERE product_id IS NULL;

DELETE 
FROM ingredients
WHERE name IS NULL AND benefits IS NULL AND comedogenic_rating IS NULL;

SET SQL_SAFE_UPDATES = 0;


SELECT ingredient_id, LENGTH(name), LENGTH(benefits), comedogenic_rating
FROM ingredients
WHERE name IS NULL OR name = '' OR benefits IS NULL OR benefits = '' OR comedogenic_rating IS NULL;

DELETE FROM ingredients
WHERE name IS NULL 
   OR name = ''
   OR benefits IS NULL 
   OR benefits = ''
   OR comedogenic_rating IS NULL;


SELECT * FROM ingredients WHERE name IS NULL OR name = '' OR benefits IS NULL OR benefits = '';

ALTER TABLE ingredients
MODIFY name VARCHAR(255) NOT NULL,
MODIFY benefits TEXT NOT NULL,
MODIFY comedogenic_rating INT NOT NULL;

INSERT INTO ingredients (ingredient_id, name, benefits, comedogenic_rating)
VALUES (13, 'Retinol', 'Anti-aging, smooths fine lines, reduces wrinkles', 1);

INSERT INTO product_ingredients (product_id, ingredient_id)
VALUES (21, 13);
