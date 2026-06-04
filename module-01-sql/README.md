<div align="center">

![](https://img.shields.io/badge/Analytics_Engineer_Journey-Module_01-2455C3?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Topic-SQL_Fundamentals-586074?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Lessons_Complete-2_of_4-0C7550?style=flat-square)&nbsp;
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
- [Quick reference](#quick-reference)

---

<a id="overview"></a>

## Module overview

| # | Lesson | Skills | Status |
|---|--------|--------|--------|
| 01 | SQL Basics | SELECT · WHERE · GROUP BY · ORDER BY | ✅ Complete |
| 02 | JOINs | INNER · LEFT · RIGHT · FULL OUTER | ✅ Complete |
| 03 | Subqueries & CASE | Nested queries · conditional logic · COALESCE | 🟡 In progress |
| 04 | Window functions & CTEs | ROW_NUMBER · LAG · LEAD · WITH | ⬜ Upcoming |

**Files**

| File | Purpose |
|------|---------|
| [`lessons/lesson-01-basics.sql`](lessons/lesson-01-basics.sql) | All queries from Lesson 01 — commented |
| [`lessons/lesson-02-joins.sql`](lessons/lesson-02-joins.sql) | All queries from Lesson 02 — commented |
| [`lessons/lesson-03-subqueries-case.sql`](lessons/lesson-03-subqueries-case.sql) | All queries from Lesson 03 — commented |
| [`practice/lesson-02-joins-practice.sql`](practice/lesson-02-joins-practice.sql) | JOIN practice — no hints, Copilot off |
| [`checkpoint/checkpoint-module-01-sql-fundamentals.sql`](checkpoint/checkpoint-module-01-sql-fundamentals.sql) | Module 01 checkpoint — conditional pass |

---

<a id="lesson-01"></a>

## Lesson 01 — SQL Basics

<div align="center">

![](https://img.shields.io/badge/Lesson-01_of_04-586074?style=flat-square)&nbsp;
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

> 💬 *A structured way to store information so you can ask questions about it later.*

A **table** is like a spreadsheet tab. A **row** is one record. A **column** is one fact about that record. SQL is the language you use to ask questions about the table.

---

### 02 · SELECT & FROM

> 💬 *"Show me these columns from this table."*

```sql
SELECT *                                  -- all columns
FROM tickets;

SELECT ticket_id, priority, status        -- specific columns only
FROM tickets;
```

<details>
<summary>Why column names have no quotes but values do</summary>
<br>

`status` is a **column name** — part of the table structure. `'Open'` is a **value** — data inside a cell. SQL needs quotes around values to distinguish them from column references. This distinction appears in every query you will ever write.

</details>

---

### 03 · WHERE

> 💬 *"Only show me rows where this condition is true."*

```sql
SELECT * FROM tickets
WHERE status = 'Open';
```

<details>
<summary>Combining conditions — AND · OR · !=</summary>
<br>

```sql
SELECT * FROM tickets
WHERE priority = 'High' AND status = 'Open';

SELECT * FROM tickets
WHERE assigned_to = 'Nabiya' OR assigned_to = 'Dev Team';

SELECT * FROM tickets
WHERE status != 'Closed';
```

> ⚠️ Always check what values are actually in a column before assuming two conditions are equivalent.

</details>

---

### 04 · GROUP BY & aggregations

> 💬 *"Instead of showing individual rows, calculate something about them."*

```sql
SELECT status, COUNT(*)
FROM tickets
GROUP BY status;

SELECT priority, AVG(resolution_hours)
FROM tickets
WHERE status = 'Closed'
GROUP BY priority;
```

<details>
<summary>COUNT(*) vs COUNT(column) — and execution order</summary>
<br>

`COUNT(*)` counts all rows including NULLs. `COUNT(column)` counts only non-NULL values.

**Execution order:** `WHERE` → `GROUP BY` → `HAVING`. `WHERE` cannot filter on aggregated results — that needs `HAVING`.

</details>

---

### 05 · HAVING

> 💬 *"`WHERE` filters rows before grouping. `HAVING` filters groups after."*

```sql
SELECT priority, AVG(resolution_hours)
FROM tickets
WHERE status = 'Closed'
GROUP BY priority
HAVING AVG(resolution_hours) > 5;
```

---

### 06 · ORDER BY & LIMIT

> 💬 *"`ORDER BY` sorts results. `LIMIT` caps how many rows come back."*

```sql
SELECT ticket_id, priority, resolution_hours
FROM tickets
WHERE status = 'Closed'
ORDER BY resolution_hours ASC
LIMIT 2;
```

<details>
<summary>The text-sort trap</summary>
<br>

`ORDER BY priority ASC` gives `High → Low → Medium` — alphabetical, not urgency order. Fix: use `CASE` to assign numeric values. Covered in Lesson 03.

</details>

---

### 07 · NULL

> 💬 *"`NULL` is not zero. It is not empty. It is the absence of any value."*

```sql
SELECT * FROM tickets
WHERE resolution_hours IS NULL;
```

<details>
<summary>Why = NULL never works, and NULL in COUNT and ORDER BY</summary>
<br>

`WHERE resolution_hours = NULL` always returns zero rows. Always use `IS NULL` or `IS NOT NULL`.

`COUNT(*)` includes NULLs. `COUNT(column)` ignores them. NULL values in `ORDER BY` land at unpredictable positions — never assume.

</details>

---

<details>
<summary><strong>🧠 Lesson 01 — Self-check</strong></summary>
<br>

<details>
<summary>Q1 · What is the difference between WHERE and HAVING?</summary>
<br>

`WHERE` filters rows before grouping. `HAVING` filters groups after `GROUP BY`. You cannot use `WHERE` to filter on `COUNT(*)` or `AVG()`.

</details>

<details>
<summary>Q2 · Why does <code>WHERE resolution_hours = NULL</code> return nothing?</summary>
<br>

`NULL` means no value exists. Nothing can equal the absence of a value. Use `IS NULL`.

</details>

<details>
<summary>Q3 · What breaks when you sort text-based priority alphabetically?</summary>
<br>

`High → Low → Medium` is not urgency order. Adding `'Critical'` makes it worse. Use `CASE` to assign numeric values before sorting.

</details>

</details>

---

<a id="lesson-02"></a>

## Lesson 02 — JOINs

<div align="center">

![](https://img.shields.io/badge/Lesson-02_of_04-586074?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Skills-INNER_·_LEFT_·_RIGHT_·_FULL_OUTER-2455C3?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Status-✓_Complete-0C7550?style=flat-square)

</div>

<br>

**The scenario** — At Meridian Systems, `autosys_jobs` ⏰ tracks automated task runs. `servicenow_tickets` 🎫 tracks reported problems. Both share `job_id` — that column is the bridge.

> 🔑 `job_id` is like a student ID — it appears in both tables and connects records across them.

**`autosys_jobs`**

| job_id | job_name | status |
|--------|----------|--------|
| `JOB001` | Daily_Sales_ETL | ❌ Failed |
| `JOB002` | Weekly_Report | ✅ Success |
| `JOB003` | Monthly_Backup | ⏳ Running |
| `JOB004` | Data_Cleanup | ❌ Failed |
| `JOB005` | User_Tracking | ✅ Success |

**`servicenow_tickets`**

| ticket_id | job_id | priority | assigned_to |
|-----------|--------|----------|-------------|
| INC001 | `JOB001` | 🔴 High | Nabiya |
| INC002 | `JOB004` | 🔴 High | Nabiya |
| INC003 | `JOB001` | 🟡 Medium | Dev Team |
| INC004 | `JOB003` | 🟢 Low | Nabiya |
| INC005 | `JOB002` | 🟢 Low | Dev Team |

> 👀 JOB001 has two tickets. JOB005 has none. These two facts drive every JOIN result below.

---

### 01 · INNER JOIN

> 💬 *"Only rows that exist in **both** tables."*

![INNER JOIN](assets/venn-inner.svg)

```sql
SELECT aj.job_id, aj.job_name, aj.status,
       sn.ticket_id, sn.priority
FROM autosys_jobs AS aj
INNER JOIN servicenow_tickets AS sn
    ON aj.job_id = sn.job_id;
```

<details>
<summary>Result · 5 rows</summary>
<br>

JOB005 disappears — no ticket. JOB001 appears twice — two tickets. This is a **one-to-many relationship**.

</details>

---

### 02 · LEFT JOIN — most used

> 💬 *"All left rows. Right side fills in where matched. `NULL` where it doesn't."*

![LEFT JOIN](assets/venn-left.svg)

```sql
SELECT aj.job_id, aj.job_name, aj.status,
       sn.ticket_id, sn.priority
FROM autosys_jobs AS aj
LEFT JOIN servicenow_tickets AS sn
    ON aj.job_id = sn.job_id;
```

<details>
<summary>Result · 6 rows</summary>
<br>

JOB005 stays with `NULL` in ticket columns. JOB001 still appears twice. When in doubt, start here.

</details>

---

### 03 · RIGHT JOIN — rarely written

> 💬 *"All right rows. Left side fills in where matched. `NULL` where it doesn't."*

![RIGHT JOIN](assets/venn-right.svg)

<details>
<summary>Why you will almost never write this</summary>
<br>

Every RIGHT JOIN rewrites as a LEFT JOIN by swapping table order. Always write LEFT JOIN and flip the tables instead.

</details>

---

### 04 · FULL OUTER JOIN

> 💬 *"Everything from both tables. `NULL` wherever there is no match on either side."*

![FULL OUTER JOIN](assets/venn-full.svg)

```sql
SELECT aj.job_id, aj.job_name, aj.status,
       sn.ticket_id, sn.priority
FROM autosys_jobs AS aj
FULL OUTER JOIN servicenow_tickets AS sn
    ON aj.job_id = sn.job_id;
```

<details>
<summary>Result · 6 rows</summary>
<br>

JOB005 appears with `NULL` on the ticket side. All tickets appear. JOB001 still appears twice.

</details>

---

### 05 · The NULL pattern — finding what's missing

> 💬 *"`LEFT JOIN` + `WHERE right_key IS NULL` = left rows with no match on the right."*

```sql
SELECT aj.job_id, aj.job_name, aj.status
FROM autosys_jobs AS aj
LEFT JOIN servicenow_tickets AS sn
    ON aj.job_id = sn.job_id
WHERE sn.job_id IS NULL;
```

<details>
<summary>Real-world uses</summary>
<br>

Customers who never ordered · employees with no review · failed jobs with no ticket. Always: LEFT JOIN → `WHERE right_key IS NULL`.

</details>

---

<details>
<summary><strong>🧠 Lesson 02 — Self-check</strong></summary>
<br>

<details>
<summary>Q1 · You want every job including those with no ticket. Which JOIN?</summary>
<br>

LEFT JOIN. Left table appears fully. Jobs with no ticket show `NULL` instead of being dropped.

</details>

<details>
<summary>Q2 · INNER returns 5 rows. LEFT returns 7. What do the extra 2 mean?</summary>
<br>

2 rows in the left table have no match in the right. INNER dropped them. LEFT kept them with NULLs.

</details>

<details>
<summary>Q3 · Why does JOB001 appear twice in the result?</summary>
<br>

JOB001 matched two rows in `servicenow_tickets`. A JOIN produces one output row per match. One-to-many relationship.

</details>

</details>

---

<a id="lesson-03"></a>

## Lesson 03 — Subqueries & CASE

<div align="center">

![](https://img.shields.io/badge/Lesson-03_of_04-586074?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Skills-CASE_·_Subqueries_·_COALESCE-2455C3?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Status-🟡_In_Progress-E8A020?style=flat-square)

</div>

<br>

**This lesson closes two open loops:**
- The **text-sort trap** from Lesson 01 — `CASE` fixes it
- Every query so far answered one question at a time — **subqueries** nest questions inside questions

**The data** — `employees` and `performance_reviews` from the checkpoint, with one addition:

```sql
ALTER TABLE performance_reviews ADD COLUMN follow_up TEXT;
UPDATE performance_reviews SET follow_up = 'Urgent' WHERE rating <= 2;
UPDATE performance_reviews SET follow_up = 'Normal' WHERE rating = 3;
UPDATE performance_reviews SET follow_up = 'Low'    WHERE rating >= 4;
```

| emp_id | name | department | salary | status |
|--------|------|------------|--------|--------|
| E001 | Sarah | Engineering | 95000 | Active |
| E002 | Marcus | Marketing | 72000 | Active |
| E003 | Priya | Engineering | 88000 | Active |
| E004 | James | Sales | 65000 | Inactive |
| E005 | Elena | Marketing | 78000 | Active |
| E006 | Tom | Sales | 70000 | Active |

| review_id | emp_id | rating | review_year | follow_up |
|-----------|--------|--------|-------------|-----------|
| R001 | E001 | 4 | 2024 | Low |
| R002 | E003 | 5 | 2024 | Low |
| R003 | E001 | 3 | 2023 | Normal |
| R004 | E002 | 4 | 2024 | Low |
| R005 | E005 | 2 | 2024 | Urgent |

> 👀 `follow_up` sorts alphabetically as `Low → Normal → Urgent` — not urgency order. `CASE` fixes this.

---

### 01 · CASE — conditional logic

> 💬 *"If this value, return that result. Otherwise return something else."*

**Simple CASE** — match exact values:

```sql
SELECT review_id, follow_up,
    CASE follow_up
        WHEN 'Urgent' THEN 1
        WHEN 'Normal' THEN 2
        WHEN 'Low'    THEN 3
    END AS follow_up_rank
FROM performance_reviews
ORDER BY follow_up_rank ASC;
```

**Searched CASE** — match conditions:

```sql
SELECT name, salary,
    CASE
        WHEN salary >= 90000 THEN 'Senior'
        WHEN salary >= 70000 THEN 'Mid'
        ELSE                      'Junior'
    END AS salary_band
FROM employees;
```

<details>
<summary>Simple vs searched CASE — when to use each</summary>
<br>

**Simple CASE** compares one column against a list of exact values. Clean and readable for known categories.

**Searched CASE** evaluates a condition in each `WHEN`. More flexible: handles ranges, multiple columns, or any boolean expression.

Use simple for category mapping. Use searched for ranges or anything more complex.

</details>

---

### 02 · Subqueries in WHERE

> 💬 *"Filter rows using the result of another query."*

```sql
-- Employees earning above the company average
SELECT name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);
```

```sql
-- Employees who have an 'Urgent' follow-up review
SELECT name, department
FROM employees
WHERE emp_id IN (
    SELECT emp_id
    FROM performance_reviews
    WHERE follow_up = 'Urgent'
);
```

<details>
<summary>How the inner query runs — and IN vs ></summary>
<br>

SQL runs the inner query first and substitutes its result into the outer query. *"First answer this smaller question, then use that answer to filter the bigger one."*

`> (subquery)` — inner query must return exactly one value (like `AVG` or `MAX`).

`IN (subquery)` — inner query returns a list of values. Outer query checks whether its column appears anywhere in that list.

</details>

---

### 03 · Subqueries in FROM

> 💬 *"Use the result of a query as if it were a table."*

```sql
-- Departments with average review rating of 4 or above
SELECT dept_avg.department,
       dept_avg.avg_rating
FROM (
    SELECT e.department,
           AVG(pr.rating) AS avg_rating
    FROM employees AS e
    INNER JOIN performance_reviews AS pr
        ON e.emp_id = pr.emp_id
    GROUP BY e.department
) AS dept_avg
WHERE dept_avg.avg_rating >= 4;
```

<details>
<summary>What a derived table is — and why this pattern matters</summary>
<br>

The subquery inside `FROM` runs first and produces a temporary table called a **derived table**. The outer query treats it like a real table.

This is how you filter on an aggregated result when `HAVING` is not enough — pre-aggregate inside the subquery, then filter in the outer `WHERE`.

This is the conceptual predecessor to CTEs (`WITH` clauses), which are the cleaner modern version. Covered in Lesson 04.

</details>

---

### 04 · COALESCE — replacing NULLs

> 💬 *"Return the first non-NULL value from a list."*

```sql
-- Replace NULL with a meaningful label in output
SELECT e.name,
       COALESCE(CAST(pr.rating AS TEXT), 'No review yet') AS review_status
FROM employees AS e
LEFT JOIN performance_reviews AS pr
    ON e.emp_id = pr.emp_id;
```

<details>
<summary>COALESCE vs IS NULL — when to use each</summary>
<br>

`IS NULL` belongs in `WHERE` — for filtering rows based on whether a value is missing.

`COALESCE` belongs in `SELECT` — for replacing NULL with a default value in your output.

`COALESCE(a, b, c)` returns the first non-NULL value from the list. They solve different problems.

</details>

---

<details>
<summary><strong>🧠 Lesson 03 — Self-check</strong></summary>
<br>

<details>
<summary>Q1 · What is the difference between simple and searched CASE?</summary>
<br>

Simple CASE: `CASE column WHEN value THEN result` — matches exact values against one column.
Searched CASE: `CASE WHEN condition THEN result` — evaluates any boolean condition per row.

</details>

<details>
<summary>Q2 · Why can't you write WHERE AVG(rating) >= 4 directly?</summary>
<br>

`WHERE` runs before `GROUP BY` — so `AVG(rating)` has not been calculated yet when `WHERE` executes. Use `HAVING` for filtering after aggregation, or a subquery in `FROM` to pre-aggregate.

</details>

<details>
<summary>Q3 · What is the difference between IN (subquery) and > (subquery)?</summary>
<br>

`> (subquery)` requires the inner query to return exactly one value. `IN (subquery)` works when the inner query returns a list — it checks whether the outer column appears anywhere in that list.

</details>

<details>
<summary>Q4 · When do you use COALESCE vs IS NULL?</summary>
<br>

`IS NULL` in `WHERE` — for filtering rows. `COALESCE` in `SELECT` — for replacing NULL with a default in output. Different tools, different purposes.

</details>

</details>

---

<a id="quick-reference"></a>

## Quick reference

<details>
<summary><strong>Core clause order</strong></summary>
<br>

| Order | Clause | Does what |
|-------|--------|-----------|
| 1 | `FROM` | Specify the table |
| 2 | `WHERE` | Filter rows before grouping |
| 3 | `GROUP BY` | Bucket rows into groups |
| 4 | `HAVING` | Filter groups after grouping |
| 5 | `SELECT` | Choose which columns to show |
| 6 | `ORDER BY` | Sort the final result |
| 7 | `LIMIT` | Cap rows returned |

</details>

<details>
<summary><strong>JOIN types</strong></summary>
<br>

| | Type | Returns | NULLs on |
|---|---|---|---|
| 🔵 | `INNER JOIN` | Only rows matching in both tables | Neither |
| 🟢 | `LEFT JOIN` | All left + matching right | Right side |
| 🟡 | `RIGHT JOIN` | All right + matching left | Left side |
| 🟣 | `FULL OUTER JOIN` | Everything from both tables | Either side |

</details>

<details>
<summary><strong>CASE syntax</strong></summary>
<br>

```sql
-- Simple CASE
CASE column
    WHEN 'value1' THEN result1
    WHEN 'value2' THEN result2
    ELSE           default_result
END

-- Searched CASE
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ELSE                 default_result
END
```

</details>

<details>
<summary><strong>Subquery patterns</strong></summary>
<br>

```sql
-- WHERE: single value
WHERE salary > (SELECT AVG(salary) FROM employees)

-- WHERE: list of values
WHERE emp_id IN (SELECT emp_id FROM table WHERE condition)

-- FROM: derived table
SELECT * FROM (
    SELECT ..., AGG() FROM table GROUP BY ...
) AS alias
WHERE alias.column condition
```

</details>

<details>
<summary><strong>Common traps</strong></summary>
<br>

| Trap | Fix |
|------|-----|
| `WHERE x = NULL` returns nothing | Use `IS NULL` |
| Alphabetical sort breaks category order | Use `CASE` to assign numeric values |
| JOIN returns more rows than expected | Check for one-to-many relationships |
| `COUNT(*)` counts NULL rows | Use `COUNT(column)` to exclude NULLs |
| `WHERE AVG(x) > n` throws an error | Use `HAVING` or a subquery in `FROM` |
| NULL appears in SELECT output | Use `COALESCE(column, 'default')` |

</details>

---

<div align="center">

*analytics-engineer-journey &nbsp;·&nbsp; module-01-sql*
&nbsp;&nbsp;
[github.com/nabiya15](https://github.com/nabiya15)

</div>
