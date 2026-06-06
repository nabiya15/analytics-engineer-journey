<div align="center">

![](https://img.shields.io/badge/Analytics_Engineer_Journey-Module_01-2455C3?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Topic-SQL_Fundamentals-586074?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Lessons_Complete-3_of_5-0C7550?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Status-In_Progress-E8A020?style=flat-square)

# Module 01 — SQL Fundamentals

*The language every data system speaks. Ask questions, filter answers, summarise data, connect tables.*

</div>

---

## Contents

- [Module overview](#overview)
- [Lesson 01 — SQL Basics](#lesson-01)
- [Lesson 02 — JOINs](#lesson-02)
- [Lesson 03 — Subqueries & CASE](#lesson-03)
- [Lesson 04 — SQL Toolkit](#lesson-04)
- [Lesson 05 — Window Functions & CTEs](#lesson-05)
- [Quick reference](#quick-reference)

---

<a id="overview"></a>

## Module overview

| # | Lesson | Skills | Status |
|---|--------|--------|--------|
| 01 | SQL Basics | SELECT · WHERE · GROUP BY · HAVING · ORDER BY · NULL | ✅ Complete |
| 02 | JOINs | INNER · LEFT · RIGHT · FULL OUTER · NULL pattern | ✅ Complete |
| 03 | Subqueries & CASE | CASE · WHERE subquery · FROM subquery · COALESCE | ✅ Complete |
| 04 | SQL Toolkit | LIKE · BETWEEN · DISTINCT · dates · strings · UNION | 🟡 In progress |
| 05 | Window functions & CTEs | ROW_NUMBER · RANK · LAG · LEAD · WITH | ⬜ Upcoming |

**Files**

| File | Purpose |
|------|---------|
| [`lessons/lesson-01-basics.sql`](lessons/lesson-01-basics.sql) | All queries from Lesson 01 — commented |
| [`lessons/lesson-02-joins.sql`](lessons/lesson-02-joins.sql) | All queries from Lesson 02 — commented |
| [`lessons/lesson-03-subqueries-case.sql`](lessons/lesson-03-subqueries-case.sql) | All queries from Lesson 03 — commented |
| [`practice/lesson-02-joins-practice.sql`](practice/lesson-02-joins-practice.sql) | JOIN practice — no hints, Copilot off |
| [`practice/lesson-03-subqueries-case-practice.sql`](practice/lesson-03-subqueries-case-practice.sql) | Subqueries & CASE practice — no hints, Copilot off |
| [`checkpoint/checkpoint-module-01-sql-fundamentals.sql`](checkpoint/checkpoint-module-01-sql-fundamentals.sql) | Mid-module checkpoint (Lessons 01–02) — passed |

---

<a id="lesson-01"></a>

## Lesson 01 — SQL Basics

<div align="center">

![](https://img.shields.io/badge/Lesson-01_of_05-586074?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Skills-SELECT_·_WHERE_·_GROUP_BY_·_ORDER_BY-2455C3?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Status-✓_Complete-0C7550?style=flat-square)

</div>

<br>

**The data** — one table, seven tickets.

| ticket_id | type | priority | status | assigned_to | resolution_hours |
|-----------|------|----------|--------|-------------|-----------------|
| INC001 | Incident | High | Open | Nabiya | `NULL` |
| INC002 | Incident | Low | Closed | Dev Team | 4 |
| REQ001 | Request | Medium | Open | Nabiya | `NULL` |
| INC003 | Incident | High | Closed | Dev Team | 12 |
| REQ002 | Request | Low | Open | Nabiya | `NULL` |
| INC004 | Incident | Medium | Open | Dev Team | `NULL` |
| REQ003 | Request | High | Closed | Nabiya | 6 |

> `NULL` in `resolution_hours` = ticket still open. `NULL` is not zero — it is the complete absence of a value.

---

### 01 · What is a database?

> 💬 *A place that stores information in organised rows and columns so you can ask questions about it instantly.*

A **table** = one organised sheet of data. A **row** = one record. A **column** = one fact about every record. **SQL** = the language you write to ask questions.

---

### 02 · SELECT & FROM

> 💬 *"Show me these columns from this table."*

```sql
SELECT * FROM tickets;                          -- all columns
SELECT ticket_id, priority, status FROM tickets; -- specific columns only
```

<details>
<summary>Why column names have no quotes but text values do</summary>
<br>

`status` is a column name — part of the table structure. `'Open'` is a value — data inside a cell. SQL needs quotes around values so it does not confuse them with column names.

Rule: **structure = no quotes. Data = single quotes. Numbers = no quotes.**

</details>

---

### 03 · WHERE

> 💬 *"Only show rows where this condition is true."*

```sql
SELECT * FROM tickets WHERE status = 'Open';
```

<details>
<summary>Combining conditions — AND · OR · !=</summary>
<br>

```sql
WHERE priority = 'High' AND status = 'Open';    -- both must be true
WHERE assigned_to = 'Nabiya' OR assigned_to = 'Dev Team'; -- either
WHERE status != 'Closed';                        -- not equal to
```

</details>

---

### 04 · GROUP BY & aggregations

> 💬 *"Sort rows into buckets, then calculate something about each bucket."*

```sql
SELECT status, COUNT(*) FROM tickets GROUP BY status;
SELECT priority, AVG(resolution_hours) FROM tickets
WHERE status = 'Closed' GROUP BY priority;
```

<details>
<summary>COUNT(*) vs COUNT(column) · Execution order</summary>
<br>

`COUNT(*)` counts all rows including NULLs. `COUNT(column)` skips NULLs.

**Order:** `WHERE` runs first → `GROUP BY` buckets what survives → `HAVING` filters the buckets.

</details>

---

### 05 · HAVING

> 💬 *"Filter groups after grouping. WHERE filters rows before grouping."*

```sql
SELECT priority, AVG(resolution_hours)
FROM tickets WHERE status = 'Closed'
GROUP BY priority HAVING AVG(resolution_hours) > 5;
```

---

### 06 · ORDER BY & LIMIT

> 💬 *"Sort results. Cap how many rows come back."*

```sql
SELECT ticket_id, priority, resolution_hours FROM tickets
WHERE status = 'Closed' ORDER BY resolution_hours ASC LIMIT 2;
```

<details>
<summary>The text-sort trap</summary>
<br>

`ORDER BY priority ASC` gives `High → Low → Medium` — alphabetical, not urgency order. Fix: use CASE to assign numbers. Covered in Lesson 03.

</details>

---

### 07 · NULL

> 💬 *"NULL means no value exists. Not zero. Not blank. Nothing."*

```sql
SELECT * FROM tickets WHERE resolution_hours IS NULL;
```

<details>
<summary>Why = NULL never works · NULL in COUNT and ORDER BY</summary>
<br>

`WHERE x = NULL` always returns zero rows. You cannot compare something to nothing. Always use `IS NULL` or `IS NOT NULL`.

`COUNT(*)` includes NULLs. `COUNT(column)` ignores them. NULL values in `ORDER BY` land in unpredictable positions.

</details>

---

<details>
<summary><strong>🧠 Lesson 01 — Self-check</strong></summary>
<br>

<details>
<summary>Q1 · Difference between WHERE and HAVING?</summary>
<br>

`WHERE` filters rows before grouping. `HAVING` filters groups after `GROUP BY`. You cannot use `WHERE` with `COUNT(*)` or `AVG()`.

</details>

<details>
<summary>Q2 · Why does WHERE resolution_hours = NULL return nothing?</summary>
<br>

NULL has no value. Nothing equals the absence of a value. Use `IS NULL`.

</details>

<details>
<summary>Q3 · What breaks when sorting priority alphabetically?</summary>
<br>

`High → Low → Medium` is not urgency order. Use CASE to assign numbers before sorting.

</details>

</details>

---

<a id="lesson-02"></a>

## Lesson 02 — JOINs

<div align="center">

![](https://img.shields.io/badge/Lesson-02_of_05-586074?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Skills-INNER_·_LEFT_·_RIGHT_·_FULL_OUTER-2455C3?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Status-✓_Complete-0C7550?style=flat-square)

</div>

<br>

**The scenario** — `autosys_jobs` ⏰ tracks automated task runs. `servicenow_tickets` 🎫 tracks reported problems. Both share `job_id` — that column is the bridge.

> 🔑 `job_id` is like a student ID — appears in both tables, connects records across them.

**`autosys_jobs`** · **`servicenow_tickets`**

| job_id | status | | ticket_id | job_id | priority |
|--------|--------|-|-----------|--------|----------|
| JOB001 | ❌ Failed | | INC001 | JOB001 | 🔴 High |
| JOB002 | ✅ Success | | INC002 | JOB004 | 🔴 High |
| JOB003 | ⏳ Running | | INC003 | JOB001 | 🟡 Medium |
| JOB004 | ❌ Failed | | INC004 | JOB003 | 🟢 Low |
| JOB005 | ✅ Success | | INC005 | JOB002 | 🟢 Low |

> 👀 JOB001 has **two** tickets. JOB005 has **none**. These drive every JOIN result.

---

### 01 · INNER JOIN

> 💬 *"Only rows matching in both tables. No match = dropped."*

![INNER JOIN](assets/venn-inner.svg)

```sql
SELECT aj.job_id, aj.job_name, sn.ticket_id, sn.priority
FROM autosys_jobs AS aj
INNER JOIN servicenow_tickets AS sn ON aj.job_id = sn.job_id;
-- JOB005 disappears. JOB001 appears twice. Result: 5 rows.
```

---

### 02 · LEFT JOIN — most used

> 💬 *"All left rows. Right fills in where matched. NULL where it doesn't."*

![LEFT JOIN](assets/venn-left.svg)

```sql
SELECT aj.job_id, aj.job_name, sn.ticket_id, sn.priority
FROM autosys_jobs AS aj
LEFT JOIN servicenow_tickets AS sn ON aj.job_id = sn.job_id;
-- JOB005 stays with NULL ticket columns. Result: 6 rows.
```

---

### 03 · RIGHT JOIN — rarely written

> 💬 *"All right rows. Left fills in where matched."*

![RIGHT JOIN](assets/venn-right.svg)

Every RIGHT JOIN rewrites as a LEFT JOIN by swapping table order. Always use LEFT JOIN in practice.

---

### 04 · FULL OUTER JOIN

> 💬 *"Everything from both tables. NULL on whichever side has no match."*

![FULL OUTER JOIN](assets/venn-full.svg)

```sql
SELECT aj.job_id, aj.job_name, sn.ticket_id, sn.priority
FROM autosys_jobs AS aj
FULL OUTER JOIN servicenow_tickets AS sn ON aj.job_id = sn.job_id;
```

---

### 05 · The NULL pattern — finding what's missing

> 💬 *"LEFT JOIN + WHERE right_key IS NULL = rows with no match on the right."*

```sql
SELECT aj.job_id, aj.job_name, aj.status
FROM autosys_jobs AS aj
LEFT JOIN servicenow_tickets AS sn ON aj.job_id = sn.job_id
WHERE sn.job_id IS NULL;  -- returns JOB005 only
```

> ⚠️ Always check IS NULL on the **JOIN key**, not a data column. A data column could have legitimate NULLs for other reasons.

---

<details>
<summary><strong>🧠 Lesson 02 — Self-check</strong></summary>
<br>

<details>
<summary>Q1 · Every job including those with no ticket — which JOIN?</summary>
<br>

LEFT JOIN. Left table appears in full. Unmatched rows get NULL on the right side.

</details>

<details>
<summary>Q2 · INNER returns 5, LEFT returns 7 — what do the extra 2 mean?</summary>
<br>

2 rows in the left table have no match. INNER dropped them. LEFT kept them with NULLs.

</details>

<details>
<summary>Q3 · Why does JOB001 appear twice?</summary>
<br>

JOB001 matched two rows in servicenow_tickets. One job × two tickets = two output rows. One-to-many relationship.

</details>

</details>

---

<a id="lesson-03"></a>

## Lesson 03 — Subqueries & CASE

<div align="center">

![](https://img.shields.io/badge/Lesson-03_of_05-586074?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Skills-CASE_·_Subqueries_·_COALESCE-2455C3?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Status-✓_Complete-0C7550?style=flat-square)

</div>

<br>

**What this lesson fixes and adds — be specific:**

**Problem 1 — broken sort order (from Lesson 01).**
When you sort `priority` alphabetically, SQL gives `High → Low → Medium`. That is wrong because `L` comes before `M` in the alphabet — but Medium is more urgent than Low. SQL sees words, not urgency levels. `CASE` lets you secretly replace each word with a number *before* sorting: High=1, Medium=2, Low=3. SQL then sorts 1, 2, 3 — numbers, not letters. Correct order.

**Problem 2 — questions that need two steps.**
Some questions cannot be answered in a single pass. *"Show employees who earn above the average salary"* requires: (1) calculate the average, (2) filter using it. But `AVG()` cannot live inside `WHERE` — SQL will throw an error because `WHERE` runs before any aggregation. A **subquery** does step 1 inside step 2. It is a complete SQL query wrapped in parentheses, running first, whose result the outer query uses.

**The data**

```sql
-- Employees
-- E001 Sarah    Engineering 95000 Active
-- E002 Marcus   Marketing   72000 Active
-- E003 Priya    Engineering 88000 Active
-- E004 James    Sales       65000 Inactive
-- E005 Elena    Marketing   78000 Active
-- E006 Tom      Sales       70000 Active

-- Performance reviews (with follow_up column added)
-- R001 E001 rating=4 follow_up='Low'
-- R002 E003 rating=5 follow_up='Low'
-- R003 E001 rating=3 follow_up='Normal'
-- R004 E002 rating=4 follow_up='Low'
-- R005 E005 rating=2 follow_up='Urgent'
```

> 👀 `follow_up` sorts alphabetically as `Low → Normal → Urgent` — completely wrong urgency order. CASE fixes this. Sarah has two reviews (R001 and R003) — this matters for COALESCE.

---

### 01 · Simple CASE — map values to new values

> 💬 *"Look at each row. If the value matches this, replace it with that."*

```sql
SELECT review_id, follow_up,
    CASE follow_up
        WHEN 'Urgent' THEN 1
        WHEN 'Normal' THEN 2
        WHEN 'Low'    THEN 3
    END AS urgency_rank
FROM performance_reviews
ORDER BY urgency_rank ASC;
```

<details>
<summary>What this returns — urgency order is now correct</summary>
<br>

| review_id | follow_up | urgency_rank |
|-----------|-----------|-------------|
| R005 | Urgent | 1 |
| R003 | Normal | 2 |
| R001 | Low | 3 |
| R002 | Low | 3 |
| R004 | Low | 3 |

R005 (Elena, Urgent) now appears first. The alphabetical problem is gone because SQL sorted numbers 1, 2, 3 — not letters.

</details>

> ⚠️ **What if a value does not match any WHEN?** If a row has a `follow_up` value you did not list (say someone added `'Critical'`), CASE returns NULL for that row. Add an `ELSE` clause to handle unknowns: `ELSE 99` or `ELSE 'Unknown'`.

---

### 02 · Searched CASE — evaluate conditions per row

> 💬 *"Instead of matching one column against exact values, evaluate any condition in each branch."*

```sql
SELECT name, salary,
    CASE
        WHEN salary >= 90000 THEN 'Senior'
        WHEN salary >= 70000 THEN 'Mid'
        ELSE 'Junior'
    END AS salary_band
FROM employees;
```

<details>
<summary>What this returns</summary>
<br>

| name | salary | salary_band |
|------|--------|------------|
| Sarah | 95000 | Senior |
| Marcus | 72000 | Mid |
| Priya | 88000 | Mid |
| James | 65000 | Junior |
| Elena | 78000 | Mid |
| Tom | 70000 | Mid |

</details>

> 🔑 **Key learning point — short-circuit evaluation.**
> CASE checks conditions top-to-bottom and **stops the moment one matches**. Once a row passes `salary >= 90000`, SQL returns `'Senior'` and never checks the next branch. This means every subsequent branch implicitly excludes all previous ones.
>
> That is why `WHEN salary >= 70000 THEN 'Mid'` does not need to say `AND salary < 90000` — by the time SQL reaches that branch, it already knows the salary is below 90,000 (because the first branch would have caught it otherwise). Writing the redundant condition is not wrong — but understanding why it is redundant is important.

<details>
<summary>Simple CASE vs searched CASE — when to use each</summary>
<br>

**Simple CASE** (`CASE column WHEN value THEN result`) — use when you are mapping a specific list of known values to replacements. Clean, readable, limited to exact matching against one column.

**Searched CASE** (`CASE WHEN condition THEN result`) — use for ranges, comparisons, or conditions across multiple columns. More flexible.

Most real-world analytics work uses searched CASE.

</details>

---

### 03 · Subqueries in WHERE — the problem first

> 💬 *"Some filters require knowing a calculated value first. Subqueries calculate it inside the query."*

**The error that explains why subqueries exist:**

```sql
SELECT name, salary FROM employees
WHERE salary > AVG(salary);
-- Error: WHERE clause cannot contain aggregates!
```

SQL is telling you: `WHERE` runs **before** any aggregation happens. At the moment `WHERE` is evaluated, `AVG(salary)` has not been calculated yet — it does not exist. You cannot filter using a value that does not exist yet.

A subquery solves this by calculating the value separately first:

```sql
SELECT name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);
```

**What SQL does, step by step:**
1. Runs `SELECT AVG(salary) FROM employees` → gets a single number: **78,000**
2. Substitutes it: `WHERE salary > 78000`
3. Filters `employees` and returns matching rows

<details>
<summary>What this returns</summary>
<br>

| name | salary |
|------|--------|
| Sarah | 95000 |
| Priya | 88000 |

Average = (95000+72000+88000+65000+78000+70000) / 6 = 78,000. Sarah and Priya are above it. Marcus, Elena, Tom are at or below. James is below.

Note: Elena (78,000) is exactly at the average. `>` is strict — she does not qualify.

</details>

**IN (subquery) — when the inner query returns a list:**

```sql
SELECT name, department
FROM employees
WHERE emp_id IN (
    SELECT emp_id FROM performance_reviews
    WHERE follow_up = 'Urgent'
);
```

**Step by step:**
1. Inner query runs: `SELECT emp_id FROM performance_reviews WHERE follow_up = 'Urgent'` → returns `['E005']`
2. Outer query: `WHERE emp_id IN ('E005')` → keeps only Elena

<details>
<summary>What this returns</summary>
<br>

| name | department |
|------|------------|
| Elena | Marketing |

Elena (E005) is the only employee with an Urgent review (R005, rating 2).

</details>

> 🔑 **Key learning point — `>` vs `IN`.**
>
> `> (subquery)` — the inner query must return **exactly one value**. Use with `AVG()`, `MAX()`, `MIN()`, `COUNT()`. If the inner query returns more than one row, SQL throws an error.
>
> `IN (subquery)` — the inner query returns a **list of values**. The outer query checks if each row's column appears anywhere in that list. Use when the inner query might return many rows.

<details>
<summary>⚠️ Common mistake — subquery returns multiple rows with ></summary>
<br>

```sql
-- This will ERROR if the subquery returns more than one row
WHERE salary > (SELECT salary FROM employees WHERE department = 'Engineering')
-- Engineering has Sarah (95000) AND Priya (88000) — two rows — error

-- Fix: use a specific aggregate
WHERE salary > (SELECT MAX(salary) FROM employees WHERE department = 'Engineering')
-- Now the inner query returns exactly one value: 95000
```

</details>

---

### 04 · Subqueries in FROM — using a query as a table

> 💬 *"Run an inner query. Name its result. Then run an outer query on top of that named result."*

```sql
SELECT dept_summary.department, dept_summary.avg_salary
FROM (
    SELECT department, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department
) AS dept_summary
WHERE dept_summary.avg_salary > 75000;
```

**What SQL does, step by step:**
1. Runs the inner query — produces a temporary table called `dept_summary`:

| department | avg_salary |
|------------|-----------|
| Engineering | 91500.0 |
| Marketing | 75000.0 |
| Sales | 67500.0 |

2. The outer query reads from `dept_summary` and filters: `WHERE avg_salary > 75000`
3. Marketing (exactly 75,000) and Sales (67,500) are removed. Only Engineering remains.

<details>
<summary>What this returns</summary>
<br>

| department | avg_salary |
|------------|-----------|
| Engineering | 91500.0 |

</details>

> 🔑 **Key learning point — the alias is NOT optional.**
>
> ```sql
> FROM (SELECT department, AVG(salary) FROM employees GROUP BY department)
> -- Error: subquery in FROM must have an alias
>
> FROM (SELECT department, AVG(salary) FROM employees GROUP BY department) AS dept_summary
> -- ✓ correct
> ```
>
> SQL needs a name for the temporary result so the outer query can reference its columns. Forget the alias and SQL throws an error immediately.

> 🔑 **Key learning point — FROM subquery vs HAVING.**
>
> For simple cases like this one, `HAVING` works just as well:
> ```sql
> SELECT department, AVG(salary) AS avg_salary FROM employees
> GROUP BY department HAVING AVG(salary) > 75000;
> ```
>
> A FROM subquery becomes necessary when you need to **join the aggregated result to another table**, **apply LIMIT to groups**, or **reference the aggregated column more than once**. HAVING cannot do those things.
>
> This pattern is also the direct predecessor of **CTEs** (`WITH` clauses in Lesson 05) — the modern, cleaner way to write the same logic.

---

### 05 · COALESCE — replacing NULLs in output

> 💬 *"Return the first non-NULL value from a list. Use it to make NULL readable."*

```sql
SELECT e.name,
       COALESCE(CAST(pr.rating AS TEXT), 'No review yet') AS review_status
FROM employees AS e
LEFT JOIN performance_reviews AS pr ON e.emp_id = pr.emp_id;
```

<details>
<summary>What this returns</summary>
<br>

| name | review_status |
|------|--------------|
| Sarah | 3 |
| Sarah | 4 |
| Marcus | 4 |
| Priya | 5 |
| Elena | 2 |
| James | No review yet |
| Tom | No review yet |

Sarah appears twice — she has two reviews (R001 rating 4 and R003 rating 3). That is correct: LEFT JOIN plus one-to-many = multiple rows. James and Tom have no reviews so COALESCE replaces their NULL with `'No review yet'`.

</details>

> 🔑 **Key learning point — COALESCE requires matching data types.**
>
> `rating` is an integer. `'No review yet'` is text. You cannot COALESCE different types — SQL does not know how to combine them:
>
> ```sql
> COALESCE(pr.rating, 'No review yet')  -- Error: cannot combine integer and text
>
> COALESCE(CAST(pr.rating AS TEXT), 'No review yet')  -- ✓ both are now text
> ```
>
> `CAST(pr.rating AS TEXT)` converts the integer to text first. Then COALESCE has two text values and works correctly.

> 🔑 **Key learning point — COALESCE vs IS NULL.**
>
> `IS NULL` belongs in `WHERE` — it **removes or keeps rows** based on whether a value is missing.
>
> `COALESCE` belongs in `SELECT` — it **replaces NULL with a default** in what you show. It does not affect which rows appear.
>
> They solve completely different problems. Confusing them is one of the most common early mistakes.

---

<details>
<summary><strong>🧠 Lesson 03 — Self-check</strong></summary>
<br>

<details>
<summary>Q1 · What is CASE short-circuit evaluation?</summary>
<br>

CASE checks branches top-to-bottom and stops at the first match. Every branch after a match is skipped entirely. This means later branches implicitly exclude all values that earlier branches already captured — so you do not need to write `AND salary < 90000` in a branch that follows `WHEN salary >= 90000`.

</details>

<details>
<summary>Q2 · Why does WHERE salary > AVG(salary) throw an error?</summary>
<br>

`WHERE` runs before any aggregation. At the moment WHERE executes, `AVG(salary)` has not been calculated yet — it does not exist. Use a subquery: `WHERE salary > (SELECT AVG(salary) FROM employees)`.

</details>

<details>
<summary>Q3 · When do you use > (subquery) vs IN (subquery)?</summary>
<br>

`> (subquery)` — inner query must return exactly one value. Use with AVG(), MAX(), MIN(), COUNT().

`IN (subquery)` — inner query returns a list. Outer query checks if its column appears in that list.

</details>

<details>
<summary>Q4 · What happens if you forget the alias on a FROM subquery?</summary>
<br>

SQL throws an error immediately. The alias is mandatory — SQL needs a name to reference the temporary table's columns in the outer query.

</details>

<details>
<summary>Q5 · COALESCE(pr.rating, 'No review yet') throws an error. Why, and how do you fix it?</summary>
<br>

`rating` is an integer and `'No review yet'` is text — mismatched types. COALESCE cannot combine them. Fix: `COALESCE(CAST(pr.rating AS TEXT), 'No review yet')`.

</details>

<details>
<summary>Q6 · What is the difference between COALESCE and IS NULL?</summary>
<br>

`IS NULL` in WHERE — filters rows (keeps or removes them). `COALESCE` in SELECT — replaces NULL with a default in the output without affecting which rows appear.

</details>

</details>

---

<a id="lesson-04"></a>

## Lesson 04 — SQL Toolkit

<div align="center">

![](https://img.shields.io/badge/Lesson-04_of_05-586074?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Skills-LIKE_·_BETWEEN_·_DISTINCT_·_Dates_·_Strings_·_UNION-2455C3?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Status-🟡_In_Progress-E8A020?style=flat-square)

</div>

<br>

These are the concepts that appear in nearly every data analyst interview that Lessons 01–03 do not cover. None are complex. All are short. Together they fill the gaps between our curriculum and what interviewers actually test.

---

### 01 · LIKE — pattern matching

> 💬 *"Filter text by pattern, not exact match. `%` = any characters. `_` = exactly one character."*

```sql
SELECT name FROM employees WHERE name LIKE 'S%';     -- starts with S → Sarah
SELECT name FROM employees WHERE name LIKE '%a';     -- ends with a → Sarah, Priya, Elena
SELECT name FROM employees WHERE name LIKE '%ar%';   -- contains ar → Sarah, Marcus
SELECT name FROM employees WHERE name LIKE '___';    -- exactly 3 chars → Tom
```

---

### 02 · BETWEEN — range filtering

> 💬 *"Both endpoints are included. `BETWEEN 70000 AND 90000` = `>= 70000 AND <= 90000`."*

```sql
SELECT name, salary FROM employees WHERE salary BETWEEN 70000 AND 90000;
-- Returns: Marcus (72k), Priya (88k), Elena (78k), Tom (70k)
-- Sarah (95k) and James (65k) are excluded
```

---

### 03 · DISTINCT — removing duplicates

> 💬 *"Each unique value appears exactly once."*

```sql
SELECT DISTINCT department FROM employees;
-- Returns: Engineering, Marketing, Sales (3 rows instead of 6)
```

---

### 04 · IN — cleaner list filtering

> 💬 *"Replaces multiple OR conditions with a clean list."*

```sql
SELECT name FROM employees WHERE department IN ('Engineering', 'Marketing');
-- Same as: WHERE department = 'Engineering' OR department = 'Marketing'
```

---

### 05 · Arithmetic & math functions

> 💬 *"Calculate directly inside SQL."*

```sql
SELECT name, salary, ROUND(salary / 12.0, 2) AS monthly_salary FROM employees;

SELECT ROUND(7916.67, 1),   -- 7916.7
       ABS(-42),            -- 42
       CEILING(3.2),        -- 4  (round up)
       FLOOR(3.9);          -- 3  (round down)
```

---

### 06 · Date & time functions

> 💬 *"Dates are everywhere in analytics. Extract parts, calculate differences, truncate to periods."*

```sql
SELECT CURRENT_DATE;                                        -- today
SELECT EXTRACT(YEAR FROM CURRENT_DATE);                    -- 2024
SELECT DATEDIFF('day', '2024-01-01', '2024-06-15');        -- 165
SELECT DATE_TRUNC('month', '2024-06-15');                  -- 2024-06-01
```

<details>
<summary>Why DATE_TRUNC is essential for analytics</summary>
<br>

`DATE_TRUNC('month', date)` converts every date in June to `2024-06-01`. This means `GROUP BY DATE_TRUNC('month', date)` groups all June events into one bucket — regardless of which day they happened. This is how monthly trend reports are built.

Without `DATE_TRUNC`, grouping by a raw date gives one row per day.

</details>

---

### 07 · String functions

> 💬 *"Clean and reshape text values."*

```sql
SELECT UPPER('hello'),         -- HELLO
       LOWER('WORLD'),         -- world
       LENGTH('Sarah'),        -- 5
       TRIM('  Sarah  '),      -- 'Sarah'
       SUBSTR('Engineering', 1, 3),          -- 'Eng'
       REPLACE('Data_Cleanup', '_', ' '),    -- 'Data Cleanup'
       'Hello' || ' ' || 'World';           -- 'Hello World'
```

---

### 08 · UNION, INTERSECT, EXCEPT

> 💬 *"Stack results from two queries vertically. Both queries must return the same number of columns."*

```sql
-- UNION: combine, remove duplicates
SELECT name FROM employees WHERE department = 'Engineering'
UNION
SELECT name FROM employees WHERE salary > 80000;

-- UNION ALL: combine, keep duplicates (faster)
SELECT name FROM employees WHERE department = 'Engineering'
UNION ALL
SELECT name FROM employees WHERE salary > 80000;

-- INTERSECT: rows in BOTH queries
SELECT name FROM employees WHERE department = 'Engineering'
INTERSECT
SELECT name FROM employees WHERE salary > 80000;

-- EXCEPT: rows in first but NOT in second
SELECT name FROM employees WHERE status = 'Active'
EXCEPT
SELECT name FROM employees WHERE salary > 80000;
```

<details>
<summary>UNION vs JOIN — completely different operations</summary>
<br>

**JOIN** adds columns — combines two tables side by side. Result has more columns.

**UNION** stacks rows — combines two results on top of each other. Result has more rows, same columns.

Use JOIN to combine related data from different tables. Use UNION to merge similar lists from the same or different sources.

</details>

---

<details>
<summary><strong>🧠 Lesson 04 — Self-check</strong></summary>
<br>

<details>
<summary>Q1 · What does % mean in LIKE? What does _ mean?</summary>
<br>

`%` matches any number of characters (including zero). `_` matches exactly one character.

</details>

<details>
<summary>Q2 · Is BETWEEN inclusive or exclusive?</summary>
<br>

Inclusive on both ends. `BETWEEN 70000 AND 90000` = `>= 70000 AND <= 90000`.

</details>

<details>
<summary>Q3 · UNION vs UNION ALL — difference and when to use each?</summary>
<br>

`UNION` removes duplicate rows. `UNION ALL` keeps them (and is faster). Use `UNION ALL` when duplicates are acceptable or when you know they will not appear.

</details>

<details>
<summary>Q4 · Why use DATE_TRUNC instead of grouping by a raw date?</summary>
<br>

A raw date is unique per day — grouping produces one row per day. `DATE_TRUNC('month', date)` converts all dates in the same month to the same value, so grouping produces one row per month.

</details>

</details>

---

<a id="lesson-05"></a>

## Lesson 05 — Window Functions & CTEs

<div align="center">

![](https://img.shields.io/badge/Lesson-05_of_05-586074?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Skills-ROW__NUMBER_·_RANK_·_LAG_·_LEAD_·_WITH-2455C3?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Status-⬜_Upcoming-9AA3B2?style=flat-square)

</div>

<br>

*Content added when this lesson begins.*

---

<a id="quick-reference"></a>

## Quick reference

<details>
<summary><strong>Core clause execution order</strong></summary>
<br>

| Order | Clause | Does what |
|-------|--------|-----------|
| 1 | `FROM` | Load the table(s) |
| 2 | `WHERE` | Filter rows before grouping |
| 3 | `GROUP BY` | Bucket rows into groups |
| 4 | `HAVING` | Filter groups after grouping |
| 5 | `SELECT` | Choose columns, run expressions |
| 6 | `ORDER BY` | Sort the final result |
| 7 | `LIMIT` | Cap rows returned |

</details>

<details>
<summary><strong>JOIN types</strong></summary>
<br>

| | Type | Returns | NULLs on |
|---|---|---|---|
| 🔵 | `INNER JOIN` | Only matching rows | Neither |
| 🟢 | `LEFT JOIN` | All left + matching right | Right side |
| 🟡 | `RIGHT JOIN` | All right + matching left | Left side |
| 🟣 | `FULL OUTER JOIN` | Everything from both | Either side |

</details>

<details>
<summary><strong>CASE syntax</strong></summary>
<br>

```sql
-- Simple (exact values)
CASE column WHEN 'x' THEN 1 WHEN 'y' THEN 2 ELSE 99 END

-- Searched (conditions)
CASE WHEN salary >= 90000 THEN 'Senior' WHEN salary >= 70000 THEN 'Mid' ELSE 'Junior' END
```

**Remember:** conditions are checked top-to-bottom. First match wins. Always include `ELSE` for unmatched values.

</details>

<details>
<summary><strong>Subquery patterns</strong></summary>
<br>

```sql
-- WHERE: single value
WHERE salary > (SELECT AVG(salary) FROM employees)

-- WHERE: list
WHERE emp_id IN (SELECT emp_id FROM reviews WHERE follow_up = 'Urgent')

-- FROM: derived table (alias is mandatory)
SELECT * FROM (
    SELECT department, AVG(salary) AS avg_sal FROM employees GROUP BY department
) AS summary
WHERE summary.avg_sal > 75000
```

</details>

<details>
<summary><strong>Filtering toolkit</strong></summary>
<br>

| Operator | What it does | Example |
|----------|-------------|---------|
| `LIKE 'S%'` | Starts with S | `WHERE name LIKE 'S%'` |
| `LIKE '%ETL%'` | Contains ETL | `WHERE job_name LIKE '%ETL%'` |
| `BETWEEN a AND b` | Inclusive range | `WHERE salary BETWEEN 70000 AND 90000` |
| `IN (list)` | Matches any | `WHERE dept IN ('Eng', 'Marketing')` |
| `DISTINCT` | Remove duplicates | `SELECT DISTINCT department` |

</details>

<details>
<summary><strong>Common traps — full list</strong></summary>
<br>

| Trap | What happens | Fix |
|------|-------------|-----|
| `WHERE x = NULL` | Returns zero rows | Use `IS NULL` |
| `WHERE AVG(x) > n` | Error — aggregate in WHERE | Use `HAVING` or subquery in FROM |
| Alphabetical sort on categories | Wrong order | Use `CASE` to assign numbers |
| JOIN returns more rows than expected | One-to-many relationship | Check for duplicate keys |
| `COUNT(*)` counts NULLs | Inflated counts | Use `COUNT(column)` |
| FROM subquery without alias | Error | Always add `AS alias_name` |
| `COALESCE(int, 'text')` | Type mismatch error | `COALESCE(CAST(col AS TEXT), 'text')` |
| COALESCE vs IS NULL confusion | Wrong tool used | IS NULL filters rows; COALESCE replaces values in output |
| `> (subquery)` returns multiple rows | Error | Use aggregate: `MAX()`, `AVG()`, etc. |
| BETWEEN excludes endpoints | Data gaps | BETWEEN is inclusive — both ends qualify |
| `UNION` is slow | Deduplication overhead | Use `UNION ALL` if duplicates are acceptable |

</details>

---

<div align="center">

*analytics-engineer-journey &nbsp;·&nbsp; module-01-sql*
&nbsp;&nbsp;
[github.com/nabiya15](https://github.com/nabiya15)

</div>
