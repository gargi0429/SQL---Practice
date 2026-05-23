create database practiceday5;
use practiceday5;
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id INT,
    manager_id INT,
    salary INT,
    joining_date DATE,
    city VARCHAR(50)
);

INSERT INTO employees VALUES
(101, 'Amit', 1, NULL, 90000, '2021-01-10', 'Mumbai'),
(102, 'Neha', 1, 101, 75000, '2021-03-15', 'Pune'),
(103, 'Raj', 2, 101, 82000, '2020-07-21', 'Delhi'),
(104, 'Priya', 2, 103, 65000, '2022-05-18', 'Mumbai'),
(105, 'Karan', 3, 101, 95000, '2019-11-11', 'Bangalore'),
(106, 'Sneha', 3, 105, 72000, '2023-01-09', 'Pune'),
(107, 'Arjun', 1, 101, 75000, '2022-08-14', 'Delhi'),
(108, 'Meera', 2, 103, 88000, '2020-09-01', 'Mumbai'),
(109, 'Vikram', 3, 105, 60000, '2021-12-25', 'Hyderabad'),
(110, 'Pooja', 1, 101, 70000, '2023-04-17', 'Pune');


-- Q1
-- Find total salary department-wise.

select dept_id, sum(salary) from employees group by dept_id;


-- Q2
-- Display departments whose average salary is greater than 75000.

select dept_id from employees group by dept_id having  avg(salary) > 75000;
-- Q3
-- Show employee name, salary, and total company salary beside every employee
-- using SUM() OVER().

select emp_name, salary , sum(salary) over() as new_sum from employees;

-- Q4
-- Show employee name, department id, salary,
-- and total department salary beside each employee
-- using PARTITION BY.

select emp_name, dept_id, salary , sum(salary) over(partition by dept_id) as new_sum from employees;

-- Q5
-- Rank employees based on salary in descending order
-- using RANK().

select emp_name, emp_id, salary, rank() over(order by salary desc) as d_order from employees;


-- Q6
-- Find dense rank of employees salary department-wise
-- using DENSE_RANK() and PARTITION BY.

select dept_id, emp_id, emp_name, salary,
dense_rank() over(partition by dept_id order by salary desc) as d_rnk from employees;


-- Q7
-- Display employee name along with their manager name
-- using SELF JOIN.

select e.emp_id as emp_name, m.emp_name as manager_name from employees e JOIN employees m On e.manager_id = m.emp_id;

-- Q8
-- Find employees whose salary is greater than
-- the average salary of their own department
-- using correlated subquery.
select * from employees e where salary > (select avg(salary) as AVG_SAL from employees where dept_id = e.dept_id);

-- Q9
-- Find top 2 highest paid employees from each department
-- using RANK() or DENSE_RANK().

select * 
   from 
   (select emp_id, emp_name, dept_id, salary, dense_rank() over(partition by dept_id order by salary desc) as new_rnk from employees)x
  limit 2;

-- Q10
-- Show:
-- employee name,
-- department id,
-- salary,
-- department average salary,
-- difference between employee salary and department average
-- using AVG() OVER(PARTITION BY dept_id).

SELECT
    emp_name,
    dept_id,
    salary,
    AVG(salary) OVER(PARTITION BY dept_id) AS dept_avg_salary,
    salary - AVG(salary) OVER(PARTITION BY dept_id) AS difference
FROM employees;


-- IQ1
-- Find duplicate salaries in the company.

SELECT
    salary,
    COUNT(*) AS total
FROM employees
GROUP BY salary
HAVING COUNT(*) > 1;

-- IQ2
-- Find employees earning the highest salary in each department.

SELECT *
FROM employees e
WHERE salary =
(
    SELECT MAX(salary)
    FROM employees
    WHERE dept_id = e.dept_id
);

-- IQ3
-- Find cumulative salary department-wise
-- ordered by salary descending
-- using SUM() OVER().


SELECT
    emp_name,
    dept_id,
    salary,
    SUM(salary) OVER(
        PARTITION BY dept_id
        ORDER BY salary DESC
    ) AS cumulative_salary
FROM employees;

-- IQ4
-- Find second highest salary without using LIMIT.

SELECT MAX(salary) AS second_highest_salary
FROM employees
WHERE salary <
(
    SELECT MAX(salary)
    FROM employees
);
-- IQ5
-- Find employees who earn more than their manager
-- using SELF JOIN.

SELECT
    e.emp_name AS employee_name,
    e.salary AS employee_salary,
    m.emp_name AS manager_name,
    m.salary AS manager_salary
FROM employees e
JOIN employees m
ON e.manager_id = m.emp_id
WHERE e.salary > m.salary;