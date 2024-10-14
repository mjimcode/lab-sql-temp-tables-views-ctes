-- Step 1: Create a View to summarize rental information for each customer
CREATE VIEW rental_summary AS
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id;

-- Step 2: Create a Temporary Table to calculate total amount paid by each customer
CREATE TEMPORARY TABLE payment_summary AS
SELECT 
    rs.customer_id,
    SUM(p.amount) AS total_paid
FROM rental_summary rs
JOIN payment p ON rs.customer_id = p.customer_id
GROUP BY rs.customer_id;

-- Step 3: Create a CTE and generate the Customer Summary Report
WITH customer_cte AS (
    SELECT 
        rs.customer_name,
        rs.email,
        rs.rental_count,
        ps.total_paid
    FROM rental_summary rs
    JOIN payment_summary ps ON rs.customer_id = ps.customer_id
)
SELECT 
    customer_name,
    email,
    rental_count,
    total_paid,
    ROUND(total_paid / rental_count, 2) AS average_payment_per_rental
FROM customer_cte;