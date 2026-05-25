-- =========================================
-- DAY 6 DATASET
-- Topics:
-- CTE, LEAD, LAG, ROW_NUMBER,
-- CASE WHEN, NTILE, EXISTS
-- =========================================

CREATE DATABASE practiceday6;

USE practiceday6;

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id INT,
    salary INT,
    joining_date DATE
);

INSERT INTO employees VALUES
(101, 'Amit', 1, 85000, '2021-01-10'),
(102, 'Neha', 1, 92000, '2020-03-15'),
(103, 'Rohit', 1, 75000, '2022-07-20'),

(104, 'Priya', 2, 68000, '2019-11-11'),
(105, 'Karan', 2, 72000, '2021-09-05'),
(106, 'Sneha', 2, 72000, '2023-02-01'),

(107, 'Vikas', 3, 99000, '2018-06-30'),
(108, 'Anjali', 3, 88000, '2020-12-25'),
(109, 'Ramesh', 3, 62000, '2022-04-18'),

(110, 'Pooja', 4, 54000, '2021-08-19'),
(111, 'Arjun', 4, 47000, '2023-01-10'),

(112, 'Meena', 5, 81000, '2020-05-14');



CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

INSERT INTO departments VALUES
(1, 'HR'),
(2, 'Finance'),
(3, 'IT'),
(4, 'Marketing'),
(5, 'Sales'),
(6, 'Admin');



-- =========================================
-- OPTIONAL CHECK
-- =========================================

SELECT * FROM employees;
SELECT * FROM departments;



-- =========================
-- DAY 6 SQL PRACTICE
-- =========================

-- Q1
-- Display employee name, salary,
-- previous employee salary using LAG().

select emp_name, salary, lag(salary) over (order by salary) as prev_salary from employees;

-- Q2
-- Display employee name, salary,
-- next employee salary using LEAD().

select emp_name, salary, lead(salary) over (order by salary) from employees;

-- Q3
-- Assign row numbers department-wise
-- using ROW_NUMBER().

select emp_name, salary, row_number () over (partition by dept_id order by salary desc) as dept_wise from employees;

-- Q4
-- Find top 2 highest paid employees
-- from each department using ROW_NUMBER().

SELECT * 
from 
(select emp_name, salary, dept_id, row_number () over (partition by dept_id order by salary desc) as rnk from employees) x where rnk <= 2;

-- Q5
-- Categorize employees:
-- salary > 80000 = High
-- salary between 50000 and 80000 = Medium
-- else Low
-- using CASE WHEN.

select emp_id, emp_name, salary,
Case 
when salary > 80000 then 'High'
when salary between 50000 and 80000 then 'Medium'
else 'low'
end as categorized

 from employees;
 


-- Q6
-- Divide employees into 4 salary groups
-- using NTILE(4).

select *, ntile(4) over (order by salary desc) as group_4 from employees;

-- Q7
-- Find employees whose salary
-- is greater than department average
-- using CTE.

With cte_name as (
  select dept_id, avg(salary) as AVG_Sal from employees group by dept_id

) select * from cte_name;




-- Q8
-- Find departments that do not have employees
-- using NOT EXISTS.
SELECT dept_id, dept_name
FROM departments d

WHERE NOT EXISTS
(
    SELECT 1
    FROM employees e
    WHERE e.dept_id = d.dept_id
);

-- Q9
-- Display cumulative salary department-wise
-- ordered by joining date.

Select *, sum(salary) over(partition by dept_id order by salary) as cumulative_sal from employees;

-- Q10
-- Find difference between current employee salary
-- and previous employee salary using LAG().

select emp_id, emp_name, lag(salary) over(order by emp_id) as prev_salary, salary - lag(salary) over (order by emp_id) as salary_difference 
from employees;

select emp_name, salary from employees order by salary;

-- =========================
-- INTERVIEW QUESTIONS
-- =========================

-- IQ1
-- Difference between RANK(),
-- DENSE_RANK() and ROW_NUMBER().

/* RANK() → skips ranks after ties
DENSE_RANK() → no rank skipping
ROW_NUMBER() → always unique numbers */

-- IQ2
-- Difference between WHERE and HAVING.


/* WHERE → filters rows before grouping
HAVING → filters groups after aggregation */


-- IQ3
-- Difference between CTE and Subquery.

/*CTE → readable, reusable temporary result using WITH
Subquery → query inside another query*/

-- IQ4
-- Difference between EXISTS and IN.
/*EXISTS → checks existence of rows
IN → checks matching values in list/subquery */


-- IQ5
-- Explain execution order of SQL query.
/* FROM
JOIN
WHERE
GROUP BY
HAVING
SELECT
ORDER BY
LIMIT */