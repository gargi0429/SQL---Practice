CREATE DATABASE practiceday16;
USE practiceday16;

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    manager_id INT,
    department VARCHAR(30),
    salary INT,
    joining_date DATE
);

INSERT INTO employees VALUES
(1,'Alice',NULL,'HR',90000,'2018-01-10'),
(2,'Bob',1,'HR',70000,'2019-02-15'),
(3,'Charlie',1,'HR',65000,'2020-05-10'),
(4,'David',2,'HR',50000,'2021-01-05'),
(5,'Eva',2,'HR',45000,'2022-04-18'),
(6,'Frank',NULL,'IT',120000,'2017-03-20'),
(7,'Grace',6,'IT',95000,'2018-08-12'),
(8,'Henry',6,'IT',90000,'2019-11-01'),
(9,'Ivy',7,'IT',70000,'2021-02-14'),
(10,'Jack',7,'IT',65000,'2022-09-25'),
(11,'Kevin',8,'IT',60000,'2023-01-10'),
(12,'Lily',NULL,'Finance',100000,'2016-06-15'),
(13,'Mike',12,'Finance',80000,'2018-04-11'),
(14,'Nancy',13,'Finance',60000,'2020-12-20'),
(15,'Oliver',13,'Finance',55000,'2022-06-30');

-- Create one CTE to display all employees.
-- Create another CTE to display employees whose salary is greater than 50000.
-- Show Employee Name, Department, and Salary.

With one_cte as 
(
 select * from employees
),
high_salary as 
(
 select emp_id, emp_name, department, salary from one_cte where salary > 50000 
)
select * from high_salary;

-- Create one CTE to display employees from the IT department.
-- Create another CTE to sort them by salary in descending order.

With cte_it as 
(
select emp_name, salary, department from employees where department = "IT"
),
sort_cte as 
(
select  emp_name, salary, department from cte_it order by salary desc
)
select * from sort_cte;

-- Create one CTE to display employees earning more than 40000.
-- Create another CTE to display only their names and salaries.

With cte_earn as
(
select emp_name, salary from employees where salary > 40000
),
sec_cte as
(
select emp_name, salary from cte_earn
)
select * from sec_cte;

-- Q4. Create one CTE to find employees who joined before '2020-01-01'. 
-- Create another CTE to find employees earning more than 70000. 
-- Display employees satisfying both conditions.

with cte_join as
(select emp_name, salary, joining_date from employees where joining_date < '2020-01-01'),
cte_earn as
(
select emp_name, salary, joining_date from cte_join where salary > 70000
)
select * from cte_earn;


-- Q5. Create one CTE to calculate the total salary paid by each department. 
-- Create another CTE to calculate each employee's salary contribution percentage within their department.

with total_cte as 
(
select department, sum(salary) as total_sal from employees group by department
),
per_cte as 
(
select e.emp_id, e.emp_name, e.salary, t.total_sal, (e.salary * 100) / t.total_sal as perc from employees e join total_cte t 
on e.department = t.department
)
select * from per_cte;

-- Q6. Create one CTE to calculate the total number of employees in each department. 
-- Create another CTE to display only departments having more than 4 employees.

with tot_emp as 
(
select count(*) as total_emp, department  from employees group by department
),
dept_cte as 
(
select department, total_emp from tot_emp where total_emp > 4
)
select * from dept_cte;


-- Q7. Create one CTE to assign ROW_NUMBER() to employees ordered by joining date within each department. 
-- Create another CTE to display only the first employee hired from each department.
With rno_cte as
(select emp_id, emp_name, department, row_number() over (partition by department order by joining_date) as rno from employees ),
first_cte as
(select emp_id, emp_name, department, rno from rno_cte where rno <= 1)
select * from first_cte;

-- Q8. Create one CTE to calculate the average salary of all employees. 
-- Create another CTE to classify employees as 'Above Average' or 'Below Average' based on the overall average salary.

WITH avg_sal AS
(
    SELECT AVG(salary) AS avg_salary
    FROM employees
),
classify AS
(
    SELECT
        e.emp_id,
        e.emp_name,
        e.salary,
        a.avg_salary,
        CASE
            WHEN e.salary > a.avg_salary THEN 'Above Average'
            ELSE 'Below Average'
        END AS classification
    FROM employees e
    CROSS JOIN avg_sal a
)

SELECT *
FROM classify;


-- Q9. Create one CTE to calculate the department average salary. 
-- Create another CTE to calculate the salary difference between every employee and their department average. 
-- Display Employee Name, Department, Salary, Department Average, and Salary Difference.

WITH avg_sal AS
(
    SELECT
        department,
        AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department
),
diff_cte AS
(
    SELECT
        e.emp_name,
        e.department,
        e.salary,
        a.avg_salary,
        ABS(e.salary - a.avg_salary) AS salary_difference
    FROM employees e
    JOIN avg_sal a
        ON e.department = a.department
)

SELECT *
FROM diff_cte;

-- Q10. Create one CTE to calculate department-wise average salary. 
-- Create another CTE to rank departments based on their average salary from highest to lowest. 
-- Display Department, Average Salary, and Department Rank.

WITH avg_cte AS
(
    SELECT
        department,
        AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department
),
rank_cte AS
(
    SELECT
        department,
        avg_salary,
        RANK() OVER (ORDER BY avg_salary DESC) AS department_rank
    FROM avg_cte
)

SELECT *
FROM rank_cte;