use classicmodels;
#######################################################################################
/* Q1. SELECT clause with WHERE, AND, DISTINCT, Wild Card (LIKE)

a.	Fetch the employee number, first name and last name of those employees who are working as Sales Rep reporting to 
employee with employeenumber 1102 (Refer employee table)
*/

select * from employees;
Select 
     employeeNumber, firstName, lastName
     from employees 
     where jobTitle = "Sales Rep" and reportsTo = "1102";
     
/* b.	Show the unique productline values containing the word cars at the end from the products table.  */

select * from products;

Select distinct
     productLine 
     from products
     where productLine like '%Cars';
     
     
##############################################################################################################################
/* Q2. CASE STATEMENTS for Segmentation

. a. Using a CASE statement, segment customers into three categories based on their country:(Refer Customers table)
                        "North America" for customers from USA or Canada
                        "Europe" for customers from UK, France, or Germany
                        "Other" for all remaining countries
     Select the customerNumber, customerName, and the assigned region as "CustomerSegment".
*/
    
    
select * from Customers;
Select 
customerNumber, customerName,
CASE 
   When country In ('USA', 'Canada')
   Then 'North America'
   When country In ('UK', 'France')
   Then 'Europe'
   ELSE
   'Other'
   END AS
   CustomerSegment from Customers;
   
 
##############################################################################################################################  
/* Q3. Group By with Aggregation functions and Having clause, Date and Time functions

a.	Using the OrderDetails table, identify the top 10 products (by productCode) with the highest total order quantity across all orders.
*/

     Select * from OrderDetails;
     
     Select 
     productCode,
     Sum(quantityOrdered) AS highest_total_order
     from OrderDetails
     group by productCode
     order by highest_total_order desc
     limit 10;
     
     
/* b.	Company wants to analyse payment frequency by month. Extract the month name from the payment date to count the total 
number of payments for each month and include only those months with a payment count exceeding 20. Sort the results by
 total number of payments in descending order.  (Refer Payments table). 

*/
     
Select * from Payments;
     
Select monthname(paymentDate) as Month_Name,
     Count(*) as total_payments 
 from payments
 Group by monthname(paymentDate)
 Having COUNT(*) > 20
 order by total_payments desc;
 
 
##############################################################################################################################
 /* Q4. CONSTRAINTS: Primary, key, foreign key, Unique, check, not null, default

Create a new database named and Customers_Orders and add the following tables as per the description

a.	Create a table named Customers to store customer information. Include the following columns:

customer_id: This should be an integer set as the PRIMARY KEY and AUTO_INCREMENT.
first_name: This should be a VARCHAR(50) to store the customer's first name.
last_name: This should be a VARCHAR(50) to store the customer's last name.
email: This should be a VARCHAR(255) set as UNIQUE to ensure no duplicate email addresses exist.
phone_number: This can be a VARCHAR(20) to allow for different phone number formats.

Add a NOT NULL constraint to the first_name and last_name columns to ensure they always have a value.
*/

Create database Customer_Orders;
use Customer_Orders;
 
 Create Table Customers(
 customer_id INT Primary Key auto_increment,
 first_name VARCHAR(50) NOT NULL,
 last_name VARCHAR (50) NOT NULL,
 email VARCHAR(255) UNIQUE,
 phone_number VARCHAR(20)
 );


/* b.	Create a table named Orders to store information about customer orders. Include the following columns:

    	order_id: This should be an integer set as the PRIMARY KEY and AUTO_INCREMENT.
customer_id: This should be an integer referencing the customer_id in the Customers table  (FOREIGN KEY).
order_date: This should be a DATE data type to store the order date.
total_amount: This should be a DECIMAL(10,2) to store the total order amount.
     	
Constraints:
a)	Set a FOREIGN KEY constraint on customer_id to reference the Customers table.
b)	Add a CHECK constraint to ensure the total_amount is always a positive value.
*/

Create Table Orders(
  order_id INT PRIMARY KEY auto_increment,
  Customer_id INT,
   Order_date Date,
  total_amount DECIMAL(10, 2),
  Foreign Key (customer_id)
   References Customers(customer_id),
   Check (total_amount > 0)
);


##############################################################################################################################
/* Q5. JOINS
a. List the top 5 countries (by order count) that Classic Models ships to. (Use the Customers and Orders tables)
 */
 
 USE classicmodels;
 Select country,
 count(Orders.orderNumber) as order_count
 from Customers
 JOIN Orders
 On Customers.customerNumber = orders.customerNumber
 group by Customers.Country
 order by order_count desc
 limit 5;


##############################################################################################################################
/* Q6. SELF JOIN
a. Create a table project with below fields.


●	EmployeeID : integer set as the PRIMARY KEY and AUTO_INCREMENT.
●	FullName: varchar(50) with no null values
●	Gender : Values should be only ‘Male’  or ‘Female’
●	ManagerID: integer 
Add below data into it.
 
Find out the names of employees and their related managers.
 */

create table project(
   EmployeeID INT Primary KEY Auto_increment,
   FullName VARCHAR(50) NOT NULL,
   Gender VARCHAR(10)
   CHECK (Gender IN ('Male','Female')),
   ManagerID INT
);

INSERT INTO Project (EmployeeID, FullName, Gender, ManagerID)
values
(1, 'Pranaya', 'Male', 3),
(2, 'Priyanka', 'Female', 1),
(3, 'Preety', 'Female', NULL),
(4, 'Anurag', 'Male', 1),
(5, 'Sambit', 'Male', 1),
(6, 'Rajesh', 'Male', 3),
(7, 'Hina', 'Female', 3);

Select m.FullName As Manager_Name,
       e.FullName as Emp_Name
       From Project e
       Join Project m
ON
e.ManagerID = m.EmployeeID;



##############################################################################################################################
/* 
Q7. DDL Commands: Create, Alter, Rename
a. Create table facility. Add the below fields into it.
●	Facility_ID
●	Name
●	State
●	Country

i) Alter the table by adding the primary key and auto increment to Facility_ID column.
ii) Add a new column city after name with data type as varchar which should not accept any null values.
 */

Create table Facility (
Facility_ID INT,
Name VARCHAR(50),
State VARCHAR(50),
Country VARCHAR(50));

Alter Table Facility 
Modify Facility_ID INT Primary Key auto_increment;

Alter Table Facility 
ADD city VARCHAR(50)  NOT NULL
After Name;
Select * from Facility;
desc Facility;


##############################################################################################################################
/*Q8. Views in SQL
a. Create a view named product_category_sales that provides insights into sales performance by product category. 
This view should include the following information:
productLine: The category name of the product (from the ProductLines table).

total_sales: The total revenue generated by products within that category 
(calculated by summing the orderDetails.quantity * orderDetails.priceEach for each product in the category).

number_of_orders: The total number of orders containing products from that category.

(Hint: Tables to be used: Products, orders, orderdetails and productlines)

The view when read should show the output as:

 */
 use classicmodels;
create or replace view product_category_sales as

Select
       p.productLine,

       SUM(od.quantityOrdered * od.priceEach) AS total_sales,

       COUNT(DISTINCT o.orderNumber) AS number_of_orders

from Products p

Join OrderDetails od
ON p.productCode = od.productCode

Join Orders o
ON od.orderNumber = o.orderNumber

JOIN ProductLines pl
ON p.productLine = pl.productLine

Group by p.productLine;

Select * from product_category_sales;



##############################################################################################################################
/* Q9. Stored Procedures in SQL with parameters

a. Create a stored procedure Get_country_payments which takes in year and country as inputs and gives year wise, 
country wise total amount as an output. Format the total amount to nearest thousand unit (K)
Tables: Customers, Payments
*/

USE classicmodels;

DELIMITER $$

CREATE PROCEDURE Get_country_payments(
    IN p_year INT,
    IN p_country VARCHAR(50)
)

BEGIN

    SELECT
           YEAR(p.paymentDate) AS Year,

           c.country,

           CONCAT(
                  ROUND(SUM(p.amount)/1000),
                  'K'
                 ) AS 'Total Amount'

    FROM Customers c

    JOIN Payments p
    ON c.customerNumber = p.customerNumber

    WHERE YEAR(p.paymentDate) = p_year
    AND c.country = p_country

    GROUP BY YEAR(p.paymentDate), c.country;

END $$

DELIMITER ;
CALL Get_country_payments(2003, 'France');


##############################################################################################################################
/* Q10. Window functions - Rank, dense_rank, lead and lag

a) Using customers and orders tables, rank the customers based on their order frequency

*/


USE classicmodels;

SELECT
       c.customerName,

       COUNT(o.orderNumber) AS Order_count,

       dense_rank() over (
                          order by COUNT(o.orderNumber) DESC
                         ) AS order_frequency_rnk

from Customers c

join Orders o
ON c.customerNumber = o.customerNumber

Group by c.customerNumber, c.customerName;


/*b) Calculate year wise, month name wise count of orders and year over year (YoY) percentage change.
 Format the YoY values in no decimals and show in % sign.
Table: Orders

 */
 
 
 SELECT
       YEAR(orderDate) AS Year,

       MONTHNAME(orderDate) AS Month_Name,

       COUNT(orderNumber) AS Order_Count,

CONCAT(ROUND((
                       (COUNT(orderNumber)
                        -
lag(COUNT(orderNumber))over(ORDER BY YEAR(orderDate),MONTH(orderDate)))/
                       lag(COUNT(orderNumber))
                       OVER (
		ORDER BY YEAR(orderDate),MONTH(orderDate))) * 100),'%') AS Percentage_Change

From Orders

Group by Year(orderDate),
         Month(orderDate),
         MONTHNAME(orderDate);
         
  
##############################################################################################################################       
/* Q11.Subqueries and their applications

a. Find out how many product lines are there for which the buy price value is greater than the average of buy price value.
 Show the output as product line and its count.
*/

Select
       productLine,

       COUNT(*) as product_count

FROM Products

Where buyPrice >
      (
        select avg(buyPrice)
        FROM Products
      )

Group by productLine
order by product_count desc;


##############################################################################################################################
/* Q12. ERROR HANDLING in SQL
      Create the table Emp_EH. Below are its fields.
●	EmpID (Primary Key)
●	EmpName
●	EmailAddress
Create a procedure to accept the values for the columns in Emp_EH. Handle the error using exception handling concept. Show the message as “Error occurred” in case of anything wrong.

Q13. TRIGGERS
Create the table Emp_BIT. Add below fields in it.
●	Name
●	Occupation
●	Working_date
●	Working_hours

Insert the data as shown in below query.
INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  
 
Create before insert trigger to make sure any new value of Working_hours, if it is negative, then it should be inserted as positive.
*/

CREATE TABLE Emp_EH (

    EmpID INT PRIMARY KEY,

    EmpName VARCHAR(100),

    EmailAddress VARCHAR(100)

);

DELIMITER $$

CREATE PROCEDURE Insert_Emp_EH(

    IN p_EmpID INT,
    IN p_EmpName VARCHAR(100),
    IN p_EmailAddress VARCHAR(100)

)

BEGIN

    declare exit handler for sqlexception
    BEGIN
        SELECT 'Error occurred' AS Message;
    END;

    insert into Emp_EH
    VALUES
    (p_EmpID, p_EmpName, p_EmailAddress);

END $$

DELIMITER ;

CALL Insert_Emp_EH(1, 'Gargi', 'gargi@gmail.com');


###############################Triggers Q- 13 ###########################################################

CREATE TABLE Emp_BIT (

    Name VARCHAR(100),

    Occupation VARCHAR(100),

    Working_date DATE,

    Working_hours INT

);

Insert Into Emp_BIT values
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);
DELIMITER $$

Create TRIGGER trg_working_hours

before insert
ON Emp_BIT

for each row

BEGIN

    IF NEW.Working_hours < 0 THEN

       SET NEW.Working_hours = -NEW.Working_hours;

    END IF;

END $$

DELIMITER ;

INSERT INTO Emp_BIT
VALUES ('Sam', 'Engineer', '2020-10-04', -8);
SELECT * FROM Emp_BIT;





