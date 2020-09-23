-- Shannon Brady
-- Professor Labouseur
-- CMPT308
-- 20 September 2020
-- Lab 4

-- 1. Get all the People data for people who are customers.

select *
from People
where pid in (select pid
			from Customers);
            
-- 2. Get all the People data for people who are agents.

select *
from People
where pid in (select pid
			 from Agents);
             
-- 3. Get all of People data for people who are both customers and agents.

select *
from People
where pid in (select pid
			 from Customers)
and pid in (select pid
		   from Agents);
           
-- 4. Get all of People data for people who are neither customers nor agents.

select *
from People
where pid not in (select pid
			 from Customers)
and pid not in (select pid
		   from Agents);
           
-- 5. Get the ID of customers who ordered either product 'p01' or 'p07' (or both).

select pid
from People
where pid in (select custID
			 from Orders
			 where prodId in ('p01', 'p07'));
             
-- 6. Get the ID of customers who ordered both products 'p01' and 'p07'. 
-- List the IDs in order from highest to lowest. Include each ID only once.

select pid
from People
where pid in (select custID
			 from Orders
			 where prodId = 'p01')
	and	pid in (select custID
			 from Orders
			 where prodId = 'p07')
order by pid DESC;

-- 7. Get the first and last names of agents who sold products 'p05' or 'p07' 
-- in order by last name from Z to A.

select firstName, lastName
from People
where pid in (select agentID
			 from Orders
			 where prodID in ('p05', 'p07'))
order by lastName DESC;

-- 8. Get the home city and birthday of agents booking an order 
-- for the customer whose pid is 001, sorted by home city from A to Z.

select homeCity, DOB
from People
where pid in (select agentID
			 from Orders
			 where custID = '001')
order by homeCity;

-- 9. Get the unique ids of products ordered through any agent who takes at least 
-- one order from a customer in Toronto, sorted by id from highest to lowest. 
-- (This is not the same as asking for ids of products ordered by customers in Toronto.)

select distinct prodID
from Orders
where agentID in (select agentID
					from Orders
					where custID in (select custID
										from Orders
										where custID in (select pid
															from People
															where homeCity = 'Toronto')))
order by prodID DESC;

-- 10. Get the last name and home city for all customers who place orders through agents 
-- in Teaneck or Santa Monica.

select lastName, homeCity
from People
where pid in (select custID
					from Orders
					where agentID in (select pid
										from People
										where homeCity in ('Teaneck', 'Santa Monica')));
             
