-- =========================
-- Employee & Department Data
-- =========================

CREATE DATABASE practiceday17;
USE practiceday17;

CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    salary INT,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

INSERT INTO departments VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Finance'),
(4, 'Marketing'),
(5, 'Operations');

INSERT INTO employees VALUES
(101, 'Amit', 55000, 1),
(102, 'Sneha', 70000, 2),
(103, 'Rahul', 65000, 2),
(104, 'Priya', 60000, 3),
(105, 'Karan', 45000, NULL),
(106, 'Neha', 50000, NULL),
(107, 'Rohan', 75000, 1);


-- =========================
-- Customer & Orders Data
-- =========================

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_amount INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customers VALUES
(1, 'Ananya'),
(2, 'Vikas'),
(3, 'Meera'),
(4, 'Arjun'),
(5, 'Riya');

INSERT INTO orders VALUES
(201, 1, 5000),
(202, 1, 3000),
(203, 2, 7000),
(204, 3, 2000),
(205, 3, 8000),
(206, 3, 1000);


-- =========================
-- Product & Sales Data
-- =========================

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50)
);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    quantity INT,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO products VALUES
(1, 'Laptop'),
(2, 'Mobile'),
(3, 'Tablet'),
(4, 'Headphones'),
(5, 'Camera');

INSERT INTO sales VALUES
(301, 1, 2),
(302, 1, 1),
(303, 2, 5),
(304, 3, 3),
(305, 3, 2),
(306, 3, 1);	


-- Display employee name along with department name.

select emp_name, dept_name from employees e left join departments d on e.dept_id = d.dept_id;

-- Find employees who do not belong to any department.

select emp_name, dept_name from employees e left join departments d on e.dept_id = d.dept_id where dept_name is NULL;

-- List all departments even if they have no employees.
select dept_name, emp_name
from departments d
left join employees e
on d.dept_id = e.dept_id;

-- Find customers along with the total number of orders they placed.

select customer_name, order_id, order_amount from customers c left join orders o on c.customer_id = o.customer_id;

-- Display products and the number of times each product was sold.

select product_name, quantity from products p left join sales s on p.product_id = s.product_id;

ALTER TABLE sales
ADD sale_date DATE;
UPDATE sales SET sale_date = '2026-01-10' WHERE sale_id = 301;
UPDATE sales SET sale_date = '2026-01-20' WHERE sale_id = 302;
UPDATE sales SET sale_date = '2026-02-05' WHERE sale_id = 303;
UPDATE sales SET sale_date = '2026-02-18' WHERE sale_id = 304;
UPDATE sales SET sale_date = '2026-03-01' WHERE sale_id = 305;
UPDATE sales SET sale_date = '2026-03-15' WHERE sale_id = 306;

-- Q16. Find total salary paid by each department.

select sum(salary) from employees group by dept_id;

-- Q17. Find the department with the highest average salary.

select avg(salary) as avg_sal  from employees group by dept_id order by avg_sal desc limit 1;

-- Q18. Find customers who placed more than three orders.

select customer_name from customers c join orders o on c.customer_id = o.customer_id group by customer_name having count(order_id) > 3;

-- Q19. Find the top five customers by purchase amount.

select customer_name, max(order_amount) as top5 from customers c join orders o on c.customer_id = o.customer_id group by customer_name
 order by top5 desc limit 5;

-- Q20. Find the total sales for each month.

select month(sale_date), sum(quantity) as total_sum from Sales group by month(sale_date);