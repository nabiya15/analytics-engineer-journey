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

SELECT status, count(*)
from tickets
group by status;

select priority, count(*)
from tickets
WHERE status = 'Open'
GROUP by priority;

SELECT AVG(resolution_hours)
from tickets
where status = 'Closed';

select assigned_to, count(*)
from tickets
group by assigned_to;

SELECT priority, AVG(resolution_hours)
from tickets
where status = 'Closed'
group BY priority
HAVING AVG(resolution_hours) > 5

SELECT ticket_id, priority, resolution_hours
from tickets
ORDER by resolution_hours DESC;

select ticket_id, priority, resolution_hours
FROM tickets
WHERE status = 'Closed'
ORDER by resolution_hours ASC
limit 2;

-- flawed query, because it doesn't consider the priority levels correctly. In real life scenarios, you would need to assign numerical values to the priority levels (e.g., High = 1, Medium = 2, Low = 3) and then order by those values to get the correct highest priority ticket. However, for the sake of this exercise, we will assume that the alphabetical order of the priority levels is sufficient. This would definately break the logic in real life scenarios, but it serves the purpose of demonstrating the use of ORDER BY and LIMIT clauses in SQL.
SELECT ticket_id, priority, resolution_hours
from tickets
WHERE  status = 'Open'
order by priority ASC
LIMIT 1;

