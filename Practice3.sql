CREATE DATABASE practiceday3;

USE practiceday3;

CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    gender VARCHAR(10),
    dept_id INT,
    salary INT,
    city VARCHAR(50),
    joining_date DATE,
    manager_id INT,
    email VARCHAR(100),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

INSERT INTO departments VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Finance'),
(4, 'Sales'),
(5, 'Marketing');

INSERT INTO employees VALUES
(101, 'Amit Sharma', 'Male', 2, 75000, 'Pune', '2021-01-10', 201, 'amit@gmail.com'),
(102, 'Neha Patil', 'Female', 1, 50000, 'Mumbai', '2020-03-15', 202, 'neha@gmail.com'),
(103, 'Rohit Jain', 'Male', 3, 65000, 'Delhi', '2019-07-01', 203, 'rohit@gmail.com'),
(104, 'Priya Singh', 'Female', 2, 85000, 'Pune', '2022-09-12', 201, 'priya@gmail.com'),
(105, 'Karan Mehta', 'Male', 4, 45000, 'Bangalore', '2021-11-25', 204, 'karan@gmail.com'),
(106, 'Sneha Iyer', 'Female', 5, 70000, 'Chennai', '2018-04-20', 205, 'sneha@gmail.com'),
(107, 'Vikas Gupta', 'Male', 2, 90000, 'Mumbai', '2017-08-30', 201, 'vikas@gmail.com'),
(108, 'Anjali Verma', 'Female', 4, 48000, 'Delhi', '2023-02-18', 204, 'anjali@gmail.com'),
(109, 'Rahul Das', 'Male', 3, 62000, 'Kolkata', '2020-12-05', 203, 'rahul@gmail.com'),
(110, 'Meera Joshi', 'Female', 1, 58000, 'Pune', '2019-05-28', 202, 'meera@gmail.com');


/* =========================================================
   EASY QUESTIONS
========================================================= */


/* Q1 (5 mins)
Display employee name and salary along with a new column:
If salary > 70000 then 'High Salary'
Else 'Normal Salary'
Use CASE WHEN.
*/

select emp_name, salary,
    CASE
       WHEN salary > 70000 THEN 'High Salary'
       Else 'Normal Salary'
       END AS Salary_Div
       from employees;

/* Q2 (5 mins)
Display all employee names in uppercase.
*/

select emp_id, upper(emp_name) from employees;

/* Q3 (5 mins)
Display employee name and length of employee name.
*/

select emp_name, length(emp_name) from employees;
## counts space also!



/* Q4 (6 mins)
Display employee name and joining year.
*/

select emp_name, year(joining_date) from employees;

/* Q5 (6 mins)
Display employee name and city in lowercase.
*/

select  lower(emp_name) as Name, lower(city) as City from employees;

/* =========================================================
   EASY-MEDIUM QUESTIONS
========================================================= */


/* Q6 (8 mins)
Display employees whose salary is greater than
average salary of all employees.

PATTERN:
1. Find avg salary
2. Use scalar subquery in WHERE
*/

Select * from employees where salary > (select avg(salary) as AVG_Salary from employees);


/* Q7 (8 mins)
Display highest salary in the company using subquery.
*/

Select emp_name, salary from employees where salary = (select max(salary) from employees);


/* Q8 (8 mins)
Display employee name and experience in years.

HINT:
Use DATEDIFF() or TIMESTAMPDIFF()
*/

select emp_name, TIMESTAMPDIFF(year, joining_date, Curdate()) as experience from employees;

/* Q9 (8 mins)
Display department-wise employee count using CASE:
If count >= 2 then 'Good'
Else 'Need Hiring'
*/

Select count(*),
   CASE 
   WHEN count(*)>= 2 THEN 'Good'
   ELSE 'NEED HIRING'
    END AS conclusion
from employees group by dept_id;

/* Q10 (10 mins)
Display employees whose salary is greater than
their department average salary.

PATTERN:
1. Inner query should calculate avg salary by dept
2. Correlated subquery required
*/

select emp_id, emp_name from employees e 
where salary > (select avg(salary) as AVG_Salary from employees where dept_id = e.dept_id );

/* =========================================================
   MEDIUM QUESTIONS
========================================================= */


/* Q11 (10 mins)
Display second highest salary from employees table.

PATTERN:
1. Find MAX salary
2. Exclude max salary
3. Find MAX again
*/

select max(salary) from employees where salary < (select max(salary)  As max from employees);

/* Q12 (10 mins)
Display employee names whose name starts with 'A'.
*/

select emp_name from employees where emp_name like 'A%';

/* Q13 (10 mins)
Display employee names whose email contains 'gmail'.
*/

select emp_name, email from employees where email like '%gmail%';

/* Q14 (12 mins)
Display employees who joined before average joining date.

PATTERN:
1. Find average joining date
2. Compare joining_date
*/

select emp_name from employees where joining_date < (select avg(joining_date) as Avg_joidate from employees);

/* Q15 (12 mins)
Display employee names and a bonus column:
If salary > 80000 → 20% bonus
If salary between 60000 and 80000 → 10% bonus
Else → 5% bonus
*/

Select emp_name, 
    CASE 
    WHEN salary > 80000 THEN '20% bonus'
    WHEN salary between 60000 and 80000 THEN '10% bonus'
    ELSE '5% Bonus'
    END AS Bonus_column
    from employees;
     
/* =========================================================
   HARD QUESTIONS
========================================================= */


/* Q16 (15 mins)
Display employees earning highest salary in each department.

PATTERN:
1. Correlated subquery
2. Compare employee salary with MAX salary
   of same department
*/

select emp_name, emp_id, dept_id from employees e 
where salary = (select max(salary) AS max from employees where dept_id = e.dept_id);

/* Q17 (15 mins)
Display employees whose salary is above company average
AND city is same as employee with highest salary.

PATTERN:
1. Find highest salary employee city
2. Find company avg salary
3. Apply both conditions
*/

select emp_name, emp_id from employees 
where salary > (select avg(salary) as avg_sal from employees) 
AND city = (select city from employees where salary = (select max(salary) from employees));

/* Q18 (15 mins)
Display employee name, department name and:
If employee joined before 2020 → 'Old Employee'
Else → 'New Employee'

Use CASE WHEN with JOIN.
*/

select emp_id, e.emp_name, d.dept_id, d.dept_name,
CASE 
WHEN year(joining_date) < 2020 THEN 'Old Employee'
ELSE 'New Employee'
END AS conclusion
 from employees e
Join departments d
on e.dept_id = d.dept_id;


/* Q19 (18 mins)
Display employees whose salary is greater than
at least one employee in Finance department.

PATTERN:
1. Find Finance salaries
2. Use ANY
*/

select salary, dept_id, emp_id, emp_name from employees where salary >
 ANY (select salary from employees e JOIN departments d ON e.dept_id = d.dept_id where dept_name = "Finance");


/* Q20 (20 mins)
Display department-wise highest paid employee names.

PATTERN:
1. Find max salary per department
2. Match employee with that salary
3. Use correlated subquery or JOIN
*/

select emp_name, emp_id, dept_id from employees e 
where salary = (select max(salary) AS max from employees where dept_id = e.dept_id);

/* =========================================================
   INTERVIEW-SPECIFIC QUESTIONS FOR DATA ANALYST
========================================================= */


/* INTERVIEW Q1 (15 mins)
Find employees earning more than company average salary.
Show:
emp_name, salary, difference_from_avg
*/

select emp_name, salary,
salary - (select avg(salary) from employees) AS difference_from_avg
 from employees where salary > (select avg(salary) from employees);

/* INTERVIEW Q2 (15 mins)
Create salary categories:
0-50000 → Low
50001-70000 → Medium
70001+ → High
Show count in each category.
*/

select count(salary),
  CASE 
  When salary Between 0 and 50000 Then 'Low'
   When  salary Between 50000 and 70000 Then 'medium'
   Else 'high'
   End as category_of_salary
 from employees
 group by category_of_salary;

/* INTERVIEW Q3 (18 mins)
Find employees who joined in the same year
as at least one other employee.
*/

SELECT emp_name, joining_date
FROM employees
WHERE YEAR(joining_date) IN (
    SELECT YEAR(joining_date)
    FROM employees
    GROUP BY YEAR(joining_date)
    HAVING COUNT(*) > 1
);
/* INTERVIEW Q4 (20 mins)
Find top-paid employee from each department
without using LIMIT.

*/
SELECT emp_name,
       emp_id,
       dept_id,
       salary
FROM employees e
WHERE salary = (
    SELECT MAX(salary)
    FROM employees
    WHERE dept_id = e.dept_id
);


/* INTERVIEW Q5 (20 mins)
Display department name having highest average salary.*/
SELECT d.dept_name,
       AVG(e.salary) AS avg_salary
FROM employees e
INNER JOIN departments d
ON e.dept_id = d.dept_id
GROUP BY d.dept_name
HAVING AVG(e.salary) = (
    SELECT MAX(avg_salary)
    FROM (
        SELECT AVG(salary) AS avg_salary
        FROM employees
        GROUP BY dept_id
    ) AS temp
);

