CREATE DATABASE practiceday23;
USE practiceday23;

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary INT,
    joining_date DATE
);

INSERT INTO employees (emp_id, name, department, salary, joining_date)
VALUES
(1, 'Amit', 'IT', 75000, '2022-01-10'),
(2, 'Priya', 'HR', 55000, '2021-03-15'),
(3, 'Rahul', 'IT', 90000, '2020-07-20'),
(4, 'Sneha', 'Finance', 80000, '2023-02-12'),
(5, 'Karan', 'IT', 90000, '2021-11-05'),
(6, 'Neha', 'HR', 65000, '2022-06-18'),
(7, 'Rohan', 'Finance', 95000, '2020-09-25'),
(8, 'Pooja', 'IT', 70000, '2023-04-01'),
(9, 'Arjun', 'HR', 65000, '2020-12-10'),
(10, 'Meera', 'Finance', 85000, '2021-08-30');
SELECT * FROM employees;

-- Q1:
-- Find the highest salary in each department.
-- Commands/concepts: GROUP BY, MAX()

select department, max(salary) as highest from employees group by department;

-- Q2:
-- Find departments whose average salary is greater than 70000.
-- Commands/concepts: GROUP BY, AVG(), HAVING

select department, avg(salary) as averg from employees group by department having averg >70000;

-- Q3:
-- Find employees earning more than the overall average salary.
-- Display name, department and salary.
-- Commands/concepts: SELECT, WHERE, AVG(), Subquery
-- Do not hardcode the average salary.

select name, salary, department from employees where salary >
(select avg(salary) from employees);

-- Q4:
-- Rank employees based on salary within each department.
-- Display: name, department, salary, salary_rank
-- Commands/concepts: RANK(), OVER(), PARTITION BY, ORDER BY

select name, department, salary, rank() over (partition by department order by salary desc) as salary_rank from employees;


-- Q5:
-- Find the second-highest salary in each department.
-- If two employees have the same salary, treat it as one salary level.
-- Display: name, department, salary
-- Commands/concepts: CTE, DENSE_RANK(), PARTITION BY, ORDER BY

with cte as (
select name, department, salary, dense_rank() over(partition by department order by salary desc) as d_rnk from employees)
select name, department, salary,d_rnk from cte where d_rnk = 2;

-- Q6:
-- For each employee, show:
-- name, joining_date, salary, previous_salary
-- Previous salary should be based on joining_date.
-- Commands/concepts: LAG(), OVER(), ORDER BY

select name, joining_date, salary, lag(salary) over(order by joining_date ) as previous_salary from employees;

-- Q7:
-- Categorize employees based on salary:
-- salary >= 90000       → 'High'
-- salary between 70000 and 89999 → 'Medium'
-- salary < 70000        → 'Low'
-- Display: name, salary, salary_category
-- Commands/concepts: CASE WHEN, ELSE



select name, salary, 
CASE 
    WHEN salary >= 90000 THEN 'High'
    WHEN salary between 70000 and 89999 THEN 'Medium'
    ELSE 'Low'
    END as salary_category
    from employees;
    
    -- Q8:
-- Find the highest-paid employee from each department.
-- If two employees have the same highest salary,
-- return BOTH employees.
--
-- Display: name, department, salary
-- Commands/concepts: CTE, DENSE_RANK(), PARTITION BY, ORDER BY

with cte as (
select name, department, salary, dense_rank() over (partition by department order by salary desc) as d_rnk from employees)
select name, department, salary, d_rnk from cte where d_rnk = 1;

-- Q9:
-- Find employees whose salary is greater than
-- the average salary of their OWN department.
--
-- Display: name, department, salary
-- Commands/concepts: correlated subquery, AVG()

select name, department, salary from employees e where salary > (select avg(salary) from employees where department = e.department);

-- Q10:
-- Find the department having the highest average salary.
-- Display:
-- department, average_salary
--
-- Commands/concepts: GROUP BY, AVG(), ORDER BY, LIMIT

select department, avg(salary) as Average_Sal from employees group by department order by Average_Sal desc limit 1;
    
