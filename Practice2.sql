create database practiceday2;
use practiceday2;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(50)
);

INSERT INTO Customers (customer_id, customer_name, city) VALUES
(101, 'Aarav', 'Pune'),
(102, 'Diya', 'Mumbai'),
(103, 'Rohan', 'Delhi'),
(104, 'Sneha', 'Bangalore'),
(105, 'Karan', 'Hyderabad'),
(106, 'Meera', 'Chennai'),
(107, 'Aditya', 'Pune'),
(108, 'Isha', 'Mumbai'),
(109, 'Rahul', 'Delhi'),
(110, 'Neha', 'Kolkata');


CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    amount DECIMAL(10,2),
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Orders (order_id, customer_id, amount, order_date) VALUES
(1, 101, 2500, '2026-05-01'),
(2, 102, 4200, '2026-05-02'),
(3, 101, 1800, '2026-05-03'),
(4, 103, 7000, '2026-05-04'),
(5, 104, 3200, '2026-05-05'),
(6, 105, 1500, '2026-05-06'),
(7, 102, 2800, '2026-05-07'),
(8, 106, 5100, '2026-05-08'),
(9, 107, 2300, '2026-05-09'),
(10, 101, 6400, '2026-05-10'),
(11, 108, 1200, '2026-05-11'),
(12, 103, 3500, '2026-05-12'),
(13, 109, 2700, '2026-05-13'),
(14, 105, 4000, '2026-05-14'),
(15, 102, 1500, '2026-05-15');


CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

INSERT INTO Department (dept_id, dept_name) VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Finance'),
(4, 'Marketing'),
(5, 'Sales');



CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    dept_id INT,
    salary INT,
    manager_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);


INSERT INTO Employee (emp_id, name, dept_id, salary, manager_id) VALUES
(1, 'Amit', 1, 40000, NULL),
(2, 'Priya', 2, 65000, 1),
(3, 'Rahul', 2, 55000, 1),
(4, 'Sneha', 3, 70000, 2),
(5, 'Karan', 4, 45000, 2),
(6, 'Meera', 5, 50000, 3),
(7, 'Rohit', 2, 80000, 1),
(8, 'Anjali', 3, 62000, 4),
(9, 'Vikas', 1, 39000, 1),
(10, 'Pooja', 5, 47000, 3),
(11, 'Arjun', 4, 53000, 2),
(12, 'Nisha', 2, 72000, 1),
(13, 'Dev', 3, 61000, 4),
(14, 'Isha', 1, 41000, 1),
(15, 'Manav', 5, 58000, 3);


-- Q1 Find the highest salary from Employee table.

select emp_id, name, salary from Employee order by salary desc limit 1;

-- Q2 Find total number of employees.

select count(*) from employee;

-- Q3 Show number of employees in each department.

select count(*), dept_id from employee group by dept_id;

-- Q4 Find average salary department-wise.

select avg(salary), dept_id as Average_Salary from employee group by dept_id;

-- Q5 Display departments with employee count greater than 3.

Select dept_id, count(*) from employee group by dept_id having count(*) > 3;

-- Q6 Display employee names whose salary is greater than 50000.

Select name, salary from employee where salary > 50000;

-- Q7 Find minimum salary in each department.

select dept_id, min(salary) as Min_Salary from employee group by dept_id;

-- Q8 Find employee details having maximum salary.

select * from employee where salary = (select max(salary) as Max_Salary from employee);

-- Q9 Find second highest salary.

select * from employee order by salary desc limit 1 offset 1; 

-- Q10 Display employees whose salary is greater than company average salary.

select * from employee where salary > (select avg(salary) as Salary from employee);

-- Q11 Find departments where average salary exceeds 60000.

select avg(salary) as Avg_sal, dept_id from employee group by dept_id having Avg_sal > 60000;

-- Q12 Find salaries that appear more than once.

select salary, count(salary) as Count from employee group by salary having count(salary) > 1;

-- Q13 Find employees working in HR department.

select emp_id, name from employee where dept_id In (select dept_id from department where dept_name = 'HR');

-- Q14 Find departments having no employees.

select * from department d where not exists (select * from employee e where e.emp_id = d.dept_id );

-- Q15 Find third highest salary.

select salary from employee order by salary desc limit 1 offset 2;

-- Q16 Find employees whose salary is greater than average salary of their own department.

select emp_id, name from employee e where salary > (select avg(salary) as Avg_Sal from employee where dept_id = e.dept_id );

-- Q17 Find managers supervising more than 2 employees.

select manager_id, count(*) from employee where manager_id is not null group by manager_id having count(*) > 2;

-- Q18 Find department with highest average salary.

select dept_id, avg(salary) as Avg_sal from employee group by dept_id order by Avg_sal desc limit 1;

-- Q19 Find customers who never placed any order.

select customer_id, customer_name from customers c where not exists (select * from orders o where c.customer_id = o.customer_id); 

-- Q20 Find employees whose salary is greater than every employee in department 2.

select emp_id, name from employee where salary > ALL (select salary from employee where dept_id = 2 );

-- DA Q1 Retrieve top 3 highest salaries without using LIMIT twice.

select * from (select * , dense_rank() over (order by salary desc) as rnk from employee) x where rnk <= 3;

-- DA Q2 Calculate total sales month-wise from Orders table.

select month(order_date) as Month, sum(amount) as Total_amount from Orders group by month(order_date);

-- DA Q3 Find customers who placed more than 1 order.

select customer_id, count(order_id) as total_Orders from Orders  group by customer_id having count(order_id) > 1;

-- DA Q4 Find customer who spent maximum amount overall.

select customer_id, sum(amount) as max_amount from Orders group by customer_id order by max_amount desc limit 1;

-- DA Q5 Calculate percentage contribution of each department salary 
-- compared to total company salary.

select 
dept_id,
(sum(salary) * 100.0 /
    (select sum(salary) from employee)
) as Percentage
from employee
group by dept_id;