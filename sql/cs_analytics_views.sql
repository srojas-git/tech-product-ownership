-- =========================================================
-- Customer Success Operations & Revenue Analytics Views
-- Database: PostgreSQL (dvdrental)
-- Purpose: Pre-aggregated semantic layer for Power BI dashboard
-- =========================================================

-- 1. Detailed Sales & Account Performance View
CREATE OR REPLACE VIEW reporte_detallado_ventas AS
SELECT 
    r.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.email,
    ct.city,
    cu.country,
    f.title AS film_title,
    cat.name AS category,
    p.amount AS revenue,
    r.rental_date,
    EXTRACT(MONTH FROM r.rental_date) AS rental_month,
    EXTRACT(YEAR FROM r.rental_date) AS rental_year
FROM rental r
JOIN payment p ON r.rental_id = p.rental_id
JOIN customer c ON r.customer_id = c.customer_id
JOIN address a ON c.address_id = a.address_id
JOIN city ct ON a.city_id = ct.city_id
JOIN country cu ON ct.country_id = cu.country_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id;

-- 2. Monthly Revenue Trend Aggregation View
CREATE OR REPLACE VIEW reporte_tendencia_mensual AS
SELECT 
    EXTRACT(YEAR FROM p.payment_date) AS year,
    EXTRACT(MONTH FROM p.payment_date) AS month,
    SUM(p.amount) AS total_revenue,
    COUNT(DISTINCT p.customer_id) AS active_customers
FROM payment p
GROUP BY 1, 2
ORDER BY 1, 2;
