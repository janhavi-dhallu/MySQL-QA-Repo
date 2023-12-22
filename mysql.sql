
create database assignment;

use assignment;




##day3

#Q Show customer number, customer name, state and credit limit from customers table for below conditions. Sort the results by highest to lowest values of creditLimit.

	#	State should not contain null values
	#	credit limit should be between 50000 and 100000

select * from customers;
select * from employees;
select * from offices;

select
customernumber, customername, state,creditlimit 
from customers
where 
state is not  null and
creditlimit > 50000 and creditlimit < 100000  order by creditlimit desc;

##Show the unique productline values containing the word cars at the end from products table.
select * from orderdetails;
select * from orders;
select * from payments;
select * from productlines;
select * from products;


SELECT DISTINCT productLine
FROM productLines
WHERE productLine LIKE '%cars';




##Show the orderNumber, status and comments from orders table for shipped status only. If some comments are having null values then show them as “-“.

update orders
set comments = "-"
where comments is null;

set sql_safe_updates=0;

select  orderNumber, status , comments from orders
where status = "shipped";

##	Select employee number, first name, job title and job title abbreviation from employees table based on following conditions.
#If job title is one among the below conditions, then job title abbreviation column should show below forms.
#	•	President then “P”
#	•	Sales Manager / Sale Manager then “SM”
#	•	Sales Rep then “SR”
#	•	Containing VP word then “VP”
 

select employeenumber, firstname, jobtitle, 
if(jobtitle = "president","P",
if(jobtitle = "vp sales","VP",
if(jobtitle = "sales manager (APAC)","SM",
If(jobtitle = "saleS manager (NA)","SM",
If(jobtitle = "VP marketing","VP",
if(jobtitle = "sales rep","SR",
if(jobtitle = "sale manager (EMEA)","SM","-")))))))
as jobtitle_abbr 
from employees;





## For every year, find the minimum amount value from payments table.

select year(paymentDate) as year, min(amount) as min_amount from payments
group by year
order by year;

## For every year and every quarter, find the unique customers and total orders from orders table. Make sure to show the quarter as Q1,Q2 etc.
select year(orderdate) as year, 
concat("Q",quarter(orderdate)) as qtr, 
count(distinct(customernumber)) as unique_customers, 
count(ordernumber) 
as total_order  from orders
group by year(orderdate),
concat("Q",quarter(orderdate));

## Show the formatted amount in thousands unit (e.g. 500K, 465K etc.) for every month (e.g. Jan, Feb etc.) with filter on total amount as 500000 to 1000000. Sort the output by total amount in descending mode. [ Refer. Payments Table]

select monthname(paymentdate) as month ,concat(left(max(amount),2),"K") as formatted_amount from payments
where amount >50000 and amount <100000
group by monthname(paymentDate)
order by formatted_amount desc; 






## Create a journey table with following fields and constraints.

	#	Bus_ID (No null values)
	#	Bus_Name (No null values)
	#	Source_Station (No null values)
	#	Destination (No null values)
	#	Email (must not contain any duplicates)

create table journey ( 
bus_id int Not null,
bus_name char (10) Not null,
source_station char (20) Not null,
destination char (20) Not null,
email char (20) unique);

##Create vendor table with following fields and constraints.

	#	Vendor_ID (Should not contain any duplicates and should not be null)
	#	Name (No null values)
	#	Email (must not contain any duplicates)
	#	Country (If no data is available then it should be shown as “N/A”)

create table vendor (
Vendor_ID int primary key,
v_name char(20) Not null,
Email char(20) unique,
Country char(20) default "N/A");

##Create movies table with following fields and constraints.

	#	Movie_ID (Should not contain any duplicates and should not be null)
	#	Name (No null values)
	#	Release_Year (If no data is available then it should be shown as “-”)
	#	Cast (No null values)
	#	Gender (Either Male/Female)
	#	No_of_shows (Must be a positive number)
    
create table movie(
Movie_ID int primary key,
Name char(20) Not null,
Release_Year char(20) default "-",
Cast char(10) Not null,
Gender char(7) check(gender = "male" or gender = "female"),
No_of_shows int check (no_of_shows >0));


##Create the following tables. Use auto increment wherever applicable

#a. Product
	#	product_id - primary key
	#	product_name - cannot be null and only unique values are allowed
	#	description
	#	supplier_id - foreign key of supplier table

create table product(
product_id int primary key,
product_name char(20),
description char(20),
supplier_id int,
foreign key(supplier_id) references suppliers(sup_id));

#b. Suppliers
	#	supplier_id - primary key
	#	supplier_name
	#	location
create table suppliers (
sup_id int primary key,
supplier_name char(20),
location char (20));

#c. Stock
	#	id - primary key
	#	product_id - foreign key of product table
	#	balance_stock
create table stock (
id int primary key auto_increment,
product_id int,
balance_stock char (20),
foreign key(product_id) references product(product_id));





## Show employee number, Sales Person (combination of first and last names of employees), unique customers for each employee number and sort the data by highest to lowest unique customers.
#Tables: Employees, Customers

select  e.employeenumber , concat(firstname," ",lastname) as sale_person, count(distinct(customerName)) as unique_customers from employees as e
join customers as c
on e.employeeNumber = c.salesRepEmployeeNumber
group by e.employeeNumber
order by unique_customers desc;


##Show total quantities, total quantities in stock, left over quantities for each product and each customer. Sort the data by customer number.

#Tables: Customers, Orders, Orderdetails, Products

Select c.customernumber , c.customername , 
p.productcode , p.productname , 
od.quantityOrdered , 
p.quantityInStock ,
(p.quantityInStock - od.quantityOrdered) as left_qty
from customers as c 
join orders as o on c.customernumber = o.customerNumber
join orderdetails as od on o.orderNumber = od.orderNumber
join products as p on od.productCode = p.productCode
order by c.customerNumber  ;

#Create below tables and fields. (You can add the data as per your wish)

	#	Laptop: (Laptop_Name)
	#	Colours: (Colour_Name)
	#	Perform cross join between the two tables and find number of rows.
create table Laptop (Laptop_Name char(20));
create table colors (color_Name char(20));

insert into laptop values ("Lenovo"),("HP");
insert into colors values ("Green"),("red"),("Blue");

select * from laptop
cross join colors;

#Create table project with below fields.

	#	EmployeeID
	#	FullName
	#	Gender
	#	ManagerID
#Add below data into it.
#INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
#INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
#INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
#INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
#INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
#INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
#INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);
#Find out the names of employees and their related managers.


create table project(
EmployeeID int,
FullName char(20),
Gender char(6),
ManagerID int);

INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);


select a.fullname , b.fullname as emp_name from project as a
inner join project as b 
on a.employeeid = b.managerid
order by fullname;




## Create table facility. Add the below fields into it.
	#	Facility_ID
	#	Name
	#	State
	#	Country

#i) Alter the table by adding the primary key and auto increment to Facility_ID column.
#ii) Add a new column city after name with data type as varchar which should not accept any null values.

create table facility (
Facility_ID int ,
Name varchar(100),
State varchar(100),
Country varchar(100));

desc facility;

alter table facility
modify column facility_id int primary key auto_increment ;

alter table facility 
add column city varchar(100) not null after name; 




## Create table university with below fields.
	#	ID
	#	Name
#Add the below data into it as it is.
#INSERT INTO University
#VALUES (1, "       Pune          University     "), 
 #              (2, "  Mumbai          University     "),
  #            (3, "     Delhi   University     "),
   #           (4, "Madras University"),
    #          (5, "Nagpur University");
#Remove the spaces from everywhere and update the column like Pune University etc.


create table university (
id int,
name char(50));

INSERT INTO University
VALUES (1, "       Pune          University     "), 
(2, "  Mumbai          University     "),
(3, "     Delhi   University     "),
(4, "Madras University"),
(5, "Nagpur University");
              
select id,concat(trim(left(trim(name),7))," ",right(trim(name),10)) as name from university;              

select trim(left(trim(name),7)) from university;





## Create the view products status. Show year wise total products sold. Also find the percentage of total value for each year. The output should look as shown in below figure.

create view productsold as 
select  year(orderdate) as y, concat(count(productcode)," ","(", round(count(productcode)*100/ (select count(productcode) from orderdetails),0),"%",")") as total from orders as o
join orderdetails as od
on o.ordernumber = od.ordernumber 
group by y; 


select * from productsold;



## Create a stored procedure GetCustomerLevel which takes input as customer number and gives the output as either Platinum, Gold or Silver as per below criteria.

#Table: Customers

	#	Platinum: creditLimit > 100000
	#	Gold: creditLimit is between 25000 to 100000
	#	Silver: creditLimit < 25000

#Create a stored procedure Get_country_payments which takes in year and country as inputs and gives year wise, country wise total amount as an output. Format the total amount to nearest thousand unit (K)
#Tables: Customers, Payments


select * from customers;

call assignment.levels(103);

select year(p.paymentdate) , c.country , concat(round((sum(p.amount)/1000),0),"K") as total_amount from payments as p 
join customers as c 
on c.customernumber = p.customernumber
where year(p.paymentdate) = 2003 and c.country = "france"
group by year(p.paymentdate), c.country;



## 	Calculate year wise, month name wise count of orders and year over year (YoY) percentage change. Format the YoY values in no decimals and show in % sign.
#Table: Orders

select year(orderdate) as year ,
monthname(orderdate) as month , 
count(ordernumber) as total_order,
concat(
round(
((count(ordernumber)- LAG(count(ordernumber)) OVER ( ORDER BY year(orderdate)))
/LAG(count(ordernumber)) OVER ( ORDER BY year(orderdate)))*100,0)
,"%") AS yoy   from orders
group by year(orderdate),monthname(orderdate);


##Create the table emp_udf with below fields.

	#	Emp_ID
	#	Name
	#	DOB
#Add the data as shown in below query.
#INSERT INTO Emp_UDF(Name, DOB)
#VALUES ("Piyush", "1990-03-30"), ("Aman", "1992-08-15"), ("Meena", "1998-07-28"), ("Ketan", "2000-11-21"), ("Sanjay", "1995-05-21");
#Create a user defined function calculate_age which returns the age in years and months (e.g. 30 years 5 months) by accepting DOB column as a parameter.

create table emp_udf(
Emp_ID int primary key auto_increment,
Name char(100),
DOB date);

INSERT INTO Emp_UDF(Name, DOB)
VALUES ("Piyush", "1990-03-30"), ("Aman", "1992-08-15"), ("Meena", "1998-07-28"), ("Ketan", "2000-11-21"), ("Sanjay", "1995-05-21");


DELIMITER //

CREATE FUNCTION calculate_age(dob DATE)
RETURNS VARCHAR(50) DETERMINISTIC
BEGIN
    DECLARE age_years INT;
    DECLARE age_months INT;

    SET age_years = TIMESTAMPDIFF(YEAR, dob, CURDATE());
    SET age_months = TIMESTAMPDIFF(MONTH, dob, CURDATE()) - 12 * age_years;

    RETURN CONCAT(age_years, ' years ', age_months, ' months');
END //

DELIMITER ;

SELECT emp_id, Name, calculate_age(DOB) AS Age FROM emp_udf;



select * from emp_udf;




## Display the customer numbers and customer names from customers table who have not placed any orders using subquery
#Table: Customers, Orders

select customernumber , customername from  customers 
where customernumber not in (select customernumber from orders)
group by customernumber , customername
order by customernumber;

#Write a full outer join between customers and orders using union and get the customer number, customer name, count of orders for every customer.
#Table: Customers, Orders

select o.customernumber , c.customername, count(c.customernumber) from customers as c
left join orders as o
on c.customernumber = o.customernumber
group by c.customernumber,c.customername; 

#Show the second highest quantity ordered value for each order number.
#Table: Orderdetails

select ordernumber ,max(quantityordered) from orderdetails
where quantityordered not in (select max(quantityordered) from orderdetails
group by ordernumber )
group by ordernumber ,quantityordered;

#For each order number count the number of products and then find the min and max of the values among count of orders.
#Table: Orderdetails
select ordernumber, quantityordered from orderdetails
group by ordernumber,quantityordered 
order by ordernumber,quantityordered desc;

select ordernumber , max(quantityordered) as maxx, min(quantityordered) as minn from orderdetails
group by ordernumber;

#Find out how many product lines are there for which the buy price value is greater than the average of buy price value. Show the output as product line and its count.

select productline , count(buyprice) as ct from products 
where buyprice > (select avg(buyprice) from products)
group by productline;



##Create the table Emp_EH. Below are its fields.
	#	EmpID (Primary Key)
	#	EmpName
	#	EmailAddress
#Create a procedure to accept the values for the columns in Emp_EH. Handle the error using exception handling concept. Show the message as “Error occurred” in case of anything wrong.





CREATE TABLE Emp_EH(

Emp_ID INT PRIMARY KEY, Name VARCHAR(100) NOT NULL

);
DELIMITER //

CREATE PROCEDURE Insert_Emp(IN p_id INT, IN p_name VARCHAR(100)) BEGIN

DECLARE EXIT HANDLER FOR 1048 SELECT "Don't insert null values in Emp ID or Name" AS Message;

INSERT INTO Emp_EH

VALUES(p_id, p_name);

SELECT * FROM Emp_EH;

END //

CALL Insert_Emp(1, "A");




## Create the table Emp_BIT. Add below fields in it.
	#	Name
	#	Occupation
	#	Working_date
	#	Working_hours

#Insert the data as shown in below query.
#INSERT INTO Emp_BIT VALUES
#('Robin', 'Scientist', '2020-10-04', 12),  
#('Warner', 'Engineer', '2020-10-04', 10),  
#('Peter', 'Actor', '2020-10-04', 13),  
#('Marco', 'Doctor', '2020-10-04', 14),  
#('Brayden', 'Teacher', '2020-10-04', 12),  
#('Antonio', 'Business', '2020-10-04', 11);  
 
#Create before insert trigger to make sure any new value of Working_hours, if it is negative, then it should be inserted as positive.

use assignment;
create table emp_bit (
Name char(100),
Occupation char(100),
Working_date date,
Working_hours int);

insert into emp_bit values
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);

select * from emp_bit;
insert into emp_bit values
('Rin', 'Sciist', '2220-11-04', -12); 

desc emp_bit ;