<div align="center">

![](https://img.shields.io/badge/Analytics_Engineer_Journey-Module_01-2455C3?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Topic-SQL_Fundamentals-586074?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Lessons_Complete-2_of_5-0C7550?style=flat-square)&nbsp;
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
| 03 | Subqueries & CASE | CASE · WHERE subquery · FROM subquery · COALESCE | 🟡 In progress |
| 04 | SQL Toolkit | LIKE · BETWEEN · DISTINCT · dates · strings · UNION | ⬜ Upcoming |
| 05 | Window functions & CTEs | ROW_NUMBER · RANK · LAG · LEAD · WITH | ⬜ Upcoming |

**Files**

| File | Purpose |
|------|---------|
| [`lessons/lesson-01-basics.sql`](lessons/lesson-01-basics.sql) | All queries from Lesson 01 — commented |
| [`lessons/lesson-02-joins.sql`](lessons/lesson-02-joins.sql) | All queries from Lesson 02 — commented |
| [`lessons/lesson-03-subqueries-case.sql`](lessons/lesson-03-subqueries-case.sql) | All queries from Lesson 03 — commented |
| [`practice/lesson-02-joins-practice.sql`](practice/lesson-02-joins-practice.sql) | JOIN practice — no hints, Copilot off |
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

**The data** — a support ticket table. One row = one ticket. Seven tickets total.

| ticket_id | type | priority | status | assigned_to | resolution_hours |
|-----------|------|----------|--------|-------------|-----------------|
| INC001 | Incident | High | Open | Nabiya | `NULL` |
| INC002 | Incident | Low | Closed | Dev Team | 4 |
| REQ001 | Request | Medium | Open | Nabiya | `NULL` |
| INC003 | Incident | High | Closed | Dev Team | 12 |
| REQ002 | Request | Low | Open | Nabiya | `NULL` |
| INC004 | Incident | Medium | Open | Dev Team | `NULL` |
| REQ003 | Request | High | Closed | Nabiya | 6 |

> `NULL` in `resolution_hours` means the ticket is still open — nobody has recorded a resolution time yet. `NULL` is not zero. It is not blank. It means **the value does not exist at all**.

---

### 01 · What is a database?

> 💬 *A place that stores information in organised rows and columns so you can ask questions about it instantly.*

Imagine a school that tracks students. Before computers, a teacher kept attendance in one notebook, grades in another notebook, and emergency contacts on a printed sheet. To find everything about one student, you checked three places. That is slow and error-prone.

A database solves this by keeping all the information in one organised system. At Meridian Systems, instead of students, we have jobs and tickets. `autosys_jobs` is one table. `servicenow_tickets` is another. Every row is one thing. Every column is one fact about that thing.

**A table** = one spreadsheet tab of organised information
**A row** = one record (one ticket, one job, one employee)
**A column** = one fact about every record in that table
**SQL** = the language you write to ask questions about what is inside

---

### 02 · SELECT & FROM

> 💬 *"Show me these specific columns from this specific table."*

```sql
SELECT *
FROM tickets;
```

`SELECT *` means "give me every column." Use this when you are exploring unfamiliar data and want to see everything.

```sql
SELECT ticket_id, priority, status
FROM tickets;
```

Naming specific columns means SQL skips the ones you did not ask for. In real work at Meridian Systems, a table might have 80 columns. Asking for all 80 when you need 3 wastes memory and makes results hard to read.

<details>
<summary>What SELECT * returns from our data</summary>
<br>

All 7 rows, all 6 columns — exactly as the table above shows. No filtering, no sorting, just the raw data.

</details>

<details>
<summary>Why column names have no quotes but text values do</summary>
<br>

Look at this line: `WHERE status = 'Open'`

`status` has no quotes because it is a **column name** — it is part of the table's structure. SQL already knows it exists.

`'Open'` has quotes because it is a **value** — actual text data stored inside a cell. Without quotes, SQL would try to find a column called `Open`, fail, and throw an error.

Simple rule: **structure (columns, tables) = no quotes. Data (text values) = single quotes.**

Numbers never need quotes: `WHERE resolution_hours = 4` not `WHERE resolution_hours = '4'`.

</details>

---

### 03 · WHERE

> 💬 *"Only show me rows where this condition is true. Ignore all other rows."*

```sql
SELECT * FROM tickets
WHERE status = 'Open';
```

SQL reads every row in `tickets`. For each row it asks: is `status` equal to `'Open'`? If yes, include it in the result. If no, skip it. You get back only the matching rows.

<details>
<summary>What this returns — 4 rows</summary>
<br>

| ticket_id | priority | status | assigned_to |
|-----------|----------|--------|-------------|
| INC001 | High | Open | Nabiya |
| REQ001 | Medium | Open | Nabiya |
| REQ002 | Low | Open | Nabiya |
| INC004 | Medium | Open | Dev Team |

INC002, INC003, REQ003 are gone — they are Closed.

</details>

<details>
<summary>Combining conditions — AND · OR · !=</summary>
<br>

**AND** — both conditions must be true for a row to appear:
```sql
SELECT * FROM tickets
WHERE priority = 'High' AND status = 'Open';
-- Only rows that are BOTH High priority AND Open
-- Returns: INC001 only
```

**OR** — at least one condition must be true:
```sql
SELECT * FROM tickets
WHERE assigned_to = 'Nabiya' OR assigned_to = 'Dev Team';
-- Every ticket belongs to one of these two, so all 7 rows return
```

**!=** — not equal to (the opposite of =):
```sql
SELECT * FROM tickets
WHERE status != 'Closed';
-- Returns everything that is NOT Closed = 4 open tickets
```

> ⚠️ `WHERE status != 'Closed'` and `WHERE status = 'Open'` return identical rows here — because `status` only has two possible values in this dataset. The moment a third value like `'Pending'` is added, they behave differently. Always check what values actually exist in a column before assuming two conditions are equivalent.

</details>

---

### 04 · GROUP BY & aggregations

> 💬 *"Instead of showing me individual rows, count them, add them up, or average them — grouped by category."*

Without GROUP BY, every query returns individual rows. With GROUP BY, SQL sorts rows into buckets (one bucket per unique value in the column you choose), then runs a calculation on each bucket.

Think of it like this: a teacher has 30 test papers scattered on a desk. `GROUP BY grade` means "sort them into piles by grade first (A pile, B pile, C pile), then count how many are in each pile."

```sql
SELECT status, COUNT(*)
FROM tickets
GROUP BY status;
```

SQL creates two buckets: one for "Open" rows and one for "Closed" rows. Then it counts how many rows landed in each.

<details>
<summary>What this returns</summary>
<br>

| status | count_star |
|--------|-----------|
| Open | 4 |
| Closed | 3 |

</details>

```sql
SELECT priority, AVG(resolution_hours)
FROM tickets
WHERE status = 'Closed'
GROUP BY priority;
```

`WHERE status = 'Closed'` runs first — this removes the 4 open tickets. Then `GROUP BY priority` buckets the remaining 3 closed tickets by their priority. Then `AVG(resolution_hours)` calculates the average hours inside each bucket.

<details>
<summary>What this returns — 3 buckets from 3 closed tickets</summary>
<br>

| priority | avg_resolution_hours |
|----------|---------------------|
| Low | 4.0 |
| High | 12.0 |
| High | 6.0 |

Wait — two High rows? That means INC002 and INC003 are in the same priority bucket (both High... but wait, INC002 is Low). Check the original table. INC002 is Low (4 hrs), INC003 is High (12 hrs), REQ003 is High (6 hrs). So:
- Low bucket: just INC002 → AVG = 4.0
- High bucket: INC003 + REQ003 → AVG = (12+6)/2 = 9.0

| priority | avg_resolution_hours |
|----------|---------------------|
| Low | 4.0 |
| High | 9.0 |

</details>

<details>
<summary>COUNT(*) vs COUNT(column) — why they give different answers</summary>
<br>

`COUNT(*)` counts every row, including rows with `NULL` values.
`COUNT(resolution_hours)` counts only rows where `resolution_hours` is not `NULL`.

From our data: `COUNT(*)` = 7. `COUNT(resolution_hours)` = 3. The 4 open tickets have `NULL` in that column and are skipped.

Use `COUNT(column)` when NULLs should not be counted. Use `COUNT(*)` when every row matters regardless of NULLs.

</details>

---

### 05 · HAVING

> 💬 *"After you have grouped the rows, filter out the groups you do not want."*

You cannot use `WHERE` to filter on `COUNT(*)` or `AVG()` because `WHERE` runs **before** grouping happens — the groups do not exist yet at that point. `HAVING` runs **after** grouping, so it can see the group totals.

```sql
SELECT priority, AVG(resolution_hours)
FROM tickets
WHERE status = 'Closed'
GROUP BY priority
HAVING AVG(resolution_hours) > 5;
```

**Here is exactly what SQL does, step by step:**

1. `FROM tickets` — load all 7 rows into memory
2. `WHERE status = 'Closed'` — remove the 4 open rows, keep 3
3. `GROUP BY priority` — sort the 3 remaining rows into priority buckets
4. `HAVING AVG(resolution_hours) > 5` — calculate the average for each bucket, remove buckets where the average is 5 or below
5. `SELECT priority, AVG(resolution_hours)` — show the surviving buckets

<details>
<summary>What this returns</summary>
<br>

| priority | avg_resolution_hours |
|----------|---------------------|
| High | 9.0 |

The Low bucket (average = 4.0) is removed by HAVING. Only High remains.

</details>

---

### 06 · ORDER BY & LIMIT

> 💬 *"`ORDER BY` sorts your results. `LIMIT` cuts the list to the top N rows."*

```sql
SELECT ticket_id, priority, resolution_hours
FROM tickets
WHERE status = 'Closed'
ORDER BY resolution_hours ASC
LIMIT 2;
```

`ASC` = ascending = smallest to largest. `DESC` = descending = largest to smallest.

<details>
<summary>What this returns — the 2 fastest resolved tickets</summary>
<br>

| ticket_id | priority | resolution_hours |
|-----------|----------|-----------------|
| INC002 | Low | 4 |
| REQ003 | High | 6 |

INC003 (12 hours) is cut by LIMIT 2.

</details>

<details>
<summary>⚠️ The text-sort trap — why sorting priority alphabetically is broken</summary>
<br>

If you run `ORDER BY priority ASC` on text values, SQL sorts alphabetically — the same way a dictionary does. The result:

| priority | (alphabetical position) |
|----------|------------------------|
| High | H = 8th letter |
| Low | L = 12th letter |
| Medium | M = 13th letter |

So alphabetically: **High → Low → Medium**

That is wrong. Medium is more urgent than Low. SQL does not know that. It only knows the alphabet.

Now add a `'Critical'` priority level. `C` comes before `H`, so Critical sorts first. But Critical is the most urgent — that happens to be correct by coincidence. Add `'Urgent'` and `U` sorts last, making Urgent appear least important. Completely broken.

The fix is `CASE` — covered in Lesson 03. `CASE` assigns a number to each word so SQL sorts numbers instead of letters.

</details>

---

### 07 · NULL

> 💬 *"`NULL` means 'no value exists here.' It is not zero. It is not an empty string. The field was never filled in."*

Imagine a job application form. If someone skips the "Middle Name" field entirely, the database stores `NULL` — not an empty box, not the word "none", but a complete absence. A middle name that is an empty string `''` and a middle name that is `NULL` are different things: one person typed nothing, the other person left the field blank before even clicking.

```sql
SELECT ticket_id, status, resolution_hours
FROM tickets
WHERE resolution_hours IS NULL;
```

This returns all tickets that have never been resolved — the open ones.

<details>
<summary>Why = NULL never works</summary>
<br>

`WHERE resolution_hours = NULL` always returns zero rows. Here is why: `NULL` has no value. You cannot check if something equals the absence of a value. Asking "is nothing equal to nothing?" is not a question SQL can answer — it returns `NULL` (unknown), not `TRUE`.

Always use `IS NULL` or `IS NOT NULL` — never `= NULL`.

</details>

<details>
<summary>NULL surprises in COUNT and ORDER BY</summary>
<br>

**In COUNT:** `COUNT(*)` counts every row including those with NULL. `COUNT(resolution_hours)` skips rows where that column is NULL.
From our data: `COUNT(*)` = 7, `COUNT(resolution_hours)` = 3. Four tickets are still open with NULL resolution times.

**In ORDER BY:** NULL values have no numeric position so SQL does not know where to put them. Different databases handle this differently — some float NULL to the top, some to the bottom. DuckDB floats them to the top on `DESC` sort. Never assume. Always check.

</details>

---

<details>
<summary><strong>🧠 Lesson 01 — Self-check</strong></summary>
<br>

<details>
<summary>Q1 · What is the difference between WHERE and HAVING?</summary>
<br>

`WHERE` filters individual rows before they are grouped. `HAVING` filters groups after `GROUP BY` has run. You cannot use `WHERE` to filter on `COUNT(*)` or `AVG()` — those values do not exist until after grouping.

</details>

<details>
<summary>Q2 · Why does <code>WHERE resolution_hours = NULL</code> return zero rows?</summary>
<br>

`NULL` means no value exists. You cannot compare something to the absence of a value using `=`. SQL evaluates the comparison as unknown (not true), so no rows pass the filter. Use `IS NULL`.

</details>

<details>
<summary>Q3 · Count how many tickets each person is assigned — write it in words.</summary>
<br>

`SELECT assigned_to, COUNT(*) FROM tickets GROUP BY assigned_to` — group rows by person, count how many rows land in each group.

</details>

<details>
<summary>Q4 · What breaks when you sort text priority alphabetically?</summary>
<br>

Alphabetical order gives `High → Low → Medium`. Low appears before Medium even though Medium is more urgent. Adding new priority levels like `'Critical'` or `'Urgent'` makes it worse — they sort by their first letter, not by urgency. Use `CASE` to assign numbers before sorting.

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

**The scenario** — Two tables. One connection.

At Meridian Systems, two teams built two separate systems. The infrastructure team built Autosys to schedule and track automated jobs. The support team built ServiceNow to track problems when those jobs break. Nobody planned for these two systems to talk to each other — but they both record `job_id`, which means we can connect them in SQL.

> 🔑 **The shared column is the key.** Think of `job_id` like a student ID number. If both the attendance sheet and the report card use the same student ID, a teacher can look up any student across both sheets — even though they were made by different people at different times. The student ID is what connects them.

**`autosys_jobs`** — the alarm clock that runs tasks on a schedule

| job_id | job_name | status |
|--------|----------|--------|
| `JOB001` | Daily_Sales_ETL | ❌ Failed |
| `JOB002` | Weekly_Report | ✅ Success |
| `JOB003` | Monthly_Backup | ⏳ Running |
| `JOB004` | Data_Cleanup | ❌ Failed |
| `JOB005` | User_Tracking | ✅ Success |

**`servicenow_tickets`** — the help-desk notebook of reported problems

| ticket_id | job_id | priority | assigned_to |
|-----------|--------|----------|-------------|
| INC001 | `JOB001` | 🔴 High | Nabiya |
| INC002 | `JOB004` | 🔴 High | Nabiya |
| INC003 | `JOB001` | 🟡 Medium | Dev Team |
| INC004 | `JOB003` | 🟢 Low | Nabiya |
| INC005 | `JOB002` | 🟢 Low | Dev Team |

> 👀 **Two things that drive every JOIN result below:**
> 1. **JOB001 has two tickets** (INC001 and INC003) — one job, two problems raised for it
> 2. **JOB005 has no ticket** — it ran successfully so nobody complained

---

### 01 · Why JOINs exist

> 💬 *"A JOIN temporarily combines two tables into one result using matching values in a shared column."*

Run `SELECT * FROM autosys_jobs` and you see jobs. Run `SELECT * FROM servicenow_tickets` and you see tickets. Neither result alone can answer: *"Which tickets belong to which failed jobs?"*

A JOIN reads both tables at once and stitches together rows where `job_id` matches. The result is a temporary combined table that exists only for that query — the original tables are untouched.

The four JOIN types answer four different versions of the same question — they differ only in **what happens to rows that have no match**.

---

### 02 · Keys — what connects two tables

> 💬 *"The primary key owns the ID. The foreign key borrows it."*

| Term | What it means | In our data |
|------|--------------|-------------|
| **Primary key** | The unique ID that belongs to this table. Every row has exactly one — no duplicates. | `job_id` in `autosys_jobs` |
| **Foreign key** | That same ID appearing in a second table as a reference pointing back to the first. | `job_id` in `servicenow_tickets` |
| **ON condition** | The instruction telling SQL which columns to match when combining rows. | `ON aj.job_id = sn.job_id` |

`autosys_jobs` *owns* `job_id`. `servicenow_tickets` *borrows* it. The JOIN uses `ON` to reunite them.

---

### 03 · INNER JOIN

> 💬 *"Only show me rows that have a matching partner in both tables. Drop everyone with no match."*

![INNER JOIN](assets/venn-inner.svg)

```sql
SELECT aj.job_id, aj.job_name, aj.status,
       sn.ticket_id, sn.priority
FROM autosys_jobs AS aj
INNER JOIN servicenow_tickets AS sn
    ON aj.job_id = sn.job_id;
```

<details>
<summary>Result · 5 rows — and why</summary>
<br>

| job_id | job_name | status | ticket_id | priority |
|--------|----------|--------|-----------|----------|
| JOB001 | Daily_Sales_ETL | Failed | INC001 | High |
| JOB001 | Daily_Sales_ETL | Failed | INC003 | Medium |
| JOB002 | Weekly_Report | Success | INC005 | Low |
| JOB003 | Monthly_Backup | Running | INC004 | Low |
| JOB004 | Data_Cleanup | Failed | INC002 | High |

**JOB005 disappeared** — it has no row in `servicenow_tickets`, so INNER JOIN drops it entirely.
**JOB001 appears twice** — it matched two tickets (INC001 and INC003). One job paired with two tickets = two output rows. This is called a **one-to-many relationship**.

</details>

---

### 04 · LEFT JOIN — most used

> 💬 *"Keep every row from the left table no matter what. For each one, attach ticket info if a match exists. Write NULL if no match exists."*

![LEFT JOIN](assets/venn-left.svg)

```sql
SELECT aj.job_id, aj.job_name, aj.status,
       sn.ticket_id, sn.priority
FROM autosys_jobs AS aj
LEFT JOIN servicenow_tickets AS sn
    ON aj.job_id = sn.job_id;
```

<details>
<summary>Result · 6 rows — and why JOB005 is now back</summary>
<br>

| job_id | job_name | status | ticket_id | priority |
|--------|----------|--------|-----------|----------|
| JOB001 | Daily_Sales_ETL | Failed | INC001 | High |
| JOB001 | Daily_Sales_ETL | Failed | INC003 | Medium |
| JOB002 | Weekly_Report | Success | INC005 | Low |
| JOB003 | Monthly_Backup | Running | INC004 | Low |
| JOB004 | Data_Cleanup | Failed | INC002 | High |
| JOB005 | User_Tracking | Success | NULL | NULL |

JOB005 is now in the result — but its ticket columns are NULL because no match existed. The left table (autosys_jobs) is guaranteed to appear in full. When in doubt, start with LEFT JOIN.

</details>

---

### 05 · RIGHT JOIN — rarely written

> 💬 *"Keep every row from the right table. Attach job info where it matches. NULL where it doesn't."*

![RIGHT JOIN](assets/venn-right.svg)

<details>
<summary>Why you will almost never write this</summary>
<br>

Every RIGHT JOIN rewrites as a LEFT JOIN by swapping table order. Most analysts always write LEFT JOIN and flip the tables. The only reason RIGHT JOIN exists is for symmetry — know it, do not reach for it.

</details>

---

### 06 · FULL OUTER JOIN

> 💬 *"Keep every row from both tables. NULL fills in wherever no match exists on either side."*

![FULL OUTER JOIN](assets/venn-full.svg)

```sql
SELECT aj.job_id, aj.job_name, aj.status,
       sn.ticket_id, sn.priority
FROM autosys_jobs AS aj
FULL OUTER JOIN servicenow_tickets AS sn
    ON aj.job_id = sn.job_id;
```

<details>
<summary>Result · 6 rows — when is this actually useful?</summary>
<br>

Same 6 rows as LEFT JOIN in our dataset because every ticket has a matching job. FULL OUTER becomes useful when you need to find gaps on *both* sides simultaneously — for example, jobs with no ticket AND tickets with no job in the same result.

</details>

---

### 07 · The NULL pattern — finding what's missing

> 💬 *"LEFT JOIN + `WHERE right_key IS NULL` finds left-side rows that have no partner on the right."*

A teacher has an attendance sheet and a homework submission pile. LEFT JOIN combines them into one view. `WHERE submission IS NULL` then points at exactly the students who did not hand anything in.

```sql
-- Which jobs ran with no ticket ever raised?
SELECT aj.job_id, aj.job_name, aj.status
FROM autosys_jobs AS aj
LEFT JOIN servicenow_tickets AS sn
    ON aj.job_id = sn.job_id
WHERE sn.job_id IS NULL;
```

The LEFT JOIN keeps JOB005 in the result with NULLs on the ticket side. The WHERE then says: *"from everything the LEFT JOIN gave me, show me only the rows where the ticket side is empty."* Returns only JOB005.

> ⚠️ Use `WHERE sn.job_id IS NULL` — check NULL on the JOIN key (the column you matched on), not on a data column like `sn.priority`. A data column could legitimately hold NULL for other reasons. The JOIN key is NULL only when there was no match.

---

<details>
<summary><strong>🧠 Lesson 02 — Self-check</strong></summary>
<br>

<details>
<summary>Q1 · You want every job including those with no ticket. Which JOIN?</summary>
<br>

LEFT JOIN with `autosys_jobs` as the FROM table. The left table appears fully. Jobs with no matching ticket get NULL in the ticket columns instead of being dropped.

</details>

<details>
<summary>Q2 · INNER JOIN returns 5 rows. LEFT JOIN returns 7. What do the extra 2 mean?</summary>
<br>

2 rows in the left table have no match in the right table. INNER JOIN silently dropped them. LEFT JOIN kept them with NULL in the right-side columns.

</details>

<details>
<summary>Q3 · Why does JOB001 appear twice in the JOIN result?</summary>
<br>

JOB001 matched two rows in `servicenow_tickets` (INC001 and INC003). A JOIN creates one output row per match found. One job × two tickets = two output rows. This is a one-to-many relationship.

</details>

</details>

---

<a id="lesson-03"></a>

## Lesson 03 — Subqueries & CASE

<div align="center">

![](https://img.shields.io/badge/Lesson-03_of_05-586074?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Skills-CASE_·_Subqueries_·_COALESCE-2455C3?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Status-🟡_In_Progress-E8A020?style=flat-square)

</div>

<br>

**What this lesson actually fixes and adds:**

**Fix 1 — The broken sort order you found in Lesson 01.**
When you sort `priority` alphabetically, SQL gives you `High → Low → Medium`. That is wrong. `CASE` lets you secretly swap each word for a number *before* sorting happens — High becomes 1, Medium becomes 2, Low becomes 3. SQL then sorts 1, 2, 3 instead of letters. The order is correct. That is all CASE does in this context: it replaces a word with a number so SQL can reason about order.

**Fix 2 — Queries that need two steps.**
Every query so far reads from a real table: `FROM tickets`, `FROM employees`. Sometimes a question requires two steps. Example: *"Show me employees who earn above the average salary."* You cannot answer that in one step — first you need to know what the average salary is, then filter against it. A **subquery** does step 1 inside step 2. It is a complete query sitting inside another query, wrapped in parentheses.

**The data** — `employees` and `performance_reviews` from the checkpoint, with one column added:

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

| review_id | emp_id | rating | follow_up |
|-----------|--------|--------|-----------|
| R001 | E001 | 4 | Low |
| R002 | E003 | 5 | Low |
| R003 | E001 | 3 | Normal |
| R004 | E002 | 4 | Low |
| R005 | E005 | 2 | Urgent |

> 👀 `follow_up` sorts alphabetically as `Low → Normal → Urgent` — completely wrong urgency order. `CASE` fixes this below.

---

### 01 · CASE — conditional logic

> 💬 *"Look at a value. If it matches this, return that. If it matches something else, return something else. Otherwise return a default."*

**Simple CASE** — swap exact values for other values:

```sql
-- Fix the broken sort order
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

Elena's review (R005, Urgent) appears first. The alphabetical trap is gone because SQL is sorting 1, 2, 3 — not letters.

</details>

**Searched CASE** — evaluate a condition in each branch instead of matching one value:

```sql
-- Assign a salary band label based on salary range
SELECT name, salary,
    CASE
        WHEN salary >= 90000 THEN 'Senior'
        WHEN salary >= 70000 THEN 'Mid'
        ELSE                      'Junior'
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

Sarah clears 90,000 so she gets Senior. James falls below 70,000 so he hits the ELSE default.

</details>

<details>
<summary>Simple vs searched CASE — when to use each</summary>
<br>

**Simple CASE:** `CASE column WHEN exact_value THEN result` — use when you are mapping a specific list of known values (like priority levels or status codes).

**Searched CASE:** `CASE WHEN condition THEN result` — use when you need ranges (salary bands), comparisons against another column, or any boolean expression. More flexible.

</details>

---

### 02 · Subqueries in WHERE

> 💬 *"Answer a small question inside a bigger question. The inner query runs first. Its result becomes the filter for the outer query."*

```sql
-- Employees earning above the company average salary
SELECT name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);
```

**What SQL does, step by step:**
1. Runs `SELECT AVG(salary) FROM employees` → gets 78,000 (the average)
2. Substitutes that number: `WHERE salary > 78000`
3. Filters `employees` and returns anyone above that threshold

You never need to know the average in advance. The subquery calculates it fresh every time the query runs.

<details>
<summary>What this returns</summary>
<br>

| name | salary |
|------|--------|
| Sarah | 95000 |
| Priya | 88000 |

Marcus (72,000), James (65,000), Elena (78,000), Tom (70,000) all fall at or below 78,000 average and are filtered out. Elena is exactly at the average — `>` is strict, not `>=`.

</details>

```sql
-- Employees who have received an 'Urgent' follow-up review
SELECT name, department
FROM employees
WHERE emp_id IN (
    SELECT emp_id
    FROM performance_reviews
    WHERE follow_up = 'Urgent'
);
```

The inner query returns a list: `['E005']`. The outer query then checks: is each employee's `emp_id` in that list?

<details>
<summary>IN (subquery) vs > (subquery) — when to use each</summary>
<br>

`> (subquery)` — the inner query must return **exactly one value** (a single number). Works with `AVG()`, `MAX()`, `MIN()`, `COUNT()`.

`IN (subquery)` — the inner query returns a **list of values**. The outer query checks whether each row's column appears anywhere in that list. Use `IN` when the inner query might return many rows.

</details>

---

### 03 · Subqueries in FROM

> 💬 *"Run a query. Then treat its result as if it were a real table. Run another query on top of that."*

This solves a specific problem: `WHERE` cannot filter on aggregated results. But a subquery in `FROM` can pre-aggregate first, and then an outer `WHERE` filters the result.

```sql
-- Departments where the average review rating is 4 or above
SELECT dept_summary.department,
       dept_summary.avg_rating
FROM (
    SELECT e.department,
           AVG(pr.rating) AS avg_rating
    FROM employees AS e
    INNER JOIN performance_reviews AS pr
        ON e.emp_id = pr.emp_id
    GROUP BY e.department
) AS dept_summary
WHERE dept_summary.avg_rating >= 4;
```

**What SQL does:**
1. Runs the inner query — produces a temporary table with one row per department showing its average rating. This temporary result is called a **derived table**.
2. Names it `dept_summary` (the alias after the closing parenthesis)
3. The outer query treats `dept_summary` exactly like a real table and filters it with `WHERE`

<details>
<summary>What this returns</summary>
<br>

The inner query produces:

| department | avg_rating |
|------------|-----------|
| Engineering | 4.5 |
| Marketing | 3.0 |

Then the outer `WHERE avg_rating >= 4` removes Marketing (3.0). Final result:

| department | avg_rating |
|------------|-----------|
| Engineering | 4.5 |

</details>

> 💡 This pattern — subquery in FROM — is the direct predecessor of **CTEs** (`WITH` clauses), which are the modern, cleaner version of the same idea. CTEs are covered in Lesson 05. Learn the subquery version first so CTEs make immediate sense when you see them.

---

### 04 · COALESCE — replacing NULLs in output

> 💬 *"Give me the first non-NULL value from this list. Use it to swap out NULLs for something readable."*

NULL values in output are ugly and confusing to non-technical readers. COALESCE lets you replace them with a meaningful default.

```sql
-- Show review status for all employees, including those never reviewed
SELECT e.name,
       COALESCE(CAST(pr.rating AS TEXT), 'No review yet') AS review_status
FROM employees AS e
LEFT JOIN performance_reviews AS pr
    ON e.emp_id = pr.emp_id;
```

`COALESCE(a, b)` returns `a` if `a` is not NULL. If `a` is NULL, it returns `b`. You can pass more than two values — it returns the first non-NULL one it finds.

<details>
<summary>What this returns</summary>
<br>

| name | review_status |
|------|--------------|
| Sarah | 4 |
| Marcus | 4 |
| Priya | 5 |
| James | No review yet |
| Elena | 2 |
| Tom | No review yet |

James and Tom have no matching row in `performance_reviews`. The LEFT JOIN gives them NULL. COALESCE swaps that NULL for the string `'No review yet'`.

Note: `CAST(pr.rating AS TEXT)` converts the integer rating to text so it matches the data type of the fallback string. You cannot COALESCE a number and a string without converting one first.

</details>

<details>
<summary>COALESCE vs IS NULL — they solve different problems</summary>
<br>

`IS NULL` belongs in `WHERE` — it **filters rows** based on whether a value is missing.
`COALESCE` belongs in `SELECT` — it **replaces NULL with a default** in the output you show.

They are not interchangeable. One removes rows. One transforms what you see.

</details>

---

<details>
<summary><strong>🧠 Lesson 03 — Self-check</strong></summary>
<br>

<details>
<summary>Q1 · What is the difference between simple and searched CASE?</summary>
<br>

Simple CASE: `CASE column WHEN value THEN result` — matches one column against a list of exact values. Use for category mapping.
Searched CASE: `CASE WHEN condition THEN result` — evaluates any boolean condition per row. Use for ranges or complex logic.

</details>

<details>
<summary>Q2 · Why can't you write WHERE AVG(rating) >= 4 directly?</summary>
<br>

`WHERE` runs before `GROUP BY` — so `AVG(rating)` has not been calculated yet when `WHERE` executes. Use `HAVING` to filter after aggregation, or a subquery in `FROM` to pre-aggregate and then filter in an outer `WHERE`.

</details>

<details>
<summary>Q3 · What is the difference between IN (subquery) and > (subquery)?</summary>
<br>

`> (subquery)` — inner query must return exactly one value. `IN (subquery)` — inner query returns a list; the outer query checks whether each row's column appears in that list.

</details>

<details>
<summary>Q4 · When do you use COALESCE vs IS NULL?</summary>
<br>

`IS NULL` in `WHERE` filters rows. `COALESCE` in `SELECT` replaces NULL with a default value in output. Different tools solving different problems.

</details>

</details>

---

<a id="lesson-04"></a>

## Lesson 04 — SQL Toolkit

<div align="center">

![](https://img.shields.io/badge/Lesson-04_of_05-586074?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Skills-LIKE_·_BETWEEN_·_DISTINCT_·_Dates_·_Strings_·_UNION-2455C3?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Status-⬜_Upcoming-9AA3B2?style=flat-square)

</div>

<br>

These are the concepts that appear in nearly every data analyst interview that Lessons 01–03 do not cover. None of them are complex. All of them are short. Together they fill the gaps between our curriculum and what interviewers at companies like Meta, Google, and Stripe actually test.

**The data** — continuing with `employees` and `performance_reviews` from Lesson 03.

---

### 01 · LIKE — pattern matching

> 💬 *"`LIKE` filters text values by pattern, not by exact match. Use it when you know part of the value but not all of it."*

Two wildcard characters:
- `%` — any number of characters (including zero)
- `_` — exactly one character

```sql
-- Names that start with the letter S
SELECT name FROM employees
WHERE name LIKE 'S%';
-- Returns: Sarah

-- Names that end in 'a'
SELECT name FROM employees
WHERE name LIKE '%a';
-- Returns: Sarah, Priya, Elena

-- Names that are exactly 3 characters long
SELECT name FROM employees
WHERE name LIKE '___';
-- Returns: Tom (3 underscores = 3 characters)

-- Names containing 'ar' anywhere
SELECT name FROM employees
WHERE name LIKE '%ar%';
-- Returns: Sarah, Marcus
```

<details>
<summary>Real-world use cases for LIKE</summary>
<br>

- Find all email addresses from a specific domain: `WHERE email LIKE '%@meridian.com'`
- Find job names that contain a keyword: `WHERE job_name LIKE '%ETL%'`
- Find ticket IDs that start with INC: `WHERE ticket_id LIKE 'INC%'`
- Find names with a specific pattern: `WHERE name LIKE 'J_mes'` (matches James, but not James with a different spelling)

Use `ILIKE` instead of `LIKE` in PostgreSQL and DuckDB when you want case-insensitive matching.

</details>

---

### 02 · BETWEEN — range filtering

> 💬 *"`BETWEEN` filters rows within a range of values. It is inclusive — both endpoints are included."*

```sql
-- Employees with salary between 70,000 and 90,000
SELECT name, salary FROM employees
WHERE salary BETWEEN 70000 AND 90000;
```

`BETWEEN 70000 AND 90000` is exactly the same as `>= 70000 AND <= 90000`. Both endpoints are included. Marcus (72,000), Elena (78,000), Tom (70,000), and Priya (88,000) all qualify. Sarah (95,000) and James (65,000) do not.

```sql
-- Reviews submitted in 2024
SELECT review_id, emp_id, rating FROM performance_reviews
WHERE review_year BETWEEN 2023 AND 2024;
```

<details>
<summary>BETWEEN vs >= AND <= — are they the same?</summary>
<br>

Yes — they are identical in behaviour. `BETWEEN` is just a cleaner way to write `>= lower AND <= upper`. Use `BETWEEN` when it makes the query easier to read. Use `>= AND <=` when you need different comparison operators on each end (like `> lower AND <= upper`).

</details>

---

### 03 · DISTINCT — removing duplicates

> 💬 *"`DISTINCT` removes duplicate rows from your result. Each unique value appears exactly once."*

```sql
-- Which departments exist? (without duplicates)
SELECT DISTINCT department FROM employees;
```

Without `DISTINCT`, this returns 6 rows (one per employee) with department values repeating. With `DISTINCT`, it returns each department name once.

<details>
<summary>What this returns</summary>
<br>

| department |
|------------|
| Engineering |
| Marketing |
| Sales |

Three rows instead of six. Each department name appears exactly once.

</details>

```sql
-- Which combinations of department and status exist?
SELECT DISTINCT department, status FROM employees;
```

When `DISTINCT` is applied to multiple columns, it removes rows where the entire combination of those columns is duplicated — not each column independently.

---

### 04 · IN — cleaner list filtering

> 💬 *"`IN` checks whether a value matches any item in a list. It replaces multiple OR conditions."*

```sql
-- Employees in Engineering or Marketing
SELECT name, department FROM employees
WHERE department IN ('Engineering', 'Marketing');
```

This is identical to:
```sql
WHERE department = 'Engineering' OR department = 'Marketing'
```

`IN` is cleaner when you have three or more values. Imagine filtering for six different departments — six `OR` conditions versus one `IN` with a list.

```sql
-- Active employees who are either in Sales or have a Junior salary band
SELECT name FROM employees
WHERE status = 'Active'
AND department IN ('Sales', 'Engineering');
```

> `IN` also works with subqueries: `WHERE emp_id IN (SELECT emp_id FROM ...)` — this was covered in Lesson 03.

---

### 05 · Arithmetic & math functions

> 💬 *"Do maths directly inside SQL — add, multiply, round, or take absolute values in a SELECT statement."*

```sql
-- Calculate monthly salary from annual salary
SELECT name, salary,
       ROUND(salary / 12.0, 2) AS monthly_salary
FROM employees;
```

`/12.0` (not `/12`) forces decimal division instead of integer division. `ROUND(value, 2)` rounds to 2 decimal places.

```sql
-- Useful math functions
SELECT
    ROUND(7916.666, 2),    -- 7916.67  (round to N decimal places)
    ABS(-42),              -- 42        (remove negative sign)
    CEILING(3.2),          -- 4         (round UP to nearest integer)
    FLOOR(3.9),            -- 3         (round DOWN to nearest integer)
    MOD(17, 5);            -- 2         (remainder after division: 17 ÷ 5 = 3 remainder 2)
```

<details>
<summary>When CEILING and FLOOR matter in analytics</summary>
<br>

**CEILING** is useful when you need to ensure you round up — for example, calculating how many pages of results to show (10 items, 3 per page = CEILING(10/3) = 4 pages).

**FLOOR** is useful when you want the conservative estimate — calculating completed full weeks from days (17 days → FLOOR(17/7) = 2 full weeks).

**MOD** (modulo) is useful for finding even/odd rows, grouping items into buckets of N, or identifying cyclical patterns.

</details>

---

### 06 · Date & time functions

> 💬 *"Dates are one of the most common data types in analytics. SQL has built-in functions to extract parts, calculate differences, and truncate dates to useful periods."*

Most real analytics questions involve time: *"How many tickets were raised this month? How long did this job take to recover? What is the week-over-week change in failures?"*

```sql
-- Get today's date and current timestamp
SELECT CURRENT_DATE;           -- 2024-06-15
SELECT CURRENT_TIMESTAMP;      -- 2024-06-15 14:32:00

-- Extract specific parts from a date
SELECT
    EXTRACT(YEAR  FROM CURRENT_DATE),   -- 2024
    EXTRACT(MONTH FROM CURRENT_DATE),   -- 6
    EXTRACT(DAY   FROM CURRENT_DATE);   -- 15

-- Calculate the number of days between two dates
SELECT DATEDIFF('day', '2024-01-01', '2024-06-15');  -- 165 days

-- Truncate a date to the start of a period
-- Useful for grouping by month or week
SELECT DATE_TRUNC('month', '2024-06-15');  -- 2024-06-01
SELECT DATE_TRUNC('week',  '2024-06-15');  -- 2024-06-10 (start of that week)
```

```sql
-- Practical example: count reviews per year
SELECT
    EXTRACT(YEAR FROM CAST(review_year AS VARCHAR || '-01-01')) AS year,
    COUNT(*) AS review_count
FROM performance_reviews
GROUP BY year
ORDER BY year;
```

<details>
<summary>Why DATE_TRUNC is essential for analytics</summary>
<br>

`DATE_TRUNC('month', date)` converts any date to the first day of its month: `2024-06-15` → `2024-06-01`, `2024-06-28` → `2024-06-01`. Every date in June becomes the same value.

This means `GROUP BY DATE_TRUNC('month', created_date)` groups all events from the same calendar month into one bucket — regardless of which day they happened. This is how you produce monthly trend reports.

Without `DATE_TRUNC`, grouping by a full date gives you one row per day, which is rarely what a monthly report needs.

</details>

---

### 07 · String functions

> 💬 *"Clean, reshape, and extract parts of text values stored in your columns."*

```sql
-- Change case
SELECT UPPER('hello world');           -- HELLO WORLD
SELECT LOWER('ENGINEERING');           -- engineering

-- Count characters
SELECT LENGTH('Sarah');                -- 5

-- Remove leading and trailing spaces (common data quality fix)
SELECT TRIM('  Sarah  ');              -- 'Sarah'

-- Extract a substring (start position, length)
SELECT SUBSTR('Engineering', 1, 3);   -- 'Eng'

-- Replace text
SELECT REPLACE('Data_Cleanup', '_', ' ');  -- 'Data Cleanup'

-- Combine strings (concatenation)
SELECT name || ' — ' || department AS label
FROM employees;
-- Returns: 'Sarah — Engineering', 'Marcus — Marketing', etc.
```

```sql
-- Practical example: clean and standardise department names
SELECT
    TRIM(LOWER(department)) AS clean_department,
    COUNT(*) AS headcount
FROM employees
GROUP BY clean_department;
```

<details>
<summary>Real data is messy — string functions are how you clean it</summary>
<br>

Real databases routinely contain: extra spaces from copy-paste (`' Engineering '`), inconsistent casing (`'engineering'` vs `'ENGINEERING'`), concatenated values that need splitting (`'Sarah_Jones'`), and codes that need reformatting.

String functions are the first line of defence in data cleaning. You will use `TRIM`, `LOWER`, `REPLACE`, and `SUBSTR` constantly.

</details>

---

### 08 · UNION, INTERSECT, EXCEPT

> 💬 *"Combine or compare the results of two separate queries vertically — stack them, overlap them, or subtract one from the other."*

These operators combine query results row by row, unlike JOINs which combine columns. Both queries must return the same number of columns with compatible data types.

```sql
-- UNION: combine both results, remove duplicates
SELECT name FROM employees WHERE department = 'Engineering'
UNION
SELECT name FROM employees WHERE salary > 80000;
-- Returns: Sarah, Priya (deduped — Sarah appears in both but shows once)
```

```sql
-- UNION ALL: combine both results, KEEP duplicates (faster than UNION)
SELECT name FROM employees WHERE department = 'Engineering'
UNION ALL
SELECT name FROM employees WHERE salary > 80000;
-- Returns: Sarah, Priya, Sarah, Priya (Sarah and Priya appear twice)
```

```sql
-- INTERSECT: only rows that appear in BOTH queries
SELECT name FROM employees WHERE department = 'Engineering'
INTERSECT
SELECT name FROM employees WHERE salary > 80000;
-- Returns: Sarah, Priya (both are in Engineering AND earn above 80k)
```

```sql
-- EXCEPT: rows in the first query that do NOT appear in the second
SELECT name FROM employees WHERE department = 'Engineering'
EXCEPT
SELECT name FROM employees WHERE salary > 80000;
-- Returns: nothing — both Engineering employees earn above 80k
```

<details>
<summary>UNION vs JOIN — they combine data in completely different ways</summary>
<br>

**JOIN** adds columns — takes two tables and combines them side by side. The result has more columns.

**UNION** stacks rows — takes two query results and stacks them on top of each other. The result has more rows but the same number of columns.

Use JOIN to combine related data from different tables.
Use UNION to combine similar data from the same or different sources into one list.

</details>

---

<details>
<summary><strong>🧠 Lesson 04 — Self-check</strong></summary>
<br>

<details>
<summary>Q1 · What does % mean in a LIKE pattern? What does _ mean?</summary>
<br>

`%` matches any number of characters (including zero). `_` matches exactly one character. `'S%'` matches any string starting with S. `'S_rah'` matches Sarah, Surah, Syrah, etc.

</details>

<details>
<summary>Q2 · Is BETWEEN 70000 AND 90000 inclusive or exclusive?</summary>
<br>

Inclusive on both ends. `BETWEEN 70000 AND 90000` is exactly `>= 70000 AND <= 90000`. Both 70,000 and 90,000 qualify.

</details>

<details>
<summary>Q3 · What is the difference between UNION and UNION ALL?</summary>
<br>

`UNION` removes duplicate rows from the combined result. `UNION ALL` keeps all rows including duplicates. `UNION ALL` is faster because it skips the deduplication step — use it when you know duplicates will not appear or when duplicates are intentional.

</details>

<details>
<summary>Q4 · Why use DATE_TRUNC instead of just grouping by a raw date column?</summary>
<br>

A raw date like `2024-06-15` is unique per day. Grouping by it gives one row per day. `DATE_TRUNC('month', date)` converts every date in June to `2024-06-01`, so all June rows group together. This is how you produce monthly summaries from daily data.

</details>

<details>
<summary>Q5 · What does UNION do that JOIN cannot?</summary>
<br>

UNION stacks rows from two queries on top of each other — the result has more rows, same columns. JOIN combines columns from two tables side by side — the result has more columns. Use UNION to merge similar lists. Use JOIN to combine related tables.

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
| 5 | `SELECT` | Choose columns, calculate expressions |
| 6 | `ORDER BY` | Sort the final result |
| 7 | `LIMIT` | Cap the number of rows returned |

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
-- Simple CASE (exact value matching)
CASE column
    WHEN 'value1' THEN result1
    WHEN 'value2' THEN result2
    ELSE           default_result
END

-- Searched CASE (condition matching)
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
-- In WHERE: single value comparison
WHERE salary > (SELECT AVG(salary) FROM employees)

-- In WHERE: list membership check
WHERE emp_id IN (SELECT emp_id FROM table WHERE condition)

-- In FROM: derived table (pre-aggregate, then filter)
SELECT *
FROM (
    SELECT department, AVG(salary) AS avg_sal
    FROM employees
    GROUP BY department
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
| `LIKE '%ETL%'` | Contains ETL anywhere | `WHERE job_name LIKE '%ETL%'` |
| `LIKE '___'` | Exactly 3 characters | `WHERE code LIKE '___'` |
| `BETWEEN a AND b` | Inclusive range | `WHERE salary BETWEEN 70000 AND 90000` |
| `IN (list)` | Matches any in list | `WHERE dept IN ('Eng', 'Marketing')` |
| `DISTINCT` | Remove duplicates | `SELECT DISTINCT department` |

</details>

<details>
<summary><strong>Common traps</strong></summary>
<br>

| Trap | What happens | Fix |
|------|-------------|-----|
| `WHERE x = NULL` | Returns zero rows | Use `IS NULL` |
| Alphabetical sort on priority | `High → Low → Medium` — wrong order | Use `CASE` to assign numbers |
| JOIN returns more rows than expected | One-to-many relationship | Check for duplicate keys in the join column |
| `COUNT(*)` counts NULL rows | Inflated counts | Use `COUNT(column)` to exclude NULLs |
| `WHERE AVG(x) > n` throws error | WHERE runs before aggregation | Use `HAVING` or a subquery in `FROM` |
| NULL in SELECT output | Shows as `NULL` or `None` | Use `COALESCE(column, 'default')` |
| `BETWEEN` missed edge values | Forgot it is inclusive | Both endpoints qualify — `>= AND <=` |
| UNION slow on large datasets | Deduplication is expensive | Use `UNION ALL` if duplicates are acceptable |

</details>

---

<div align="center">

*analytics-engineer-journey &nbsp;·&nbsp; module-01-sql*
&nbsp;&nbsp;
[github.com/nabiya15](https://github.com/nabiya15)

</div>
