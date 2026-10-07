-- ============================================================
-- RETAIL SALES & PROFITABILITY ANALYSIS
-- Business Analysis using PostgreSQL
-- ============================================================


-- ============================================================
-- 1. OVERALL SALES, PROFIT & PROFIT MARGIN
-- ============================================================
-- Purpose:
-- Understand the overall financial performance of the business.

SELECT
    ROUND(SUM(sales)::numeric, 2) AS total_sales,
    ROUND(SUM(profit)::numeric, 2) AS total_profit,
    ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric,
        2
    ) AS profit_margin
FROM superstore;


-- ============================================================
-- 2. YEARLY SALES & PROFIT PERFORMANCE
-- ============================================================
-- Purpose:
-- Analyze how sales and profitability changed over the years.

SELECT
    EXTRACT(YEAR FROM order_date) AS order_year,
    ROUND(SUM(sales)::numeric, 2) AS total_sales,
    ROUND(SUM(profit)::numeric, 2) AS total_profit,
    ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric,
        2
    ) AS profit_margin
FROM superstore
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY order_year;


-- ============================================================
-- 3. PRODUCT CATEGORY PERFORMANCE
-- ============================================================
-- Purpose:
-- Compare sales and profitability across major product
-- categories.

SELECT
    product_category,
    ROUND(SUM(sales)::numeric, 2) AS total_sales,
    ROUND(SUM(profit)::numeric, 2) AS total_profit,
    ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric,
        2
    ) AS profit_margin
FROM superstore
GROUP BY product_category
ORDER BY total_profit DESC;


-- ============================================================
-- 4. PRODUCT SUBCATEGORY PERFORMANCE
-- ============================================================
-- Purpose:
-- Identify which product subcategories contribute the most
-- and least to profitability.

SELECT
    "product_sub_category",
    ROUND(SUM(sales)::numeric, 2) AS total_sales,
    ROUND(SUM(profit)::numeric, 2) AS total_profit,
    ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric,
        2
    ) AS profit_margin
FROM superstore
GROUP BY "product_sub_category"
ORDER BY total_profit DESC;


-- ============================================================
-- 5. REGIONAL PERFORMANCE
-- ============================================================
-- Purpose:
-- Compare sales and profitability across different regions.

SELECT
    region,
    ROUND(SUM(sales)::numeric, 2) AS total_sales,
    ROUND(SUM(profit)::numeric, 2) AS total_profit,
    ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric,
        2
    ) AS profit_margin
FROM superstore
GROUP BY region
ORDER BY total_profit DESC;


-- ============================================================
-- 6. CUSTOMER SEGMENT PERFORMANCE
-- ============================================================
-- Purpose:
-- Understand which customer segments generate the most
-- revenue and profit.

SELECT
    customer_segment,
    ROUND(SUM(sales)::numeric, 2) AS total_sales,
    ROUND(SUM(profit)::numeric, 2) AS total_profit,
    ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric,
        2
    ) AS profit_margin
FROM superstore
GROUP BY customer_segment
ORDER BY total_profit DESC;


-- ============================================================
-- 7. DISCOUNT VS PROFITABILITY
-- ============================================================
-- Purpose:
-- Analyze how different discount levels are associated
-- with sales and profitability.

SELECT
    discount,
    ROUND(SUM(sales)::numeric, 2) AS total_sales,
    ROUND(SUM(profit)::numeric, 2) AS total_profit,
    ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric,
        2
    ) AS profit_margin
FROM superstore
GROUP BY discount
ORDER BY discount;


-- ============================================================
-- 8. TOP 10 MOST PROFITABLE CUSTOMERS
-- ============================================================
-- Purpose:
-- Identify customers who contribute the most profit.

SELECT
    customer_name,
    ROUND(SUM(sales)::numeric, 2) AS total_sales,
    ROUND(SUM(profit)::numeric, 2) AS total_profit
FROM superstore
GROUP BY customer_name
ORDER BY total_profit DESC
LIMIT 10;


-- ============================================================
-- 9. TOP 10 MOST PROFITABLE PRODUCTS
-- ============================================================
-- Purpose:
-- Identify individual products generating the highest
-- total profit.

SELECT
    product_name,
    product_category,
    ROUND(SUM(sales)::numeric, 2) AS total_sales,
    ROUND(SUM(profit)::numeric, 2) AS total_profit
FROM superstore
GROUP BY product_name, product_category
ORDER BY total_profit DESC
LIMIT 10;


-- ============================================================
-- 10. FURNITURE PROFITABILITY DRILL-DOWN
-- ============================================================
-- Purpose:
-- Investigate why Furniture has relatively low profitability
-- despite generating substantial sales.
--
-- This breaks Furniture down into its subcategories.

SELECT
    "product_sub_category",
    ROUND(SUM(sales)::numeric, 2) AS total_sales,
    ROUND(SUM(profit)::numeric, 2) AS total_profit,
    ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric,
        2
    ) AS profit_margin
FROM superstore
WHERE product_category = 'Furniture'
GROUP BY "product_sub_category"
ORDER BY total_profit ASC;


-- ============================================================
-- 11. FURNITURE DISCOUNT ANALYSIS
-- ============================================================
-- Purpose:
-- Examine whether different discount levels are associated
-- with changes in Furniture profitability.

SELECT
    discount,
    ROUND(SUM(sales)::numeric, 2) AS total_sales,
    ROUND(SUM(profit)::numeric, 2) AS total_profit,
    ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric,
        2
    ) AS profit_margin
FROM superstore
WHERE product_category = 'Furniture'
GROUP BY discount
ORDER BY discount;


-- ============================================================
-- 12. TABLES & BOOKCASES: DISCOUNT VS PROFITABILITY
-- ============================================================
-- Purpose:
-- Drill further into the two loss-making Furniture
-- subcategories to investigate their performance at
-- different discount levels.

SELECT
    "product_sub_category",
    discount,
    ROUND(SUM(sales)::numeric, 2) AS total_sales,
    ROUND(SUM(profit)::numeric, 2) AS total_profit,
    ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric,
        2
    ) AS profit_margin
FROM superstore
WHERE "product_sub_category" IN ('Tables', 'Bookcases')
GROUP BY "product_sub_category", discount
ORDER BY "product_sub_category", discount;


-- ============================================================
-- 13. LOSS-MAKING PRODUCTS
-- ============================================================
-- Purpose:
-- Identify products that generate an overall loss and may
-- require pricing, discount, or product strategy review.

SELECT
    product_name,
    product_category,
    ROUND(SUM(sales)::numeric, 2) AS total_sales,
    ROUND(SUM(profit)::numeric, 2) AS total_profit
FROM superstore
GROUP BY product_name, product_category
HAVING SUM(profit) < 0
ORDER BY total_profit ASC
LIMIT 10;


-- ============================================================
-- END OF BUSINESS ANALYSIS
-- ============================================================