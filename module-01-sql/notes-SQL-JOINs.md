<div align="center">

![](https://img.shields.io/badge/Module_01-SQL_Fundamentals-2455C3?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Lesson-02_of_04-586074?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Review_time-45_min-9AA3B2?style=flat-square)&nbsp;
![](https://img.shields.io/badge/Status-✓_Complete-0C7550?style=flat-square)

# SQL JOINs

**How to combine two tables into one result using a shared column.**
*All examples use our Meridian Systems scenario.*

</div>

---

## The tools

Before writing a single JOIN, understand what these two tables actually represent.

<table>
<tr>
<td width="50%" valign="top">

**⏰ `autosys_jobs` — The Robot Alarm Clock**

At Meridian Systems, hundreds of computer tasks run automatically every single night — sorting numbers, moving files, generating reports. **Autosys** is the system that schedules and runs these tasks.

Think of it like a robot with a to-do list. It ticks off each task and writes down whether it finished properly or broke.

Our `autosys_jobs` table is **that to-do list**.

</td>
<td width="50%" valign="top">

**🎫 `servicenow_tickets` — The Help-Desk Notebook**

When something breaks at Meridian Systems, the support team creates a **ticket** — a note that says: *"this thing broke, here is how urgent it is, and someone is working on it."*

Think of it like a sticky-note board at a repair shop. Every problem gets a note. Every note tracks who is fixing it.

Our `servicenow_tickets` table is **that sticky-note board**.

</td>
</tr>
</table>

---

## The scenario — two tables, one connection

Both tables were built separately by different teams. But they share one column: **`job_id`**.

> 🔑 Think of `job_id` like a student's ID number. If both the attendance sheet and the report card use the same student ID, a teacher can look up any student across both sheets — even though the sheets were created separately. That shared ID is the **key** that connects them.

### ⏰ `autosys_jobs` — the alarm clock list

| job_id | job_name | status |
|--------|----------|--------|
| `JOB001` | Daily_Sales_ETL | ❌ Failed |
| `JOB002` | Weekly_Report | ✅ Success |
| `JOB003` | Monthly_Backup | ⏳ Running |
| `JOB004` | Data_Cleanup | ❌ Failed |
| `JOB005` | User_Tracking | ✅ Success |

### 🎫 `servicenow_tickets` — the help-desk notebook

| ticket_id | job_id | priority | assigned_to |
|-----------|--------|----------|-------------|
| INC001 | `JOB001` | 🔴 High | Nabiya |
| INC002 | `JOB004` | 🔴 High | Nabiya |
| INC003 | `JOB001` | 🟡 Medium | Dev Team |
| INC004 | `JOB003` | 🟢 Low | Nabiya |
| INC005 | `JOB002` | 🟢 Low | Dev Team |

> 👀 **Two things to notice before we write a single JOIN:**
> - **JOB001 appears twice** in the tickets table (INC001 and INC003) — one job had two separate tickets raised for it
> - **JOB005 has no ticket at all** — it ran successfully, so nobody raised a complaint
>
> These two facts explain every JOIN result below.

---

## Sections

<details>
<summary><strong>01 &nbsp;·&nbsp; Why JOINs exist</strong></summary>
<br>

Imagine both tables as physical notebooks sitting on your desk. If you want to answer *"which tickets belong to which failed job?"* — you'd have to flip between notebooks, match up the job IDs yourself, and write the combined information by hand. That's painful with 5 rows. It's impossible with 5 million.

A JOIN is SQL's way of doing that combination automatically. You tell it: *"look at these two tables, find rows where the `job_id` matches, and stitch those rows together into one result."*

The four types of JOIN only differ in **one question: what do we do when a match doesn't exist on one side?** Each type answers that differently.

<br>

- [ ] &nbsp;Got it

</details>

---

<details>
<summary><strong>02 &nbsp;·&nbsp; Primary key vs foreign key</strong></summary>
<br>

| Term | What it means |
|------|--------------|
| **Primary key** | The unique ID that belongs to a table. In `autosys_jobs`, that is `job_id` — every job has exactly one, and no two jobs share the same one. Like a passport number. |
| **Foreign key** | When that same ID appears in a second table as a reference. In `servicenow_tickets`, `job_id` is a foreign key — it is saying *"this ticket belongs to that job over there."* It is the bridge. |
| **ON condition** | `ON aj.job_id = sn.job_id` — this tells SQL: *"match rows from both tables wherever these two columns have the same value."* |

The `autosys_jobs` table *owns* the `job_id`. Every other table that references a job borrows that ID. The JOIN reunites them.

<br>

- [ ] &nbsp;Got it

</details>

---

<details>
<summary><strong>03 &nbsp;·&nbsp; INNER JOIN</strong></summary>
<br>

> 💬 **Plain English:** "Only show me rows that exist in **both** lists at the same time."

![INNER JOIN diagram](assets/venn-inner.svg)

```sql
SELECT aj.job_id, aj.job_name, aj.status,
       sn.ticket_id, sn.priority
FROM autosys_jobs AS aj
INNER JOIN servicenow_tickets AS sn
    ON aj.job_id = sn.job_id;
```

**From our Meridian data:**
- JOB005 **disappears** — it has no matching ticket, so INNER JOIN drops it entirely
- JOB001 **appears twice** — it matched two tickets (INC001 and INC003)
- Result: **5 rows**

<br>

- [ ] &nbsp;Got it

</details>

---

<details>
<summary><strong>04 &nbsp;·&nbsp; LEFT JOIN &nbsp; <code>most used</code></strong></summary>
<br>

> 💬 **Plain English:** "Show me every row from the left list. For each one, add ticket info if it exists. Write `NULL` if it doesn't."

![LEFT JOIN diagram](assets/venn-left.svg)

```sql
SELECT aj.job_id, aj.job_name, aj.status,
       sn.ticket_id, sn.priority
FROM autosys_jobs AS aj
LEFT JOIN servicenow_tickets AS sn
    ON aj.job_id = sn.job_id;
```

**From our Meridian data:**
- JOB005 **stays in the result** — with `NULL` written in the ticket columns because no matching ticket exists
- JOB001 still **appears twice**
- Result: **6 rows**

> ✅ This is the JOIN you will write most often. When in doubt, start here.

<br>

- [ ] &nbsp;Got it

</details>

---

<details>
<summary><strong>05 &nbsp;·&nbsp; RIGHT JOIN &nbsp; <code>rarely written</code></strong></summary>
<br>

> 💬 **Plain English:** "Show me every row from the right list. Add job info where it exists. Write `NULL` where it doesn't."

![RIGHT JOIN diagram](assets/venn-right.svg)

Every RIGHT JOIN can be rewritten as a LEFT JOIN by swapping which table comes first. Most analysts just flip the tables and always write LEFT JOIN. **Know that RIGHT JOIN exists — but you will almost never write it.**

<br>

- [ ] &nbsp;Got it

</details>

---

<details>
<summary><strong>06 &nbsp;·&nbsp; FULL OUTER JOIN</strong></summary>
<br>

> 💬 **Plain English:** "Show me absolutely everything from both lists. Fill in `NULL` wherever there is no match on either side."

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

> 🎯 **Pattern:** `LEFT JOIN` + `WHERE right_key IS NULL` → *"find rows in the left table with nothing matching on the right"*

Think of it like a teacher with an attendance sheet and a homework submission pile. LEFT JOIN combines them. `WHERE submission IS NULL` finds exactly which students didn't hand anything in.

```sql
-- Which jobs ran with no ticket ever raised?
SELECT aj.job_id, aj.job_name, aj.status
FROM autosys_jobs AS aj
LEFT JOIN servicenow_tickets AS sn
    ON aj.job_id = sn.job_id
WHERE sn.ticket_id IS NULL;
```

This returns only **JOB005**. The LEFT JOIN kept it in the result with `NULL`s. The `WHERE` then says *"only show me the rows where the ticket side is empty."*

**You will use this constantly:**
- Customers who never placed an order
- Employees with no performance review on file
- Students who didn't submit homework
- Failed jobs with no incident raised

The pattern is always identical — LEFT JOIN, then `WHERE right_key IS NULL`.

<br>

- [ ] &nbsp;Got it

</details>

---

## Self-check

<details>
<summary>Q1 &nbsp;·&nbsp; You want every job including those with no ticket. Which JOIN type?</summary>
<br>

**LEFT JOIN.**

The left table (`autosys_jobs`) is guaranteed to appear fully in the result. Jobs with no matching ticket show `NULL` in the ticket columns instead of being dropped.

</details>

<details>
<summary>Q2 &nbsp;·&nbsp; An INNER JOIN returns 5 rows. A LEFT JOIN on the same tables returns 7. What do the extra 2 rows mean?</summary>
<br>

There are **2 rows in the left table with no match in the right table**. INNER JOIN quietly dropped them. LEFT JOIN kept them, filling the right-side columns with `NULL`.

</details>

<details>
<summary>Q3 &nbsp;·&nbsp; Why does JOB001 appear twice even though it only exists once in autosys_jobs?</summary>
<br>

JOB001 matched **two rows** in `servicenow_tickets` — INC001 and INC003. A JOIN creates one output row for every match it finds. One job matched twice = two output rows. This is called a **one-to-many relationship**.

</details>

<details>
<summary>Q4 &nbsp;·&nbsp; In plain words, describe the pattern for finding jobs that never had a ticket raised.</summary>
<br>

`LEFT JOIN servicenow_tickets` on `job_id`, then add `WHERE sn.ticket_id IS NULL`. The LEFT JOIN keeps all jobs even those with no ticket match. `IS NULL` then isolates only the unmatched ones — the rows the JOIN filled with `NULL` on the right side.

</details>

<details>
<summary>Q5 &nbsp;·&nbsp; You have a RIGHT JOIN. How do you rewrite it as a LEFT JOIN without changing the result?</summary>
<br>

Swap the table positions — move the right table into the `FROM` clause, move the left table into the `JOIN` clause, then change `RIGHT JOIN` to `LEFT JOIN`. The result is identical. This is why most analysts just always write LEFT JOIN.

</details>

---

## Quick reference

| | Type | What it returns | NULLs on |
|---|---|---|---|
| 🔵 | `INNER JOIN` | Only rows matching in both tables | Neither side |
| 🟢 | `LEFT JOIN` | All left rows + matching right rows | Right side |
| 🟡 | `RIGHT JOIN` | All right rows + matching left rows | Left side |
| 🟣 | `FULL OUTER JOIN` | Every row from both tables | Either side |

---

<div align="center">

*analytics-engineer-journey &nbsp;·&nbsp; module-01-sql &nbsp;·&nbsp; lesson-02*
&nbsp;
[github.com/nabiya15](https://github.com/nabiya15)

</div>
