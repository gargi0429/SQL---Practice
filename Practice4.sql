-- =====================================================
-- SQL DAY 4
-- TOPICS:
-- 1. JOINS (INNER, LEFT, RIGHT, SELF)
-- 2. GROUP BY + HAVING
-- 3. WINDOW FUNCTIONS
-- 4. RANK(), DENSE_RANK(), ROW_NUMBER()
-- 5. CTEs
-- 6. Mixed Data Analyst Questions
-- =====================================================

-- =====================================================
-- PATTERN TO SOLVE QUESTIONS
-- =====================================================

-- EASY QUESTIONS
-- Pattern:
-- 1. Understand required columns
-- 2. Identify table
-- 3. Apply WHERE if needed
-- 4. Use GROUP BY only if aggregation exists

-- MEDIUM QUESTIONS
-- Pattern:
-- 1. Identify tables and JOIN condition
-- 2. Think aggregation/grouping
-- 3. Use HAVING for grouped filtering
-- 4. Break problem into:
--      a) filtering
--      b) grouping
--      c) sorting

-- HARD QUESTIONS
-- Pattern:
-- 1. Read output carefully
-- 2. Decide:
--      a) JOIN?
--      b) SUBQUERY?
--      c) CTE?
--      d) WINDOW FUNCTION?
-- 3. Solve step-by-step
-- 4. First create intermediate result
-- 5. Then final filtering/ranking

-- WINDOW FUNCTION PATTERN
-- 1. PARTITION BY = grouping
-- 2. ORDER BY = ranking order
-- 3. Choose:
--      ROW_NUMBER()
--      RANK()
--      DENSE_RANK()

-- =====================================================
-- DATASET
-- =====================================================

create database practiceday4;
use practiceday4;

create table departments(
    dept_id int primary key,
    dept_name varchar(50)
);

insert into departments values
(1,'HR'),
(2,'IT'),
(3,'Finance'),
(4,'Marketing');

create table employees(
    emp_id int primary key,
    emp_name varchar(50),
    dept_id int,
    salary int,
    manager_id int,
    joining_date date,
    city varchar(50),
    foreign key(dept_id) references departments(dept_id)
);

insert into employees values
(101,'Amit',2,75000,NULL,'2021-01-10','Pune'),
(102,'Sneha',1,50000,101,'2022-02-15','Mumbai'),
(103,'Rahul',2,80000,101,'2020-06-20','Pune'),
(104,'Priya',3,65000,103,'2021-07-11','Delhi'),
(105,'Neha',4,55000,101,'2023-03-19','Mumbai'),
(106,'Karan',2,90000,103,'2019-11-25','Bangalore'),
(107,'Simran',1,48000,102,'2022-08-30','Pune'),
(108,'Arjun',3,72000,103,'2020-09-17','Delhi'),
(109,'Meera',4,60000,105,'2021-12-01','Mumbai'),
(110,'Rohit',2,85000,106,'2018-04-21','Bangalore');

create table projects(
    project_id int primary key,
    project_name varchar(50),
    emp_id int,
    project_cost int,
    foreign key(emp_id) references employees(emp_id)
);

insert into projects values
(1,'Banking App',101,500000),
(2,'Ecommerce',103,300000),
(3,'Insurance AI',106,700000),
(4,'HR Portal',102,150000),
(5,'Marketing Dashboard',109,200000),
(6,'Finance Tracker',104,250000),
(7,'CRM System',110,400000);

-- =====================================================
-- EASY QUESTIONS
-- =====================================================

-- Q1 (5 min)
-- Display employee name and salary of all employees.

Select emp_name, salary from employees;

-- Q2 (5 min)
-- Show all employees whose salary is greater than 70000

select emp_id, emp_name, salary from employees where salary > 70000;

-- Q3 (6 min)
-- Display employee names and their department names using JOIN.

select d.dept_name, emp_name from employees e JOIN departments d  on e.dept_id = d.dept_id;

-- Q4 (7 min)
-- Find total number of employees in each department.

select count(*) from employees group by dept_id;

-- Q5 (7 min)
-- Find average salary department-wise.

select avg(salary) from employees group by dept_id;

-- =====================================================
-- MEDIUM QUESTIONS
-- =====================================================

-- Q6 (10 min)
-- Show department names where average salary is greater than 70000.
-- Pattern:
-- 1. JOIN employees + departments
-- 2. GROUP BY department
-- 3. AVG(salary)
-- 4. HAVING condition
select d.dept_name,
avg(e.salary) as Avg_Sal
from employees e
join departments d
on e.dept_id = d.dept_id
group by d.dept_name
having avg(e.salary) > 70000;

-- Q7 (10 min)
-- Find employees who belong to Mumbai city and work in Marketing department.
-- Pattern:
-- 1. JOIN employees + departments
-- 2. Apply multiple WHERE conditions

select d.dept_name, emp_name,
city
from employees e
join departments d
on e.dept_id = d.dept_id
where d.dept_name = "Marketing" and city = "Mumbai";


-- Q8 (12 min)
-- Display employee name, salary, and rank based on highest salary.
-- Pattern:
-- 1. Use RANK()
-- 2. ORDER BY salary DESC

select emp_name, salary , rank() over( order by salary desc) as new_rank from employees;

-- Q9 (12 min)
-- Display highest salary employee from each department.
-- Pattern:
-- 1. Use window function
-- 2. PARTITION BY dept_id
-- 3. ORDER BY salary DESC
-- 4. Filter rank = 1


select emp_name, salary , rank() over(partition by dept_id order by salary desc) as new_rank from employees;

-- Q10 (12 min)
-- Find total project cost handled by each employee.
-- Pattern:
-- 1. JOIN employees + projects
-- 2. GROUP BY employee
-- 3. SUM(project_cost)

select emp_name, sum(p.project_cost) as total_cost from employees e Join projects p on e.emp_id = p.emp_id group by e.emp_name;


-- =====================================================
-- HARD QUESTIONS
-- =====================================================

-- Q11 (15 min)
-- Find second highest salary employee.
-- Pattern:
-- 1. Use DENSE_RANK()
-- 2. ORDER BY salary DESC
-- 3. Filter rank = 2

select * 
 from (
	select emp_name, salary, 
    dense_rank() 
    over(order by salary desc) as drk
    from employees 
    ) x
    where drk = 2; 


-- Q12 (15 min)
-- Display managers and count of employees working under them.
-- Pattern:
-- 1. SELF JOIN employees table
-- 2. manager_id = emp_id
-- 3. GROUP BY manager

select m.emp_name as manager_name, count(e.emp_id) as 
employee_count from employees e JOIN employees m on e.manager_id = m.emp_id group by m.emp_name;

-- Q13 (18 min)
-- Find employees earning more than department average salary.
-- Pattern:
-- 1. Calculate department average
-- 2. Compare employee salary with avg
-- 3. Use subquery OR CTE

select emp_id, emp_name from employees e where salary > ALL (select avg(salary) as Avg_Sal from employees where dept_id = e.dept_id);

-- Q14 (18 min)
-- Display top 2 highest paid employees from each department.
-- Pattern:
-- 1. Use DENSE_RANK()
-- 2. PARTITION BY dept_id
-- 3. ORDER BY salary DESC
-- 4. Filter rank <= 2

select * from
  (select emp_id, emp_name, salary, dept_id, 
  dense_rank() over(partition by dept_id order by salary desc)
  as new_rank
  from employees )x
  where new_rank > 2;

-- Q15 (20 min)
-- Find department having highest total salary expense.
-- Pattern:
-- 1. GROUP BY department
-- 2. SUM(salary)
-- 3. ORDER BY total DESC
-- 4. LIMIT 1 OR DENSE_RANK()


select dept_id, sum(salary) as total_salary from employees group by dept_id order by total_salary desc limit 1;

-- =====================================================
-- INTERVIEW-SPECIFIC DATA ANALYST QUESTIONS
-- =====================================================

-- IQ1 (15 min)
-- Calculate percentage contribution of each department salary
-- compared to total company salary.

select dept_id, 
  (sum(salary) * 100.0 / (select sum(salary) from employees))
  as percentage
  from employees
  group by dept_id;



-- IQ2 (15 min)
-- Find month-wise joining count of employees.

select count(emp_id) , month(joining_date) as Month from employees group by month(joining_date);

-- IQ3 (18 min)
-- Find cumulative salary expense department-wise.
-- Pattern:
-- Use SUM() OVER()

select emp_name, dept_id, emp_id, sum(salary) over(partition by dept_id order by salary desc) as new_sum from employees;

-- IQ4 (20 min)
select *
from employees
where salary in
(
    select salary
    from employees
    group by salary
    having count(*) > 1
);


-- IQ5 (20 min)
-- Find gap between highest and lowest salary in each department.

select dept_id, max(salary) - min(salary) as gap from employees group by dept_id;