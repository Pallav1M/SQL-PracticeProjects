-- Case When
-- ============

select * from flights;

-- You need to find out how many tickets you have sold in the following category? 
-- Low price ticket : total_amount < 20,000
-- Mid price ticket : total_amount between 20,000 and 150,000 
-- high price ticket : total_amount >= 150,000

-- How many high price tickets has the company sold? 

select * from bookings;

select 
count(*) as no_tickets,
case
when total_amount < 20000 then 'low price ticket'
when total_amount between 20000 and 150000 then 'mid price ticket'
else 'high price ticket'
end as price_category
from bookings
group by price_category;
-- order by price_category asc;
-- limit 1;

-- You need to find out how many flights have departed in the following season - 

-- Winter - December, January, February
-- Spring - March, April, May
-- Summer - June, July, August
-- Fall - Sepetember, October, November

select * from flights;

select count(*) as no_of_flights,
case
when extract(month from scheduled_departure) in (12,1,2) then 'Winter'
when extract(month from scheduled_departure) in (3,4,5) then 'spring'
when extract(month from scheduled_departure) in (6,7,8) then 'Summer'
else 'Fall'
end as season
from flights
group by season;			 

-- Replace - Replaces text from a string in a column with another text
-- =======

-- Replace PG of the flight number and change the data type into INT

select 
flight_no,
cast(replace(flight_no,'PG','') as INT)
from flights;

-- JOINS
-- ======
-- Inner joins - Only rows that appear in both tables
-- ===========
-- The airline company wants to know in which category they sell most tickets - Business , Economy, Comfort

select * from seats;
select * from boarding_passes;

select fare_conditions
, count(*)
from seats 
inner join 
boarding_passes on seats.seat_no = boarding_passes.seat_no
group by fare_conditions;

-- Full Outer Join
-- ===============

-- Find the tickets which dont have boarding passes? 

select * from boarding_passes;

select * from tickets
full outer join boarding_passes 
on tickets.ticket_no = boarding_passes.ticket_no 
where tickets.ticket_no is null;

-- Left Outer Join
-- ==============
-- Find all aircrafts that have not been used in any flights;

select * from aircrafts_data;
select * from flights;

select * from aircrafts_data a
left join flights f
on a.aircraft_code = f.aircraft_code
where f.flight_id is null;

-- The flight company is trying to find out what their most popular seats are. 

-- Try to find out the seats that have been most frequently chosen. 
-- Make sure all the seats are included even if they have never been booked. 
-- Are there any seats that have never been booked?

select * from seats;
select * from boarding_passes;

select count(*), seats.seat_no
from seats
left join boarding_passes 
on seats.seat_no = boarding_passes.seat_no
-- where boarding_passes.boarding_no is null
group by seats.seat_no
order by count(*) desc;

-- Try to find which line (A,B,H) has been most frequently chosen?
	
select right(seats.seat_no,1), count(*)
from seats
left join boarding_passes 
on seats.seat_no = boarding_passes.seat_no
-- where boarding_passes.boarding_no is null
group by right(seats.seat_no,1)
order by count(*) desc;

-- Joins on multiple conditions (Expert Tip - using AND is more efficient than WHERE clause)
-- ============================

-- Get the average price for the different seat numbers.

select * from ticket_flights;
select * from boarding_passes;
select * from seats;

-- Why the following is wrong is because we can have all calculation based on just two tables, we need not use the seats table.

-- select round(avg(tf.amount),2), s.seat_no
-- from seats s
-- inner join boarding_passes bs 
-- on s.seat_no = bs.seat_no 
-- inner join ticket_flights tf 
-- on bs.ticket_no = tf.ticket_no
-- group by s.seat_no
-- order by avg(tf.amount) desc;

select seat_no, round(avg(amount),2) 
from boarding_passes b
left join ticket_flights t
on b.ticket_no = t.ticket_no 
and b.flight_id = t.flight_id
group by seat_no
order by round(avg(amount),2) desc;

-- Joing multiple tables
-- ======================

-- For single ticket, display the column of the scheduled departure 

select * from tickets;
select * from flights;
select * from ticket_flights;

select t.ticket_no, f.scheduled_departure  from tickets t
inner join ticket_flights tf
on t.ticket_no = tf.ticket_no
inner join flights f 
on tf.flight_id = f.flight_id;

-- See the movie database file for "Joining multiple tables"

-- Which passenger (passenger_name) has spent most amount in their bookings (total_amount)?
select * from bookings;
select * from tickets;

select passenger_name, sum(total_amount)
from tickets 
inner join bookings 
on tickets.book_ref = bookings.book_ref
group by passenger_name
order by sum(total_amount) desc;

-- Which fare_condition has ALEKSANDR IVANOV used the most?

select passenger_name, count(fare_conditions), fare_conditions
from tickets 
inner join ticket_flights 
on tickets.ticket_no = ticket_flights.ticket_no
where passenger_name = 'ALEKSANDR IVANOV'
group by passenger_name, fare_conditions
order by count(fare_conditions) desc;

SELECT passenger_name, fare_conditions, COUNT(*) FROM tickets t
INNER JOIN bookings b
ON t.book_ref=b.book_ref
INNER JOIN ticket_flights tf
ON t.ticket_no=tf.ticket_no
WHERE passenger_name = 'ALEKSANDR IVANOV'
GROUP BY fare_conditions, passenger_name;

-- See the movie database for more challenges on multiple joins 

-- OVER() with ORDER BY()
-- =====================

-- Write a query that returns the running total of how late the flights are (difference between actual arrival and 
-- scheduled arrival) ordered by flight_id including the departure airport. 
-- As a second query, calculate the same running total but partition also by the departure airport. 

select flight_id, 
departure_airport,
sum(actual_arrival - scheduled_arrival)
over(partition by departure_airport order by flight_id)
from flights;

-- Go to the movie database for the next section - RANK()

