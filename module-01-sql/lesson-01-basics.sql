-- ============================================
-- Part 1 & 2: Basic SELECT and filtering
-- Uses original tickets table (no resolution_hours column)
-- ============================================
CREATE TABLE tickets (
  ticket_id TEXT,
  type TEXT,
  priority TEXT,
  status TEXT,
  assigned_to TEXT,
  created_date TEXT
);

INSERT INTO tickets VALUES
('INC001','Incident','High','Open','Nabiya','2021-03-15'),
('INC002','Incident','Low','Closed','Dev Team','2021-03-16'),
('REQ001','Request','Medium','Open','Nabiya','2021-03-17'),
('INC003','Incident','High','Closed','Dev Team','2021-03-18'),
('REQ002','Request','Low','Open','Nabiya','2021-03-19'),
('INC004','Incident','Medium','Open','Dev Team','2021-03-20'),
('REQ003','Request','High','Closed','Nabiya','2021-03-21');

-- What: List of all tickets
-- Why: To get an overview of all the tickets in the system
SELECT *
FROM tickets;

-- What: List of ticket_id, priority, and status for all tickets
-- Why: To get a quick overview of the ticket IDs, their priority levels, and current status without needing all the details
SELECT ticket_id, priority, status
FROM tickets;

-- What: List of all open tickets
-- Why: To identify which tickets are currently open and need attention
SELECT *
FROM tickets
WHERE status = 'Open';

-- What: List of all tickets assigned to Nabiya
-- Why: To see which tickets are currently assigned to Nabiya for tracking her workload
SELECT *
FROM tickets
WHERE assigned_to = 'Nabiya';

-- What: List of all high priority open tickets
-- Why: To identify which open tickets are of high priority and may require immediate attention 
SELECT *
FROM tickets
WHERE priority = 'High'
AND status = 'Open';

-- What: List of all tickets assigned to either Nabiya or Dev Team
-- Why: To see which tickets are currently assigned to either Nabiya or the Dev Team for tracking their workload
SELECT *
FROM tickets
WHERE assigned_to = 'Nabiya'
OR assigned_to = 'Dev Team';

-- What: List of all tickets that are not closed
-- Why: To identify which tickets are still open or in progress and may require attention
SELECT *
FROM tickets
WHERE status != 'Closed';

-- What: List of all tickets that are of the type 'Incident' and are currently open
-- Why: To identify which open tickets are incidents and may require immediate attention due to their nature
SELECT *
FROM tickets
WHERE status = 'Open'
AND type = 'Incident';

-- What: List of all high priority tickets. Do not get all the columns, just ticket_id, priority, and assigned_to some of the key information about the ticket.
-- Why: To identify which tickets are of high priority and may require immediate attention
SELECT ticket_id, priority, assigned_to
FROM tickets
WHERE priority = 'High';

-- ============================================
-- Part 3: Aggregation and grouping
-- Uses modified tickets table with resolution_hours column
-- ============================================ 
DROP TABLE tickets;

CREATE table tickets (
  ticket_id TEXT,
  type TEXT,
  priority TEXT,
  status TEXT,
  assigned_to TEXT,
  created_date TEXT,
  resolution_hours INTEGER
);

INSERT INTO tickets VALUES
('INC001','Incident','High','Open','Nabiya','2021-03-15',NULL),
('INC002','Incident','Low','Closed','Dev Team','2021-03-16',4),
('REQ001','Request','Medium','Open','Nabiya','2021-03-17',NULL),
('INC003','Incident','High','Closed','Dev Team','2021-03-18',12),
('REQ002','Request','Low','Open','Nabiya','2021-03-19',NULL),
('INC004','Incident','Medium','Open','Dev Team','2021-03-20',NULL),
('REQ003','Request','High','Closed','Nabiya','2021-03-21',6);

-- What: List of all closed tickets
-- Why: To understand which tickets have been resolved
SELECT *
FROM tickets
WHERE status = 'Closed';

-- What: Count of tickets grouped by current status
-- Why: To understand workload distribution across Open vs Closed tickets
SELECT status, count(*)
FROM tickets
GROUP BY status;

-- What: Count of open tickets grouped by priority
-- Why: To understand the distribution of open tickets across different priority levels
SELECT priority, count(*)
FROM tickets
WHERE status = 'Open'
GROUP BY priority;

-- What: Average resolution hours for closed tickets
-- Why: To understand the efficiency of ticket resolution
SELECT AVG(resolution_hours)
FROM tickets
WHERE status = 'Closed';

-- What: Count of tickets assigned to each person
-- Why: To understand workload distribution among team members
SELECT assigned_to, count(*)
FROM tickets
GROUP BY assigned_to;

-- What: Average resolution hours for closed tickets by priority
-- Why: To understand the efficiency of ticket resolution across different priority levels
SELECT priority, AVG(resolution_hours)
FROM tickets
WHERE status = 'Closed'
GROUP BY priority
HAVING AVG(resolution_hours) > 5;

-- What: List of tickets ordered by resolution hours in descending order
-- Why: To identify which tickets took the longest to resolve
SELECT ticket_id, priority, resolution_hours
FROM tickets
ORDER BY resolution_hours DESC;

-- What: List of the top 2 tickets with the shortest resolution hours
-- Why: To identify which tickets were resolved the quickest
SELECT ticket_id, priority, resolution_hours
FROM tickets
WHERE status = 'Closed'
ORDER BY resolution_hours ASC
LIMIT 2;

-- What: List of the highest priority open ticket
-- Why: To identify which open ticket should be addressed first based on its priority level
-- flawed query, because it doesn't consider the priority levels correctly. In real life scenarios, you would need to assign numerical values to the priority levels (e.g., High = 1, Medium = 2, Low = 3) and then order by those values to get the correct highest priority ticket. However, for the sake of this exercise, we will assume that the alphabetical order of the priority levels is sufficient. This would definately break the logic in real life scenarios, but it serves the purpose of demonstrating the use of ORDER BY and LIMIT clauses in SQL.
SELECT ticket_id, priority, resolution_hours
FROM tickets
WHERE  status = 'Open'
ORDER BY priority ASC
LIMIT 1;

