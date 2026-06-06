-- ============================================================
-- PRACTICE: Lesson 03 — Subqueries & CASE
-- ============================================================
-- Rules: Copilot OFF. No files open. No notes.
-- Dataset: employees + performance_reviews (same as Lesson 03)
-- Re-run the setup SQL from lesson-03-subqueries-case.sql
-- if your DuckDB session has reset.
-- ============================================================

--Setting up dataset
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

-- Q1. Add a column called action_required to the performance_reviews output.
--     Use CASE to assign labels based on the follow_up value:
--       'Urgent' → 'Schedule immediate 1:1'
--       'Normal' → 'Add to next review cycle'
--       'Low'    → 'No action needed'
--     Show: review_id, emp_id, follow_up, action_required
--     Order by action_required alphabetically.

SELECT review_id, emp_id, follow_up,
    CASE follow_up
        WHEN 'Urgent' THEN 'Schedule immediate 1:1'
        WHEN 'Normal' THEN 'Add to next review cycle'
        WHEN 'Low' THEN 'No action needed'
    END AS action_required
FROM performance_reviews
ORDER BY action_required ASC;

-- Q2. Show every employee with a column called employment_status.
--     Use searched CASE:
--       Active AND salary >= 85000 → 'Key talent'
--       Active AND salary <  85000 → 'Active'
--       Inactive (any salary)      → 'Inactive'
--     Show: name, salary, status, employment_status
--     HINT: the ELSE clause handles the Inactive case cleanly — think about why.
SELECT name, salary, status, 
    CASE 
        WHEN status = 'Active' AND salary >= 85000 THEN 'Key talent'
        WHEN status = 'Active' AND salary < 85000 THEN 'Active'
        ELSE 'Inactive'
    END AS employment_status
FROM employees;
--Answer to hint: ELSE clause handles explicitly any case where status is inactive. The query tries to compare the status being active irrespective of the salary. In case a status of inactive is caught, the ELSE clause handles that cleanly and simply by giving a simple answer to it instead of doing the salary comparision.

-- Q3. Show every employee who earns BELOW the average salary.
--     Display: name, salary
--     Use a subquery in WHERE.
--     HINT: this is the opposite of what you wrote in the lesson.
SELECT name , salary
FROM employees
WHERE salary < (
    SELECT AVG(salary)
    FROM employees
);
--Answer to hint: The subquery simply calculates the average salary of all the employees and returns the answer to the outer query which then does the comparision of that average and gives every employee who's salary is less than that average.


-- Q4. Show every employee who has at least one review recorded in 2023.
--     Display: name, department
--     Use IN with a subquery.
--     The review_year column is in performance_reviews.
SELECT name, department
FROM employees
WHERE emp_id IN
(SELECT emp_id FROM performance_reviews
    WHERE review_year = 2023);


-- Q5. For each department that has at least one review, count the total reviews.
--     Only show departments with MORE THAN ONE review total.
--     Display: department, total_reviews
--     Use a subquery in FROM.
--     HINT: the inner query aggregates, the outer query filters the result.

SELECT review_summary.department, review_summary.total_reviews
FROM (
    SELECT COUNT(pr.review_id) AS total_reviews, e.department
    FROM performance_reviews as pr
    INNER JOIN employees as e
        ON pr.emp_id = e.emp_id
    GROUP BY e.department
) AS review_summary
WHERE review_summary.total_reviews > 1;


-- Q6. Show every employee's name and their review rating as text.
--     Where an employee has no review at all, show 'Not yet reviewed'.
--     Display: name, review_status
--     Use COALESCE and CAST.
--     NOTE: Sarah will appear twice — that is correct and expected. Why?

SELECT e.name, COALESCE(CAST(pr.rating AS TEXT), 'Not yet reviewed') AS review_status
    FROM employees AS e
        LEFT JOIN performance_reviews AS pr
        ON e.emp_id = pr.emp_id
    
-- ============================================================
-- REFLECTIONS
-- ============================================================
-- What I kept getting wrong:
--  - One thing I kept getting wrong is the typos. Although it is not a catasrophic mistake, I now understand that in production environment it can possibly break the code. 
--  - Use of wrong operator was a confusion caused by Claude. I changes it to <= from my initial choice of < because I was prompted about it by claude and then I decided to use <=. However, I should have stuck to my solution based on the undestanding of the actual question rather than being dicey about the whole thing and changing the real question in the first place. I should understand that in real life, I would be able to change the problems if I am indecisive about a solution. 

-- What clicked today that didn't before:
--  - Using the right JOINs. Even though I made one mistake at one point, I feel the progress is better than yesterday.
--  - I made the the use of a LEFT JOIN intead of an INNER JOIN. My concept with specifically INNER join is still vage. I have conquered the logic behind left , right and full outer joins. However, still get confused as to when to use the INNER vs the other JOINS. 
-- - I think now I have some hold on that topic, and I'm sure i will improve with a little more practice.

-- One thing I need to carry into the checkpoint:
-- Read and understand the question, break it down into smaller parts if needed.  That is something I learnt today. That's the reson it took me long time to solve each query, but that helped me reduce the errors or asking for help. Rather it encouraged me to take up the challenge and solve each question on my own and implement the correct logic most of the times.
-- ============================================================
 