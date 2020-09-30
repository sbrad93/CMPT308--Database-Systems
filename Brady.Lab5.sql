-- 1. Show all the People data (and only people data) for people who are customers. 
-- Use joins this time; no subqueries.

select *
from People p inner join Customers c on p.pid = c.pid;

-- 2. Show all the People data (and only the people data) for people who are agents. 
-- Use joins this time; no subqueries.

select *
from People p inner join Agents a on p.pid = a.pid;

-- 3. Show all People and Agent data for people who are both customers and agents. 
-- Use joins this time; no subqueries.

select *
from People p inner join Agents    a on p.pid = a.pid
			  inner join Customers c on a.pid = c.pid;
               
-- 4. Show the First name of customers who have never placed an order. Use subqueries.

select firstName
from People
where pid in (select pid
				from Customers
				where pid not in (select custID
				   					from Orders));
                                    
-- 5. Show the first name of customers who have never placed an order. Use one inner and one outer join.

select p.firstName
from People p inner join      Customers c   on p.pid   = c.pid
			  left outer join Orders o      on c.pid   = o.custID
where o.ordernum is null;

-- 6. Show the id and commission percent of Agents who booked an order for the Customer whose id is 008, 
-- sorted by commission percent from low to high. Use joins; no subqueries.

select distinct a.pid, a.commissionpct
from Agents a inner join Orders o on a.pid = o.agentID
where o.custID = '008'
order by a.commissionpct;

-- 7. Show the last name, home city, and commission percent of Agents who booked an order 
-- for the customer whose id is 001, sorted by commission percent from high to low. Use joins.

select distinct p.lastName, p.homeCity, a.commissionpct
from Agents a inner join Orders o   on  a.pid     = o.agentID
              inner join People p   on  o.agentID = p.pid
where o.custID = '001'
order by a.commissionpct DESC;

-- 8. Show the last name and home city of customers 
-- who live in the city that makes the fewest different kinds of products. 
-- (Hint: Use count and group by on the Products table. You may need limit as well.)

select p.lastName, p.homeCity
from People p inner join Customers c on p.pid = c.pid
				inner join Products prod on prod.city = p.homeCity
where prod.city in (select city
	  				from Products
	  				group by city)
	  				having count(*) = 1);

-- 9. Show the name and id of all Products ordered through any Agent who booked at least one order for a Customer in Chicago, 
-- sorted by product name from A to Z. You can use joins or subqueries. Better yet, do it both ways and impress me.

-- w/ subqueries
select prodID, name
from Products
where prodID in (select prodID
					from orders
					where agentID in (select agentID
										from Orders
										where custID in (select pid
															from Customers
															where pid in (select pid
																				from People
																				where homeCity = 'Chicago'))))
order by name;

-- w/joins 
select distinct prod.prodID, prod.name
from Orders o inner join Products prod on o.prodID = prod.prodID
where o.agentID in (select a.pid
					from Agents a inner join Orders o on a.pid = o.agentID
					where o.custID in (select p.pid
										from People p inner join Customers c on p.pid = c.pid
										where p.homeCity = 'Chicago'))
order by prod.name	

-- 10. Show the first and last name of customers and agents living in the same city, 
-- along with the name of their shared city. (Living in a city with yourself does not count, so exclude those from your results.)

select firstName, lastName
from People
where homeCity = (select p.homeCity
					from People p left outer join Customers c on p.pid = c.pid
									left outer join Agents a on p.pid = a.pid
 				group by p.homeCity
 				having count(*) > 1)