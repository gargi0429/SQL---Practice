create database practiceday18;
use practiceday18;
/*
=========================================================
COMMON DATASET FOR ALL 10 CTE QUESTIONS
=========================================================
*/

CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(30),
    manager_id INT,
    salary INT,
    hire_date DATE,
    city VARCHAR(30)
);

INSERT INTO Employees VALUES
(101,'John','HR',201,65000,'2022-01-10','Pune'),
(102,'Alice','HR',201,80000,'2021-03-15','Mumbai'),
(103,'Bob','HR',201,72000,'2023-06-01','Pune'),
(104,'David','IT',202,95000,'2020-02-20','Delhi'),
(105,'Emma','IT',202,91000,'2022-07-18','Delhi'),
(106,'Tom','IT',202,70000,'2023-04-25','Mumbai'),
(107,'Sara','Finance',203,68000,'2021-11-30','Pune'),
(108,'Mike','Finance',203,75000,'2022-09-12','Mumbai'),
(201,'Robert','HR',NULL,120000,'2018-01-01','Pune'),
(202,'Sophia','IT',NULL,130000,'2017-05-10','Delhi'),
(203,'James','Finance',NULL,125000,'2019-08-20','Mumbai');

/*
=========================================================
CTE INTERVIEW QUESTIONS
=========================================================
*/
-- 1. Find the employee with the second highest salary in each department.

With CTE as 
( 
Select emp_name, department, salary,rank() over (partition by department order by salary desc) as rnk from employees )
select emp_name, department, salary from CTE where rnk = 2;

-- 2. Find employees earning more than the average salary of their department.

With Cte_avg as (
select emp_name, department, salary, avg(salary) over (partition by department) as avg_sal from employees ) 
select emp_name, department, salary from Cte_avg 
where salary > avg_sal;

-- 3. Find the top 2 highest-paid employees in each department.

With CTE as 
( 
Select emp_name, department, salary, dense_rank() over (partition by department order by salary desc) as d_rnk from employees )
select emp_name, department, salary from CTE where d_rnk <= 2;

-- 4. Rank employees by salary within each department using DENSE_RANK().

With CTE as 
( 
Select emp_name, department, salary, dense_rank() over (partition by department order by salary desc) as d_rnk from employees )
select emp_name, department, salary, d_rnk from CTE;

	-- 5. Find the department with the highest average salary.

	With Cte_avg as 
	(
    select department, avg(salary) as avg_sal , rank() over (order by avg(salary) desc) as rnk from employees group by department )
	select department, avg_sal from Cte_avg where rnk = 1;

-- 6. Find employees whose salary is higher than their manager's salary.	

with cte_join as (
select e.emp_name, e.salary as emp_sal, m.emp_name as manager_name, m.salary as manager_sal
 from employees e inner join employees m on  e.manager_id = m.emp_id)
select emp_name, emp_sal, manager_name, manager_sal from cte_join where emp_sal > manager_sal;		

-- 7. Display each employee along with the average salary of their department.

 with cte as(
select emp_name, salary, department, avg(salary) over (partition by department ) as avg_sal from employees) 
select emp_name, salary, department, avg_sal from cte;

-- 8. Find employees hired after the average hire date of their department.

with cte as
(
select emp_name, department,
        hire_date, avg(hire_date) over (partition by department) as avg_date from employees )

select emp_name, department,
        hire_date from cte where hire_date > avg_date;

-- 9. Find the difference between each employee's salary and their department's average salary.

with cte as
(
select 
        emp_name,
        department,
        salary, avg(salary) over (partition by department) as dept_avg_sal from employees  )
select
    emp_name,
    department,
    salary,
    dept_avg_sal, (salary - dept_avg_sal) as sal_diff from cte ;

-- 10. Using a RECURSIVE CTE, display the complete employee hierarchy starting from the top-level managers.

WITH RECURSIVE EmployeeHierarchy AS
(
    -- Anchor Member (Top-level managers)
    SELECT
        emp_id,
        emp_name,
        manager_id,
        department,
        1 AS level
    FROM Employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive Member
    SELECT
        e.emp_id,
        e.emp_name,
        e.manager_id,
        e.department,
        eh.level + 1
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh
        ON e.manager_id = eh.emp_id
)

SELECT
    emp_id,
    emp_name,
    manager_id,
    department,
    level
FROM EmployeeHierarchy
ORDER BY level, emp_id;

Select 1 as n


