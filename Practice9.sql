CREATE DATABASE practiceday9;

USE practiceday9;

CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

INSERT INTO Departments VALUES
(1,'HR'),
(2,'IT'),
(3,'Finance'),
(4,'Marketing'),
(5,'Operations');



CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id INT,
    salary INT,
    manager_id INT
);

INSERT INTO Employees VALUES
(101,'Amit',2,70000,105),
(102,'Priya',1,50000,106),
(103,'Rahul',2,80000,105),
(104,'Neha',3,65000,107),
(105,'Vikas',2,120000,NULL),
(106,'Sneha',1,90000,NULL),
(107,'Rohit',3,110000,NULL),
(108,'Pooja',4,55000,109),
(109,'Karan',4,100000,NULL),
(110,'Anjali',NULL,45000,NULL);



CREATE TABLE Projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(50),
    dept_id INT
);

INSERT INTO Projects VALUES
(1,'ERP System',2),
(2,'Recruitment Portal',1),
(3,'Budget Planning',3),
(4,'Digital Campaign',4),
(5,'Warehouse Automation',5);



CREATE TABLE Employee_Project (
    emp_id INT,
    project_id INT
);

INSERT INTO Employee_Project VALUES
(101,1),
(103,1),
(105,1),
(102,2),
(106,2),
(104,3),
(107,3),
(108,4),
(109,4),
(101,4);


/*
====================================================
DAY 9 - SQL JOINS (INTERVIEW LEVEL)
====================================================

DATASET


====================================================
Q1. Show employee name and department name.
====================================================

Expected Output:
emp_name | dept_name */

Select emp_name, dept_name from employees e JOIN departments d on e.dept_id = d.dept_id;


/*
====================================================
Q2. Show all employees including those not assigned
to any department.
====================================================

Expected Output:
emp_name | dept_name (NULL if no department)*/ 

select emp_name, dept_name from employees e LEFT JOIN departments d on e.dept_id = d.dept_id;



/*

====================================================
Q3. Find departments that have no employees.
====================================================

Expected Output:
dept_name */

Select d.dept_name from departments d left join employees e on d.dept_id = e.dept_id where emp_id is null;


/*

====================================================
Q4. Show employee name along with manager name.
(Self Join)
====================================================

Expected Output:
Employee | Manager*/

select e.emp_name as employee, m.emp_name as manager from employees e left join employees m on e.manager_id = m.emp_id;


/*
====================================================
Q5. Find employees working on more than one project.
====================================================

Expected Output:
emp_name | project_count*/

select e.emp_name, count(ep.project_id) as Project_count from employees e join Employee_Project ep
on
 e.emp_id = ep.emp_id group by e.emp_name
having count(ep.project_id) > 1;


 /*

====================================================
Q6. Show project name and number of employees
working on each project.
====================================================

Expected Output:
project_name | employee_count*/

select p.project_name, count(ep.emp_id) as Employee_count from Projects p
left JOIN Employee_Project ep
on
p.project_id = ep.project_id
group by p.project_name;


 /*
====================================================
Q7. Find employees whose salary is greater than
their manager's salary.
====================================================


Expected Output:
emp_name | salary | manager_name | manager_salary*/

select e.emp_name, e.salary, m.emp_name as Manager_Name, m.salary as Manager_Salary 
from employees e 
Left join
employees m
on e.manager_id = m.emp_id
where e.salary > m.salary;




/*

====================================================
Q8. Show department name and average salary
of employees in that department.
====================================================

Expected Output:
dept_name | avg_salary*/

select d.dept_name, avg(e.salary) as Avg_Sal from departments d join employees e on d.dept_id = e.dept_id group by dept_name;

/*
====================================================
Q9. Find employees who are not assigned
to any project.
====================================================

Expected Output:
emp_name*/

select e.emp_name from employees e LEFT JOIN Employee_Project ep ON e.emp_id = ep.emp_id where project_id is null; 

/*

====================================================
Q10. Find the department having the highest
average salary.
====================================================

Expected Output:
dept_name | avg_salary*/ 


select d.dept_name, avg(e.salary) as AVG_SAL from departments d LEFT JOIN employees e
 on d.dept_id = e.dept_id group by dept_name order by AVG_SAL desc limit 1;


/*

====================================================
BONUS INTERVIEW QUESTIONS
====================================================

Q11. Find employees working in the same department
as 'Amit'. */



select e2.emp_name from employees e1 join employees e2 on e1.dept_id = e2.dept_id where e1.emp_name = "Amit";



  /*

Q12. Find the highest paid employee in each department.*/
 
select e.emp_id, d.dept_name, e.salary from employees e join departments d on e.dept_id = d.dept_id where
e.salary = (
select max(salary) as MAX from employees where dept_id = e.dept_id
);

/*Q13. Find departments where average salary is
greater than 75000.*/

select d.dept_id, d.dept_name, avg(e.salary) as AVG_SAL from employees e join departments d on e.dept_id = d.dept_id group by dept_id
having AVG_SAL > 75000;

/* Q14. Show employees and project names they are
working on.
Departments(dept_id, dept_name)*/




SELECT e.emp_name,
       p.project_name
FROM Employees e
JOIN Employee_Project ep
ON e.emp_id = ep.emp_id
JOIN Projects p
ON ep.project_id = p.project_id;



/*
Q15. Find projects that currently have no employees
assigned.
*/



SELECT p.project_id,
       p.project_name
FROM Projects p
LEFT JOIN Employee_Project ep
ON p.project_id = ep.project_id
WHERE ep.emp_id IS NULL;
/*

Q16. Find managers who supervise more than
one employee.*/
SELECT m.emp_name AS manager_name,
       COUNT(e.emp_id) AS employee_count
FROM Employees e
JOIN Employees m
ON e.manager_id = m.emp_id
GROUP BY m.emp_id, m.emp_name
HAVING COUNT(e.emp_id) > 1;

/* Q17. Show employee name, department name,
and project name. */
SELECT e.emp_name,
       d.dept_name,
       p.project_name
FROM Employees e
JOIN Departments d
ON e.dept_id = d.dept_id
JOIN Employee_Project ep
ON e.emp_id = ep.emp_id
JOIN Projects p
ON ep.project_id = p.project_id;

/* Q18. Find employees who are working on projects
outside their own department.*/
 
SELECT e.emp_name,
       d.dept_name AS employee_department,
       p.project_name,
       pd.dept_name AS project_department
FROM Employees e
JOIN Employee_Project ep
ON e.emp_id = ep.emp_id
JOIN Projects p
ON ep.project_id = p.project_id
JOIN Departments d
ON e.dept_id = d.dept_id
JOIN Departments pd
ON p.dept_id = pd.dept_id
WHERE e.dept_id <> p.dept_id;


/*

Q19. Find the department with the maximum
number of employees.*/
SELECT d.dept_name,
       COUNT(e.emp_id) AS employee_count
FROM Departments d
JOIN Employees e
ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY employee_count DESC
LIMIT 1;

/*Q20. Find pairs of employees working in the
same department (Self Join).*/

SELECT e1.emp_name AS Employee1,
       e2.emp_name AS Employee2,
       d.dept_name
FROM Employees e1
JOIN Employees e2
ON e1.dept_id = e2.dept_id
AND e1.emp_id < e2.emp_id
JOIN Departments d
ON e1.dept_id = d.dept_id;




/*

====================================================
TOPICS COVERED
====================================================

✔ INNER JOIN
✔ LEFT JOIN
✔ SELF JOIN
✔ MULTIPLE TABLE JOIN
✔ JOIN + GROUP BY
✔ JOIN + HAVING
✔ JOIN + AGGREGATE FUNCTIONS
✔ MANY-TO-MANY RELATIONSHIP
✔ NULL HANDLING
✔ INTERVIEW SCENARIOS

*/