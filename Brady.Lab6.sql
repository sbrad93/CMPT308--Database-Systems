-- Shannon Brady
-- Professor Labouseur
-- CMPT308
-- 9 October 2020
-- Lab 6

-- 1.
-- Display the cities that makes the most different kinds of products.

select prod.city
from Products prod
group by prod.city
having count(city) = (select max(myMax.myCount)
				      from (select city, count(city) myCount
	   				        from Products
	   				        group by city) myMax);
 
 
-- 2.
-- Display the names of products whose priceUSD is at or above the average priceUSD,
-- in reverse-alphabetical order.

select name
from Products
where priceUSD >= (select avg(priceUSD)
				   from Products)
order by name DESC;


-- 3.
-- Display the customer last name, product id ordered, and the totalUSD for all orders made in March, 
-- sorted by totalUSD from high to low.

select p.lastName, o.prodID, o.totalUSD
from People p inner join Customers  c on p.pid = c.pid
			  inner join Orders     o on c.pid = o.custID
where o.orderNum in (select orderNum
				     from Orders
				     where dateOrdered between '2020-03-01' and '2020-03-31')
order by o.totalUSD DESC;


-- 4.
-- Display the last name of all customers (in reverse alphabetical order) and their total ordered, and nothing more. 
-- (Hint: Use coalesce to avoid showing NULLs.)

select p.lastName, coalesce(sum(o.quantityOrdered), 0) totalQuantity, coalesce(sum(o.totalUSD), 0) totalUSD
from People p inner join      Customers c on p.pid = c.pid
              left outer join Orders    o on c.pid = o.custID
group by p.lastName
order by p.lastName DESC;
  
  
-- 5.
-- Display the names of all customers who bought products from agents based in Teaneck 
-- along with the names of the products they ordered, and the names of the agents who sold it to them.

select cu.firstName custFirst, cu.lastName custLast, prod.name prodName, ag.firstName agFirst, ag.lastName agLast
from People cu inner join Orders   o    on cu.pid    = o.custID
               inner join Products prod on o.prodID  = prod.prodID
               inner join People   ag   on o.agentID = ag.pid
where o.agentID in (select pid
			   		from People
			   		where homeCity = 'Teaneck');


-- 6.
-- Write a query to check the accuracy of the totalUSD column in the Orders table. 
-- This means calculating Orders.totalUSD from data in other tables and comparing those values to 
-- the values in Orders.totalUSD. Display all rows in Orders where Orders.totalUSD is incorrect, 
-- if any. If there are any incorrect values, explain why they are wrong.

select o.orderNum, o.totalUSD origTotal, round((o.quantityOrdered * prod.priceUSD) * (1-c.discountPct / 100), 7) newTotal
from Customers c inner join Orders   o    on c.pid    = o.custID
			     inner join Products prod on o.prodID = prod.prodID
where o.totalUSD != round((o.quantityOrdered * prod.priceUSD) * (1-c.discountPct / 100), 7);

-- Order numbers 1012, 1017, 1023, and 1026 have a slightly different totalUSD value when calculated from the data in other relevant tables. This is because the original Orders.totalUSD values are not calculated by the database serve but rather were inserted individually when the table was created. The since the new totals are calculated values, there is discrepency in regards to rounding. If the new totals were rounded to two decimal places, only order number 1017 would be different by $0.01. 


-- 7.
-- Display the first and last name of all customers who are also agents.

select p.firstName, p.lastName
from People p inner join Customers c on p.pid = c.pid
			   inner join Agents   a on p.pid = a.pid;
  
  
-- 8.
-- Create a VIEW of all Customer and People data called PeopleCustomers. 
-- Then another VIEW of all Agent and People data called PeopleAgents. 
-- Then "select *" from each of them in turn to test.

create view PeopleCustomers
as (select p.pid,  p.prefix,  p.firstName,  p.lastName, p.suffix, p.homeCity, p.DOB, 
			c.paymentTerms, c.discountPct
	from People p inner join Customers c on p.pid = c.pid);
	
create view PeopleAgents
as (select p.pid,  p.prefix,  p.firstName,  p.lastName, p.suffix, p.homeCity, p.DOB, 
			a.paymentTerms, a.commissionPct
	from People p inner join Agents a on p.pid = a.pid);
	
select *
from PeopleCustomers;

select *
from PeopleAgents;

-- 9.
-- Display the first and last name of all customers who are also agents, 
-- this time using the views you created.

select pc.firstName, pc.lastName
from PeopleCustomers pc inner join PeopleAgents pa on pc.pid = pa.pid;


-- 10.
-- Compare your SQL in #7 (no views) and #9 (using views). The output is the same. How does that work? 
-- What is the database server doing internally when it processes the #9 query?

-- In #9, since views do not actually hold data, the database server will first access the view definition in the system catalog, and then it will use that query to access the specified part of the base tables, in this case a table of People joined with Customers and a table of People joined with Agents. In #7, this is achieved by querying the required tables directly; no separate defining query is necessary. The joins in #7 can essentially broken down to form the views in #9. 


-- 11. (Bonus)
-- What’s the difference between a LEFT OUTER JOIN and a RIGHT OUTER JOIN? 
-- Give example queries in SQL to demonstrate. (Feel free to use the CAP database to make your points here.)

-- A left outer join returns all the records from the table on the left of the join statement and the corresponding matching rows from the right table. If the right table does not have the matching record, then NULL is used in its place. 
-- In the example below, all People information is returned along with the Customer information for those who are both people and customers. If a person is an agent, however, the People information is returned, but all Customer information for those individuals is NULL.

select *
from People p left outer join Customers c on p.pid = c.pid;

-- A right outer join is the opposite of the left outer join, in that it returns all records from the table on the right of the join statement and the corresponding matching rows from the left table. A NULL value is again placed where no matching record is applicable. 
-- In the example below, all Customer information is returned and joined with the custID of each order from the Orders table. Since the customer with pid = 7 did not place an order, all Order information for that individual is NULL.

select *
from Orders o right outer join Customers c on o.custID = c.pid;