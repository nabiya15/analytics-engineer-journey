-- ============================================================
-- PRACTICE: Lesson 04 — SQL Toolkit
-- ============================================================
-- Rules: Copilot OFF. No files open. No notes.
-- Dataset: employees + performance_reviews (same as Lesson 04)
-- Re-run setup SQL from lesson-04-toolkit.sql if session reset.
-- ============================================================

-- Q1. Show the names of all employees whose name contains the letter 'a'
--     (lowercase). Do not hard-code names — use LIKE.
--     Display: name

-- Q2. Show all employees whose salary falls between 70,000 and 88,000 inclusive.
--     Display: name, salary, department
--     Order by salary descending.

-- Q3. List every unique combination of department and status in the employees table.
--     Display: department, status
--     No duplicates.

-- Q4. Show each employee's name and their monthly salary (salary divided by 12),
--     rounded to 2 decimal places. Label the column monthly_salary.
--     Display: name, monthly_salary

-- Q5. You need a single combined list of names from two groups:
--       - Employees in the Engineering department
--       - Employees with a rating of 5 in performance_reviews
--     No duplicates in the final list.
--     Display: name
--     HINT: you will need to JOIN performance_reviews to get names for the second group.

-- Q6. Show the names of active employees who do NOT appear in Engineering or Marketing.
--     Use NOT IN with a list — not a subquery.
--     Display: name, department

-- Q7. Write a query that shows each employee's name and department,
--     with a column called dept_code built using string functions:
--     Take the first 3 characters of department, convert to uppercase.
--     Display: name, department, dept_code

-- ============================================================
-- REFLECTIONS
-- ============================================================
-- What I kept getting wrong:
--
-- What clicked today that didn't before:
--
-- One thing I need to carry into the next lesson:
-- ============================================================
