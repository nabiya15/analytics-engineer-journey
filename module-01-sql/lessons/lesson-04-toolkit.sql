-- ============================================================
-- Lesson 04 — SQL Toolkit
-- ============================================================
-- Skills: LIKE · BETWEEN · DISTINCT · IN · Arithmetic ·
--         Dates · Strings · UNION · INTERSECT · EXCEPT
-- Dataset: employees + performance_reviews (same as L03)
-- ============================================================

-- Re-run setup if your DuckDB session has reset:
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

-- ============================================================
-- 01 · LIKE — pattern matching
-- ============================================================
-- % = any number of characters (including zero)
-- _ = exactly one character

SELECT name FROM employees WHERE name LIKE 'S%';
-- Starts with S → Sarah

SELECT name FROM employees WHERE name LIKE '%a';
-- Ends with a → Sarah, Priya, Elena

SELECT name FROM employees WHERE name LIKE '%ar%';
-- Contains 'ar' → Sarah, Marcus

SELECT name FROM employees WHERE name LIKE '___';
-- Exactly 3 characters → Tom

-- ⚠️ LIKE is case-sensitive in most engines.
-- 'sarah' LIKE 'S%' → no match. Use LOWER() to normalise first:
SELECT name FROM employees WHERE LOWER(name) LIKE 's%';

-- ============================================================
-- 02 · BETWEEN — inclusive range filtering
-- ============================================================
-- BETWEEN a AND b = >= a AND <= b  (both endpoints included)

SELECT name, salary FROM employees WHERE salary BETWEEN 70000 AND 90000;
-- Returns: Marcus (72k), Priya (88k), Elena (78k), Tom (70k)
-- Sarah (95k) excluded. James (65k) excluded.

-- Works on text and dates too:
SELECT name FROM employees WHERE name BETWEEN 'E' AND 'P';
-- Alphabetical range — Elena, Marcus (M comes after E, before P)

-- ============================================================
-- 03 · DISTINCT — remove duplicates
-- ============================================================

SELECT DISTINCT department FROM employees;
-- 3 rows instead of 6: Engineering, Marketing, Sales

SELECT DISTINCT status FROM employees;
-- Active, Inactive

-- DISTINCT on multiple columns = unique COMBINATION of those columns:
SELECT DISTINCT department, status FROM employees;
-- Engineering/Active, Marketing/Active, Sales/Inactive, Sales/Active

-- ============================================================
-- 04 · IN — cleaner list filtering
-- ============================================================
-- Replaces chained OR conditions with a readable list

SELECT name FROM employees WHERE department IN ('Engineering', 'Marketing');
-- Same as: WHERE department = 'Engineering' OR department = 'Marketing'

SELECT name FROM employees WHERE emp_id NOT IN ('E001', 'E003');
-- Everyone except Sarah and Priya

-- ============================================================
-- 05 · Arithmetic & math functions
-- ============================================================

SELECT name, salary,
       ROUND(salary / 12.0, 2) AS monthly_salary
FROM employees;
-- Note: salary/12 (integer division) truncates. salary/12.0 preserves decimals.

SELECT ROUND(7916.67, 1),    -- 7916.7
       ABS(-42),              -- 42
       CEILING(3.2),          -- 4  (always round up)
       FLOOR(3.9);            -- 3  (always round down)

-- ============================================================
-- 06 · Date & time functions
-- ============================================================

SELECT CURRENT_DATE;
-- Today's date

SELECT EXTRACT(YEAR FROM CURRENT_DATE);
SELECT EXTRACT(MONTH FROM CURRENT_DATE);
SELECT EXTRACT(DAY FROM CURRENT_DATE);

-- Date difference in days (DuckDB syntax):
SELECT DATEDIFF('day', DATE '2024-01-01', DATE '2024-06-15');
-- 165 days

-- DATE_TRUNC — collapse a date to the start of a period:
SELECT DATE_TRUNC('month', DATE '2024-06-15');
-- Returns: 2024-06-01

-- WHY THIS MATTERS for analytics:
-- Without DATE_TRUNC, GROUP BY on a date column = one row per exact day
-- With DATE_TRUNC('month', date), GROUP BY = one row per month
-- This is how monthly/quarterly trend reports are built.

SELECT DATE_TRUNC('month', CURRENT_DATE) AS month_start;

-- ============================================================
-- 07 · String functions
-- ============================================================

SELECT UPPER('hello'),                          -- HELLO
       LOWER('WORLD'),                          -- world
       LENGTH('Sarah'),                         -- 5
       TRIM('  Sarah  '),                       -- 'Sarah'
       SUBSTR('Engineering', 1, 3),             -- 'Eng'
       REPLACE('Data_Cleanup', '_', ' '),       -- 'Data Cleanup'
       'Hello' || ' ' || 'World';              -- 'Hello World'

-- Practical use — normalise messy department names:
SELECT UPPER(TRIM(department)) AS clean_dept FROM employees;

-- ============================================================
-- 08 · UNION, UNION ALL, INTERSECT, EXCEPT
-- ============================================================
-- These stack two query results VERTICALLY (more rows, same columns).
-- Both queries must return the same number of columns, compatible types.

-- UNION: combine and remove duplicates
SELECT name FROM employees WHERE department = 'Engineering'
UNION
SELECT name FROM employees WHERE salary > 80000;
-- Returns: Sarah, Priya (Engineering) + Sarah, Priya (salary > 80k)
-- Duplicates removed → Sarah, Priya (2 rows, not 4)

-- UNION ALL: combine and KEEP duplicates (faster — no dedup step)
SELECT name FROM employees WHERE department = 'Engineering'
UNION ALL
SELECT name FROM employees WHERE salary > 80000;
-- Returns 4 rows: Sarah, Priya, Sarah, Priya

-- INTERSECT: rows that appear in BOTH queries
SELECT name FROM employees WHERE department = 'Engineering'
INTERSECT
SELECT name FROM employees WHERE salary > 80000;
-- Engineering: Sarah, Priya. Salary > 80k: Sarah, Priya. Overlap = Sarah, Priya.

-- EXCEPT: rows in the first query NOT in the second
SELECT name FROM employees WHERE status = 'Active'
EXCEPT
SELECT name FROM employees WHERE salary > 80000;
-- Active: Sarah, Marcus, Priya, Elena, Tom. Salary > 80k: Sarah, Priya.
-- Active BUT NOT high earner = Marcus, Elena, Tom

-- ⚠️ UNION vs JOIN — completely different:
-- JOIN adds COLUMNS (combines tables side by side)
-- UNION adds ROWS (stacks results on top of each other)


--RECAP
--QUERY 1:
--Show me each department's average salary, rounded to the nearest whole number, but only for active employees. Call the column avg_salary. Order by avg_salary descending.

SELECT department, ROUND(AVG(salary),0) as avg_salary
FROM employees
where status = 'Active'
GROUP BY department
ORDER BY avg_salary DESC;

--QUERY 2:
--Write a query using a string function that returns each employee's name in uppercase and their department with any leading or trailing spaces removed. Two columns: clean_name and clean_dept.
SELECT TRIM(UPPER(name)) as clean_name, TRIM(UPPER(department)) as clean_dept
FROM employees;

--Query 3:
--Using the employees table, write a query that returns names of employees in Engineering, then EXCEPT removes anyone earning over 90000. Who would be left in the result and why?
SELECT name FROM employees
WHERE department = 'Engineering'
EXCEPT
SELECT name FROM employees
WHERE salary > 90000