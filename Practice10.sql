Create database practiceday10;
use practiceday10;
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    salary INT,
    dept_id INT,
    manager_id INT
);

CREATE TABLE Projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(50),
    dept_id INT
);

CREATE TABLE Employee_Project (
    emp_id INT,
    project_id INT
);

INSERT INTO Departments VALUES
(1,'HR'),
(2,'IT'),
(3,'Finance');

INSERT INTO Employees VALUES
(101,'Amit',50000,2,105),
(102,'Priya',60000,2,105),
(103,'Rahul',45000,1,106),
(104,'Sneha',70000,3,107),
(105,'Vikas',90000,2,NULL),
(106,'Neha',85000,1,NULL),
(107,'Rohan',95000,3,NULL);

INSERT INTO Projects VALUES
(1,'CRM System',2),
(2,'Payroll App',1),
(3,'Budget Tracker',3),
(4,'Inventory App',2);

INSERT INTO Employee_Project VALUES
(101,1),
(101,4),
(102,1),
(103,2),
(104,3),
(105,4);

-- Show all employees earning more than 55000

Select * from employees where salary > 55000;

-- Show employees belonging to IT department

Select emp_name, dept_id from employees where dept_id = 2;

-- Show employees whose salary is between 45000 and 70000

Select emp_name, salary from employees where salary >= 45000 and salary <= 70000;

-- Show top 3 highest paid employees

Select emp_name, salary from employees order by salary desc limit 3;

-- Show employees sorted by salary descending

Select * from employees order by salary desc;

-- Find employee with lowest salary

Select emp_name, salary from employees order by salary asc limit 1;

-- Find average salary

Select avg(salary) as Avg_sal from employees;

-- Find highest salary

Select max(salary) as Max from employees;

-- Count total employees

Select count(*) as Total_Count from employees;

-- Find total salary department wise

Select sum(salary) as Total_Salary from employees group by dept_id;

-- Find employee count department wise

Select count(*) as Count from employees group by dept_id;

-- Find average salary department wise

Select avg(salary) as Average from employees group by dept_id;

-- Show employee name and department name

Select e.emp_name, d.dept_name from employees e Join departments d on e.dept_id = d.dept_id;

-- Show employee name and project name

Select e.emp_name, p.project_name from employees e Join Employee_Project ep on e.emp_id = ep.emp_id Join Projects p on ep.project_id = p.project_id;

-- Show employees who are not assigned to any project

Select e.emp_name from employees e Left Join Employee_Project ep on e.emp_id = ep.emp_id where ep.emp_id is NULL;

-- Find second highest salary

Select emp_name, salary from employees order by salary desc limit 1 offset 1;

-- Find employees earning more than department average salary

Select emp_id, emp_name, salary from employees e where salary > (select avg(salary) as average from employees where dept_id = e.dept_id);

-- Find departments having more than 2 employees

Select dept_id, count(*) from employees group by dept_id having count(*) > 2;

-- Find manager name and employee name

Select e.emp_name, m.emp_name from employees e Join employees m on e.emp_id = m.manager_id;

-- Find department with highest average salary

Select dept_id, avg(salary) as Average from employees group by dept_id order by Average desc limit 1;

-- Find projects having no employees assigned


SELECT p.project_name
FROM Projects p
LEFT JOIN Employee_Project ep
ON p.project_id = ep.project_id
WHERE ep.project_id IS NULL;


-- Find employees working on more than one project


Select emp_id, count(project_id) as Project_Count from Employee_Project group by emp_id having count(Project_id) > 1;


-- Find employees working on projects outside their department

SELECT e.emp_name,
       e.dept_id,
       p.project_name,
       p.dept_id
FROM Employees e
JOIN Employee_Project ep
ON e.emp_id = ep.emp_id
JOIN Projects p
ON ep.project_id = p.project_id
WHERE e.dept_id <> p.dept_id;

-- Find manager who supervises maximum employees

SELECT m.emp_name,
       COUNT(*) as total
FROM Employees e
JOIN Employees m
ON e.manager_id = m.emp_id
GROUP BY emp_name
ORDER BY total DESC
LIMIT 1;

