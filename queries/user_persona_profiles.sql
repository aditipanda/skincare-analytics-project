-- 🌟 Loyalty & Lifestyle Tags Per User
-- Assigns personas like "High Spender", "Explorer", or "Minimalist" based on:
-- - Spend level
-- - Ingredient/category variety
-- - Ordering frequency and span
-- Helps personalize marketing, build user dashboards, or create retention strategies

SELECT 
    u.user_id,
    u.name,
    ROUND(SUM(p.price), 2) AS total_spent,
    COUNT(DISTINCT YEAR(o.order_date)) AS active_years,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT pi.ingredient_id) AS ingredient_diversity,
    COUNT(DISTINCT p.category) AS category_diversity,
    
      CONCAT_WS(', ',
        CASE WHEN SUM(p.price)/COUNT(DISTINCT YEAR(o.order_date)) > 15000 THEN '💎 High Spender' END,
        CASE WHEN COUNT(DISTINCT pi.ingredient_id) >= 15 THEN '🧬 Ingredient Explorer' END,
        CASE WHEN COUNT(DISTINCT p.category) >= 8 THEN '🧴 Category Explorer' END,
        CASE WHEN COUNT(DISTINCT YEAR(o.order_date)) >= 3 THEN '📆 Long-Term User' END,
        CASE WHEN COUNT(DISTINCT o.order_id) >= 17 THEN '📦 Power Buyer' END,
        CASE 
            WHEN COUNT(DISTINCT pi.ingredient_id) < 5 AND COUNT(DISTINCT p.category) < 3 
            THEN '💤 Minimalist' 
        END
    ) AS lifestyle_tags

FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_ingredients pi ON p.product_id = pi.product_id

GROUP BY u.user_id, u.name
ORDER BY total_spent DESC;
