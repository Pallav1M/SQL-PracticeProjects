-- MID COURSE PROJECT
-- ==================

-- Task 1: Create a list of all the different (distinct) replacement costs of the films.
-- Question: What's the lowest replacement cost?

select min(distinct(replacement_cost))
from film;

-- Task 2: Write a query that gives an overview of how many films have replacements costs in the following cost ranges
-- low: 9.99 - 19.99
-- medium: 20.00 - 24.99
-- high: 25.00 - 29.99
-- Question: How many films have a replacement cost in the "low" group?

select count(*), 
case
when replacement_cost between 9.99 and 19.99 then 'Low'
when replacement_cost between 20.00 and 24.99 then 'medium'
else 'high'
end as ranges
from film
group by ranges
;

-- Task 3: Create a list of the film titles including their title, length, and category name ordered descendingly by length. Filter the results to only the movies in the category 'Drama' or 'Sports'.
-- Question: In which category is the longest film and how long is it?

select f.title, f.length, c.category_id, cat.name
from film f 
inner join film_category c 
on f.film_id = c.film_id
inner join category cat
on c.category_id = cat.category_id
where cat.name in ('Drama', 'Sports')
order by  length desc
limit 1;

-- Task 4: Create an overview of how many movies (titles) there are in each category (name).
-- Question: Which category (name) is the most common among the films?

select count(f.film_id), c.name
from film f 
inner join film_category cat on f.film_id = cat.film_id 
inner join category c on cat.category_id = c.category_id
group by c.name
order by count(f.film_id) desc
limit 1;

-- Task 5: Create an overview of the actors' first and last names and in how many movies they appear in.
-- Question: Which actor is part of most movies??

select count(*), a.first_name, a.last_name
from actor a inner join film_actor fa on a.actor_id = fa.actor_id
group by a.first_name, a.last_name
order by count(*) desc
limit 1;

-- Task 6: Create an overview of the addresses that are not associated to any customer.
-- Question: How many addresses are that?

select count(*), a.address_id, a.address
from address a left join customer c on a.address_id = c.address_id
where customer_id is null
group by a.address_id, a.address;

-- Task 7: Create an overview of the cities and how much sales (sum of amount) have occurred there.
-- Question: Which city has the most sales?

-- city --> address --> customer --> payment

select c.city, c.city_id, sum(p.amount)
from city c inner join address a on c.city_id = a.city_id 
inner join customer cus on a.address_id = cus.address_id 
inner join payment p on cus.customer_id = p.customer_id
group by c.city, c.city_id
order by sum(p.amount) desc
limit 1;

-- Task 8: Create an overview of the revenue (sum of amount) grouped by a column in the format "country, city".
-- Question: Which country, city has the least sales?

-- payment p --> customer cus --> address a --> city ci --> country co

select sum(p.amount), co.country, ci.city
from payment p inner join customer cus on p.customer_id = cus.customer_id
inner join address a on cus.address_id = a.address_id 
inner join city ci on a.city_id = ci.city_id 
inner join country co on ci.country_id = co.country_id
group by co.country, ci.city
order by sum(p.amount)
limit 1;

-- Task 9: Create a list with the average of the sales amount each staff_id has per customer.
-- Question: Which staff_id makes on average more revenue per customer?

select staff_id, 
round(avg(total), 2)
from( -- per customer
select sum(amount) total, 
	staff_id, 
	customer_id
from payment
group by staff_id, customer_id
order by customer_id) sub 
group by staff_id;

-- Task 10: Create a query that shows average daily revenue of all Sundays.
-- Question: What is the daily average revenue of all Sundays?

select round(avg(total),2)
from
(select date(payment_date),
extract(dow from payment_date),
sum(amount) as total
from payment 
where extract(dow from payment_date) = 0
group by date(payment_date), 
extract(dow from payment_date))sub;

-- Task 11: Create a list of movies - with their length and their replacement cost - that are longer than the average length in each replacement cost group.
-- Question: Which two movies are the shortest on that list and how long are they?

select title, length, replacement_cost
from film f1
where length > 
(select avg(length)
 from film f2
 where f1.replacement_cost = f2.replacement_cost)
order by length asc
limit 2;

-- Task 12: Create a list that shows the "average customer lifetime value" grouped by the different districts.
-- Example: 
-- If there are two customers in "District 1" where one customer has a total (lifetime) spent of $1000 and the second customer has a total spent of $2000 then the "average customer lifetime spent" in this district is $1500.
-- So, first, you need to calculate the total per customer and then the average of these totals per district.

-- Question: Which district has the highest average customer lifetime value?
-- payment --> customer --> address

select 
round(avg(total),2),
district
from
	(select a.district, 
	sum(p.amount) as total,
	c.customer_id
	from payment p inner join customer c on p.customer_id = c.customer_id 
	inner join address a on c.address_id = a.address_id
	group by a.district, c.customer_id) sub
group by district
order by round(avg(total),2) desc
limit 2;

-- Task 13: Create a list that shows all payments including the payment_id, amount, and the film category (name) plus the total amount that was made in this category. Order the results ascendingly by the category (name) and as second order criterion by the payment_id ascendingly.
-- Question: What is the total revenue of the category 'Action' and what is the lowest payment_id in that category 'Action'?
-- payment --> 

select payment_id, 
amount, 
name,
(select sum(amount)
from payment p left join rental r on 
r.rental_id = p.rental_id 
left join inventory i on i.inventory_id = r.inventory_id
left join film f on i.film_id = f.film_id 
left join film_category fc on fc.film_id = f.film_id 
left join category c2 on fc.category_id = c2.category_id
where c1.name = c2.name)

from payment p left join rental r on 
r.rental_id = p.rental_id 
left join inventory i on i.inventory_id = r.inventory_id
left join film f on i.film_id = f.film_id 
left join film_category fc on fc.film_id = f.film_id 
left join category c1 on fc.category_id = c1.category_id
order by name;

-- Task 14: Create a list with the top overall revenue of a film title (sum of amount per title) for each category (name).
-- Question: Which is the top-performing film in the animation category?


