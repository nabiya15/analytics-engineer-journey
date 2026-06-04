-- ============================================================
-- REFLECTIONS upon completing this assessment
-- ============================================================
-- What I got right:
--  - Assessed and used the JOINs correctly. 
--  - Did not make unnecessary use of JOINs

-- One thing I missed and need to carry forward:
--  - READ and UNDERSTAND the task properly before getting excited and jumping on an incomplete/incorrect solution. For Task 3, I completely missed half the passing requirement in the excitement of getting things done as fast as I can.

CREATE TABLE employees (
    emp_id TEXT,
    name TEXT,
    department TEXT,
    salary INTEGER,
    status TEXT
);

INSERT INTO employees VALUES
    ('E001', 'Sarah',  'Engineering', 95000, 'Active'),
    ('E002', 'Marcus', 'Marketing',   72000, 'Active'),
    ('E003', 'Priya',  'Engineering', 88000, 'Active'),
    ('E004', 'James',  'Sales',       65000, 'Inactive'),
    ('E005', 'Elena',  'Marketing',   78000, 'Active'),
    ('E006', 'Tom',    'Sales',       70000, 'Active');

CREATE TABLE performance_reviews (
    review_id TEXT,
    emp_id TEXT,
    rating INTEGER,
    review_year INTEGER
);

INSERT INTO performance_reviews VALUES
    ('R001', 'E001', 4, 2024),
    ('R002', 'E003', 5, 2024),
    ('R003', 'E001', 3, 2023),
    ('R004', 'E002', 4, 2024),
    ('R005', 'E005', 2, 2024);

SELECT * from employees;
SELECT * from performance_reviews;

-- Task 1. Show the average salary per department. Only include departments where the average salary is above 75,000. Order by average salary descending.

SELECT department, 
    AVG(salary) AS average_salary
FROM employees
GROUP BY department
HAVING AVG(salary)>75000 
ORDER BY AVG(salary) DESC;

-- Task 2. Show each employee's name and their review rating. Only include employees who have at least one review on record.
SELECT e.emp_id, e.name, pr.rating
FROM employees AS e
    INNER JOIN performance_reviews AS pr
    ON e.emp_id = pr.emp_id;

-- Task 3. Find all active employees who have never received a performance review.
SELECT e.name AS employees_without_review
FROM employees AS e
    LEFT JOIN performance_reviews AS pr
    ON e.emp_id = pr.emp_id
WHERE pr.emp_id is NULL AND e.status = 'Active' ;

-- Task 4. Show every employee's name, department, and total number of reviews they have received — including employees with zero reviews. Order by review count descending.
SELECT e.name, e.department, 
    COUNT(pr.rating) as no_of_reviews
FROM employees as e
    LEFT JOIN performance_reviews as pr
    ON e.emp_id = pr.emp_id
GROUP BY e.name, e.department
ORDER BY COUNT(pr.rating) DESC;