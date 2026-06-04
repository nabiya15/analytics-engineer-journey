<div align="center">

![](https://img.shields.io/badge/Analytics_Engineer_Journey-Module_01-2455C3?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Topic-SQL_Fundamentals-586074?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Lessons_Complete-2_of_4-0C7550?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Status-In_Progress-E8A020?style=flat-square)

# Module 01 — SQL Fundamentals

_The language every data system speaks. Ask questions, filter answers, summarise data, connect tables._

</div>

---

## Contents

- [Module overview](#overview)
- [Lesson 01 — SQL Basics](#lesson-01)
- [Lesson 02 — JOINs](#lesson-02)
- [Quick reference](#quick-reference)

---

<a id="overview"></a>

## Module overview

| #   | Lesson                  | Skills                               | Status      |
| --- | ----------------------- | ------------------------------------ | ----------- |
| 01  | SQL Basics              | SELECT · WHERE · GROUP BY · ORDER BY | ✅ Complete |
| 02  | JOINs                   | INNER · LEFT · RIGHT · FULL OUTER    | ✅ Complete |
| 03  | Subqueries & CASE       | Nested queries · conditional logic   | ⬜ Upcoming |
| 04  | Window functions & CTEs | ROW_NUMBER · LAG · LEAD · WITH       | ⬜ Upcoming |

**Files in this module**

| File                                                                             | Purpose                                |
| -------------------------------------------------------------------------------- | -------------------------------------- |
| [`lessons/lesson-01-basics.sql`](lessons/lesson-01-basics.sql)                   | All queries from Lesson 01 — commented |
| [`lessons/lesson-02-joins.sql`](lessons/lesson-02-joins.sql)                     | All queries from Lesson 02 — commented |
| [`practice/lesson-02-joins-practice.sql`](practice/lesson-02-joins-practice.sql) | JOIN practice — no hints, Copilot off  |

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

| ticket_id | type     | priority | status | assigned_to | resolution_hours |
| --------- | -------- | -------- | ------ | ----------- | ---------------- |
| INC001    | Incident | High     | Open   | Nabiya      | `NULL`           |
| INC002    | Incident | Low      | Closed | Dev Team    | 4                |
| REQ001    | Request  | Medium   | Open   | Nabiya      | `NULL`           |
| INC003    | Incident | High     | Closed | Dev Team    | 12               |
| REQ002    | Request  | Low      | Open   | Nabiya      | `NULL`           |
| INC004    | Incident | Medium   | Open   | Dev Team    | `NULL`           |
| REQ003    | Request  | High     | Closed | Nabiya      | 6                |

> `NULL` in `resolution_hours` = ticket still open, no resolution time recorded yet. `NULL` is not zero — it is the complete absence of a value.

---

### 01 · What is a database?

> 💬 _A structured way to store information so you can ask questions about it later._

A **table** is like a spreadsheet tab. A **row** is one record. A **column** is one fact about that record. SQL is the language you use to ask questions about the table.

---

### 02 · SELECT & FROM

> 💬 _"Show me these columns from this table."_

```sql
SELECT *                                  -- all columns
FROM tickets;

SELECT ticket_id, priority, status        -- specific columns only
FROM tickets;
```

<details>
<summary>Why column names have no quotes but values do</summary>
<br>

`status` is a **column name** — part of the table's structure. `'Open'` is a **value** — actual data inside a cell. SQL needs quotes around values to distinguish them from column references. This distinction appears in every query you will ever write.

</details>

---

### 03 · WHERE

> 💬 _"Only show me rows where this condition is true."_

```sql
SELECT * FROM tickets
WHERE status = 'Open';

SELECT * FROM tickets
WHERE assigned_to = 'Nabiya';
```

<details>
<summary>Combining conditions — AND · OR · !=</summary>
<br>

`AND` = both conditions must be true. `OR` = at least one. `!=` = not equal.

```sql
SELECT * FROM tickets
WHERE priority = 'High' AND status = 'Open';

SELECT * FROM tickets
WHERE assigned_to = 'Nabiya' OR assigned_to = 'Dev Team';

SELECT * FROM tickets
WHERE status != 'Closed';
```

> ⚠️ `WHERE status != 'Closed'` and `WHERE status = 'Open'` return the same rows here because only two values exist. Add `'Pending'` and they diverge. Always check what values are actually in a column.

</details>

---

### 04 · GROUP BY & aggregations

> 💬 _"Instead of showing individual rows, calculate something about them."_

```sql
SELECT status, COUNT(*)            -- how many tickets per status?
FROM tickets
GROUP BY status;

SELECT priority, AVG(resolution_hours)  -- average resolution per priority?
FROM tickets
WHERE status = 'Closed'
GROUP BY priority;
```

<details>
<summary>COUNT(*) vs COUNT(column) — and why it matters</summary>
<br>

`COUNT(*)` counts all rows including those with `NULL`. `COUNT(resolution_hours)` counts only rows where a value exists. When NULLs should count as zero, use `COUNT(column)`.

**Execution order:** `WHERE` filters rows first, then `GROUP BY` buckets the survivors. This means `WHERE` cannot filter on a grouped result — that needs `HAVING`.

</details>

---

### 05 · HAVING

> 💬 _"`WHERE` filters rows before grouping. `HAVING` filters groups after."_

```sql
SELECT priority, AVG(resolution_hours)
FROM tickets
WHERE status = 'Closed'
GROUP BY priority
HAVING AVG(resolution_hours) > 5;
```

<details>
<summary>The pipeline: WHERE → GROUP BY → HAVING</summary>
<br>

Think of it as a conveyor belt. `WHERE` removes the rows you do not want. `GROUP BY` buckets the remaining rows. `HAVING` removes the buckets that do not meet your condition. Each step only sees what the previous step passed through.

</details>

---

### 06 · ORDER BY & LIMIT

> 💬 _"`ORDER BY` sorts results. `LIMIT` caps how many rows come back."_

```sql
SELECT ticket_id, priority, resolution_hours
FROM tickets
WHERE status = 'Closed'
ORDER BY resolution_hours ASC
LIMIT 2;
```

<details>
<summary>The text-sort trap — why alphabetical priority is dangerous</summary>
<br>

`ORDER BY priority ASC` gives `High → Low → Medium` — alphabetical, not urgency order. Add `'Critical'` and it silently sorts before `'High'` because `C` comes before `H`. Your query returns the wrong row with no error.

Fix: use `CASE` to assign numbers before sorting. Covered in Lesson 03.

```sql
-- Wrong: alphabetical
ORDER BY priority ASC;

-- Right: meaningful order (Lesson 03)
ORDER BY CASE priority
    WHEN 'Critical' THEN 1
    WHEN 'High'     THEN 2
    WHEN 'Medium'   THEN 3
    WHEN 'Low'      THEN 4
END;
```

</details>

---

### 07 · NULL

> 💬 _"`NULL` is not zero. It is not empty. It is the absence of any value."_

```sql
SELECT * FROM tickets
WHERE resolution_hours IS NULL;    -- open tickets with no resolution time
```

<details>
<summary>Why = NULL never works, and how NULL behaves in COUNT and ORDER BY</summary>
<br>

`WHERE resolution_hours = NULL` always returns zero rows. `NULL` has no value — nothing can be equal to the absence of a value, not even another `NULL`. Always use `IS NULL` or `IS NOT NULL`.

**In ORDER BY:** `NULL` values have no numeric position. They float to unpredictable positions depending on the database. Never assume where they land.

**In COUNT:** `COUNT(*)` includes rows with `NULL`. `COUNT(resolution_hours)` ignores them. Use whichever matches your intent.

</details>

---

<details>
<summary><strong>🧠 Lesson 01 — Self-check</strong></summary>
<br>

<details>
<summary>Q1 · What is the difference between WHERE and HAVING?</summary>
<br>

`WHERE` filters individual rows before grouping. `HAVING` filters groups after `GROUP BY` has run. You cannot use `WHERE` to filter on `COUNT(*)` or `AVG()`.

</details>

<details>
<summary>Q2 · Why does <code>WHERE resolution_hours = NULL</code> return nothing?</summary>
<br>

`NULL` means no value exists. Nothing can be equal to the absence of a value. Use `IS NULL` instead.

</details>

<details>
<summary>Q3 · Count how many tickets each person is assigned — write it in words.</summary>
<br>

`SELECT assigned_to, COUNT(*) FROM tickets GROUP BY assigned_to` — group by person, count the rows in each group.

</details>

<details>
<summary>Q4 · What breaks when you sort text-based priority alphabetically?</summary>
<br>

`High → Low → Medium` is not urgency order. Adding `'Critical'` makes it worse — `C` before `H` means Critical sorts lower than it should. Text categories representing order must use `CASE` to get numeric values before sorting.

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

**The scenario** — At Meridian Systems, `autosys_jobs` ⏰ tracks automated task runs. `servicenow_tickets` 🎫 tracks reported problems. Both tables share `job_id` — that column is the bridge.

> 🔑 Think of `job_id` like a student ID. If both the attendance sheet and the report card use the same ID, a teacher can look up any student across both — even though the sheets were made separately.

**`autosys_jobs`**

| job_id   | job_name        | status     |
| -------- | --------------- | ---------- |
| `JOB001` | Daily_Sales_ETL | ❌ Failed  |
| `JOB002` | Weekly_Report   | ✅ Success |
| `JOB003` | Monthly_Backup  | ⏳ Running |
| `JOB004` | Data_Cleanup    | ❌ Failed  |
| `JOB005` | User_Tracking   | ✅ Success |

**`servicenow_tickets`**

| ticket_id | job_id   | priority  | assigned_to |
| --------- | -------- | --------- | ----------- |
| INC001    | `JOB001` | 🔴 High   | Nabiya      |
| INC002    | `JOB004` | 🔴 High   | Nabiya      |
| INC003    | `JOB001` | 🟡 Medium | Dev Team    |
| INC004    | `JOB003` | 🟢 Low    | Nabiya      |
| INC005    | `JOB002` | 🟢 Low    | Dev Team    |

> 👀 **Notice before you write a single JOIN:** JOB001 appears twice in tickets (INC001 + INC003). JOB005 has no ticket. These two facts explain every result below.

---

### 01 · Why JOINs exist

> 💬 _"A JOIN temporarily combines two tables into one result using a shared column."_

<details>
<summary>The long version — and the key concept</summary>
<br>

Imagine both tables as physical notebooks. To answer _"which tickets belong to which failed job?"_ you'd flip between notebooks and match job IDs by hand. A JOIN does that automatically.

**Primary key:** The unique ID that belongs to a table. `job_id` in `autosys_jobs` — every job has exactly one, none share it.

**Foreign key:** That same ID appearing in a second table as a reference. `job_id` in `servicenow_tickets` points back to `autosys_jobs`. It is the bridge.

**The ON condition:** `ON aj.job_id = sn.job_id` — find rows where these values match and merge them into one output row.

The four JOIN types differ in only one thing: **what happens when a match doesn't exist on one side?**

</details>

---

### 02 · INNER JOIN

> 💬 _"Only show me rows that exist in **both** tables."_

![INNER JOIN](assets/venn-inner.svg)

```sql
SELECT aj.job_id, aj.job_name, aj.status,
       sn.ticket_id, sn.priority
FROM autosys_jobs AS aj
INNER JOIN servicenow_tickets AS sn
    ON aj.job_id = sn.job_id;
```

<details>
<summary>Result from our data · 5 rows</summary>
<br>

- **JOB005 disappears** — no matching ticket, INNER JOIN drops it entirely
- **JOB001 appears twice** — matched two tickets (INC001 and INC003)
- This is a **one-to-many relationship**: one job, many tickets, many output rows

</details>

---

### 03 · LEFT JOIN — most used

> 💬 _"Show me every row from the left table. Fill in ticket info where it exists. `NULL` where it doesn't."_

![LEFT JOIN](assets/venn-left.svg)

```sql
SELECT aj.job_id, aj.job_name, aj.status,
       sn.ticket_id, sn.priority
FROM autosys_jobs AS aj
LEFT JOIN servicenow_tickets AS sn
    ON aj.job_id = sn.job_id;
```

<details>
<summary>Result from our data · 6 rows</summary>
<br>

- **JOB005 stays** — appears with `NULL` in the ticket columns
- **JOB001 still appears twice** — one-to-many still applies
- When in doubt, start with LEFT JOIN. It is the most commonly written JOIN in real analytics work.

</details>

---

### 04 · RIGHT JOIN — rarely written

> 💬 _"Show me every row from the right table. Fill in job info where it exists. `NULL` where it doesn't."_

![RIGHT JOIN](assets/venn-right.svg)

<details>
<summary>Why you will almost never write this</summary>
<br>

Every RIGHT JOIN can be rewritten as a LEFT JOIN by swapping which table comes first. Most analysts always write LEFT JOIN and flip the table positions instead. Know it exists — but use LEFT JOIN in practice.

</details>

---

### 05 · FULL OUTER JOIN

> 💬 _"Show me absolutely everything from both tables. `NULL` wherever there is no match on either side."_

![FULL OUTER JOIN](assets/venn-full.svg)

```sql
SELECT aj.job_id, aj.job_name, aj.status,
       sn.ticket_id, sn.priority
FROM autosys_jobs AS aj
FULL OUTER JOIN servicenow_tickets AS sn
    ON aj.job_id = sn.job_id;
```

<details>
<summary>Result from our data · 6 rows</summary>
<br>

- **JOB005** appears with `NULL` on the ticket side
- All 5 tickets appear — each has a matching job so no NULLs on the left
- **JOB001** still appears twice
- Use this when you need to audit both sides for gaps simultaneously

</details>

---

### 06 · The NULL pattern — finding what's missing

> 💬 _"LEFT JOIN + `WHERE right_key IS NULL` = find left rows with no match on the right."_

```sql
SELECT aj.job_id, aj.job_name, aj.status
FROM autosys_jobs AS aj
LEFT JOIN servicenow_tickets AS sn
    ON aj.job_id = sn.job_id
WHERE sn.ticket_id IS NULL;
```

<details>
<summary>How it works + real-world uses</summary>
<br>

The LEFT JOIN keeps JOB005 in the result with `NULL`s on the ticket side. The `WHERE sn.ticket_id IS NULL` then isolates only those unmatched rows.

**You will use this constantly:**

- Customers who never placed an order
- Employees with no performance review on file
- Failed jobs with no incident ticket raised
- Students who didn't submit their homework

The pattern is always the same — LEFT JOIN, then `WHERE right_key IS NULL`.

</details>

---

<details>
<summary><strong>🧠 Lesson 02 — Self-check</strong></summary>
<br>

<details>
<summary>Q1 · You want every job including those with no ticket. Which JOIN?</summary>
<br>

**LEFT JOIN.** The left table appears fully. Jobs with no matching ticket show `NULL` in the ticket columns instead of being dropped.

</details>

<details>
<summary>Q2 · INNER JOIN returns 5 rows. LEFT JOIN returns 7. What do the extra 2 mean?</summary>
<br>

There are 2 rows in the left table with no match in the right. INNER JOIN dropped them. LEFT JOIN kept them with `NULL`s on the right side.

</details>

<details>
<summary>Q3 · Why does JOB001 appear twice even though it only exists once in autosys_jobs?</summary>
<br>

JOB001 matched two rows in `servicenow_tickets` — INC001 and INC003. A JOIN creates one output row per match. One job × two tickets = two output rows. This is a one-to-many relationship.

</details>

<details>
<summary>Q4 · Describe the pattern for finding jobs with no ticket ever raised.</summary>
<br>

`LEFT JOIN servicenow_tickets ON job_id`, then `WHERE sn.ticket_id IS NULL`. LEFT JOIN keeps all jobs. `IS NULL` isolates only the unmatched ones.

</details>

<details>
<summary>Q5 · You have a RIGHT JOIN. How do you rewrite it as a LEFT JOIN?</summary>
<br>

Swap the table positions — move the right table into `FROM`, the left table into `JOIN`, change `RIGHT` to `LEFT`. The result is identical.

</details>

</details>

---

<a id="quick-reference"></a>

## Quick reference

### Core clause order

| Order | Clause     | Does what                       |
| ----- | ---------- | ------------------------------- |
| 1     | `FROM`     | Specify the table               |
| 2     | `WHERE`    | Filter rows before grouping     |
| 3     | `GROUP BY` | Bucket rows into groups         |
| 4     | `HAVING`   | Filter groups after grouping    |
| 5     | `SELECT`   | Choose which columns to show    |
| 6     | `ORDER BY` | Sort the final result           |
| 7     | `LIMIT`    | Cap the number of rows returned |

### JOIN types

|     | Type              | Returns                           | NULLs on    |
| --- | ----------------- | --------------------------------- | ----------- |
| 🔵  | `INNER JOIN`      | Only rows matching in both tables | Neither     |
| 🟢  | `LEFT JOIN`       | All left + matching right         | Right side  |
| 🟡  | `RIGHT JOIN`      | All right + matching left         | Left side   |
| 🟣  | `FULL OUTER JOIN` | Everything from both tables       | Either side |

### Common traps

| Trap                                    | Fix                                  |
| --------------------------------------- | ------------------------------------ |
| `WHERE x = NULL` returns nothing        | Use `IS NULL`                        |
| Alphabetical sort breaks priority order | Use `CASE` to assign numeric values  |
| JOIN returns more rows than expected    | Check for one-to-many relationships  |
| `COUNT(*)` counts NULL rows             | Use `COUNT(column)` to exclude NULLs |

---

<div align="center">

_analytics-engineer-journey &nbsp;·&nbsp; module-01-sql_
&nbsp;&nbsp;
[github.com/nabiya15](https://github.com/nabiya15)

</div>
