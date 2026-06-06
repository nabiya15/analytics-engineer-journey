CREATE TABLE employees (
    emp_id TEXT, name TEXT, department TEXT,
    salary INTEGER, status TEXT
);
INSERT INTO employees VALUES
    ('E001','Sarah','Engineering',95000,'Active'),
    ('E002','Marcus','Marketing',72000,'Active'),
    ('E003','Priya','Engineering',88000,'Active'),
    ('E004','James','Sales',65000,'Inactive'),
    ('E005','Elena','Marketing',78000,'Active'),
    ('E006','Tom','Sales',70000,'Active');

CREATE TABLE performance_reviews (
    review_id TEXT, emp_id TEXT,
    rating INTEGER, review_year INTEGER
);
INSERT INTO performance_reviews VALUES
    ('R001','E001',4,2024),
    ('R002','E003',5,2024),
    ('R003','E001',3,2023),
    ('R004','E002',4,2024),
    ('R005','E005',2,2024);

ALTER TABLE performance_reviews ADD COLUMN follow_up TEXT;
UPDATE performance_reviews SET follow_up = 'Urgent' WHERE rating <= 2;
UPDATE performance_reviews SET follow_up = 'Normal' WHERE rating = 3;
UPDATE performance_reviews SET follow_up = 'Low'    WHERE rating >= 4;

SELECT review_id, follow_up,
    CASE follow_up
        WHEN 'Urgent' THEN 1
        WHEN 'Normal' THEN 2
        WHEN 'Low' THEN 3
    END AS urgency_rank
FROM performance_reviews
ORDER BY urgency_rank ASC;


SELECT name, salary,
    CASE 
        WHEN salary >= 90000 THEN 'Senior'
        WHEN salary >=70000 THEN 'Mid'
        ELSE 'Junior'
    END AS salary_band
FROM employees;


--  Query 1: Show all employees whose salary is above the average. Display name and salary.
SELECT name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

--  Query 2: Show all employees who have received at least one 'Urgent' follow-up review. Display name and department. The follow_up column lives in performance_reviews — use IN with a subquery to find the matching emp_id values first. 

SELECT name, department
FROM employees
WHERE emp_id IN (
    SELECT emp_id 
    FROM performance_reviews
    WHERE follow_up = 'Urgent');


--Sample query to make sure the DuckDB session is still running on return
--In today' session, we will look at subqueries from a lightly different angle. 
-- In our learning so far sub-query was sitting in WHERE clause. Which means the output of that sub-query was a "condition".
-- Now, we will insert the sub-query in the FROM clause. The output of this sub-query will be another "Temporary table" that the outer query reads from.

SELECT name, follow_up
FROM employees AS e
LEFT JOIN performance_reviews AS pr ON e.emp_id = pr.emp_id
LIMIT 3;


--Example:
-- Get all Departments having average Salary above 75000
SELECT department, AVG(salary) AS avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > 75000;

-- Write this version using a subquery in FROM:
-- The inner query selects department and AVG(salary) AS avg_salary from employees, grouped by department
-- The outer query reads from that result and filters where avg_salary > 75000
-- Give the inner query the alias dept_summary

SELECT dept_summary.department, dept_summary.avg_salary
FROM 
    (SELECT department, AVG(salary) AS avg_salary
        FROM employees
        GROUP BY department) AS dept_summary
WHERE dept_summary.avg_salary > 75000;

--COALESCE:
-- Sample query
SELECT e.name,
       pr.rating
FROM employees AS e
LEFT JOIN performance_reviews AS pr
    ON e.emp_id = pr.emp_id;

-- Using COALESCE to replace NUll values with a more meaningful value
SELECT e.name, COALESCE(CAST(pr.rating AS TEXT), 'No review yet') AS review_status
FROM employees AS e
    LEFT JOIN performance_reviews AS pr
    ON e.emp_id =pr.emp_id