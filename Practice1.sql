create database practiceday1;
use practiceday1;
create table employees(
 emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary INT,
    city VARCHAR(50),
    joining_year INT
);

INSERT INTO employees (emp_id, name, department, salary, city, joining_year)
VALUES
(1, 'Asha', 'HR', 40000, 'Pune', 2021),
(2, 'Rahul', 'IT', 65000, 'Mumbai', 2020),
(3, 'Neha', 'Sales', 50000, 'Pune', 2022),
(4, 'Arjun', 'IT', 75000, 'Delhi', 2019),
(5, 'Priya', 'HR', 42000, 'Mumbai', 2023),
(6, 'Karan', 'Sales', 55000, 'Pune', 2020),
(7, 'Sneha', 'IT', 80000, 'Bangalore', 2018),
(8, 'Amit', 'Marketing', 47000, 'Delhi', 2021);

/* 1. Display all employee records */
SELECT * FROM employees;

/* 2. Show only employee names and salaries */

Select name, salary from employees;

/* 3. Find employees from Pune */

Select name, city from employees where city = 'Pune';

/* 4. Show employees whose salary is greater than 50000 */

Select emp_id, name, salary from employees where salary > 50000;


/* 5. Display employees from IT department */

Select emp_id, name, department from employees where department = 'IT';

/* 6. Show employees whose salary is between 40000 and 70000 */

Select * from employees where salary > 40000 and salary < 70000;

Select salary from employees where salary between 40000 and 70000;



/* 7. Find employees from Pune or Mumbai */

Select name, city from employees where city in ('pune', 'mumbai');

/* 8. Display employees whose names start with 'A'*/

Select name from employees where name like 'A%';

/* 9. Sort employees by salary in descending order */

Select * from employees order by salary desc;


/* 10. Show top 3 highest paid employees */
 
Select * from employees order by salary desc limit 3;


/* 11. Count total employees in each department */

Select department, count(*) as total_count from employees group by department;


/* 12. Find average salary department-wise */

Select avg(salary) as AVG_SALARY, department from employees group by department;


/* 13. Show departments having more than 2 employees */

Select department, count(name) from employees group by department having count(*) > 2;


/* 14. Find the second highest salary */

Select * from employees order by salary desc limit 1 offset 1;
### offset --> removes first row from top and limit restricts the row so therefore we get second row!

/* 15. Display departments where average salary is greater than 60000 */

Select department from employees  group by department having avg(salary)> 60000;

/* 16. Find duplicate cities in the table */

Select city from employees group by city having count(*) > 1;

/* 17. Retrieve employees who joined after 2020 and belong to IT department*/

Select * from employees where department = "IT" and joining_year > 2020;

/* 18. Find highest salary in each department */

Select max(salary) as Highest_Salary, department from employees group by department;

/*19. Count employees city-wise and sort by highest count */

Select city, count(name) as highest_count from employees group by city order by highest_count desc;

/* 20. Find employees earning more than department average salary */

Select emp_id, name, department from employees e where salary > (select avg(salary)from employees where department = e.department);


