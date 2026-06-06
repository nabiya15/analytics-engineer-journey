--
---JOIN type            Question it answers
---INNER JOIN           Show me only jobs that have tickets
---LEFT JOIN            Show me all jobs, with ticket info where it exists
---RIGHT JOIN           Show me all tickets, with job info where it exists
---FULL OUTER JOIN      Show me everything from both tables regardless
--
-- ============================================================
-- PRACTICE: Lesson 02 — JOINs
-- ============================================================
-- Key takeaways from this session:
--
-- What I kept getting wrong?
-- Kept using FULL OUTER JOIN unnecessarily. When the problem mentioned that we need ALL JOBS from the left table with values where they exist from the right table should have prompted LEFT JOIN in my mind. 
-- Understanding of JOINS is still a little vague, but will need more practice.

-- The fix i need to make:
--  - Read and understand the requirement first.
--  - One thing I learned here today "ALL JOBS, with ticket info where exists" should automatically bring out the concrete info that I learnt today, ie. LEFT JOIN and not FULL OUTER
--  - For instance in Q2, I made the mistake of unnecessarily using JOIN where it was not needed. Learnt to analyze the requirement first before thinking that since its a lesson on joins, I should blindly use a JOIN.

-- What I got right without prompting:
--  - COUNT(sn.job_id) for zero-counting (not count(*) which may be a defualt instinct in beginners). I did the mistake of using COUNT(*) initially but realized that it counted the jobs from the left table. SO JOB005 and JOB006 should have ticket_count = 0 , but it gave me 1. This made me understand that the query asked me to count ALL JOBS where tickets exist(including 0 tickets), so I need to have a COUNT on the tickets table instead. 
--  For Q5, I started with writing the wrong query (COUNT(*)). However, I understood the problem and fixed it with the correct reasoning and understanding(COUNT(sn.job_id))

CREATE TABLE autosys_jobs(
    job_id TEXT,
    job_name TEXT,
    status TEXT,
    scheduled_time TIME,
    run_date DATE
);

INSERT INTO autosys_jobs VALUES
    ('JOB001', 'Data Backup', 'Failed', '02:00:00', '2024-06-01'),
    ('JOB002', 'Report Generation', 'Success', '03:00:00', '2024-06-01'),
    ('JOB003', 'System Update', 'Running', '04:00:00', '2024-06-01'),
    ('JOB004', 'Data Sync', 'Failed', '05:00:00', '2024-06-01'),
    ('JOB005', 'Log Cleanup', 'Success', '06:00:00', '2024-06-01'),
    ('JOB006', 'User Activity Tracking', 'Failed', '07:00:00', '2024-06-01');

CREATE TABLE servicenow_tickets(
    ticket_id TEXT,
    job_id TEXT,
    priority TEXT,
    assigned_to TEXT,
    resolution TEXT,
    created_date DATE
);

INSERT INTO servicenow_tickets VALUES
    ('INC001', 'JOB001', 'High', 'Alice', 'Restarted job manually', '2024-06-01'),
    ('INC002', 'JOB004', 'High', 'Bob', 'Investigating root cause', '2024-06-01'),
    ('INC003', 'JOB001', 'Medium', 'Charlie', 'Monitoring job for next run', '2024-06-01'),
    ('INC004', 'JOB003', 'Low', 'Dave', 'Job is still running, no action needed yet', '2024-06-01'),
    ('INC005', 'JOB002', 'Low', 'Eve', 'No action needed, job succeeded', '2024-06-01');

SELECT * FROM autosys_jobs;
SELECT * FROM servicenow_tickets;

--Query 1: Show all failed jobs with their ticket ID and priority. Only show jobs that actually have a ticket.
SELECT aj.job_id, 
       aj.job_name, 
       aj.status, 
       sn.ticket_id, 
       sn.priority
FROM autosys_jobs AS aj 
INNER JOIN servicenow_tickets AS sn 
    ON aj.job_id = sn.job_id
WHERE aj.status = 'Failed';

--Q2. Count how many tickets each person has been assigned. Include their name and the count. Order by count descending.
SELECT assigned_to, 
    COUNT(*) AS ticket_count
FROM servicenow_tickets 
GROUP BY assigned_to
ORDER BY COUNT(*) DESC;

--Q3. Find every job that has more than one ticket raised for it. Show the job name and the ticket count.
SELECT aj.job_name,
    COUNT(*) AS ticket_count
FROM autosys_jobs AS aj
    INNER JOIN servicenow_tickets AS sn
    ON aj.job_id = sn.job_id
GROUP BY aj.job_name
HAVING COUNT(*) > 1;

--Q4. Show all jobs with a status of 'Failed' that have no ticket raised at all.
SELECT aj.job_id, aj.job_name, aj.status
FROM autosys_jobs AS aj
    LEFT JOIN servicenow_tickets AS sn
    ON aj.job_id = sn.job_id
WHERE aj.status = 'Failed' AND sn.ticket_id IS NULL;


--Q5. Show every job alongside its ticket count — including jobs with zero tickets. Order by ticket count descending.
SELECT aj.job_id, aj.job_name, 
    COUNT(sn.job_id) AS ticket_count
FROM autosys_jobs AS aj
    LEFT JOIN servicenow_tickets AS sn
    ON sn.job_id = aj.job_id
GROUP BY aj.job_id, aj.job_name
ORDER BY COUNT(sn.job_id) DESC 