CREATE DATABASE practiceday24;
USE practiceday24;

CREATE TABLE employees (
    employee_id INT,
    employee_name VARCHAR(50),
    department VARCHAR(50),
    salary INT,
    joining_date DATE
);

INSERT INTO employees VALUES
(1, 'Amit', 'IT', 60000, '2022-01-15'),
(2, 'Priya', 'IT', 80000, '2021-06-20'),
(3, 'Rahul', 'HR', 50000, '2023-03-10'),
(4, 'Sneha', 'HR', 70000, '2020-11-05'),
(5, 'Vikas', 'IT', 90000, '2019-08-12'),
(6, 'Neha', 'Sales', 75000, '2022-09-18'),
(7, 'Rohan', 'Sales', 85000, '2021-12-01'),
(8, 'Anjali', 'IT', 80000, '2023-01-25'),
(9, 'Karan', 'Sales', 65000, '2024-02-14'),
(10, 'Meera', 'HR', 60000, '2022-07-30');

-- QUESTION 1
-- Find the departments where the average salary is greater than ₹70,000.

select avg(salary) as Average_Sal, department from employees group by department having avg(salary) > 70000;

-- QUESTION 2
-- Find the employee(s) who have the highest salary
-- in each department.
--
-- Expected columns:
-- employee_name | department | salary
--
-- Do NOT use LIMIT.
-- Try to solve it using a subquery or another SQL technique.

With cte as(
select employee_name , department , salary, rank() over(partition by department order by salary desc) as rnk from employees )
select employee_name , department , salary from cte where rnk = 1;


-- QUESTION 3
-- For every employee, display:
-- employee_name
-- department
-- salary
-- average salary of their department
--
-- Do NOT use GROUP BY.
-- Use a window function.
--
-- Expected columns:
-- employee_name | department | salary | department_avg_salary

select employee_name, department, salary, avg(salary) over (partition by department) as  department_avg_salary from employees;

-- QUESTION 4
-- For each employee, display:
-- employee_name
-- department
-- salary
-- previous employee's salary within the SAME department
--
-- Sort employees within each department by salary from LOW to HIGH.
--
-- Expected columns:
-- employee_name | department | salary | previous_salary
--
-- Use LAG().

select employee_name, department, salary, lag(salary) over (partition by department order by salary asc) as previous_salary from employees;


-- QUESTION 5
-- For each employee, display:
-- employee_name
-- department
-- salary
-- next_salary
--
-- Find the next higher salary within the SAME department.
-- Sort salaries from LOW to HIGH.
--
-- Use LEAD().
--
-- Expected columns:
-- employee_name | department | salary | next_salary

select employee_name, department, salary, lead(salary) over (partition by department order by salary asc) as next_salary from employees;

-- QUESTION 6
-- Assign a unique row number to every employee
-- within their department.
--
-- Highest salary should get row number 1.
--
-- Expected columns:
-- employee_name | department | salary | row_num
--
-- Use ROW_NUMBER().

select employee_name, department, salary, row_number() over (partition by department order by salary desc) as row_num from employees;

-- QUESTION 7
-- Rank employees within each department based on salary.
-- Highest salary should have rank 1.
--
-- If two employees have the same salary,
-- they should receive the SAME rank.
--
-- Do NOT use RANK().
-- Use DENSE_RANK().
--
-- Expected columns:
-- employee_name | department | salary | salary_rank

select employee_name, department, salary, dense_rank() over (partition by department order by salary desc) as salary_rank from employees;

-- QUESTION 8
-- Categorize each employee based on salary:
--
-- salary >= 80000  → 'High'
-- salary >= 60000  → 'Medium'
-- salary < 60000   → 'Low'
--
-- Display:
-- employee_name | salary | salary_category
--
-- Use CASE WHEN.

select employee_name, salary,
case when salary >= 80000 then "high"
when salary >= 60000 then "Medium"
when salary < 60000 then "low"
end as salary_category
from employees;

-- QUESTION 9
-- Count how many employees fall into each salary category.
--
-- Categories:
-- salary >= 80000 → High
-- salary >= 60000 → Medium
-- salary < 60000  → Low
--
-- Expected columns:
-- salary_category | employee_count
--
-- Use CASE WHEN + GROUP BY.

select
case when salary >= 80000 then "high"
when salary >= 60000 then "Medium"
when salary < 60000 then "low"
end as salary_category, count(employee_id) as employee_count
from employees group by case when salary >= 80000 then "high"
when salary >= 60000 then "Medium"
when salary < 60000 then "low"
end;


-- QUESTION 10
-- Find employees whose salary is greater than
-- the average salary of their own department.
--
-- Expected columns:
-- employee_name | department | salary
--
-- Use a CORRELATED SUBQUERY.
--
-- Do NOT use a window function.
-- Do NOT use GROUP BY.

select employee_name, department, salary from employees e where salary > (select avg(salary) from employees where department = e.department);

-- QUESTION 11
CREATE TABLE departments (
    department_id INT,
    department_name VARCHAR(50)
);

INSERT INTO departments (department_id, department_name)
VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Sales'),
(4, 'Finance');
-- Find all departments that have at least one employee.
--
-- Return:
-- department_name
--
-- Use EXISTS.
-- Do NOT use JOIN.

SELECT department_name
FROM departments d
WHERE EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.department = d.department_name
);


-- Find departments that have NO employees.
-- Return only department_name.
-- Use NOT EXISTS.
-- Do NOT use JOIN.

SELECT department_name
FROM departments d
WHERE not EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.department = d.department_name
);

-- Find all employees who have the maximum salary
-- in the entire company.
--
-- Return:
-- employee_name | department | salary
--
-- Use a subquery with MAX().
-- Do NOT use ORDER BY.
-- Do NOT use LIMIT.
DESC employees;

SELECT employee_name, department, salary
FROM practiceday24.employees
WHERE salary = (
    SELECT MAX(salary)
    FROM practiceday24.employees
);

-- Find the employee(s) who have the second-highest salary
-- in the entire company.
--
-- Return:
-- employee_name | department | salary
--
-- Do NOT use LIMIT.
-- Do NOT use OFFSET.
-- Handle duplicate salaries correctly.

SELECT employee_name, department, salary
FROM employees
WHERE salary = (
    SELECT MAX(salary)
    FROM employees
    WHERE salary < (
        SELECT MAX(salary)
        FROM employees
    )
);

-- QUESTION 15
-- Find departments having more than 2 employees.
--
-- Return:
-- department | employee_count
--
-- Use GROUP BY and HAVING.

SELECT department, COUNT(*) AS employee_count
FROM employees
GROUP BY department
HAVING COUNT(*) > 2;
