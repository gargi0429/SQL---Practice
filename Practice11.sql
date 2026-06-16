CREATE DATABASE practiceday11;
USE practiceday11;

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(30),
    salary INT,
    manager_id INT,
    hire_date DATE
);

INSERT INTO employees VALUES
(1,'Amit','HR',50000,NULL,'2020-01-15'),
(2,'Priya','HR',60000,1,'2019-03-20'),
(3,'Rahul','IT',80000,NULL,'2018-07-10'),
(4,'Sneha','IT',75000,3,'2021-02-01'),
(5,'Vikas','IT',90000,3,'2017-11-12'),
(6,'Neha','Finance',65000,NULL,'2019-08-25'),
(7,'Arjun','Finance',70000,6,'2022-04-18'),
(8,'Pooja','Finance',72000,6,'2020-06-30'),
(9,'Karan','Sales',55000,NULL,'2021-09-15'),
(10,'Meera','Sales',58000,9,'2022-01-10');

-- 1. Display all employees along with their salary rank in the company.

select *, rank() over(order by salary desc) as salary_rank from employees;

-- 2. Display all employees along with dense rank based on salary.

select *, dense_rank() over(order by salary desc) as dense_rnk from employees;

-- 3. Assign a unique row number to employees ordered by highest salary.

select *, row_number() over(order by salary desc) as rowno from employees;

-- 4. Find the highest-paid employee in each department.

select * from (select emp_name, department, row_number() over(partition by department order by salary desc)as rn 
from employees)x where rn = 1;

-- 5. Find the second-highest-paid employee in each department.


select * from (select emp_name, department, dense_rank() over(partition by department order by salary desc)as rn 
from employees)x where rn = 2;

-- 6. Display the previous employee's salary within each department.

select * , lag(salary) over(partition by department order by salary) as previous from employees;

-- 7. Display the next employee's salary within each department.

select * , lead(salary) over(partition by department order by salary) as next_sal from employees;

-- 8. Calculate a running total of salaries department-wise.

select *, sum(salary) over(partition by department order by salary) as running_total from employees;

-- 9. Calculate department-wise average salary for every employee.

select *, avg(salary) over(partition by department order by salary) as avg_sal from employees;

-- 10. Find the top 3 highest-paid employees in each department.

select * from (select emp_name, salary, department, dense_rank() over(partition by department order by salary desc) as hp 
from employees)x where hp <= 3;

-- 11. Find employees whose salary is greater than the overall average salary.

select * from employees where salary > (select avg(salary) as avg_sal from employees);

-- 12. Find employees earning the maximum salary in the company.

select * from employees where salary = (select max(salary) from employees);

-- 13. Find employees working in the department having the highest average salary.

select avg(salary) from employees group by department  order by avg(salary) desc limit 1;

-- 14. Find the second-highest salary in the company.

SELECT salary
FROM (
    SELECT salary,
           DENSE_RANK() OVER(ORDER BY salary DESC) AS dr
    FROM employees
) x
WHERE dr = 2;

-- 15. Find employees whose salary is greater than the maximum salary in the HR department.

SELECT *
FROM employees
WHERE salary > (
    SELECT MAX(salary)
    FROM employees
    WHERE department = 'HR'
);

-- 16. Find departments whose average salary is greater than the company average salary.
SELECT department,
       AVG(salary) AS dept_avg_salary
FROM employees
GROUP BY department
HAVING AVG(salary) > (
    SELECT AVG(salary)
    FROM employees
);

-- 17. Find employees earning more than their department's average salary.

SELECT *
FROM employees e1
WHERE salary > (
    SELECT AVG(salary)
    FROM employees e2
    WHERE e1.department = e2.department
);

-- 18. Find the highest-paid employee in every department using a correlated subquery.

SELECT *
FROM employees e1
WHERE salary = (
    SELECT MAX(salary)
    FROM employees e2
    WHERE e1.department = e2.department
);

-- 19. Find employees hired before the average hire date of their department.

SELECT *
FROM employees e1
WHERE hire_date < (
    SELECT FROM_DAYS(
             AVG(TO_DAYS(hire_date))
           )
    FROM employees e2
    WHERE e1.department = e2.department
);

-- 20. Find employees whose salary is greater than at least one employee in the same department.

SELECT *
FROM employees e1
WHERE EXISTS (
    SELECT 1
    FROM employees e2
    WHERE e1.department = e2.department
      AND e1.salary > e2.salary
);