CREATE TABLE employees (
    emp_id TEXT, name TEXT, department TEXT,
    salary INTEGER, status TEXT
);
INSERT INTO employees VALUES
    ('E001','Sarah','Engineering',95000,'Active'),
    ('E002','Marcus','Marketing',72000,'Active'),
    ('E003','Priya','Engineering',88000,'Active'),
    ('E004','James','Sales',65000,'Inactive'),
    ('E005','Elena','Marketing',78000,'Active'),
    ('E006','Tom','Sales',70000,'Active');

CREATE TABLE performance_reviews (
    review_id TEXT, emp_id TEXT,
    rating INTEGER, review_year INTEGER
);
INSERT INTO performance_reviews VALUES
    ('R001','E001',4,2024),
    ('R002','E003',5,2024),
    ('R003','E001',3,2023),
    ('R004','E002',4,2024),
    ('R005','E005',2,2024);

ALTER TABLE performance_reviews ADD COLUMN follow_up TEXT;
UPDATE performance_reviews SET follow_up = 'Urgent' WHERE rating <= 2;
UPDATE performance_reviews SET follow_up = 'Normal' WHERE rating = 3;
UPDATE performance_reviews SET follow_up = 'Low'    WHERE rating >= 4;

SELECT review_id, follow_up,
    CASE follow_up
        WHEN 'Urgent' THEN 1
        WHEN 'Normal' THEN 2
        WHEN 'Low' THEN 3
    END AS urgency_rank
FROM performance_reviews
ORDER BY urgency_rank ASC;


SELECT name, salary,
    CASE 
        WHEN salary >= 90000 THEN 'Senior'
        WHEN salary >=70000 THEN 'Mid'
        ELSE 'Junior'
    END AS salary_band
FROM employees;