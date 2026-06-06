-- ============================================================
-- PRACTICE: Lesson 03 — Subqueries & CASE
-- ============================================================
-- Rules: Copilot OFF. No files open. No notes.
-- Dataset: employees + performance_reviews (same as Lesson 03)
-- Re-run the setup SQL from lesson-03-subqueries-case.sql
-- if your DuckDB session has reset.
-- ============================================================

-- Q1. Add a column called action_required to the performance_reviews output.
--     Use CASE to assign labels based on the follow_up value:
--       'Urgent' → 'Schedule immediate 1:1'
--       'Normal' → 'Add to next review cycle'
--       'Low'    → 'No action needed'
--     Show: review_id, emp_id, follow_up, action_required
--     Order by action_required alphabetically.



-- Q2. Show every employee with a column called employment_status.
--     Use searched CASE:
--       Active AND salary >= 85000 → 'Key talent'
--       Active AND salary <  85000 → 'Active'
--       Inactive (any salary)      → 'Inactive'
--     Show: name, salary, status, employment_status
--     HINT: the ELSE clause handles the Inactive case cleanly — think about why.



-- Q3. Show every employee who earns BELOW the average salary.
--     Display: name, salary
--     Use a subquery in WHERE.
--     HINT: this is the opposite of what you wrote in the lesson.



-- Q4. Show every employee who has at least one review recorded in 2023.
--     Display: name, department
--     Use IN with a subquery.
--     The review_year column is in performance_reviews.



-- Q5. For each department that has at least one review, count the total reviews.
--     Only show departments with MORE THAN ONE review total.
--     Display: department, total_reviews
--     Use a subquery in FROM.
--     HINT: the inner query aggregates, the outer query filters the result.



-- Q6. Show every employee's name and their review rating as text.
--     Where an employee has no review at all, show 'Not yet reviewed'.
--     Display: name, review_status
--     Use COALESCE and CAST.
--     NOTE: Sarah will appear twice — that is correct and expected. Why?



-- ============================================================
-- REFLECTIONS
-- ============================================================
-- What I kept getting wrong:
--
-- What clicked today that didn't before:
--
-- One thing I need to carry into the checkpoint:
-- ============================================================
