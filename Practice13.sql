-- EMPLOYEES TABLE

/*
emp_id | emp_name | dept_id | manager_id | salary
--------------------------------------------------
1      | Alice    | 101     | 5          | 60000
2      | Bob      | 102     | 5          | 55000
3      | Charlie  | 101     | 6          | 70000
4      | David    | NULL    | 6          | 50000
5      | Emma     | 103     | NULL       | 90000
6      | Frank    | 103     | NULL       | 95000
7      | Grace    | 104     | 5          | 65000
*/
CREATE DATABASE practiceday13;
USE practiceday13;

CREATE TABLE employees(
emp_id INT PRIMARY KEY,
emp_name VARCHAR(50),
dept_id INT,
manager_id INT,
salary INT
);

INSERT INTO employees VALUES
(1,'Alice',101,5,60000),
(2,'Bob',102,5,55000),
(3,'Charlie',101,6,70000),
(4,'David',NULL,6,50000),
(5,'Emma',103,NULL,90000),
(6,'Frank',103,NULL,95000),
(7,'Grace',104,5,65000);

-- DEPARTMENTS TABLE

/*
dept_id | dept_name
-------------------
101     | HR
102     | Finance
103     | IT
105     | Marketing
*/

CREATE TABLE departments(
dept_id INT PRIMARY KEY,
dept_name VARCHAR(50)
);

INSERT INTO departments VALUES
(101,'HR'),
(102,'Finance'),
(103,'IT'),
(105,'Marketing');

-- PROJECTS TABLE

/*
project_id | project_name | emp_id
----------------------------------
1          | ERP          | 1
2          | CRM          | 2
3          | AI Tool      | 3
4          | Dashboard    | 3
5          | Migration    | 7
*/

CREATE TABLE projects(
project_id INT PRIMARY KEY,
project_name VARCHAR(50),
emp_id INT
);

INSERT INTO projects VALUES
(1,'ERP',1),
(2,'CRM',2),
(3,'AI Tool',3),
(4,'Dashboard',3),
(5,'Migration',7);

-- Find employee name and department name.

Select emp_name, dept_name from employees e INNER JOIN departments d on e.dept_id = d.dept_id;

-- Find all employees along with department names.
-- Employees without departments should also appear.

Select emp_id, emp_name, dept_name from employees e LEFT JOIN departments d on e.dept_id = d.dept_id;

-- Find all departments even if no employee belongs to them.

Select d.dept_id, d.dept_name from employees e right join departments d on e.dept_id = d.dept_id;

-- Find all employees and all departments,
-- including unmatched records from both sides.

Select e.emp_name, d.dept_name from employees e LEFT JOIN departments d on e.dept_id = d.dept_id
UNION 
Select e.emp_name, d.dept_name from employees e RIGHT JOIN departments d on e.dept_id = d.dept_id;

-- Find employee name and their manager name.

Select e.emp_name, m.emp_name from employees e INNER JOIN employees m on e.manager_id = m.emp_id;

-- Find department-wise employee count.

Select count(*), dept_name from employees e inner JOIN departments d on e.dept_id = d.dept_id group by dept_name;

-- Find departments having more than 1 employee.

Select  d.dept_name from departments d left join employees e on e.dept_id = d.dept_id 
group by  d.dept_name having Count(e.emp_id) > 1;

-- Display employee name, department name, project name.

Select e.emp_name, d.dept_name, p.project_name 
from employees e 
left join departments d on e.dept_id = d.dept_id 
right join projects p on e.emp_id = p.emp_id;

-- Find employees who are not assigned to any project.	

Select e.emp_name from employees e 
left join 
projects p on e.emp_id = p.emp_id
where p.project_id is NULL;

-- Find employees earning more than the average salary
-- of their department.

Select emp_id, emp_name from employees e1
 where salary > (select avg(salary) as dept_avg from employees e2
 where e2.dept_id = e1.dept_id);
