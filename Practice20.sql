CREATE DATABASE practiceday20;
USE practiceday20;

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(30),
    salary INT,
    manager_id INT,
    joining_date DATE
);

INSERT INTO employees VALUES
(1, 'Amit',   'IT',      75000, NULL, '2021-01-10'),
(2, 'Priya',  'IT',      65000, 1,    '2022-03-15'),
(3, 'Rahul',  'IT',      90000, 1,    '2020-06-20'),
(4, 'Sneha',  'HR',      55000, NULL, '2021-08-12'),
(5, 'Karan',  'HR',      70000, 4,    '2022-01-25'),
(6, 'Neha',   'Sales',   60000, NULL, '2021-05-18'),
(7, 'Rohan',  'Sales',   85000, 6,    '2020-11-11'),
(8, 'Pooja',  'Sales',   75000, 6,    '2022-07-01'),
(9, 'Vikas',  'IT',      90000, 1,    '2023-02-14'),
(10,'Anjali',  'Finance', 80000, NULL, '2021-09-30'),
(11,'Arjun',  'Finance', 65000, 10,   '2022-12-05'),
(12,'Meera',  'Finance', 95000, 10,   '2020-04-22');

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    emp_id INT,
    sale_date DATE,
    amount INT,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

INSERT INTO sales VALUES
(101, 6, '2026-01-05', 50000),
(102, 7, '2026-01-06', 80000),
(103, 8, '2026-01-10', 60000),
(104, 6, '2026-01-15', 70000),
(105, 7, '2026-02-03', 90000),
(106, 8, '2026-02-10', 75000),
(107, 6, '2026-02-18', 55000),
(108, 7, '2026-03-01', 100000),
(109, 8, '2026-03-05', 65000),
(110, 6, '2026-03-12', 90000);

-- Q1. Find the second-highest salary among all employees.
-- Do NOT use LIMIT with OFFSET.

with cte as (
select emp_name, salary , dense_rank() over (order by salary desc) as rnk from employees) 
select emp_name, salary from cte where rnk = 2;


-- Q2. Find employees whose salary is greater than the
-- average salary of their own department.

select emp_name, salary, department from employees e where salary > (select avg(salary) from employees where department = e.department);


-- Q3. Find the highest-paid employee in each department.
-- If multiple employees have the same highest salary,
-- return ALL of them.

with cte as
(select emp_name, salary, department, rank() over (partition by department order by salary desc) as rnk from employees )
select emp_name,salary, department from cte where rnk = 1;

-- Q4. Rank employees by salary within each department.
-- Display:
-- emp_name, department, salary, salary_rank
-- Use DENSE_RANK().

with cte as
(select emp_name, salary, department, dense_rank() over (partition by department order by salary desc) as rnk from employees )
select emp_name,salary, department from cte;


-- Q5. Find employees who earn more than their manager.
-- Display employee name, employee salary,
-- manager name, and manager salary.

select e.emp_name, e.salary, m.emp_name, m.salary from employees e
Inner Join employees m
on e.manager_id = m.emp_id
where e.salary > m.salary;


-- Q6. Find the top 2 highest-paid employees from each department.
-- If there is a tie, handle it appropriately.

with cte as (
select emp_name, salary , department, rank() over (partition by department order by salary desc) as rnk from employees) 
select emp_name, salary, department from cte where rnk <= 2;

-- Q7. For every employee in the Sales department,
-- calculate their total sales and show:
-- employee name, total_sales.
-- Include employees who have made NO sales.

select emp_name, coalesce(sum(s.amount)) as total_sales from employees e left join sales s on e.emp_id = s.emp_id
 where department = "Sales" group by e.emp_name;

-- Q8. Calculate a running total of sales ordered by sale_date.
-- Display:
-- sale_date, amount, running_total.

Select sale_date, amount, sum(amount) over(order by sale_date rows between unbounded preceding and current row) as running_total from Sales;

-- Q9. Find the employee who generated the highest total sales.
-- Display employee name and total sales.
WITH employee_sales AS (
    SELECT 
        e.emp_name,
        SUM(s.amount) AS total_sales
    FROM employees e
    JOIN sales s
        ON e.emp_id = s.emp_id
    GROUP BY e.emp_id, e.emp_name
)
SELECT emp_name, total_sales
FROM employee_sales
WHERE total_sales = (
    SELECT MAX(total_sales)
    FROM employee_sales
);

-- Q10. Find employees whose salary is higher than the
-- previous employee's salary within the same department
-- when employees are ordered by joining_date.
-- Display:
-- employee name, department, salary,
-- previous_employee_salary.
-- Use LAG().

WITH cte AS (
    SELECT 
        emp_name,
        department,
        salary,
        LAG(salary) OVER (
            PARTITION BY department
            ORDER BY joining_date
        ) AS previous_employee_salary
    FROM employees
)
SELECT 
    emp_name,
    department,
    salary,
    previous_employee_salary
FROM cte
WHERE salary > previous_employee_salary;
