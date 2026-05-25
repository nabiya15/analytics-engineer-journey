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

SELECT *
FROM tickets
where status = 'Closed';

-- What: Count of tickets grouped by current status
-- Why: To understand workload distribution across Open vs Closed tickets
SELECT status, count(*)
from tickets
group by status;

-- What: Count of open tickets grouped by priority
-- Why: To understand the distribution of open tickets across different priority levels
select priority, count(*)
from tickets
WHERE status = 'Open'
GROUP by priority;

-- What: Average resolution hours for closed tickets
-- Why: To understand the efficiency of ticket resolution
SELECT AVG(resolution_hours)
from tickets
where status = 'Closed';

-- What: Count of tickets assigned to each person
-- Why: To understand workload distribution among team members
SELECT assigned_to, count(*)
from tickets
group by assigned_to;

-- What: Average resolution hours for closed tickets by priority
-- Why: To understand the efficiency of ticket resolution across different priority levels
SELECT priority, AVG(resolution_hours)
from tickets
where status = 'Closed'
group BY priority
HAVING AVG(resolution_hours) > 5

-- What: List of tickets ordered by resolution hours in descending order
-- Why: To identify which tickets took the longest to resolve
SELECT ticket_id, priority, resolution_hours
from tickets
ORDER by resolution_hours DESC;

-- What: List of the top 2 tickets with the shortest resolution hours
-- Why: To identify which tickets were resolved the quickest
select ticket_id, priority, resolution_hours
FROM tickets
WHERE status = 'Closed'
ORDER by resolution_hours ASC
limit 2;

-- What: List of the highest priority open ticket
-- Why: To identify which open ticket should be addressed first based on its priority level
-- flawed query, because it doesn't consider the priority levels correctly. In real life scenarios, you would need to assign numerical values to the priority levels (e.g., High = 1, Medium = 2, Low = 3) and then order by those values to get the correct highest priority ticket. However, for the sake of this exercise, we will assume that the alphabetical order of the priority levels is sufficient. This would definately break the logic in real life scenarios, but it serves the purpose of demonstrating the use of ORDER BY and LIMIT clauses in SQL.
SELECT ticket_id, priority, resolution_hours
from tickets
WHERE  status = 'Open'
order by priority ASC
LIMIT 1;

