select * from actor;

-- The Marketting Manager wants you for a list of all customers with first name, last name, and customer's email address. 

Select first_name, last_name, email
from customer;

-- Order by - By default, it is ascending
-- ======================================

-- The Marketing manager asks you to order the customer list by last name.

select first_name, last_name, email
from customer
order by last_name desc, first_name;

select first_name, last_name, email
from customer
order by 2 desc, 1 desc;

-- Distinct
-- ===============

select distinct 
first_name, last_name
from actor
order by first_name;

select * from film;

select distinct rating from film;

select distinct rating, rental_duration from film;

-- A Marketing team memeber asks you about the different prices that have been paid?

select distinct amount 
from payment
order by amount desc;

-- Limit - Always at the end of our query, and to get a quick idea about the table
-- ===============================================================================

select * from rental;

-- count() - used to count the number of rows in a output
-- often used with grouping and filtering 
-- =======================================================

-- Create a list of all the distinct districts customers are from?

select distinct district 
from address;

-- what is the latest rental date?

select rental_date 
from rental 
order by rental_date desc
limit 1;

-- how many films does the company have?

select * from film;

select count(*) 
from film;

-- BASIC FILTERING
-- ===============

-- how many distinct last names of the customers are there? 

select count(distinct last_name)
from customer;

-- How many payments were made from customers with customer id = 100;

select count(payment_id)
from payment 
where customer_id = 100;

-- what is the last name our customer with first name 'ERICA'? 

select first_name,last_name 
from customer 
where first_name = 'ERICA';

-- Marketing Manager wants to see a list of payments which are greater than $10? 

Select amount
from payment 
where amount > 10;

-- The inventory manager asks you how rentals have not been returned yet (return date is null)

select count(*) from rental 
where return_date is null;

-- The sales manager asks you for a list of all the payment_ids with an amount less than or equal to $2. 
-- Include payment_id and the amount. 

select payment_id, amount
from payment 
where amount <= 2;

-- Where with AND and OR
-- =====================

-- The support manager asks you about a list of all the payment of the customer 322, 346, and 354 where the amount 
-- is either less than $2 or greater than $10. It should be ordered by the customer first name(ascending) and then as second condition 
-- order by amount in a descending order. 

select customer_id, amount 
from payment 
where customer_id in(322, 346, 354)
and (amount < 2 or amount > 10)
order by customer_id asc, amount desc;

-- Between
-- ===========

-- The marketing manager mentions that there have been some faulty payments and you need help to find out how many payments
-- have been affected. How many payments have been made on January 26th and 27th 2020 with an amount between 1.99 and 3.99?

select * from payment;

select count(payment_id)
from payment 
where payment_date between '2020-01-26 00:00' and '2020-01-27 23:59'
--  where payment_date between '2020-01-26' and '2020-01-28'
and amount between 1.99 and 3.99;

select * from customer
where customer_id in(123, 212, 323,243,353,432);

-- The Marketing manager says that there have been complaints of 6 customers about their payments. Here are the customer IDs - 
-- 12, 25, 67, 93, 124, 234. The concerned payments are all the payments of these customers with amounts 4.99, 7.99, 9.99 in January 2020. 
-- Write a SQL query to get a list of the concerned payments. 

select * from payment 
where customer_id in(12,25,67,93, 124,234)
and amount in(4.99,7.99,9.99)
and payment_date between '2020-01-01' and '2020-01-31 23:59';

-- Like - It is case-sensitive
-- ===========================

-- You need to help the inventory manager to find out :
-- How many movies are there that contains the "Documentary" in the description? 

select count(film_id)
from film
where description like '%Documentary%';

-- How many customers are there with a first name that is 3 letters long and either an 'X' or 'Y' as the last letter in
-- the last name? 

select count(customer_id)
from customer
where first_name like '___'
-- where length(first_name) = 3
and (last_name like '%X' or last_name like '%Y'); -- adding this bracket is very important as it can change the output

-- How many movies are there that contains "Saga" in the description and where the title starts either with "A" or ends with "R". 
-- Use the alias "no_of_movies"

select
count(film_id) as "no_of_movies"
from film
where description like '%Saga%'
and (title like 'A%' or title like '%R');

-- Create a list of all customers where the first name contains "ER" and has a "A" as the second letter. Order the results by the last name
-- descendingly. 

select * 
from customer
where first_name like '%ER%'
and first_name like '_A%'
order by customer_id desc;

-- How many payments are there where the amount is either 0 or is between 3.99 and 7.99 and in the same time has happened 
-- on 2020-05-01. 

select *
from payment
where (amount = 0.00 or amount between 3.99 and 7.99)
and (payment_date between '2020-05-01' and '2020-05-02');

-- AGGREGATE FUNCTIONS AND GROUPS
-- ==============================

-- Your manager wants you to write a query to see the 
-- minimum
-- maximum
-- average(round)
-- sum
-- of the replacement cost of the films

Select 
min(replacement_cost),
max(replacement_cost),
round(avg(replacement_cost),2),
sum(replacement_cost)
from film;

-- Your Manager wants to know which of the two employees is repsonsible for more payments?

select * from payment;

-- Which of the two is reponsible for a higher overall payment amount? Make sure to add a count of payments 
select 
sum(amount),
count(payment_id),
staff_id 
from payment 
group by staff_id
order by count(payment_id) desc;

-- How do these amounts change if we don't consider amounts equal to 0? Sum should be constant, only count should change.

select * from payment;

select 
sum(amount),
count(payment_id),
staff_id 
from payment 
where amount != 0.00
group by staff_id
order by count(payment_id) desc;

-- Group by multiple columns
-- =========================

-- There are two competition between the two employees
-- Which employee had the highest sales amount in a single day
-- Which employee had the most sales in a single day(not counting payments with amount =0)

select * from payment;

select staff_id, date(payment_date), sum(amount), count(payment_id)
from payment 
where amount != 0
group by staff_id, date(payment_date)
order by sum(amount) desc;

-- Having
-- =========

-- Manager wants to see an output with number of sales more than 400 only 

select staff_id, 
count(*)
from payment 
where amount != 0
group by staff_id
having count(*) > 400;

-- In April 2020, 28, 29th and 30th were the dates with very high revenue. That why we want to focus in this task only on those days. 
-- Find out what is the average payment amount grouped by customers and day - consider only the days/customers with more
-- than 1 payment (per customer and day). Order by the average amount in a descending order. 

select * from payment;

select round(avg(amount),2), customer_id, date(payment_date), count(payment_id)
from payment
where date(payment_date) in('2020-04-28','2020-04-29','2020-04-30')
group by customer_id, date(payment_date)
having count(payment_id)> 1
order by avg(amount) desc;

-- FUNCTIONS
-- =========

-- Functions - Length, Lower and Upper
-- =====================================
-- In the email system there was a problem with names where either the first name or the last name is more than 10 character long. 

-- Find these customers and output the list of these first and last names in all lower case.

select lower(first_name) as lower_first_name, lower(last_name) as lower_last_name, lower(email) as lower_email
from customer
where length(first_name) >10 or length(last_name) >10;

-- Functions -Left and Right
-- =========================
-- Extract the last 5 characters of the email address first.
-- The email always ends with '.org'
-- How can you extract just the dot from the email address?

select * from customer;

select right(email,5)
from customer;

select left(right(email,4),1), email
from customer;

-- The Manager wants me to create an anonymous version of the email address. It should be the first character followed 
-- by *** and then the last part starting with '@'. Note that the email always ends with @sakilacustomer.org.

select * from customer;

select left(email,1) || '***' ||'@sakilacustomer.org', email
from customer;

-- Position
-- ===========

-- In this challenge, you have only the email address and the last name of the customers. You need to extract the first name
-- from the email address and concatinate it with the last name. It should be in the form : Last name,First name. 

Select last_name || ',' || Left(email,position('.' in email)-1),
last_name
from 
customer;

-- Substring
-- ============

-- You need to create an anonymized form of the email addresses in the following way:
-- M**.S**@sakilacustomer.org
-- In the second query, create an anonymized form of the email addresses in the following way:
-- ***Y.S**@sakilacustomer.org

select 
'***' || substring(email from position('.' in email)-1 for 3)
|| '***'
|| substring(email from position('@' in email))
from customer;

-- Function - Extract (used to extract parts of timestamp/date)
-- ===============================================================

-- You need to analyze the payments and find out the following - 

-- What's the month with the highest total payment amount?
-- What's the day of the week with the highest total payment amount?(0 is Sunday)
-- What's the highest amount one customer has spent in a week?

select 
extract(month from payment_date) as month,
sum(amount) as total_payment_amount
from payment
group by 
month 
order by total_payment_amount desc;

select 
extract(dow from payment_date) as dow,
sum(amount) as total_payment_amount
from payment
group by 
dow 
order by total_payment_amount desc;

select 
customer_id,
extract(week from payment_date) as week,
sum(amount) as total_payment_amount
from payment
group by 
week , customer_id
order by total_payment_amount desc;

-- Function - To Char
-- =====================
select sum(amount) as total_payment,
to_char(payment_date,'Dy,HH:MI') as Day_time
from payment
group by day_time
order by total_payment asc;

-- Function - Intervals and Timestamps
-- ======================================

-- You need to create a list for the support team of all rental duration of customer with customer_id 35. 

-- Also, you need to find out for the support team which customer has the longest average rental dusration

select customer_id,
avg(return_date - rental_date) as rental_duration
from rental
group by customer_id 
order by rental_duration desc;

-- CONDITIONAL EXPRESSIONS
-- =======================

-- Mathematical functions and Operators
-- =======================================

-- Your manager is thinking of increasing the prices for films that are more expensive to replace. 
-- Fro that reason, you should create a list of the films including the relation of rental rate/replacement cost where the 
-- rental rate is less than 4% of the replacement cost. 
-- Create a list of that film_ids together with the percentage rounded to 2 decimal places. For example 3.45 = 3.45%.

select * from film;

select film_id, 
-- rental_rate, 
-- replacement_cost, 
(round(((rental_rate/replacement_cost)*100),2) || '%') as percentage
from film
where rental_rate < (0.04*replacement_cost)
order by percentage asc;

-- Case - When
-- ===========

-- You want to create a tier list in the following way -

-- Rating is PG or PG-13 or length is more than 210 mins - Great rating or long(tier 1)
-- Description contains Drama and length is more than 90 mins - Long drama (tier 2)
-- Description contains 'Drama' and length is not more than 90 mins - Short drama (tier 3)
-- Rental_rate less than $1 - Very cheap (tier 4)

-- If one movie can be in multiple tier, it is always in higher tier.
-- How can you filter to only those movies that appear in one of those 4 tiers? 

select * from film;

select title,
case
when rating in('PG','PG-13') or length > 210 then 'Great rating or long - tier-1'
when description like '%Drama%' and length > 90 then 'Long drama - tier 2'
when description like '%Drama%' and length < 90 then 'Short drama - tier 3'
when rental_rate < 1 then 'Very cheap - tier 4'
end as tier
from film
-- ;
WHERE -- you cant just write where tier is null because where clause is processed first and tier doesnt exist yet.
CASE
WHEN rating IN ('PG','PG-13') OR length > 210 THEN 'Great rating or long (tier 1)'
WHEN description LIKE '%Drama%' AND length>90 THEN 'Long drama (tier 2)'
WHEN description LIKE '%Drama%' THEN 'Short drama (tier 3)'
WHEN rental_rate<1 THEN 'Very cheap (tier 4)'
END is not null;

-- Case When and Sum - you can count the number of times a value (usually 1) is present.
-- =================

select * from film;

select rating,
count(*)
from film 
group by rating;

select 
sum(case when rating ='G' then 1 else 0 end) as "G",
sum(case when rating ='R' then 1 else 0 end) as "R",
sum(case when rating ='PG-13' then 1 else 0 end) as "PG-13",
sum(case when rating ='NC-17' then 1 else 0 end) as "NC-17",
sum(case when rating ='PG' then 1 else 0 end) as "PG"
from film;

-- coalesce - Returns the first vaue of a list of value which is not null
-- ========

-- cast - 
-- ======

select 
return_date,
coalesce(cast(return_date as varchar),'not returned')
from rental
order by rental_date desc;

-- Right Outer Join
-- ================

-- The company wants to run a phone call campaign on all customers in Texas. Who are the customers (first_name, last_name, 
-- 																								 phone number, and their district) from Texas? 

select * from customer;
select * from address;

select c.first_name, c.last_name, a.phone, a.district  from customer c
left join address a
on a.address_id = c.address_id
where a.district = 'Texas';

-- See the flight database sql file --

-- Joining multiple tables
-- ========================
-- The company wants to customize their campaigns to customets based on their 	country of origin. 
-- Which customers are from Brazil? 
-- Write a query to get first_name, last name, email, and country from BRazil. 

select * from city;
select * from address;
select * from country;

select first_name, last_name, email, c.country
from customer cu
left join address a 
on cu.address_id = a.address_id
left join city ci 
on a.city_id = ci.city_id
left join country c 
on ci.country_id = c.country_id 
where c.country = 'Brazil';

-- See flight database sql file for more challnges on multiple joins/multiple table joins

-- Which title has GEORGE LINTON rented the most often?

select * from film;
select * from customer;
select * from rental;
select * from inventory;

select title, count(title)
from customer 
inner join 
rental on customer.customer_id = rental.customer_id
inner join 
inventory on rental.inventory_id = inventory.inventory_id
inner join 
film on inventory.film_id = film.film_id
WHERE first_name='GEORGE' and last_name='LINTON'
group by title
order by count(title) desc;

-- UNION AND SUBQUERIES
-- ====================
-- UNION 
-- ===============================================

--       - Must be aware of the order in the match
--       - No of columns must match
-- 		 - Data tyoes must match 
-- 		 - Duplicates are decoupled

-- Subqueries
-- ==========

-- Manager wants me to get a list of all the payments are greater than the average payment amount

select * from payment 
where amount > (select avg(amount) from payment);

-- Select all the films where the length is longer than the average of all films

select title, length
from film 
where length > (
select avg(length) from film)
;

-- Return all the films which are available in inventory in store 2 more than 3 times. 
select * from inventory;

select  f.title, i.store_id, count(f.film_id) 
from film f
inner join 
inventory i on f.film_id = i.film_id
where i.store_id = 2
group by f.title, i.store_id
having count(f.film_id) > 3
order by f.title asc;

select title
from film 
where film_id in(
	select film_id from inventory
	where store_id = 2 
	group by film_id 
	having count(*) > 3);
	
-- Return all customer's first names and last names that have made a payment on '2020-01-25'
select * from payment;

select first_name, last_name 
from customer 
where customer_id in (
select customer_id from payment 
where date(payment_date) = '2020-01-25');

-- Return all customers first and email addresses that have spent more than $30.  

select first_name, last_name, email
from customer
where customer_id in 
(select customer_id
from payment 
group by customer_id
having sum(amount) > 30);

-- Return all the customers first name and first name that are from California and have spent more than 100$ in total? 
select * from address;

select first_name, last_name, email
from customer
where address_id in 
(select address_id 
from address 
where district = 'California')
and customer_id in 
(select customer_id
from payment 
group by customer_id
having sum(amount) > 100)
order by first_name asc;


-- MANAGING TABLES AND DATABASES
-- =============================
-- CREATE
-- ======

-- Create a table called online_sales with the following columns:
-- transaction_id
-- customer_id
-- film_id
-- amount
-- promotion_code
-- Transaction_id shoul be the primary key.
-- The columns customer_id and film_id should be foreign keys to the relevant tables.
-- The amount column can contain values from 0.00 to 999.99 - nulls should not be allowed.
-- The column promotion_code contains a promotion code of at maximum 10 characters. If there is no value you should set the default value 'None'.
-- Create that table and choose appropriate data types and constraints!
-- Questions for this assignment

-- What data type you think is appropriate for the transaction_id column?

create table online_sales(
transaction_id serial primary key,
customer_id int references customer(customer_id), 
film_id int references film(film_id),
amount numeric(5,2) not null,
promotion_code varchar(10) default 'None'
);

insert into online_sales(customer_id, film_id, amount, promotion_code)
values
(124, 65, 14.99, 'PROMO2022'),
(225,231,12.99,'JULYPROMO'),
(119,53,15.99,'SUMMERDEAL');

select * from online_sales;

-- ALTER
-- =====

create table director
( 
	director_id serial primary key,
	director_account_name varchar(20) unique,
	first_name varchar(50),
	last_name varchar(50) default 'not specified',
	date_of_birth date,
	address_id int references address(address_id)	
);

-- alter 
-- 1.director account name to varchar(30)
-- 2.drop the default on last_name 
-- 3.add the constraint 'not null' to last name
-- 4.add the column email of data type varchar(40)
-- 5.rename the director_account_name to account_name 
-- 6.rename the table from director to directors

alter table director 
alter column director_account_name type varchar(30),
alter column last_name drop default,
alter column last_name set not null, 
add column email varchar(40)

select * from director;

alter table director 
rename director_account_name to account_name

alter table director 
rename to directors;

-- DROP AND TRUNCATE
-- =================
 Drop - Deletes the table 
 Truncate - deletes all data in a table 
 
Create table emp_table 
(
	emp_id serial primary key,
	emp_name text
);

select * from emp_table;

drop table emp_table;

insert into emp_table
values(1, 'Frank'),
(2,'Maria');

truncate table emp_table;
select * from emp_table;

truncate  emp_table;
select * from emp_table;

-- CHECK
-- =====

create table songs
(
	song_id serial primary key,
	song_name varchar(30) not null,
	genre varchar(30) default 'Not Defined',
	price numeric(4,2) check(price>=1.99),
	release_date date constraint date_check check(release_date between '01-01-1950' and current_date)
);
select * from songs;

insert into songs(song_name, price, release_date)
values(
	'SQL songs',0.99, '01-07-2022'
)
-- ERROR:  new row for relation "songs" violates check constraint "songs_price_check"
-- DETAIL:  Failing row contains (1, SQL songs, Not Defined, 0.99, 2022-01-07).
-- SQL state: 23514

-- Drop the default constraint 
-- ===========================

-- In order to update the constraint, first drop the constraint. 
-- The default constraint is tablename_columnname_check
                             --------------------------

alter table songs 
drop constraint songs_price_check;

alter table songs
add constraint songs_price_check check(price>=0.99);

select * from songs;

-- VIEWS AND DATA MANIPULATION
-- ===========================

-- Update
-- ======

update customer
set last_name = 'Brown'
where customer_id = 1;

select * from customer
order by customer_id asc;

-- update all rental prices that are 0.99 to 1.99

update film
set rental_rate = 1.99
where rental_rate = 0.99;

select * from film;

-- The customer table needs to be altered as well
-- add the column initial  with datatype(varchar(10))

alter table customer
add column initials varchar(4);
select * from customer;

-- update the values to the actual initial - For example Frank Smith will be F.S

update customer
set initials = left(first_name, 1) || '.'|| left(last_name,1) || '.';
select * from customer;


-- DELETE
-- ======
select * from songs;

To return all the values to be deleted

delete from songs 
where song_id in(3,4)
returning *

-- There have been two payments that are not correct and they need to be deleted - 17064 and 17067

select * from payment
where payment_id in(17064, 17067);

delete from payment
where payment_id in(17064, 17067)
returning *;

select * from payment
where payment_id in(17064, 17067);

-- CREATE TABLE AS
-- ===============
create table customer_address 
as
select first_name, last_name, email, address , city
from customer c left join address a
on c.address_id = a.address_id 
left join city ci on a.city_id = ci.city_id;

select * from customer_address;

-- Create a table with the first_name and the last name in one column and the total spending. 

create table customer_spending 
as
select first_name || ' '|| last_name as name, 
sum(amount) as total_amount
from customer c 
left join payment p on 
c.customer_id = p.customer_id 
group by name;

select * from customer_spending;

-- VIEWS
-- =====
drop table customer_spending;

select * from customer_spending;

create view customer_spending 
as
select first_name || ' '|| last_name as name, 
sum(amount) as total_amount
from customer c 
left join payment p on 
c.customer_id = p.customer_id 
group by name;

-- Create a view called films_category that shows a list of the film titles including their title, length and category name ordered descendingly by the length.
-- Filter the results to only the movies in the category 'Action' and 'Comedy'.

create view films_category
as
select f.title, f.length, c.name
from film f 
left join film_category fc on f.film_id = fc.film_id
left join category c on fc.category_id = c.category_id 
where c.name in('Action','Comedy')
order by f.length desc;

-- CREATE MATERIALIZED VIEW - It will update the view if the tables from which the view is selected changes.
-- ========================
select f.title, f.length, c.name
from film f 
left join film_category fc on f.film_id = fc.film_id
left join category c on fc.category_id = c.category_id 
where c.name in('Action','Comedy')
order by f.length desc;

create materialized view mv_films_category
as
select f.title, f.length, c.name
from film f 
left join film_category fc on f.film_id = fc.film_id
left join category c on fc.category_id = c.category_id 
where c.name in('Action','Comedy')
order by f.length desc;

select * from mv_films_category;

-- Lets update the view
update film
set length = 192
where title = 'SATURN NAME';

-- Still does not reflect the change 
select * from mv_films_category;

-- Refresh the view to see the changes 
refresh materialized view mv_films_category;

select * from mv_films_category;

-- MANAGING VIEWS
-- ==============

-- ALTER VIEW AND DROP VIEWS 
-- ALTER MVIEW AND DROP MVIEW

-- create or replace view is not possible with materialized view 

CREATE VIEW v_customer_info
AS
SELECT cu.customer_id,
    cu.first_name || ' ' || cu.last_name AS name,
    a.address,
    a.postal_code,
    a.phone,
    city.city,
    country.country
     FROM customer cu
     JOIN address a ON cu.address_id = a.address_id
     JOIN city ON a.city_id = city.city_id
     JOIN country ON city.country_id = country.country_id
ORDER BY customer_id;

select * from v_customer_info;

-- 1) Rename the view to v_customer_information.

alter view v_customer_info 
rename to v_customer_information;

-- 2) Rename the customer_id column to c_id.

alter view v_customer_information
rename column customer_id to c_id;

-- 3) Add also the initial column as the third column to the view by replacing the view.
-- CREATE OR REPLACE VIEW v_customer_information
-- AS
-- SELECT cu.customer_id,
--     cu.first_name || ' ' || cu.last_name AS name,
--     cu.initials,
-- 	a.address,
--     a.postal_code,
--     a.phone,
--     city.city,
--     country.country
--      FROM customer cu
--      JOIN address a ON cu.address_id = a.address_id
--      JOIN city ON a.city_id = city.city_id
--      JOIN country ON city.country_id = country.country_id
-- ORDER BY customer_id

-- Import and Export
-- =================

-- Import - 
-- Import Exernal data into an existing table
-- Table needs to be xreated first
-- Data needs to be in correct format

CREATE TABLE sales (
transaction_id SERIAL PRIMARY KEY,
customer_id INT,
payment_type VARCHAR(20),
creditcard_no VARCHAR(20),
cost DECIMAL(5,2),
quantity INT,
price DECIMAL(5,2));

-- Now insert data from the csv file to sales table using the Import/Export tab - Fact_sales.csv

select * from sales;

-- Export - 
-- Export Data from a table into a csv file