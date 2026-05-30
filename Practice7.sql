
CREATE DATABASE practiceday7;

USE practiceday7;

CREATE TABLE employees (
    emp_id INT,
    emp_name VARCHAR(50),
    dept_id INT,
    manager_id INT,
    salary INT,
    hire_date DATE
);

INSERT INTO employees VALUES
(1,'Amit',101,NULL,90000,'2020-01-10'),
(2,'Neha',101,1,75000,'2021-03-15'),
(3,'Raj',102,1,60000,'2022-06-20'),
(4,'Simran',102,3,65000,'2021-07-11'),
(5,'Karan',103,2,55000,'2023-01-05'),
(6,'Pooja',103,2,50000,'2020-11-18'),
(7,'Vikas',104,4,45000,'2022-04-25'),
(8,'Sneha',104,4,40000,'2023-08-30'),
(9,'Rohit',105,5,70000,'2021-12-12'),
(10,'Meera',105,5,72000,'2020-09-14');

CREATE TABLE departments (
    dept_id INT,
    dept_name VARCHAR(50)
);

INSERT INTO departments VALUES
(101,'HR'),
(102,'IT'),
(103,'Finance'),
(104,'Sales'),
(105,'Marketing'),
(106,'Admin');


-- Q1
-- Create a CTE to display employees
-- earning more than average salary.

With CTE_avg AS 
(
select avg(salary) as Avg_Sal from employees 	
 )
 Select * from employees where salary > 
 (
  select Avg_Sal from CTE_avg
 );



-- Q2
-- Using CTE, find department-wise
-- highest salary employee.

With CTE_max AS
(
  select max(salary) as Highest from employees group by dept_id
)
Select * from CTE_max;

-- Q3
-- Create multiple CTEs to show:
-- department average salary
-- and employees above department average.

With CTE_multiple AS 
(
Select dept_id, avg(salary) as Average from employees group by dept_id
)
Select * from employees e where salary > (select Average from CTE_multiple c where e.dept_id = c.dept_id);

-- Q4
-- Write a recursive CTE to generate numbers from 1 to 10.

WITH RECURSIVE cte_name AS
(
    select 	1 as n

    UNION ALL

    -- Recursive Query
    select n + 1
    from cte_name
    where n < 10
)
SELECT * FROM cte_name;


-- Q6
-- Use LEAD() to show next employee salary
-- Q5
-- Write a recursive CTE to display
-- employee hierarchy using manager_id.
-- within same department.

With Recursive CTE_name AS
(
Select emp_id, emp_name, manager_id, 1 as Level from employees where manager_id is NULL
UNION ALL 
select e.emp_id, e.emp_name, e.manager_id, h.level + 1 from employees e join CTE_name h on e.manager_id = h.emp_id
)
select * from CTE_name;

-- Q7
-- Use LAG() to show previous employee salary
-- within same department.

select emp_id, emp_name, salary,  lag(salary) over(order by salary) as previous from employees;

-- Q8
-- Find salary difference between current
-- and previous employee using LAG().

select emp_id, emp_name, salary,  lag(salary) over(order by salary) as previous,
 salary - lag(salary) over (order by salary) as difference from employees;

-- Q9
-- Assign ROW_NUMBER() to employees
-- department-wise ordered by salary descending.

Select
* from ( select emp_id, emp_name, row_number() over (partition by dept_id order by salary desc) as ROW_Order from employees) x;

-- Q10
-- Find top 2 highest paid employees
-- in each department using ROW_NUMBER().

Select
* from ( select emp_id, emp_name, row_number() over (partition by dept_id order by salary desc) 
as ROW_Order from employees) x where ROW_Order <= 2;

-- Q11
-- Categorize employees using CASE WHEN:
-- salary > 80000 = 'High'
-- salary between 60000 and 80000 = 'Medium'
-- else = 'Low'

select *, 

CASE WHEN salary > 80000 THEN 'High'
	 WHEN salary between 60000 and 80000 then 'Medium'
     else  'Low'
     END as category


from employees;

-- Q12
-- Divide employees into 4 salary buckets
-- using NTILE().


select *, ntile(4) over (order by salary desc) as group_4 from employees;

-- Q13
-- Find departments having employees
-- using EXISTS.

select dept_id, dept_name from departments d
where exists (select 1 from employees e where e.dept_id = d.dept_id);
-- Q14
-- Find departments having no employees
-- using NOT EXISTS.
select dept_id, dept_name from departments d
where not exists (select 1 from employees e where e.dept_id = d.dept_id);