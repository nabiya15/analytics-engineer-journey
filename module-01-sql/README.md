<div align="center">

![](https://img.shields.io/badge/Analytics_Engineer_Journey-Module_01-2455C3?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Topic-SQL_Fundamentals-586074?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Lessons-2_of_4_complete-0C7550?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Status-In_Progress-E8A020?style=flat-square)

# Module 01 — SQL Fundamentals

**The language every data system speaks. Learn to ask questions, filter answers, summarise data, and connect tables.**

| File | What it is |
|------|-----------|
| [`lesson-01-basics.sql`](lesson-01-basics.sql) | All queries from Lesson 01 — fully commented |
| [`lesson-02-joins.sql`](lesson-02-joins.sql) | All queries from Lesson 02 — fully commented |
| [`practice-les-02-joins.sql`](practice-les-02-joins.sql) | Cold practice exercises for JOINs |

</div>

---

## Lessons in this module

| # | Topic | Status |
|---|-------|--------|
| 01 | SELECT, WHERE, aggregations, ORDER BY | ✅ Done |
| 02 | JOINs — INNER, LEFT, RIGHT, FULL OUTER | ✅ Done |
| 03 | Subqueries and CASE statements | ⬜ Upcoming |
| 04 | Window functions and CTEs | ⬜ Upcoming |

---

<br>

# Lesson 01 — SQL Basics

<div align="center">

![](https://img.shields.io/badge/Lesson-01_of_04-586074?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Skill-SELECT_·_WHERE_·_GROUP_BY-2455C3?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Status-✓_Complete-0C7550?style=flat-square)

*How to ask questions about data using SQL — filtering, summarising, and sorting rows.*

</div>

<br>

### The data we use in Lesson 01

A single table: a support ticket system. One row = one ticket.

| ticket_id | type | priority | status | assigned_to | resolution_hours |
|-----------|------|----------|--------|-------------|-----------------|
| INC001 | Incident | High | Open | Nabiya | `NULL` |
| INC002 | Incident | Low | Closed | Dev Team | 4 |
| REQ001 | Request | Medium | Open | Nabiya | `NULL` |
| INC003 | Incident | High | Closed | Dev Team | 12 |
| REQ002 | Request | Low | Open | Nabiya | `NULL` |
| INC004 | Incident | Medium | Open | Dev Team | `NULL` |
| REQ003 | Request | High | Closed | Nabiya | 6 |

> 💡 `NULL` in `resolution_hours` means the ticket is still open — it has no resolution time *yet*. `NULL` is not zero. It means **no value exists**.

---

<details>
<summary><strong>01 &nbsp;·&nbsp; What is a database?</strong></summary>
<br>

Forget the technical definition. You already understand this from real life.

Think of a database like a filing cabinet. Each drawer is a **table**. Each sheet of paper inside a drawer is a **row** — one record about one thing. Each column printed on that sheet is an **attribute** — one fact about that thing.

The table above is a database table. Every row is one ticket. Every column is one fact about that ticket — its ID, its type, its status.

**SQL is the language you use to ask questions about what's inside the filing cabinet.**

You don't open every drawer yourself. You write a question in SQL and the database finds the answer.

<br>

- [ ] &nbsp;Got it

</details>

---

<details>
<summary><strong>02 &nbsp;·&nbsp; SELECT and FROM — choosing what to show</strong></summary>
<br>

> 💬 **Plain English:** "Show me *these columns* from *this table*."

Every SQL query starts with two things: **what columns** you want, and **which table** they live in.

```sql
-- Show everything in the table
SELECT *
FROM tickets;

-- Show only specific columns
SELECT ticket_id, priority, status
FROM tickets;
```

`SELECT *` means *"give me all columns."* Use it when exploring. In real work, always name the specific columns you need — pulling unnecessary data is wasteful at scale.

<br>

- [ ] &nbsp;Got it

</details>

---

<details>
<summary><strong>03 &nbsp;·&nbsp; WHERE — filtering rows</strong></summary>
<br>

> 💬 **Plain English:** "Only show me rows where *this condition* is true."

Without `WHERE`, you get every row. With `WHERE`, you narrow down to exactly the rows you care about.

```sql
-- Only open tickets
SELECT *
FROM tickets
WHERE status = 'Open';

-- Only tickets assigned to Nabiya
SELECT *
FROM tickets
WHERE assigned_to = 'Nabiya';
```

**Why does `'Open'` have quotes but `status` does not?**

`status` is the **column name** — part of the table's structure. `'Open'` is a **value** — actual data sitting inside a cell. SQL needs quotes around values so it knows you're searching for that exact text, not looking for another column named `Open`. This distinction — structure vs value — comes up in every query you'll ever write.

<br>

- [ ] &nbsp;Got it

</details>

---

<details>
<summary><strong>04 &nbsp;·&nbsp; AND, OR, != — combining conditions</strong></summary>
<br>

> 💬 **Plain English:** `AND` = both must be true. `OR` = at least one must be true. `!=` = not equal to.

```sql
-- High priority tickets that are still open
SELECT *
FROM tickets
WHERE priority = 'High'
AND status = 'Open';

-- Tickets assigned to either Nabiya or Dev Team
SELECT *
FROM tickets
WHERE assigned_to = 'Nabiya'
OR assigned_to = 'Dev Team';

-- Everything except closed tickets
SELECT *
FROM tickets
WHERE status != 'Closed';
```

> ⚠️ `WHERE status != 'Closed'` and `WHERE status = 'Open'` return the same rows here — because status only has two possible values. But if a third status like `'Pending'` existed, they would behave differently. Always check what values are actually in the column before assuming equivalence.

<br>

- [ ] &nbsp;Got it

</details>

---

<details>
<summary><strong>05 &nbsp;·&nbsp; COUNT, AVG, GROUP BY — summarising data</strong></summary>
<br>

> 💬 **Plain English:** Instead of showing individual rows, calculate *something about* the rows — how many, what average, what total.

So far you have been **retrieving** rows. Now you start **summarising** them. This is where SQL starts to feel like actual analysis.

```sql
-- How many tickets exist in total?
SELECT COUNT(*)
FROM tickets;

-- How many tickets per status?
SELECT status, COUNT(*)
FROM tickets
GROUP BY status;

-- How many open tickets per priority?
SELECT priority, COUNT(*)
FROM tickets
WHERE status = 'Open'
GROUP BY priority;

-- Average resolution time for closed tickets
SELECT AVG(resolution_hours)
FROM tickets
WHERE status = 'Closed';
```

**The execution order matters:**

`WHERE` runs first — it filters the rows. `GROUP BY` runs second — it buckets the surviving rows into groups. This means `WHERE` cannot filter on a grouped result. For that, you need `HAVING` (next section).

<br>

- [ ] &nbsp;Got it

</details>

---

<details>
<summary><strong>06 &nbsp;·&nbsp; HAVING — filtering after grouping</strong></summary>
<br>

> 💬 **Plain English:** "`WHERE` filters rows before grouping. `HAVING` filters groups after grouping."

`WHERE` runs too early to know what a group's total or average is. `HAVING` runs after `GROUP BY` — so it can filter on aggregated values.

```sql
-- Only priority groups where average resolution time is over 5 hours
SELECT priority, AVG(resolution_hours)
FROM tickets
WHERE status = 'Closed'
GROUP BY priority
HAVING AVG(resolution_hours) > 5;
```

**Execution order:** `WHERE` → `GROUP BY` → `HAVING`

Think of it as a pipeline: filter the rows, then group them, then filter the groups.

<br>

- [ ] &nbsp;Got it

</details>

---

<details>
<summary><strong>07 &nbsp;·&nbsp; ORDER BY and LIMIT — sorting and capping results</strong></summary>
<br>

> 💬 **Plain English:** `ORDER BY` sorts your results. `LIMIT` caps how many rows come back.

```sql
-- All tickets sorted by resolution time, longest first
SELECT ticket_id, priority, resolution_hours
FROM tickets
ORDER BY resolution_hours DESC;

-- Top 2 fastest resolved closed tickets
SELECT ticket_id, priority, resolution_hours
FROM tickets
WHERE status = 'Closed'
ORDER BY resolution_hours ASC
LIMIT 2;
```

`ASC` = smallest to largest (default). `DESC` = largest to smallest.

> ⚠️ **The text-sort trap:** What if you sort by `priority` alphabetically? `ORDER BY priority ASC` gives you: **High → Low → Medium** (alphabetical). That is not a meaningful priority order. If you later add a `'Critical'` level, `C` sorts before `H` — and your "highest priority" query breaks silently with no error. The fix is a `CASE` statement that assigns numbers to priority levels before sorting. We cover this in Lesson 03.

<br>

- [ ] &nbsp;Got it

</details>

---

<details>
<summary><strong>08 &nbsp;·&nbsp; NULL — the missing value</strong></summary>
<br>

> 💬 **Plain English:** `NULL` means "this value does not exist." It is not zero. It is not an empty string. It is the absence of any value.

```sql
-- Find tickets with no resolution time recorded
SELECT ticket_id, status, resolution_hours
FROM tickets
WHERE resolution_hours IS NULL;
```

**Never write `WHERE resolution_hours = NULL`.** That will always return zero rows. `NULL` cannot be compared with `=` — it has no value to compare. You must always use `IS NULL` or `IS NOT NULL`.

**NULL in ORDER BY:** NULL values have no numeric position. In most databases they float to the top on `DESC` sorts and to the bottom on `ASC` sorts — but this varies by database. Never assume.

**NULL in COUNT:** `COUNT(*)` counts all rows including those with NULL. `COUNT(resolution_hours)` counts only rows where `resolution_hours` is not NULL. This difference will matter when you reach Lesson 02's JOIN exercises.

<br>

- [ ] &nbsp;Got it

</details>

---

### Lesson 01 self-check

<details>
<summary>Q1 &nbsp;·&nbsp; What is the difference between WHERE and HAVING?</summary>
<br>

`WHERE` filters individual rows **before** they are grouped. `HAVING` filters groups **after** `GROUP BY` has run. You cannot use `WHERE` to filter on an aggregated value like `COUNT(*)` or `AVG()` — that's what `HAVING` is for.

</details>

<details>
<summary>Q2 &nbsp;·&nbsp; Why does <code>WHERE resolution_hours = NULL</code> return zero rows?</summary>
<br>

Because `NULL` means no value exists — and nothing can be equal to the absence of a value, not even another `NULL`. You must use `IS NULL` or `IS NOT NULL` to check for missing values.

</details>

<details>
<summary>Q3 &nbsp;·&nbsp; You want to count how many tickets each person has been assigned. Write it in words.</summary>
<br>

`SELECT assigned_to, COUNT(*) FROM tickets GROUP BY assigned_to` — select the person's name and a count of rows, then group by name so the count applies per person.

</details>

<details>
<summary>Q4 &nbsp;·&nbsp; What is wrong with sorting priority alphabetically?</summary>
<br>

Alphabetical order gives: **High → Low → Medium**. That is not a meaningful urgency order. If a `'Critical'` level is added later, `C` sorts before `H` and your query silently returns the wrong result — no error, just wrong data. Text-based categories that represent an order should never be sorted alphabetically. Use `CASE` to assign numeric values first.

</details>

---

<br>

# Lesson 02 — JOINs

<div align="center">

![](https://img.shields.io/badge/Lesson-02_of_04-586074?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Skill-INNER_·_LEFT_·_RIGHT_·_FULL_OUTER-2455C3?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Status-✓_Complete-0C7550?style=flat-square)

*How to combine two tables into one result using a shared column.*
*All examples use the Meridian Systems scenario.*

</div>

<br>

## The tools

<table>
<tr>
<td width="50%" valign="top">

**⏰ `autosys_jobs` — The Robot Alarm Clock**

At Meridian Systems, hundreds of tasks run automatically every night — sorting numbers, moving files, generating reports. **Autosys** schedules and runs these tasks. It keeps a list of every task (called a "job") and records whether it finished properly or broke.

Our `autosys_jobs` table is that list.

</td>
<td width="50%" valign="top">

**🎫 `servicenow_tickets` — The Help-Desk Notebook**

When something breaks, the support team creates a **ticket** — a note saying: *"this thing broke, here is how urgent it is, someone is working on it."*

Think of it like a sticky-note board at a repair shop. Every problem gets a note.

Our `servicenow_tickets` table is that sticky-note board.

</td>
</tr>
</table>

---

## The scenario — two tables, one connection

Both tables were built by different teams. But they share one column: **`job_id`**.

> 🔑 Think of `job_id` like a student's ID number. If both the attendance sheet and the report card use the same student ID, a teacher can look up any student across both — even though the sheets were made separately. That shared ID is the **key** that connects the two tables.

### ⏰ `autosys_jobs`

| job_id | job_name | status |
|--------|----------|--------|
| `JOB001` | Daily_Sales_ETL | ❌ Failed |
| `JOB002` | Weekly_Report | ✅ Success |
| `JOB003` | Monthly_Backup | ⏳ Running |
| `JOB004` | Data_Cleanup | ❌ Failed |
| `JOB005` | User_Tracking | ✅ Success |

### 🎫 `servicenow_tickets`

| ticket_id | job_id | priority | assigned_to |
|-----------|--------|----------|-------------|
| INC001 | `JOB001` | 🔴 High | Nabiya |
| INC002 | `JOB004` | 🔴 High | Nabiya |
| INC003 | `JOB001` | 🟡 Medium | Dev Team |
| INC004 | `JOB003` | 🟢 Low | Nabiya |
| INC005 | `JOB002` | 🟢 Low | Dev Team |

> 👀 **Two things to notice before writing a single JOIN:**
> - **JOB001 appears twice** in tickets (INC001 + INC003) — one job, two separate tickets raised for it
> - **JOB005 has no ticket at all** — it ran successfully, nobody complained
>
> These two facts drive every JOIN result below.

---

<details>
<summary><strong>01 &nbsp;·&nbsp; Why JOINs exist</strong></summary>
<br>

Imagine both tables as physical notebooks on your desk. To answer *"which tickets belong to which failed job?"* you'd flip between notebooks, match up the job IDs by hand, and write the combined information yourself. Painful with 5 rows. Impossible with 5 million.

A JOIN is SQL's way of doing that combination automatically. You tell it: *"look at these two tables, find rows where `job_id` matches, and stitch those rows into one result."*

The four JOIN types differ in only one thing: **what happens when a match doesn't exist on one side?**

<br>

- [ ] &nbsp;Got it

</details>

---

<details>
<summary><strong>02 &nbsp;·&nbsp; Primary key vs foreign key</strong></summary>
<br>

| Term | What it means |
|------|--------------|
| **Primary key** | The unique ID that belongs to a table. In `autosys_jobs`, that is `job_id` — every job has exactly one, and no two share the same one. Like a passport number. |
| **Foreign key** | That same ID appearing in a second table as a reference. In `servicenow_tickets`, `job_id` is a foreign key pointing back to `autosys_jobs`. It is the bridge. |
| **ON condition** | `ON aj.job_id = sn.job_id` — SQL finds rows where the values match and merges them into one output row. |

The `autosys_jobs` table *owns* the `job_id`. Every table that references a job borrows that ID. The JOIN reunites them.

<br>

- [ ] &nbsp;Got it

</details>

---

<details>
<summary><strong>03 &nbsp;·&nbsp; INNER JOIN</strong></summary>
<br>

> 💬 **Plain English:** "Only show me rows that exist in **both** tables at the same time."

![INNER JOIN diagram](assets/venn-inner.svg)

```sql
SELECT aj.job_id, aj.job_name, aj.status,
       sn.ticket_id, sn.priority
FROM autosys_jobs AS aj
INNER JOIN servicenow_tickets AS sn
    ON aj.job_id = sn.job_id;
```

**From our Meridian data:**
- JOB005 **disappears** — no matching ticket, so INNER JOIN drops it
- JOB001 **appears twice** — matched two tickets (INC001 and INC003)
- Result: **5 rows**

<br>

- [ ] &nbsp;Got it

</details>

---

<details>
<summary><strong>04 &nbsp;·&nbsp; LEFT JOIN &nbsp;<code>most used</code></strong></summary>
<br>

> 💬 **Plain English:** "Show me every row from the left table. Add ticket info where it exists. Write `NULL` where it doesn't."

![LEFT JOIN diagram](assets/venn-left.svg)

```sql
SELECT aj.job_id, aj.job_name, aj.status,
       sn.ticket_id, sn.priority
FROM autosys_jobs AS aj
LEFT JOIN servicenow_tickets AS sn
    ON aj.job_id = sn.job_id;
```

**From our Meridian data:**
- JOB005 **stays in the result** — with `NULL` in the ticket columns
- JOB001 still **appears twice**
- Result: **6 rows**

> ✅ This is the JOIN you will write most often. When in doubt, start here.

<br>

- [ ] &nbsp;Got it

</details>

---

<details>
<summary><strong>05 &nbsp;·&nbsp; RIGHT JOIN &nbsp;<code>rarely written</code></strong></summary>
<br>

> 💬 **Plain English:** "Show me every row from the right table. Add job info where it exists. Write `NULL` where it doesn't."

![RIGHT JOIN diagram](assets/venn-right.svg)

Every RIGHT JOIN can be rewritten as a LEFT JOIN by swapping which table comes first. Most analysts always write LEFT JOIN and flip the table order. **Know it exists — you will almost never write it.**

<br>

- [ ] &nbsp;Got it

</details>

---

<details>
<summary><strong>06 &nbsp;·&nbsp; FULL OUTER JOIN</strong></summary>
<br>

> 💬 **Plain English:** "Show me absolutely everything from both tables. Fill in `NULL` wherever there is no match on either side."

![FULL OUTER JOIN diagram](assets/venn-full.svg)

```sql
SELECT aj.job_id, aj.job_name, aj.status,
       sn.ticket_id, sn.priority
FROM autosys_jobs AS aj
FULL OUTER JOIN servicenow_tickets AS sn
    ON aj.job_id = sn.job_id;
```

**From our Meridian data:**
- JOB005 appears with `NULL` on the ticket side
- All 5 tickets appear
- JOB001 still appears twice
- Result: **6 rows**

<br>

- [ ] &nbsp;Got it

</details>

---

<details>
<summary><strong>07 &nbsp;·&nbsp; The NULL pattern — finding what's missing</strong></summary>
<br>

> 🎯 **Pattern:** `LEFT JOIN` + `WHERE right_key IS NULL` → find rows in the left table with nothing matching on the right

Think of a teacher with an attendance sheet and a homework pile. LEFT JOIN combines them. `WHERE submission IS NULL` finds exactly which students didn't hand anything in.

```sql
-- Which jobs ran with no ticket ever raised?
SELECT aj.job_id, aj.job_name, aj.status
FROM autosys_jobs AS aj
LEFT JOIN servicenow_tickets AS sn
    ON aj.job_id = sn.job_id
WHERE sn.ticket_id IS NULL;
```

Returns only **JOB005**. The LEFT JOIN kept it with `NULL`s. The `WHERE` isolates only those unmatched rows.

**You will use this constantly:** customers who never ordered, employees with no review, students who didn't submit, failed jobs with no incident raised. The pattern is always the same.

<br>

- [ ] &nbsp;Got it

</details>

---

### Lesson 02 self-check

<details>
<summary>Q1 &nbsp;·&nbsp; You want every job including those with no ticket. Which JOIN?</summary>
<br>

**LEFT JOIN.** The left table is guaranteed to appear fully. Jobs with no matching ticket show `NULL` in the ticket columns instead of being dropped.

</details>

<details>
<summary>Q2 &nbsp;·&nbsp; INNER JOIN returns 5 rows. LEFT JOIN on the same tables returns 7. What do the extra 2 mean?</summary>
<br>

There are **2 rows in the left table with no match in the right.** INNER JOIN dropped them silently. LEFT JOIN kept them and filled the right-side columns with `NULL`.

</details>

<details>
<summary>Q3 &nbsp;·&nbsp; Why does JOB001 appear twice even though it only exists once in autosys_jobs?</summary>
<br>

JOB001 matched **two rows** in `servicenow_tickets` — INC001 and INC003. A JOIN creates one output row per match. One job × two tickets = two output rows. This is called a **one-to-many relationship**.

</details>

<details>
<summary>Q4 &nbsp;·&nbsp; Describe the pattern for finding jobs that never had a ticket raised.</summary>
<br>

`LEFT JOIN servicenow_tickets ON job_id`, then `WHERE sn.ticket_id IS NULL`. The LEFT JOIN keeps all jobs including those with no ticket. `IS NULL` isolates only the unmatched ones.

</details>

<details>
<summary>Q5 &nbsp;·&nbsp; You have a RIGHT JOIN. How do you rewrite it as a LEFT JOIN?</summary>
<br>

Swap the table positions — move the right table into `FROM`, move the left table into the `JOIN` clause, change `RIGHT JOIN` to `LEFT JOIN`. The result is identical.

</details>

---

<br>

## Module 01 — quick reference

### Core clauses

| Clause | What it does | Runs when |
|--------|-------------|-----------|
| `SELECT` | Choose which columns to show | Last |
| `FROM` | Specify the table | First |
| `WHERE` | Filter rows before grouping | Before GROUP BY |
| `GROUP BY` | Bucket rows into groups | After WHERE |
| `HAVING` | Filter groups after grouping | After GROUP BY |
| `ORDER BY` | Sort the final result | Near last |
| `LIMIT` | Cap the number of rows returned | Last |

### JOIN types

| | Type | What it returns | NULLs on |
|---|---|---|---|
| 🔵 | `INNER JOIN` | Only rows matching in both tables | Neither |
| 🟢 | `LEFT JOIN` | All left rows + matching right rows | Right side |
| 🟡 | `RIGHT JOIN` | All right rows + matching left rows | Left side |
| 🟣 | `FULL OUTER JOIN` | Every row from both tables | Either side |

### Things that will bite you

| Trap | Why it happens | Fix |
|------|---------------|-----|
| `WHERE x = NULL` returns nothing | NULL can't be compared with `=` | Use `IS NULL` |
| Sorting text priorities alphabetically breaks | `High → Low → Medium` is not urgency order | Use `CASE` to assign numbers |
| JOIN returns more rows than expected | One-to-many relationships duplicate rows | Check for duplicate keys first |
| `COUNT(*)` vs `COUNT(column)` | `COUNT(*)` includes NULLs; `COUNT(col)` ignores them | Use `COUNT(col)` when NULLs should count as zero |

---

<div align="center">

*analytics-engineer-journey &nbsp;·&nbsp; module-01-sql*
&nbsp;&nbsp;
[github.com/nabiya15](https://github.com/nabiya15)

</div>
