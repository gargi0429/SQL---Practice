
CREATE DATABASE practiceday8;

USE practiceday8;


CREATE TABLE employee (
    emp_id INT,
    emp_name VARCHAR(50),
    dept_id INT,
    salary INT
);

INSERT INTO employee VALUES
(101,'Amit',1,50000),
(102,'Neha',1,65000),
(103,'Raj',2,70000),
(104,'Priya',2,80000),
(105,'Karan',3,45000),
(106,'Sneha',3,55000),
(107,'Vikas',1,75000),
(108,'Pooja',2,65000),
(109,'Rohan',3,90000),
(110,'Anjali',1,52000);

CREATE TABLE department (
    dept_id INT,
    dept_name VARCHAR(50)
);

INSERT INTO department VALUES
(1,'HR'),
(2,'IT'),
(3,'Finance'),
(4,'Marketing');


########### CTE & RECURSIVE CTE PRACTICE ############################

-- ==========================================
-- Q1
-- Display employees earning more than
-- company average salary using CTE.
-- ==========================================

WITH cte_avg AS 
(
Select avg(salary) AS Avg_Sal from employee 
)
Select * from employee where salary  >
(
   Select Avg_Sal from cte_avg 
);


-- ==========================================
-- Q2
-- Find department-wise average salary
-- using a CTE.
-- ==========================================

WITH Cte_avg AS
(
select dept_id, avg(salary) from employee group by dept_id
)
select * from cte_avg;

-- ==========================================
-- Q3
-- Show employees whose salary is above
-- their department average salary.
-- ==========================================
With Cte_avg As(
select dept_id, avg(salary) as Average from employee group by dept_id)
Select e.* from employee e JOIN Cte_avg c ON e.dept_id = c.dept_id where e.salary > c.Average; 


-- ==========================================
-- Q4
-- Find highest paid employee
-- in each department using CTE.
-- ==========================================
with cte_max as
(
select dept_id, max(salary) as Highest from employee group by dept_id
)
select Highest from cte_max order by Highest desc;

############# using join ####################################
with cte_max as
(
select dept_id, max(salary) as Highest from employee group by dept_id
)

select e.emp_name, e.dept_id, e.salary from employee e Join cte_max c where e.dept_id = c.dept_id And e.salary = c.Highest;

-- ==========================================
-- Q5
-- Find departments whose total salary
-- is greater than 150000.
-- ==========================================

select dept_id, sum(salary) as Total from employee group by dept_id having sum(salary) > 150000;

##################################### using cte ################################################
with cte_total as 
(
select dept_id, sum(salary) as total from employee group by dept_id
)
select * from cte_total where total > 150000;

-- ==========================================
-- Q6
-- Rank employees by salary within
-- each department using CTE.
-- ==========================================

with cte_rank as(
select dept_id, emp_id, salary, rank() over(partition by dept_id order by salary desc) as rnk from employee)
select * from cte_rank;

-- ==========================================
-- Q7
-- Find second highest salary
-- in the company using CTE.
-- ==========================================

With cte_sec_highest AS
(
select *, dense_rank() over(order by salary desc) As second_highest from employee
)
select * from cte_sec_highest where second_highest = 2;
################## use dense rank to manage duplicates ############################

-- ==========================================
-- Q8
-- Show cumulative salary department-wise
-- using CTE and window function.
-- ==========================================

With cte_total as
(
select dept_id, emp_id,salary, sum(salary) over (partition by dept_id order by salary ) as cumulative from employee
)
select * from cte_total;

-- ==========================================	
-- Q9
-- Find duplicate salaries using CTE.
-- ==========================================
TRUNCATE TABLE employee;
With cte_duplicates as
(
select salary, count(*) as cnt from employee group by salary
)
select * from cte_duplicates where cnt > 1;
-- ==========================================
-- Q10
-- Show employee name, salary,
-- department average salary,
-- and difference from department average.
-- ==========================================
WITH cte_avg AS (
    SELECT dept_id,
           AVG(salary) AS avg_salary
    FROM employee
    GROUP BY dept_id
)

SELECT emp_name,
       salary,
       avg_salary,
       salary - avg_salary AS difference
FROM employee e
JOIN cte_avg c
ON e.dept_id = c.dept_id;

-- ==========================================
-- IQ1
-- What is CTE?
-- ==========================================


-- ==========================================
-- IQ2
-- Difference between
-- CTE and Subquery.
-- ==========================================


-- ==========================================
-- IQ3
-- Can we use multiple CTEs
-- in a single query?
-- ==========================================


-- ==========================================
-- IQ4
-- Can a CTE reference another CTE?
-- ==========================================


-- ==========================================
-- IQ5
-- What is Recursive CTE?
-- ==========================================