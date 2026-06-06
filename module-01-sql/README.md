<div align="center">

![](https://img.shields.io/badge/Analytics_Engineer_Journey-Module_01-2455C3?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Topic-SQL_Fundamentals-586074?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Lessons_Complete-4_of_5-0C7550?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Status-In_Progress-E8A020?style=flat-square)

# Module 01 — SQL Fundamentals

*The language every data system speaks.*  
*Ask questions, filter answers, summarise data, connect tables.*

</div>

---

## Contents

| | Section |
|---|---------|
| 1 | [Module overview](#module-overview) |
| 2 | [Lesson 01 — SQL Basics](#lesson-01--sql-basics) |
| 3 | [Lesson 02 — JOINs](#lesson-02--joins) |
| 4 | [Lesson 03 — Subqueries & CASE](#lesson-03--subqueries--case) |
| 5 | [Lesson 04 — SQL Toolkit](#lesson-04--sql-toolkit) |
| 6 | [Lesson 05 — Window Functions & CTEs](#lesson-05--window-functions--ctes) |
| 7 | [Quick reference](#quick-reference) |

> 💡 **GitHub tip:** click the **≡** icon at the top-right of this page for a floating table of contents.

---

## Module overview

| # | Lesson | Skills | Status |
|---|--------|--------|--------|
| 01 | SQL Basics | SELECT · WHERE · GROUP BY · HAVING · ORDER BY · NULL | ✅ Complete |
| 02 | JOINs | INNER · LEFT · RIGHT · FULL OUTER · NULL pattern | ✅ Complete |
| 03 | Subqueries & CASE | CASE · WHERE subquery · FROM subquery · COALESCE · CAST | ✅ Complete |
| 04 | SQL Toolkit | LIKE · BETWEEN · DISTINCT · Dates · Strings · UNION | 🟡 In progress |
| 05 | Window Functions & CTEs | ROW_NUMBER · RANK · LAG · LEAD · WITH | ⬜ Upcoming |

| Checkpoint | Coverage | Result |
|------------|----------|--------|
| Mid-module | Lessons 01–03 | ✅ Passed |
| Final | All 5 lessons | ⬜ Upcoming |

<details>
<summary>📁 &nbsp;<strong>File listing</strong> &nbsp;— click to expand</summary>
<br>

```
module-01-sql/
├── lessons/
│   ├── lesson-01-basics.sql               ✅
│   ├── lesson-02-joins.sql                ✅
│   ├── lesson-03-subqueries-case.sql      ✅
│   └── lesson-04-toolkit.sql             🟡
├── practice/
│   ├── lesson-02-JOINs.sql               ✅
│   ├── lesson-03-subqueries-case-practice.sql  ✅
│   └── lesson-04-toolkit-practice.sql    🟡
├── checkpoint/
│   └── checkpoint-module-01-sql-fundamentals.sql  ✅ Passed
├── assets/
└── README.md
```

</details>

<div align="right"><a href="#contents">↑ Back to top</a></div>

---

## Lesson 01 — SQL Basics

<div align="center">

![](https://img.shields.io/badge/Lesson-01_of_05-586074?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Skills-SELECT_·_WHERE_·_GROUP_BY_·_ORDER_BY_·_NULL-2455C3?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Status-✓_Complete-0C7550?style=flat-square)

</div>

<details>
<summary>📋 &nbsp;<strong>The dataset</strong> &nbsp;— click to expand</summary>
<br>

One table, seven tickets.

| ticket_id | type | priority | status | assigned_to | resolution_hours |
|-----------|------|----------|--------|-------------|-----------------|
| INC001 | Incident | High | Open | Nabiya | `NULL` |
| INC002 | Incident | Low | Closed | Dev Team | 4 |
| REQ001 | Request | Medium | Open | Nabiya | `NULL` |
| INC003 | Incident | High | Closed | Dev Team | 12 |
| REQ002 | Request | Low | Open | Nabiya | `NULL` |
| INC004 | Incident | Medium | Open | Dev Team | `NULL` |
| REQ003 | Request | High | Closed | Nabiya | 6 |

> `NULL` in `resolution_hours` = ticket still open. NULL is not zero — it is the complete absence of a value.

</details>

---

### SELECT & FROM

> *"Show me these columns from this table."*

```sql
SELECT * FROM tickets;                           -- all columns
SELECT ticket_id, priority, status FROM tickets; -- specific columns only
```

<details>
<summary>💬 &nbsp;<strong>Why column names have no quotes but text values do</strong> &nbsp;— click to expand</summary>
<br>

`status` is a column name — part of the table structure. `'Open'` is a value — data inside a cell.

**Rule: structure = no quotes · data = single quotes · numbers = no quotes**

</details>

---

### WHERE

> *"Only show rows where this condition is true."*

```sql
SELECT * FROM tickets WHERE status = 'Open';
```

<details>
<summary>💬 &nbsp;<strong>Combining conditions — AND · OR · !=</strong> &nbsp;— click to expand</summary>
<br>

```sql
WHERE priority = 'High' AND status = 'Open'
WHERE assigned_to = 'Nabiya' OR assigned_to = 'Dev Team'
WHERE status != 'Closed'
```

</details>

---

### GROUP BY & aggregations

> *"Sort rows into buckets, then calculate something about each bucket."*

```sql
SELECT status, COUNT(*) FROM tickets GROUP BY status;

SELECT priority, AVG(resolution_hours)
FROM tickets WHERE status = 'Closed'
GROUP BY priority;
```

<details>
<summary>💬 &nbsp;<strong>COUNT(*) vs COUNT(column) · Execution order</strong> &nbsp;— click to expand</summary>
<br>

`COUNT(*)` counts all rows including NULLs. `COUNT(column)` skips NULLs.

**Execution order:** `FROM` → `WHERE` → `GROUP BY` → `HAVING` → `SELECT` → `ORDER BY` → `LIMIT`

</details>

---

### HAVING

> *"Filter groups after grouping. WHERE filters rows before grouping."*

```sql
SELECT priority, AVG(resolution_hours)
FROM tickets
WHERE status = 'Closed'
GROUP BY priority
HAVING AVG(resolution_hours) > 5;
```

---

### ORDER BY & LIMIT

> *"Sort results. Cap how many rows come back."*

```sql
SELECT ticket_id, priority, resolution_hours
FROM tickets WHERE status = 'Closed'
ORDER BY resolution_hours ASC LIMIT 2;
```

<details>
<summary>⚠️ &nbsp;<strong>The text-sort trap</strong> &nbsp;— click to expand</summary>
<br>

`ORDER BY priority ASC` gives `High → Low → Medium` — alphabetical, not urgency order. Fix with CASE (covered in Lesson 03).

</details>

---

### NULL

> *"NULL means no value exists. Not zero. Not blank. Nothing."*

```sql
SELECT * FROM tickets WHERE resolution_hours IS NULL;
```

> ⚠️ `WHERE x = NULL` always returns zero rows. Nothing equals the absence of a value. Always use `IS NULL` or `IS NOT NULL`.

<details>
<summary>🧠 &nbsp;<strong>Lesson 01 Self-check — 3 questions</strong> &nbsp;— click to expand</summary>
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

`High → Low → Medium` — alphabetical, not urgency order. Use CASE to assign numbers before sorting.

</details>

</details>

<div align="right"><a href="#contents">↑ Back to top</a></div>

---

## Lesson 02 — JOINs

<div align="center">

![](https://img.shields.io/badge/Lesson-02_of_05-586074?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Skills-INNER_·_LEFT_·_RIGHT_·_FULL_OUTER-2455C3?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Status-✓_Complete-0C7550?style=flat-square)

</div>

<details>
<summary>📋 &nbsp;<strong>The dataset — two tables, one bridge column</strong> &nbsp;— click to expand</summary>
<br>

`autosys_jobs` tracks automated task runs. `servicenow_tickets` tracks reported problems. Both share `job_id` — that column is the bridge.

| autosys_jobs | | servicenow_tickets |
|---|---|---|
| JOB001 · Failed | | INC001 · JOB001 · High |
| JOB002 · Success | | INC002 · JOB004 · High |
| JOB003 · Running | | INC003 · JOB001 · Medium |
| JOB004 · Failed | | INC004 · JOB003 · Low |
| JOB005 · Success | | INC005 · JOB002 · Low |

> **JOB001 has two tickets. JOB005 has none.** These two facts drive every JOIN result below.

</details>

---

### INNER JOIN

> *"Only rows matching in both tables. No match = dropped."*

![INNER JOIN](assets/venn-inner.svg)

```sql
SELECT aj.job_id, aj.job_name, sn.ticket_id, sn.priority
FROM autosys_jobs AS aj
INNER JOIN servicenow_tickets AS sn ON aj.job_id = sn.job_id;
-- JOB005 disappears. JOB001 appears twice. Result: 5 rows.
```

---

### LEFT JOIN — most used

> *"All left rows. Right fills in where matched. NULL where it doesn't."*

![LEFT JOIN](assets/venn-left.svg)

```sql
SELECT aj.job_id, aj.job_name, sn.ticket_id, sn.priority
FROM autosys_jobs AS aj
LEFT JOIN servicenow_tickets AS sn ON aj.job_id = sn.job_id;
-- JOB005 stays with NULL ticket columns. Result: 6 rows.
```

---

### RIGHT JOIN

> *"All right rows. Left fills in where matched."*

![RIGHT JOIN](assets/venn-right.svg)

Every RIGHT JOIN can be rewritten as a LEFT JOIN by swapping table order. Always use LEFT JOIN in practice.

---

### FULL OUTER JOIN

> *"Everything from both tables. NULL on whichever side has no match."*

![FULL OUTER JOIN](assets/venn-full.svg)

```sql
SELECT aj.job_id, sn.ticket_id
FROM autosys_jobs AS aj
FULL OUTER JOIN servicenow_tickets AS sn ON aj.job_id = sn.job_id;
```

---

### The NULL pattern — finding what's missing

> *"LEFT JOIN + WHERE right_key IS NULL = rows with no match on the right."*

```sql
SELECT aj.job_id, aj.job_name, aj.status
FROM autosys_jobs AS aj
LEFT JOIN servicenow_tickets AS sn ON aj.job_id = sn.job_id
WHERE sn.job_id IS NULL;
-- Returns JOB005 only — the job with no associated ticket.
```

> ⚠️ Always check `IS NULL` on the **JOIN key**, not a data column. Data columns can have legitimate NULLs.

<details>
<summary>🧠 &nbsp;<strong>Lesson 02 Self-check — 3 questions</strong> &nbsp;— click to expand</summary>
<br>

<details>
<summary>Q1 · Every job including those with no ticket — which JOIN?</summary>
<br>

LEFT JOIN. All left-table rows appear. Unmatched rows get NULL on the right side.

</details>

<details>
<summary>Q2 · INNER returns 5 rows, LEFT returns 7 — what do the extra 2 mean?</summary>
<br>

2 rows in the left table have no match. INNER dropped them. LEFT kept them with NULLs.

</details>

<details>
<summary>Q3 · Why does JOB001 appear twice?</summary>
<br>

JOB001 matched two rows in servicenow_tickets. One job × two tickets = two output rows. One-to-many relationship.

</details>

</details>

<div align="right"><a href="#contents">↑ Back to top</a></div>

---

## Lesson 03 — Subqueries & CASE

<div align="center">

![](https://img.shields.io/badge/Lesson-03_of_05-586074?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Skills-CASE_·_Subqueries_·_COALESCE_·_CAST-2455C3?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Status-✓_Complete-0C7550?style=flat-square)

</div>

<details>
<summary>📋 &nbsp;<strong>What this lesson solves + dataset</strong> &nbsp;— click to expand</summary>
<br>

**Problem 1 — broken sort order.**
SQL sorts `priority` alphabetically: `High → Low → Medium`. CASE reassigns values to numbers before sorting.

**Problem 2 — two-step questions.**
*"Show employees above average salary"* requires calculating the average first. `WHERE` runs before aggregation — so `AVG()` inside `WHERE` throws an error. A subquery does step one inside step two.

**The data:**
```
employees                              performance_reviews (with follow_up)
E001 · Sarah    · Engineering · 95000  R001 · E001 · rating 4 · Low
E002 · Marcus   · Marketing   · 72000  R002 · E003 · rating 5 · Low
E003 · Priya    · Engineering · 88000  R003 · E001 · rating 3 · Normal
E004 · James    · Sales       · 65000  R004 · E002 · rating 4 · Low
E005 · Elena    · Marketing   · 78000  R005 · E005 · rating 2 · Urgent
E006 · Tom      · Sales       · 70000
```

</details>

---

### Simple CASE — map values to new values

> *"Look at each row. If the value matches, replace it with something else."*

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

> ⚠️ If a value matches no WHEN branch, CASE returns NULL. Always add `ELSE` to handle unknowns.

---

### Searched CASE — evaluate conditions per row

> *"Evaluate any condition in each branch — not just exact values."*

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
<summary>💬 &nbsp;<strong>Short-circuit evaluation — why later branches don't need AND</strong> &nbsp;— click to expand</summary>
<br>

CASE checks top-to-bottom and **stops at the first match**. Once a row passes `salary >= 90000`, SQL returns `'Senior'` and moves on. Every branch after that implicitly excludes values that earlier branches already caught.

`WHEN salary >= 70000 THEN 'Mid'` doesn't need `AND salary < 90000` — by the time SQL reaches that branch, the salary is already known to be below 90,000.

</details>

<details>
<summary>💬 &nbsp;<strong>Simple CASE vs searched CASE — when to use each</strong> &nbsp;— click to expand</summary>
<br>

**Simple CASE** (`CASE column WHEN value`) — mapping a known list of exact values. Clean and readable.

**Searched CASE** (`CASE WHEN condition`) — ranges, comparisons, or conditions across multiple columns. More flexible. Most real-world analytics work uses this form.

</details>

---

### Subqueries in WHERE

> *"Some filters require a calculated value. Subqueries calculate it inside the query."*

```sql
-- This errors — WHERE runs before AVG() exists:
SELECT name, salary FROM employees WHERE salary > AVG(salary);

-- Subquery fixes it:
SELECT name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);
```

```sql
-- IN (subquery) — when the inner query returns a list:
SELECT name, department FROM employees
WHERE emp_id IN (
    SELECT emp_id FROM performance_reviews WHERE follow_up = 'Urgent'
);
```

> 🔑 `> (subquery)` — inner must return **one value**. Use with `AVG()`, `MAX()`, `MIN()`.  
> 🔑 `IN (subquery)` — inner returns a **list**. Outer checks membership.

<details>
<summary>⚠️ &nbsp;<strong>Common mistake — subquery returns multiple rows with &gt;</strong> &nbsp;— click to expand</summary>
<br>

```sql
-- Errors if subquery returns more than one row:
WHERE salary > (SELECT salary FROM employees WHERE department = 'Engineering')
-- Engineering has Sarah AND Priya — two rows — error.

-- Fix: use a specific aggregate:
WHERE salary > (SELECT MAX(salary) FROM employees WHERE department = 'Engineering')
```

</details>

---

### Subqueries in FROM

> *"Run an inner query. Name its result. Query on top of it."*

```sql
SELECT dept_summary.department, dept_summary.avg_salary
FROM (
    SELECT department, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department
) AS dept_summary
WHERE dept_summary.avg_salary > 75000;
```

> ⚠️ The alias (`AS dept_summary`) is **mandatory**. SQL needs a name for the temporary result. Omit it and SQL throws an error immediately.

> 🔑 This pattern is the direct predecessor of **CTEs** (`WITH` clauses) — covered in Lesson 05.

---

### COALESCE — replacing NULLs in output

> *"Return the first non-NULL value. Use it to make NULL readable."*

```sql
SELECT e.name,
       COALESCE(CAST(pr.rating AS TEXT), 'No review yet') AS review_status
FROM employees AS e
LEFT JOIN performance_reviews AS pr ON e.emp_id = pr.emp_id;
```

> ⚠️ Types must match. `CAST(rating AS TEXT)` converts the integer first — then COALESCE has two compatible types.

<details>
<summary>💬 &nbsp;<strong>COALESCE vs IS NULL — different tools, different jobs</strong> &nbsp;— click to expand</summary>
<br>

`IS NULL` in `WHERE` → **filters rows** (keeps or removes them based on whether a value is missing)

`COALESCE` in `SELECT` → **replaces NULL with a default** in the output, without affecting which rows appear

Confusing these is one of the most common early mistakes.

</details>

<details>
<summary>🧠 &nbsp;<strong>Lesson 03 Self-check — 5 questions</strong> &nbsp;— click to expand</summary>
<br>

<details>
<summary>Q1 · What is CASE short-circuit evaluation?</summary>
<br>

CASE checks branches top-to-bottom and stops at the first match. Later branches implicitly exclude everything earlier branches already caught.

</details>

<details>
<summary>Q2 · Why does WHERE salary > AVG(salary) throw an error?</summary>
<br>

WHERE runs before aggregation. AVG(salary) doesn't exist yet at that point. Fix: `WHERE salary > (SELECT AVG(salary) FROM employees)`.

</details>

<details>
<summary>Q3 · When do you use > (subquery) vs IN (subquery)?</summary>
<br>

`> (subquery)` — inner must return exactly one value. Use with aggregate functions.
`IN (subquery)` — inner returns a list. Outer checks if its column appears in that list.

</details>

<details>
<summary>Q4 · What happens if you forget the alias on a FROM subquery?</summary>
<br>

SQL throws an error immediately. The alias is mandatory — SQL needs a name to reference the temp table's columns.

</details>

<details>
<summary>Q5 · COALESCE(pr.rating, 'No review yet') errors. Why?</summary>
<br>

Type mismatch — INTEGER and TEXT. Fix: `COALESCE(CAST(pr.rating AS TEXT), 'No review yet')`.

</details>

</details>

<div align="right"><a href="#contents">↑ Back to top</a></div>

---

## Lesson 04 — SQL Toolkit

<div align="center">

![](https://img.shields.io/badge/Lesson-04_of_05-586074?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Skills-LIKE_·_BETWEEN_·_DISTINCT_·_Dates_·_Strings_·_UNION-2455C3?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Status-🟡_In_Progress-E8A020?style=flat-square)

</div>

Operators and functions that appear in nearly every analytics interview and real-world query — filling the gaps Lessons 01–03 leave open.

---

### LIKE — pattern matching

> *"`%` = any characters. `_` = exactly one character."*

```sql
SELECT name FROM employees WHERE name LIKE 'S%';    -- starts with S
SELECT name FROM employees WHERE name LIKE '%a';    -- ends with a
SELECT name FROM employees WHERE name LIKE '%ar%';  -- contains 'ar'
SELECT name FROM employees WHERE name LIKE '___';   -- exactly 3 characters
```

> ⚠️ LIKE is case-sensitive. `'sarah' LIKE 'S%'` → no match. Normalise first: `LOWER(name) LIKE 's%'`.

---

### BETWEEN — inclusive range filtering

> *"Both endpoints included. `BETWEEN 70000 AND 90000` = `>= 70000 AND <= 90000`."*

```sql
SELECT name, salary FROM employees WHERE salary BETWEEN 70000 AND 90000;
```

---

### DISTINCT — remove duplicates

> *"Each unique value (or combination) appears exactly once."*

```sql
SELECT DISTINCT department FROM employees;
SELECT DISTINCT department, status FROM employees; -- unique COMBINATIONS
```

---

### Arithmetic & math functions

```sql
SELECT name, salary, ROUND(salary / 12.0, 2) AS monthly_salary FROM employees;
SELECT ROUND(7916.67, 1), ABS(-42), CEILING(3.2), FLOOR(3.9);
```

> ⚠️ `salary / 12` truncates to integer. Use `salary / 12.0` to preserve decimals.

---

### Date & time functions

```sql
SELECT CURRENT_DATE;
SELECT EXTRACT(YEAR FROM CURRENT_DATE);
SELECT DATEDIFF('day', DATE '2024-01-01', DATE '2024-06-15');  -- 165
SELECT DATE_TRUNC('month', DATE '2024-06-15');                 -- 2024-06-01
```

<details>
<summary>💬 &nbsp;<strong>Why DATE_TRUNC is essential for analytics</strong> &nbsp;— click to expand</summary>
<br>

`DATE_TRUNC('month', created_at)` converts every date in June to `2024-06-01`. Now `GROUP BY DATE_TRUNC('month', created_at)` gives one row per month — not one row per day. This is how monthly trend reports are built.

Without `DATE_TRUNC`, grouping by a raw date gives one row per exact day.

</details>

---

### String functions

```sql
SELECT UPPER('hello'),                           -- HELLO
       LOWER('WORLD'),                           -- world
       LENGTH('Sarah'),                          -- 5
       TRIM('  Sarah  '),                        -- 'Sarah'
       SUBSTR('Engineering', 1, 3),              -- 'Eng'
       REPLACE('Data_Cleanup', '_', ' '),        -- 'Data Cleanup'
       'Hello' || ' ' || 'World';               -- 'Hello World'
```

---

### UNION · UNION ALL · INTERSECT · EXCEPT

> *"Stack two query results vertically. Same column count and compatible types required."*

```sql
-- UNION: combine, remove duplicates
SELECT name FROM employees WHERE department = 'Engineering'
UNION
SELECT name FROM employees WHERE salary > 80000;

-- UNION ALL: combine, keep duplicates (faster — skips dedup)
SELECT name FROM employees WHERE department = 'Engineering'
UNION ALL
SELECT name FROM employees WHERE salary > 80000;

-- INTERSECT: rows appearing in BOTH queries
SELECT name FROM employees WHERE department = 'Engineering'
INTERSECT
SELECT name FROM employees WHERE salary > 80000;

-- EXCEPT: rows in first but NOT in second
SELECT name FROM employees WHERE status = 'Active'
EXCEPT
SELECT name FROM employees WHERE salary > 80000;
```

<details>
<summary>💬 &nbsp;<strong>UNION vs JOIN — completely different operations</strong> &nbsp;— click to expand</summary>
<br>

**JOIN** adds **columns** — combines tables side by side. Result has more columns.

**UNION** adds **rows** — stacks results on top of each other. Result has more rows, same columns.

Use JOIN to combine related data from different tables. Use UNION to merge similar lists from the same or different sources.

</details>

<details>
<summary>🧠 &nbsp;<strong>Lesson 04 Self-check — 4 questions</strong> &nbsp;— click to expand</summary>
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
<summary>Q3 · UNION vs UNION ALL — when to use each?</summary>
<br>

`UNION` removes duplicates (slower). `UNION ALL` keeps them (faster). Use `UNION ALL` when duplicates are acceptable — it skips the deduplication step entirely.

</details>

<details>
<summary>Q4 · Why use DATE_TRUNC instead of grouping by a raw date column?</summary>
<br>

A raw date is unique per day — grouping gives one row per day. `DATE_TRUNC('month', date)` collapses all dates in the same month to the same value, giving one row per month.

</details>

</details>

<div align="right"><a href="#contents">↑ Back to top</a></div>

---

## Lesson 05 — Window Functions & CTEs

<div align="center">

![](https://img.shields.io/badge/Lesson-05_of_05-586074?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Skills-ROW__NUMBER_·_RANK_·_LAG_·_LEAD_·_WITH-2455C3?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Status-⬜_Upcoming-9AA3B2?style=flat-square)

</div>

*Content added when this lesson begins.*

<div align="right"><a href="#contents">↑ Back to top</a></div>

---

## Quick reference

<details>
<summary>📌 &nbsp;<strong>Clause execution order</strong> &nbsp;— click to expand</summary>
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
<summary>📌 &nbsp;<strong>JOIN types at a glance</strong> &nbsp;— click to expand</summary>
<br>

| Type | Returns | NULLs on |
|------|---------|----------|
| `INNER JOIN` | Only matching rows | Neither side |
| `LEFT JOIN` | All left + matching right | Right side |
| `RIGHT JOIN` | All right + matching left | Left side |
| `FULL OUTER JOIN` | Everything from both | Either side |

</details>

<details>
<summary>📌 &nbsp;<strong>CASE syntax</strong> &nbsp;— click to expand</summary>
<br>

```sql
-- Simple (exact values)
CASE column WHEN 'x' THEN 1 WHEN 'y' THEN 2 ELSE 99 END

-- Searched (conditions)
CASE WHEN salary >= 90000 THEN 'Senior'
     WHEN salary >= 70000 THEN 'Mid'
     ELSE 'Junior'
END
```

Conditions check top-to-bottom. First match wins. Always include `ELSE`.

</details>

<details>
<summary>📌 &nbsp;<strong>Subquery patterns</strong> &nbsp;— click to expand</summary>
<br>

```sql
-- Single value in WHERE
WHERE salary > (SELECT AVG(salary) FROM employees)

-- List in WHERE
WHERE emp_id IN (SELECT emp_id FROM reviews WHERE follow_up = 'Urgent')

-- Derived table in FROM (alias mandatory)
SELECT * FROM (
    SELECT department, AVG(salary) AS avg_sal
    FROM employees GROUP BY department
) AS summary
WHERE summary.avg_sal > 75000
```

</details>

<details>
<summary>📌 &nbsp;<strong>Common traps — full list</strong> &nbsp;— click to expand</summary>
<br>

| Trap | Symptom | Fix |
|------|---------|-----|
| `WHERE x = NULL` | Zero rows returned | Use `IS NULL` |
| `WHERE AVG(x) > n` | Error | Use `HAVING` or FROM subquery |
| Alphabetical sort on categories | Wrong order | CASE to assign sort numbers |
| JOIN returns more rows than expected | One-to-many relationship | Check for duplicate keys |
| `COUNT(*)` counts NULLs | Inflated count | Use `COUNT(column)` |
| FROM subquery without alias | Error | Always add `AS alias_name` |
| `COALESCE(int, 'text')` | Type error | `COALESCE(CAST(col AS TEXT), 'text')` |
| `> (subquery)` returns multiple rows | Error | Use `MAX()`, `AVG()`, etc. |
| `salary / 12` truncates | Wrong decimal | Use `salary / 12.0` |
| `UNION` on large datasets is slow | Performance | Use `UNION ALL` if duplicates are acceptable |

</details>

<div align="right"><a href="#contents">↑ Back to top</a></div>

---

<div align="center">

*analytics-engineer-journey &nbsp;·&nbsp; module-01-sql*
&nbsp;&nbsp;
[github.com/nabiya15](https://github.com/nabiya15)

</div>
