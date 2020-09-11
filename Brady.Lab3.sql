-- Shannon Brady
-- Professor Labouseur
-- CMPT308
-- 12 September 2020
-- Lab 3


-- 1.
select ordernum, totalusd
from Orders;

-- 2.
select lastname, homecity
from people
where prefix = 'Dr.';

-- 3.
select prodid, name, priceusd
from products
where qtyonhand > 1007;

-- 4.
select firstname, homecity
from people
where dob between '1950-01-01' and '1960-01-01';

-- 5.
-- dr. peart, ms. schock, ms. plakas, ms. carrington, dr. bruford
select prefix, lastname
from people
where prefix != 'Mr.';

-- 6.
-- p02, p09
select *
from products
where city != 'Dallas' and city != 'Duluth' 
    and priceusd >= 3;

-- 7.
-- 1022, 1023, 1024
select *
from orders
where dateordered between '2020-03-01' and '2020-03-31';

-- 8.
-- 1017, 1018, 1021
select *
from orders
where dateordered between '2020-02-01' and '2020-02-29' 
	and totalusd >= 20000;
    
-- 9.
-- none
select *
from orders
where custid = 007;

-- 10.
-- 1015, 1024
select *
from orders
where custid = 005;