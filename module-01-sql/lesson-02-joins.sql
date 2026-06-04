
CREATE TABLE autosys_jobs (
  job_id TEXT,
  job_name TEXT,
  status TEXT,
  scheduled_time TEXT,
  run_date TEXT
);

INSERT into autosys_jobs VALUES
    ('JOB001', 'Daily_Sales_ETL', 'Failed', '02:00', '2024-06-01'),
    ('JOB002', 'Weekly_Report_Generation', 'Success', '03:00', '2024-06-01'),
    ('JOB003', 'Monthly_Backup', 'Running', '04:00', '2024-06-01'),
    ('JOB004', 'Data_Cleanup', 'Failed', '01:00', '2024-06-01'),
    ('JOB005', 'User_Activity_Tracking', 'Success', '05:00', '2024-06-01');

CREATE TABLE servicenow_tickets(
    ticket_id TEXT, 
    job_id TEXT, 
    priority TEXT,
    assigned_to TEXT,
    resolution TEXT,
    created_date TEXT
);

INSERT INTO servicenow_tickets VALUES
   ('INC001','JOB001','High','Nabiya','Restarted job manually','2024-06-01'),
   ('INC002','JOB004','High','Nabiya','Investigating root cause','2024-06-01'),
   ('INC003','JOB001','Medium','Dev Team','Monitoring job for next run','2024-06-01'),
   ('INC004','JOB003','Low','Nabiya','Job is still running, no action needed yet','2024-06-01'),
    ('INC005','JOB002','Low','Dev Team','No action needed, job succeeded','2024-06-01');


SELECT * FROM autosys_jobs;
SELECT * FROM servicenow_tickets;

-- INNER JOIN: only jobs that have at least one ticket
-- JOB005 disappears. JOB001 appears twice.
SELECT
    aj.job_id,
    aj.job_name,
    aj.status,
    sn.ticket_id,
    sn.priority,
    sn.assigned_to
FROM autosys_jobs AS aj
INNER JOIN servicenow_tickets AS sn
    ON aj.job_id = sn.job_id;

-- LEFT JOIN: "all jobs", with ticket info where it exists
-- JOB005 appears with NULL ticket info. JOB001 appears twice.
SELECT
    aj.job_id,
    aj.job_name,
    aj.status,
    sn.ticket_id,
    sn.priority,    
    sn.assigned_to
FROM autosys_jobs AS aj
LEFT JOIN servicenow_tickets AS sn
    ON aj.job_id = sn.job_id;

-- RIGHT JOIN: "all tickets", with job info where it exists
-- JOB005 appears with NULL job info. JOB001 appears twice.
SELECT
    aj.job_id,
    aj.job_name,
    aj.status,
    sn.ticket_id,
    sn.priority,    
    sn.assigned_to
FROM autosys_jobs AS aj
RIGHT JOIN servicenow_tickets AS sn
    ON aj.job_id = sn.job_id;

-- FULL OUTER JOIN: everything from both tables regardless
-- NULLs on left where "ticket has no job"
-- NULLs on right where "job has no ticket"
-- JOB001 appears twice, JOB005 appears once with NULL ticket info
SELECT
    aj.job_id,
    aj.job_name,        
    aj.status,
    sn.ticket_id,
    sn.priority,    
    sn.assigned_to
FROM autosys_jobs AS aj
FULL OUTER JOIN servicenow_tickets AS sn
    ON aj.job_id = sn.job_id;

-- Test my knowledge
-- Query 1:  Show only Failed jobs that have a ticket. Display job_name, status, ticket_id, and priority.
SELECT
    aj.job_name,
    aj.status,
    sn.ticket_id,
    sn.priority
FROM autosys_jobs AS aj
INNER JOIN servicenow_tickets AS sn
    ON aj.job_id = sn.job_id
WHERE aj.status = 'Failed';

--Query 2: Find all jobs that have NO ticket at all. Hint — use a LEFT JOIN, then filter on a NULL value from the right side. Think about which column from servicenow_tickets would be NULL when there's no match.
SELECT
    aj.job_id,
    aj.job_name,
    aj.status,
    sn.ticket_id,
    sn.priority,
FROM autosys_jobs AS aj
LEFT JOIN servicenow_tickets AS sn
    ON aj.job_id = sn.job_id
WHERE sn.ticket_id IS NULL;

-- Count how many tickets each job has, including jobs with zero tickets. Display job_id, job_name, and a column called ticket_count.
SELECT
    aj.job_id,
    aj.job_name,
    COUNT(sn.ticket_id) AS ticket_count
FROM autosys_jobs AS aj
LEFT JOIN servicenow_tickets AS sn
    ON aj.job_id = sn.job_id
GROUP BY aj.job_id, aj.job_name;

