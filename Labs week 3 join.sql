use sakila;

-- List number of films per category.
select category_id, sum(film_id) from sakila.film_category
group by category_id
order by category_id; 


-- Display the first and last names, as well as the address, of each staff member.
select first_name, last_name, address_id from sakila.staff; 



-- Using the tables payment and customer and the JOIN command, 
-- list the total paid by each customer. 
-- List the customers alphabetically by last name.
select c.last_name as customer, sum(p.amount) as total_amount from sakila.customer as c
join sakila.payment as p
on c.customer_id = p.customer_id
group by c.last_name
order by c.last_name;



--                         lab 2

use sakila;
-- Write a query to display for each store its store ID, city, and country.

select c.city as city, s.store_id as store_id, co.country as country  from sakila.city c
join sakila.country as co
on c.country_id = co.country_id
left join sakila.store as s
on s.last_update = co.last_update;

-- Write a query to display how much business, in dollars, each store brought in.
select s.store_id as store, sum(p.amount) as total_amount from sakila.store as s
join sakila.customer as c
on s.store_id = c.store_id
join sakila.payment as p
on c.customer_id = p.customer_id
group by s.store_id
order by total_amount;

-- What is the average running time of films by category?
select c.name as name, avg(f.length) as average_movie_length from sakila.category as c
join sakila.film_category as fc
on c.category_id = fc.category_id
join sakila.film as f
on f.film_id = fc.film_id
group by c.name
order by average_movie_length; 

-- Which film categories are longest?
select c.name as name, avg(f.length) as average_movie_length from sakila.category as c
join sakila.film_category as fc
on c.category_id = fc.category_id
join sakila.film as f
on f.film_id = fc.film_id
group by c.name
order by average_movie_length desc; 

-- Display the most frequently rented movies in descending order.
select*from sakila.rental
order by inventory_id desc;

-- List the top five genres in gross revenue in descending order.
select c.name as category_name, sum(p.amount) as gross_revenue  from sakila.category as c
left join sakila.film_category as fc
on fc.category_id = fc.category_id
left join sakila.inventory as i
on fc.film_id = i.film_id
left join sakila.rental as r
on i.inventory_id = r.inventory_id
left join sakila.payment as p
on r.rental_id = p.rental_id
group by name
order by gross_revenue
limit 5;

-- Is "Academy Dinosaur" available for rent from Store 1?
select f.title, s.store_id , inventory_id, i.last_update from sakila.film as f
join sakila.inventory as i
on f.film_id = i.film_id 
join sakila.store as s
on i.store_id = s.store_id
where f.title = 'Academy Dinosaur' and s.store_id ='1';

use sakila;

--                       lab 3

-- Get all pairs of actors that worked together.

select fa1.film_id, concat(a1.first_name, ' ', a1.last_name), concat(a2.first_name, ' ', a2.last_name)
from sakila.actor as a1
inner join sakila.film_actor as fa1
on a1.actor_id = fa1.actor_id
inner join film_actor fa2
on (fa1.film_id = fa2.film_id) and (fa1.actor_id != fa2.actor_id)
inner join actor a2
on a2.actor_id = fa2.actor_id;



-- Get all pairs of customers that have rented the same film more than 3 times.

SET sql_mode=(SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));

select r1.customer_id, r1.inventory_id, count(r1.rental_id) as 'Times_rented', r2.customer_id, count(r2.rental_id) as ' Times_rented_2' from sakila.rental as r1
join sakila.rental as r2
on r1.customer_id <> r2.customer_id
and r1.inventory_id = r2.inventory_id
group by r1.customer_id, r2.customer_id
having (count(r1.rental_id)>3) and (count(r2.rental_id)>3);


--  Get all possible pairs of actors and films.
select * from (
 select distinct actor_id from sakila.actor
 ) sub1
 cross join (
select distinct film_id from sakila.film_actor
) sub2; 

