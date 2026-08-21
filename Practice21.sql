-- ============================================
-- INTERVIEW LEVEL SQL PRACTICE DATASET
-- ============================================

create database practiceday21;
use practiceday21;


CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(50),
    salary INT,
    manager_id INT,
    joining_date DATE
);

INSERT INTO employees VALUES
(1, 'Amit', 'Sales', 55000, NULL, '2021-01-15'),
(2, 'Priya', 'Sales', 72000, 1, '2020-06-10'),
(3, 'Rahul', 'IT', 85000, NULL, '2019-03-20'),
(4, 'Sneha', 'IT', 65000, 3, '2022-07-11'),
(5, 'Karan', 'HR', 60000, NULL, '2021-09-01'),
(6, 'Neha', 'HR', 48000, 5, '2023-02-14'),
(7, 'Vikas', 'Sales', 90000, 1, '2018-11-25'),
(8, 'Pooja', 'IT', 78000, 3, '2020-12-05'),
(9, 'Rohan', 'Finance', 95000, NULL, '2017-04-18'),
(10, 'Anjali', 'Finance', 70000, 9, '2022-01-30'),
(11, 'Sahil', 'Sales', 62000, 1, '2023-05-19'),
(12, 'Meera', 'IT', 92000, 3, '2018-08-22'),
(13, 'Arjun', 'Finance', 88000, 9, '2021-10-12'),
(14, 'Isha', 'HR', 55000, 5, '2022-11-03'),
(15, 'Dev', 'Sales', 72000, 1, '2024-01-08');


CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    emp_id INT,
    sale_date DATE,
    amount INT,
    region VARCHAR(30),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

INSERT INTO sales VALUES
(101, 1, '2024-01-05', 12000, 'Pune'),
(102, 2, '2024-01-10', 18000, 'Mumbai'),
(103, 7, '2024-01-12', 25000, 'Delhi'),
(104, 11, '2024-01-15', 14000, 'Pune'),
(105, 2, '2024-02-05', 22000, 'Mumbai'),
(106, 7, '2024-02-11', 30000, 'Delhi'),
(107, 1, '2024-02-18', 16000, 'Pune'),
(108, 15, '2024-02-20', 19000, 'Mumbai'),
(109, 11, '2024-03-03', 21000, 'Pune'),
(110, 7, '2024-03-08', 27000, 'Delhi'),
(111, 2, '2024-03-15', 15000, 'Mumbai'),
(112, 15, '2024-03-20', 23000, 'Mumbai'),
(113, 1, '2024-04-02', 17000, 'Pune'),
(114, 7, '2024-04-10', 35000, 'Delhi'),
(115, 11, '2024-04-18', 12000, 'Pune'),
(116, 15, '2024-04-22', 28000, 'Mumbai'),
(117, 2, '2024-05-05', 26000, 'Mumbai'),
(118, 7, '2024-05-12', 32000, 'Delhi'),
(119, 1, '2024-05-20', 19000, 'Pune'),
(120, 15, '2024-05-25', 31000, 'Mumbai');


CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    department VARCHAR(50),
    location VARCHAR(50)
);

INSERT INTO departments VALUES
(1, 'Sales', 'Mumbai'),
(2, 'IT', 'Pune'),
(3, 'HR', 'Delhi'),
(4, 'Finance', 'Bangalore');


-- Q1. Find the employee who generated the highest total sales.
-- Display employee name and total sales.

With cte as (
select e.emp_name, sum(amount) as total_sales from employees e left join Sales s on e.emp_id = s.emp_id group by e.emp_name) 
select emp_name, total_sales from cte order by total_sales desc limit 1;

-- Q2. Find the second-highest paid employee in each department.
-- Display department, employee name and salary.

with cte as 
(
select emp_name, department,salary, rank() over (partition by department order by salary desc ) as rnk from employees 
)
select emp_name, department, salary from cte where rnk = 2;

-- Q3. Find employees whose salary is greater than the average salary
-- of their respective department.
-- Display employee name, department and salary.


select emp_name, department, salary from employees e where salary > 
(select avg(salary) from employees where department = e.department);

-- Q4. Find the department having the highest total salary.
-- Display department and total salary.

select department, sum(salary) as tot_sal from employees group by department order by tot_sal desc limit 1;


-- Q5. Find employees who have never generated any sales.
-- Display employee name and department.

SELECT emp_name, department
FROM employees e
WHERE NOT EXISTS (
    SELECT 1
    FROM sales s
    WHERE s.emp_id = e.emp_id
);


-- Q6. Find the top 3 employees with the highest total sales.
-- Display employee name, department and total sales.

with cte as (
select e.emp_name, e.department, coalesce(sum(amount)) as total_sales from employees e left join sales s
on e.emp_id = s.emp_id GROUP BY e.emp_id, e.emp_name, e.department) 
select emp_name, department, total_sales from cte  order by total_sales desc limit 3;


-- Q7. Find the employee(s) whose total sales are greater than
-- the average total sales of all employees who have made sales.
-- Display employee name and total sales.

with cte as 
(
select e.emp_name, sum(s.amount) as total_sales from employees e join sales s on e.emp_id = s.emp_id group by e.emp_name )
select emp_name, total_sales from cte where total_sales > (select avg(total_sales) from cte);

-- Q8. Find the highest-selling employee in each region.
-- Display region, employee name and total sales.

with cte as 
(
select e.emp_name, s.region, sum(s.amount) as total_sales, 
rank() over(partition by s.region order by sum(s.amount) desc) as rnk 
from employees e join sales s on e.emp_id = s.emp_id group by e.emp_name, s.region
) 
select emp_name, region, total_sales from cte  where rnk = 1;

-- Q9. Find employees who earn more than their manager.
-- Display employee name, employee salary, manager name and manager salary.

select e.emp_name, e.salary, m.emp_name, m.salary from employees e inner join employees m on
m.emp_id = e.manager_id where e.salary > m.salary;


-- Q10. Find the department-wise salary rank of every employee.
-- Display employee name, department, salary and rank.
-- Employees with the same salary should receive the same rank.

select emp_name, department, salary, rank() over (partition by department order by salary desc) from employees;

-- Q11. Find the running total of sales for each employee.
-- Display employee name, sale date, amount and cumulative sales.

select e.emp_name, s.sale_date, s.amount, sum(s.amount) over ( partition by e.emp_name
order by sale_date rows between unbounded preceding and current row) as 
cumulative_sales from employees e left join sales s on e.emp_id = s.emp_id;

-- Q12. Find the month with the highest total sales.
-- Display month and total sales.

With cte as (
select month(sale_date) as mnth, sum(amount) as total_sales from Sales group by  YEAR(sale_date), month(sale_date) ) 
select total_sales, mnth from cte order by total_sales desc limit 1;


-- Q13. Find employees who generated sales in at least 3 different months.
-- Display employee name and number of distinct months.

SELECT 
    e.emp_name, 
    COUNT(DISTINCT MONTH(s.sale_date)) AS distinct_months_count
FROM employees e
INNER JOIN sales s ON e.emp_id = s.emp_id
GROUP BY e.emp_id, e.emp_name
HAVING COUNT(DISTINCT MONTH(s.sale_date)) >= 3;

-- Q14. Find the employee with the highest sale amount in each month.
-- Display month, employee name and sale amount.

with cte as (
select month(s.sale_date) as sale_month, e.emp_name, s.amount, rank () over (partition by month(s.sale_date) order by (s.amount) desc) 
as rnk from employees e right join sales s on s.emp_id = e.emp_id)
 select emp_name, amount, sale_month from cte where rnk = 1;
 

-- Q15. Find the department whose average salary is greater than
-- the overall company average salary.
-- Display department and department average salary.

with cte as (
Select department, avg(salary) as dept_avg_sal from employees group by department)
select department, dept_avg_sal from cte where dept_avg_sal > (select avg(salary) from employees);