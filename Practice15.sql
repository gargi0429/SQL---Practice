CREATE DATABASE practiceday15;
USE practiceday15;

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(30),
    designation VARCHAR(30),
    city VARCHAR(30),
    salary INT,
    joining_date DATE,
    performance_score INT
);

INSERT INTO employees VALUES
(101,'Amit','IT','Developer','Pune',65000,'2021-01-15',88),
(102,'Neha','IT','Developer','Mumbai',72000,'2020-03-12',91),
(103,'Rohan','HR','Executive','Delhi',45000,'2022-06-10',80),
(104,'Sneha','Finance','Analyst','Pune',68000,'2019-09-25',92),
(105,'Karan','IT','Tester','Pune',58000,'2023-01-18',78),
(106,'Priya','Finance','Manager','Mumbai',92000,'2018-11-30',95),
(107,'Rahul','HR','Manager','Delhi',80000,'2017-04-19',90),
(108,'Anjali','Sales','Executive','Bangalore',50000,'2022-08-20',82),
(109,'Vikas','Sales','Manager','Mumbai',95000,'2019-05-11',94),
(110,'Meera','IT','Developer','Pune',72000,'2021-10-01',89),
(111,'Nikhil','Finance','Analyst','Delhi',70000,'2020-07-16',84),
(112,'Pooja','Sales','Executive','Pune',52000,'2023-02-14',77),
(113,'Arjun','IT','Manager','Mumbai',98000,'2018-01-05',97),
(114,'Kriti','HR','Executive','Pune',47000,'2021-09-09',79),
(115,'Sahil','Finance','Executive','Mumbai',62000,'2022-12-01',85);

-- Q1. Assign a row number to every employee based on salary (highest to lowest).

Select emp_id, emp_name, salary, row_number() over (order by salary desc) as rn from employees;

-- Q2. Assign a rank to employees based on salary.
-- If two employees have the same salary, the rank should skip.

select emp_id, emp_name, salary, rank() over (order by salary desc) as rnk from employees;

-- Q3. Assign a dense rank to employees based on salary.
-- If two employees have the same salary, ranks should not skip.

Select emp_name, salary, dense_rank() over (order by salary) as drnk from employees;

-- Q4. Find the top 2 highest-paid employees from each department.

Select emp_id, emp_name, salary, rank() over (order by salary desc) as rno from employees limit 2;

-- Q5. Display each employee along with the previous employee's salary
-- based on joining date.

select emp_id, emp_name, joining_date, salary, lag(salary) over (order by joining_date, emp_id) as prev_sal from employees; 

-- Q6. Display each employee along with the next employee's salary
-- based on joining date.

select emp_id, emp_name, joining_date, salary, lead(salary) over (order by joining_date, emp_id) as next_sal from employees; 

-- Q7. Calculate the running total of salaries
-- ordered by joining date.

select emp_id, emp_name, salary, sum(salary) over ( order by joining_date rows between unbounded preceding and current row)
 as running_total from
employees;

-- Q8. Display each employee along with the total salary
-- of their department.

select emp_id, emp_name, sum(salary) over (partition by department) as dept_total from employees;

-- Q9. Display each employee along with the average salary
-- of their department.

select emp_id, emp_name, avg(salary) over (partition by department) as dept_avg from employees;


-- Q10. Divide all employees into 4 salary groups
-- using NTILE().

select emp_id, emp_name, salary, ntile(4) over ( order by salary desc) as grp from employees;

-- ===========================
-- Advanced Interview Questions
-- ===========================

-- Q11. Find employees whose salary is greater than the salary
-- of the previous employee based on joining date.

With CTE AS
 (select emp_id, emp_name, salary, lag(salary) over (order by joining_date ) as prev_sal from employees)
 select emp_id, emp_name, salary
 from CTE
 where salary > prev_sal;

-- Q12. Find employees earning more than the average salary
-- of their own department without using GROUP BY
-- in the final output.

With CTE AS
 (select emp_id, emp_name, salary, avg(salary) over (partition by department ) as avg_sal from employees)
 select emp_id, emp_name, salary
 from CTE
 where salary > avg_sal;


-- Q13. Display only the highest-paid employee
-- from each department using window functions.

With CTE As (
select emp_id, emp_name, department, salary,
 rank() over (partition by department order by salary desc)
 as highest_paid from employees )
 select emp_id, emp_name, department, salary 
 from CTE
 where highest_paid = 1


-- Q14. Find the difference between an employee's salary
-- and the next highest salary within the same department.

-- Q14. Find the difference between an employee's salary
-- and the next highest salary within the same department.*/

WITH CTE AS
(
    SELECT
        emp_name,
        department,
        salary,
        LEAD(salary) OVER
        (
            PARTITION BY department
            ORDER BY salary DESC
        ) AS next_sal
    FROM employees
)

SELECT
    emp_name,
    department,
    salary,
    ABS(next_sal - salary) AS sal_diff
FROM CTE
WHERE next_sal IS NOT NULL;
 
 select version();

-- Q15. Find employees whose performance score
-- ranks in the Top 3 within each department.

With CTE As (
select emp_id, emp_name, department, salary,
 rank() over (partition by department order by performance_score  desc)
 as rnk from employees )
 select emp_id, emp_name, department, salary 
 from CTE
 where rnk <= 3;

-- ===========================
-- Bonus Interview Questions
-- ===========================

-- Q16. Calculate the cumulative average salary
-- ordered by joining date.



-- Q17. Find the second highest salary
-- in every department.



-- Q18. Find employees who share the same salary
-- with one or more employees.



-- Q19. Display each employee's salary contribution
-- as a percentage of the company's total salary.



-- Q20. Display each employee's salary contribution
-- as a percentage of their department's total salary.