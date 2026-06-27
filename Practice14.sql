CREATE DATABASE practiceday14;
USE practiceday14;

CREATE TABLE departments(
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

CREATE TABLE employees(
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    salary INT,
    manager_id INT,
    dept_id INT,
    FOREIGN KEY(dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE projects(
    project_id INT PRIMARY KEY,
    project_name VARCHAR(50),
    budget INT
);

CREATE TABLE employee_projects(
    emp_id INT,
    project_id INT,
    hours_worked INT,
    PRIMARY KEY(emp_id,project_id),
    FOREIGN KEY(emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY(project_id) REFERENCES projects(project_id)
);


INSERT INTO departments VALUES
(1,'HR'),
(2,'Finance'),
(3,'IT'),
(4,'Sales'),
(5,'Marketing');



INSERT INTO employees VALUES
(101,'Alice',65000,NULL,3),
(102,'Bob',52000,101,3),
(103,'Charlie',48000,101,3),
(104,'David',70000,NULL,2),
(105,'Emma',45000,104,2),
(106,'Frank',55000,101,3),
(107,'Grace',40000,104,2),
(108,'Henry',60000,NULL,4),
(109,'Ivy',42000,108,4),
(110,'Jack',39000,108,4),
(111,'Kevin',51000,NULL,1),
(112,'Laura',47000,111,1),
(113,'Mike',53000,NULL,NULL);



INSERT INTO projects VALUES
(1,'ERP System',800000),
(2,'Mobile App',450000),
(3,'AI Chatbot',900000),
(4,'Cloud Migration',650000),
(5,'Website Redesign',300000);



INSERT INTO employee_projects VALUES
(101,1,120),
(101,3,80),
(102,1,90),
(102,2,60),
(103,2,70),
(104,4,110),
(105,4,50),
(106,3,100),
(107,4,45),
(108,5,75),
(109,5,40),
(111,1,30);

-- Q1.
-- Display employee name along with their department name.

Select emp_name, dept_name from employees e inner join departments d on e.dept_id = d.dept_id;

-- Q2.
-- Display all employees and their department names.
-- Employees without departments should also appear.

Select e.emp_name, d.dept_name from employees e left join departments d on e.dept_id = d.dept_id
UNION ALL  
Select e.emp_name, d.dept_name from departments d right join employees e on e.dept_id = d.dept_id;

-- Q3.
-- Find all departments that currently have no employees.

select dept_name from departments d left join employees e on e.dept_id = d.dept_id where e.emp_id is null;

-- Q4.
-- Display every employee along with their manager's name.
-- (Use SELF JOIN)

select e.emp_name, m.emp_name from employees e inner join employees m on e.manager_id = m.emp_id;

-- Q5.
-- Find employees who are working on more than one project.
-- Show employee name and total number of projects.

Select e.emp_id, e.emp_name, count(ep.project_id) as Project_Count from employees e join employee_projects ep on e.emp_id = ep.emp_id
group by e.emp_id, e.emp_name having count(ep.project_id) > 1;

-- Q6.
-- Display employee name, department name, project name and hours worked.
-- (Use multiple JOINs)

select e.emp_name, d.dept_name, ep.projects_name from employees e 
left join departments d on e.dept_id = d.dept_id 
right join employee_projects ep on e.emp_id = ep.emp_id;

-- Q7.
-- Find the department having the highest average salary.



-- Q8.
-- Find employees who are not assigned to any project.



-- Q9.
-- Display each project along with the total salary of employees
-- working on that project.
-- (Hint: Join 3 tables)



-- Q10. (Interview Favorite ⭐⭐⭐⭐⭐)
-- Find employees whose salary is greater than the average salary
-- of their own department.
-- Show:
-- Employee Name
-- Department Name
-- Employee Salary
-- Department Average Salary
