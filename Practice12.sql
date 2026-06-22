-- Department Table
CREATE DATABASE practiceday12;
USE practiceday12;

CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

INSERT INTO Departments VALUES
(1,'HR'),
(2,'IT'),
(3,'Finance'),
(4,'Sales');

-- Employee Table
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id INT,
    salary INT,
    manager_id INT,
    hire_date DATE
);

INSERT INTO Employees VALUES
(101,'Amit',2,70000,NULL,'2020-01-15'),
(102,'Priya',2,55000,101,'2021-03-20'),
(103,'Rahul',3,65000,101,'2019-07-10'),
(104,'Sneha',1,45000,103,'2022-05-11'),
(105,'Vikas',4,60000,101,'2021-08-25'),
(106,'Neha',4,75000,105,'2018-02-15'),
(107,'Karan',2,80000,101,'2017-06-30'),
(108,'Pooja',3,50000,103,'2023-01-10');

-- Orders Table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    order_amount INT,
    order_date DATE,
    emp_id INT
);

INSERT INTO Orders VALUES
(1,'John',10000,'2024-01-10',105),
(2,'Mary',15000,'2024-01-12',106),
(3,'David',8000,'2024-01-15',105),
(4,'Sarah',20000,'2024-01-18',107),
(5,'Alex',12000,'2024-01-20',106),
(6,'Emma',25000,'2024-01-22',105);


-- Q1. Find employees earning more than the average salary.

select emp_id, emp_name, salary from employees where salary > (select avg(salary) from employees);

-- Q2. Find employees earning the highest salary in the company.

select emp_id, emp_name, salary from employees where salary = (select max(salary) from employees);

-- Q3. Find employees earning the second highest salary.

select emp_id, emp_name, salary from employees where salary = (select max(salary) from employees 
 where salary < (select max(salary) from employees));

-- Q4. Display employees whose salary is greater than their department's average salary.

select emp_id, emp_name, salary from employees e1 where salary >
 (select avg(salary) as Dept_avg from employees e2 where e1.dept_id = e2.dept_id);

-- Q5. Find departments having more than 2 employees.

select * from departments d where exists (select count(*) from employees e where e.dept_id = d.dept_id having count(*) > 2);

-- Q6. Find employees working in the same department as 'Priya'.

select emp_id, emp_name from employees  where dept_id = (select dept_id from employees 
where emp_name  = "Priya" );

-- Q6. Find employees working in the same department as 'Priya' exluding priya.

select emp_id, emp_name from employees  where dept_id = (select dept_id from employees 
where emp_name  = "Priya" ) and emp_name <> 'Priya';

-- Q7. Display employees whose salary is greater than Amit's salary.

select emp_id, emp_name, salary from employees where salary > (select salary from employees where emp_name = 'Amit');

-- Q8. Find employees who are not managers.

SELECT e1.emp_id, e1.emp_name
FROM Employees e1
WHERE NOT EXISTS
(
    SELECT 1
    FROM Employees e2
    WHERE e2.manager_id = e1.emp_id
);

-- Q9. Find employees who manage at least one employee.

select emp_id, emp_name from employees e where emp_id IN (select manager_id from employees where manager_id is not null);

-- Q10. Display department names where average salary exceeds 60000.

select d.dept_id, d.dept_name from departments d left join employees e on e.dept_id = d.dept_id 
group by d.dept_name, d.dept_id having avg(e.salary) > 60000;

-- Q11. Find employee(s) with the maximum salary in each department.

select dept_id, emp_id, emp_name, salary from employees e where salary = (select max(salary) from employees e2	where e.dept_id = e2.dept_id);

-- Q12. Display employees hired before the average hire date of all employees.

select emp_name, hire_date from employees where date(hire_date) < (select avg(hire_date) from employees);

-- Q13. Find departments with no employees.

select d.dept_id, d.dept_name from departments d left join employees e on d.dept_id = e.dept_id where e.emp_id is null;

-- Q14. Display employees whose salary is equal to any employee in Finance department.

SELECT emp_id, emp_name, salary
FROM Employees
WHERE salary IN
(
    SELECT salary
    FROM Employees e
    JOIN Departments d
    ON e.dept_id = d.dept_id
    WHERE d.dept_name = 'Finance'
);

-- Q15. Find employees earning more than all employees in HR department.

-- Q16. Show employee name along with manager name using SELF JOIN.

-- Q17. Find employees who earn more than their manager.

-- Q18. Find total order amount handled by each employee.

-- Q19. Find employee(s) who handled the highest total sales amount.

-- Q20. Find customers whose order amount is above the average order amount.