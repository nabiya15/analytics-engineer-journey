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