-- Shannon Brady
-- Professor Labouseur
-- CMPT308
-- 1 December 2020

drop table if exists Reservations;
drop table if exists RentalRates;
drop table if exists Seasons;
drop table if exists RentalAmenities;
drop table if exists Amenities;
drop table if exists Rentals;
drop table if exists RentalStatuses;
drop table if exists IslandLocations;
drop table if exists PropertyOwners;
drop table if exists Guests;
drop table if exists Employees;
drop table if exists Positions;
drop table if exists People;
drop table if exists Addresses;
drop table if exists Cities;
drop table if exists States;
drop table if exists Countries;

-- Countries --
CREATE TABLE Countries (
	countryCode		text not null,
	name			text,
primary key(countryCode)
);

-- States --
CREATE TABLE States (
	stateID		text not null,
	name		text,
primary key(stateID)
);

-- Cities --
CREATE TABLE Cities (
	postalCode		text not null,
	name		    text,
	stateID			text           references States(stateID),
	countryCode		text not null references Countries(countryCode),
primary key(postalCode)
);

-- Addresses --
CREATE TABLE Addresses (
	addressID		text not null,
	streetAddress	text,
	postalCode		text not null references Cities(postalCode),
primary key(addressID)
);

-- People --
CREATE TABLE People (
	pid			text not null,
	prefix		text,
	firstName	text,
	lastName	text,
	addressID	text not null references Addresses(addressID),
	DOB			date,
	phoneNum	text,
	email		text,
primary key(pid)
);

-- Positions --
CREATE TABLE Positions (
	positionID		text not null,
	name			text,
	description		text,
primary key(positionID)
);

-- Employees --
CREATE TABLE Employees (
	pid				text not null references People(pid),
	positionID		text not null references Positions(positionID),
	hireDate		date,
	hourlyWageUSD	money,
primary key(pid)
);

-- Guests --
CREATE TABLE Guests (
	pid			 text not null references People(pid),
	username	 text not null,
	password	text not null,
primary key(pid)
);

-- PropertyOwners --
CREATE TABLE PropertyOwners (
	pid		text not null references People(pid),
primary key(pid)
);

-- IslandLocations --
CREATE TABLE IslandLocations (
	locationID		text not null,
	name			text,
primary key(locationID)
);

-- RentalStatuses --
CREATE TABLE RentalStatuses (
	statusID	text not null,
	name		text,
	description	text,
primary key(statusID)
);

-- Rentals --
CREATE TABLE Rentals (
	rentalID		int not null,
	name			text,
	addressID		text not null references Addresses(addressID),
	locationID		text not null references IslandLocations(locationID),
	propertyType	text,
	ownerID			text not null references PropertyOwners(pid),
	statusID		text not null references RentalStatuses(statusID),
	allowsSmoking	boolean,
	allowsPets		boolean,
	numRooms		int,
	numBathrooms	int,
	maxGuests		int,
primary key(rentalID)
);	

-- Amenities --
CREATE TABLE Amenities (
	amenityID	text not null,
	name		text,
primary key(amenityID)
);

-- RentalAmenities --
CREATE TABLE RentalAmenities (
	rentalID	int  not null references Rentals(rentalID),
	amenityID	text not null references Amenities(amenityID),
primary key(rentalID, amenityID)
);

-- Seasons --
CREATE TABLE Seasons (
	seasonID	text not null,
	name		text,
    startDate   date,
    endDate     date,
primary key(seasonID)
);

-- RentalRates --
CREATE TABLE RentalRates (
	rentalID	    int not null references Rentals(rentalID),
	seasonID		text not null references Seasons(seasonID),
    weeklyRate      money,
primary key(rentalID, seasonID)
);

-- Reservations --
CREATE TABLE Reservations (
	resID	        text not null,
	guestID			text not null references Guests(pid),
	rentalID		int  not null references Rentals(rentalID),
	numGuests		int,
	checkIn		    date  not null,
	checkOut		date  not null,
	costUSD			money not null,
primary key(resID)
);



-- Countries --
INSERT INTO Countries (countryCode, name)
VALUES
('US', 'United States'),
('GB', 'United Kingdom'),
('AU', 'Australia');

-- States --
INSERT INTO States (stateID, name)
VALUES
('AL', 'Alabama'),
('FL', 'Florida'),
('NY', 'New York'),
('NC', 'North Carolina'),
('WY', 'Wyoming');

-- Cities --
INSERT INTO Cities (postalCode, name, stateID, countryCode)
VALUES
('36801',    'Auburn',          'AL',   'US'),
('20175',    'Leesburg',        'FL',   'US'),
('10992',    'Washingtonville', 'NY',   'US'),
('12601',    'Poughkeepsie',    'NY',   'US'),
('28467',    'Calabash',        'NC',   'US'),
('28468',    'Sunset Beach',    'NC',   'US'),
('82331',    'Saratoga',        'WY',   'US'),
('EC80 5JF', 'London',          NULL,   'GB'),
('4000',     'Brisbane',        NULL,   'AU');

-- Addresses --
INSERT INTO Addresses (addressID, streetAddress, postalCode)
VALUES
('ad001', '150 Barnes Rd',           '10992'),
('ad002', '3399 North Rd',           '12601'),
('ad003', '9910 Beach Dr SW',        '28467'),
('ad004', '1014 River Rd',           '28467'),
('ad005', '123 Abbott St',           '82331'),
('ad006', '771 York Road',           'EC80 5JF'),
('ad007', '58 Mills St',             '4000'),
('ad008', '25 Seafern Dr',           '20175'),
('ad009', '55 Decker Ct',            '36801'),
('ad010', '1610-A East Main Street', '28468'),
('ad011', '424 31st St',             '28468'),
('ad012', '1215 Canal Drive',        '28468'),
('ad013', '307 West Main Street',    '28468');

-- People --
INSERT INTO People (pid, prefix, firstName, lastName, addressID, DOB, phoneNum, email)
VALUES
('p001', 'Mr.',  'Kenneth',   'Smith',     'ad001', '1952-09-12', '(845) 493-9756', 'ksmith12@gmail.com'),
('p002', 'Dr.',  'Alan',      'Labouseur', 'ad002', '1990-07-04', '(845) 575-3000', 'alan.labouseur@marist.edu'),
('p003', 'Mrs.', 'Charlotte', 'Jenson',    'ad003', '1963-03-22', '(718) 551-9003', 'jdog101@yahoo.com'),
('p004', 'Mrs.', 'Meghan',    'Amato',     'ad004', '1991-04-13', '(318) 444-1234', 'megamato@gmail.com'),
('p005', 'Mr,',  'Charles',   'Stanley',   'ad005', '1944-08-16', '(877) 313-4448', 'stantheman222@aol.com'),
('p006', 'Mr.',  'Joey',      'Randazzo',  'ad006', '1994-02-14', '(218) 994-3322', 'jmr712@gmail.com'),
('p007', 'Dr.',  'April',     'Luciano',   'ad007', '1992-09-02', '(944) 121-2121', 'catlady321@yahoo.com'),
('p008', 'Mr.',   'Clark',     'Kent',     'ad008', '1975-10-31', '(123) 435-9999', 'superguy@gmail.com'),
('p009', 'Ms.',   'Isabelle',  'Reyes',    'ad009', '1996-02-01', '(612) 754-4312', 'bella68@yahoo.com');

-- Positions --
INSERT INTO Positions (positionID, name, description)
VALUES
('pos001', 'Receptionist',             'responsible for greeting visitors and delivering exceptional customer service assistance'),
('pos002', 'Administrative Assistant', 'handles routine and advanced duties for other professionals'),
('pos003', 'Office Manager',           'ensures the smooth running of an office on a day-to-day basis'),
('pos004', 'Housekeeper',              'responsible for ensuring/obtaining the highest level of cleanliness in rental properties');

-- Employees --
INSERT INTO Employees (pid, positionID, hireDate, hourlyWageUSD)
VALUES
('p003', 'pos001', '2019-01-01', 15.00),
('p004', 'pos003', '2005-04-06', 35.00);

-- Guests --
INSERT INTO Guests (pid, username, password)
VALUES
('p002', 'alab123',     'referentialintegrity'),
('p006', 'coolguy246',  'pa$$word'),
('p007', 'lucianoGang', 'yadayada'),
('p008', 'kent33',      '123456789'),
('p009', 'isreyes',     'ilovethebeach');

-- PropertyOwners --
INSERT INTO PropertyOwners (pid)
VALUES
('p001'),
('p005');

-- IslandLocations --
INSERT INTO IslandLocations (locationID, name)
VALUES 
('l001', '7th to 18th Row East'),
('l002', '7th to 18th Row West'),
('l003', 'Ocean Front East'),
('l005', 'Ocean Front West'),
('l006', 'Bay Front'),
('l007', 'Waterway on Mainland');
 
 -- RentalStatuses --
INSERT INTO RentalStatuses (statusID, name, description)
VALUES
('stat001', 'Occupied',      'Rental currently has guests'),
('stat002', 'Vacant',        'Rental is not currently booked'),
('stat003', 'Being Cleaned', 'Rental is being cleaned for next reservation'),
('stat004', 'N/A',           'Rental is not available at this time');
 
 -- Rentals --
 INSERT INTO Rentals (rentalID, name, addressID, locationID, propertyType, ownerID, statusID, allowsSmoking, allowsPets, numRooms, numBathrooms, maxGuests)
 VALUES
 (001, 'Fantasea',     'ad010', 'l003', 'Duplex',      'p001', 'stat001', false, false, 4, 3, 10),
 (033, 'Beats-Workin', 'ad011', 'l002', 'Single Home', 'p001', 'stat002', false, false, 4, 4, 8),
 (042, 'Shore Enuff',  'ad013', 'l005', 'Single Home', 'p001', 'stat004', false, true,  4, 4, 10),
 (080, 'Baywatch',     'ad012', 'l006', 'Single Home', 'p005', 'stat003', false, true,  4, 3, 10);
 
 -- Amenities --
 INSERT INTO Amenities (amenityID, name)
 VALUES 
 ('am001', 'Wi-Fi'),
 ('am002', 'Covered Porch'),
 ('am003', 'Screened Porch'),
 ('am004', 'Sun Deck'),
 ('am005', 'Outside Shower'),
 ('am006', 'Roof Deck'),
 ('am007', 'Grill'),
 ('am008', 'Boat Dock'),
 ('am009', 'Loft'),
 ('am010', 'Jacuzzi Tub');
 
 -- RentalAmenities --
 INSERT INTO RentalAmenities (rentalID, amenityID)
 VALUES
 (001, 'am001'),
 (001, 'am002'),
 (001, 'am004'),
 (033, 'am001'),
 (033, 'am002'),
 (033, 'am003'),
 (033, 'am004'),
 (033, 'am005'),
 (033, 'am006'),
 (033, 'am007'),
 (042, 'am001'),
 (042, 'am002'),
 (042, 'am004'),
 (042, 'am005'),
 (042, 'am010'),
 (080, 'am001'),
 (080, 'am002'),
 (080, 'am004'),
 (080, 'am006'),
 (080, 'am008'),
 (080, 'am009');
 
  -- Seasons --
 INSERT INTO Seasons (seasonID, name, startDate, endDate)
 VALUES
 ('s1000', 'Low Season',   '2020-08-29', '2021-05-28'),
 ('s1001', 'Value Season', '2021-05-29', '2021-06-18'),
 ('s1002', 'High Season',  '2021-06-19', '2021-08-06'),
 ('s1003', 'Value Season', '2021-08-07', '2021-08-27'),
 ('s1004', 'Low Season',   '2021-08-28', '2022-01-07');

 -- RentalRates --
 INSERT INTO RentalRates (rentalID, seasonID, weeklyRate)
 VALUES
(001, 's1000', 1195.00),
(001, 's1001', 1995.00),
(001, 's1002', 2745.00),
(001, 's1003', 1995.00),
(001, 's1004', 1195.00),
(033, 's1000', 1175.00),
(033, 's1001', 1625.00),
(033, 's1002', 2100.00),
(033, 's1003', 1625.00),
(033, 's1004', 1175.00),
(042, 's1000', 1295.00),
(042, 's1001', 2395.00),
(042, 's1002', 3595.00),
(042, 's1003', 2395.00),
(042, 's1004', 1295.00),
(080, 's1000', 1395.00),
(080, 's1001', 2095.00),
(080, 's1002', 2795.00),
(080, 's1003', 2095.00),
(080, 's1004', 1395.00);
 
 -- Reservations --
 INSERT INTO Reservations (resID, guestID, rentalID, numGuests, checkIn, checkOut, costUSD)
 VALUES
 ('res1200', 'p002', 080, 3, '2021-06-12', '2021-06-26', 4890.00),
 ('res1201', 'p006', 033, 5, '2021-08-14', '2021-08-21', 1625.00),
 ('res1202', 'p007', 001, 8, '2021-07-03', '2021-07-24', 8235.00),
 ('res1203', 'p008', 001, 3, '2020-11-28', '2020-12-12', 2390.00),
 ('res1204', 'p009', 080, 6, '2021-07-03', '2021-07-24', 8385.00);
 
 -----------------------------------------------------------------------------------------------------
 -- Reports
 
 -- All rentals that are currently N/A
 select rentalID, name
 from Rentals
 where statusID in ( select statusID
 					from RentalStatuses
 					where name = 'N/A');
                    
-- All reservations longer than a week
 select *
 from Reservations
 where checkOut - checkIn > 7;
 
 -- Number of amenities in each rental
select ra.rentalID, count(ra.amenityID) as numAmenities
from Rentals r inner join RentalAmenities ra on r.rentalID = ra.rentalID
				inner join Amenities a on a.amenityID = ra.amenityID
group by ra.rentalID
order by ra.rentalID;
 
 -- All usernames and password of guests that live outside the US
select p.firstName, p.lastName, g.username, g.password
from People p inner join Guests g on p.pid = g.pid
where addressID in (select addressID
					from Addresses a inner join Cities c on a.postalCode = c.postalCode
					where countryCode != 'US');
                    
-- Average reservation cost for July 2021
select round(avg(costUSD::numeric), 2)
from Reservations
where checkIn between '2021-07-01' and '2021-07-31' 
  and checkOut between '2021-07-01' and '2021-07-31';
  
-- All reservations during the Summer 2021 High Season
select res.resID, res.guestID, res.rentalID, r.name, res.numGuests, res.checkIn, res.checkOut, res.costUSD
from Reservations res inner join Rentals      r  on res.rentalID = r.rentalID
						inner join RentalRates ra on ra.rentalID = r.rentalID
						inner join Seasons     s  on s.seasonID  = ra.seasonID
where s.name = 'High Season';

-------------------------------------------------------------------------------------------------
-- Views

-- Important rental information
create view RentalInfo
as
select r.rentalID, r.name, a.streetAddress, r.propertyType, l.name as location, 
        r.ownerID, rs.name as status, rs.description, r.allowsSmoking,
		r.allowsPets, r.numRooms, r.numBathrooms, r.maxGuests
from Rentals r inner join RentalStatuses   rs on r.statusID = rs.statusID
				inner join Addresses       a on r.addressID = a.addressID
				inner join IslandLocations l on r.locationID = l.locationID;

-- Pet friendly rentals
create or replace view PetFriendlyRentals
as
select r.rentalID, r.name, a.streetAddress, l.name as location, r.propertyType, r.numRooms, r.numBathrooms, r.maxGuests
from Rentals r inner join Addresses        a on r.addressID  = a.addressID
				inner join IslandLocations l on l.locationID = r.locationID
where r.allowsPets = true;

-- All ocean front rentals
create or replace view OceanFrontRentals
as
select r.rentalID, r.name, a.streetAddress, r.propertyType, r.statusID,
 		r.allowsSmoking, r.allowsPets, r.numRooms, r.numBathrooms, r.maxGuests
from Rentals r inner join IslandLocations l on r.locationID = l.locationID
 				inner join Addresses a      on r.addressID  = a.addressID
where l.name = 'Ocean Front East' or l.name = 'Ocean Front West';
 
 -- All current guests
create or replace view CurrentGuests
as
select  p.prefix, p.firstName, p.lastName, 
         a.streetAddress, c.name as city, c.stateID as state, c.postalCode,
		 p.DOB, p.phoneNum, p.email,r.rentalID, r.name, res.checkIn, res.checkOut, res.numGuests
from People p  inner join Guests       g   on p.pid         = g.pid
				inner join Reservations res on g.pid        = res.guestID 
			    inner join Rentals      r   on r.rentalID   = res.rentalID
				inner join Addresses    a   on a.addressID  = p.addressID
				inner join Cities       c   on c.postalCode = a.postalCode
where current_date between checkIn and checkOut;

-- Weekly rates for all reservations
create or replace view ReservationRates
as
select res.resID, ra.weeklyRate
from Reservations res inner join Rentals      r  on res.rentalID = r.rentalID
				       inner join RentalRates ra on r.rentalID   = ra.rentalID
				       inner join Seasons     s  on ra.seasonID  = s.seasonID
where (res.checkIn, res.checkOut) overlaps (s.startDate, s.endDate);

-------------------------------------------------------------------------------------------------
-- Stored Procedures

-- finds guest info based on first and last name
create or replace function findGuest (TEXT, TEXT, REFCURSOR) returns refcursor as 
$$
declare 
	searchFirst TEXT := $1;
	searchLast TEXT := $2;
	resultset REFCURSOR := $3;

begin
	open resultset for
		select  p.prefix, p.firstName, p.lastName, 
				 a.streetAddress, c.name as city, c.stateID as state, c.postalCode,
				 p.DOB, p.phoneNum, p.email, g.username, g.password
		from People p  inner join Guests       g   on p.pid         = g.pid
						inner join Reservations res on g.pid        = res.guestID 
						inner join Addresses    a   on a.addressID  = p.addressID
						inner join Cities       c   on c.postalCode = a.postalCode
		where p.firstName like searchFirst and p.lastName like searchLast;
	return resultset;
end;
$$
LANGUAGE PLPGSQL;	

select findGuest ('Alan', 'Labouseur', 'res');
fetch all from res;

select findGuest ('%', 'R%', 'res1');
fetch all from res1;

select findGuest ('%a%', '%', 'res2');
fetch all from res2;
 
-- finds reservation info based on reservationID
create or replace function findReservation (TEXT, REFCURSOR) returns refcursor as
$$
declare
	searchResID TEXT := $1;
	resultset REFCURSOR := $2;
begin
	open resultset for
		select *
		from Reservations
		where resID = searchResID;
	return resultset;
end;
$$
LANGUAGE plpgsql;

select findReservation ('res1200', 'res');
fetch all from res;

select findReservation ('res1204', 'res1');
fetch all from res1;
 
-- finds amenities for specific rental based on rentalID
create or replace function findAmenities (INT, REFCURSOR) returns refcursor as
$$
declare
	searchRentalID INT := $1;
	resultset REFCURSOR := $2;
begin
	open resultset for
		select a.name as AmenityName
		from RentalAmenities ra inner join Amenities a on ra.amenityID = a.amenityID
		where ra.rentalID = searchRentalID;
	return resultset;
end;
$$
LANGUAGE plpgsql;

select findAmenities (001, 'res');
fetch all from res;

select findAmenities (033, 'res1');
fetch all from res1;

select findAmenities (042, 'res2');
fetch all from res2;

select findAmenities (080, 'res3');
fetch all from res3;

-------------------------------------------------------------------------------------------------
-- Triggers

-- Cannot reserve a rental that is currently N/A
CREATE OR REPLACE FUNCTION cannotReserve()
RETURNS TRIGGER AS
$$
BEGIN
   IF (select rs.name as status
		from Reservations res inner join Rentals        r  on res.rentalID = r.rentalID
							   inner join RentalStatuses rs on r.statusID  = rs.statusID
	    where res.resID = NEW.resID) = 'N/A'
   THEN
      delete from Reservations where resID = NEW.resID;
END IF;
   RETURN NEW;
END;
$$
language plpgsql;
CREATE TRIGGER cannotReserve
AFTER INSERT ON Reservations
FOR EACH ROW
EXECUTE PROCEDURE cannotReserve();

select r.rentalID
from Rentals r inner join RentalStatuses rs on rs.statusID = r.statusID
where rs.name = 'N/A';

INSERT INTO Reservations (resID, guestID, rentalID, numGuests, checkIn, checkOut, costUSD)
VALUES
('res1205', 'p009', 042, 5, '2020-12-05', '2020-12-12', 1295.00);

select *
from Reservations;

-- Cannot make a reservation that has number of guests exceed the maximum guest capacity of the rental 
CREATE OR REPLACE FUNCTION maxGuests()
RETURNS TRIGGER AS
$$
BEGIN
   IF (select res.numGuests
		from Reservations res inner join Rentals r on res.rentalID = r.rentalID
	  	where res.resID = NEW.resID) > (select maxGuests
										 from Rentals
									     where rentalID = NEW.rentalID)
   THEN
      delete from Reservations where resID = NEW.resID;
END IF;
   RETURN NEW;
END;
$$
language plpgsql;
CREATE TRIGGER maxGuests
AFTER INSERT ON Reservations
FOR EACH ROW
EXECUTE PROCEDURE maxGuests();

INSERT INTO Reservations (resID, guestID, rentalID, numGuests, checkIn, checkOut, costUSD)
VALUES
('res1205', 'p009', 042, 20, '2020-12-05', '2020-12-12', 1295.00);

select *
from Reservations;

-------------------------------------------------------------------------------------------------
-- Security

create role admin;
grant all
on all tables in schema public
to admin;

create role manager;
grant select, insert, update
on all tables in schema public
to manager;

create role customer service;
grant select, insert, update
on Reservations, Guests, People
to customer service;

create role housekeeping;
grant select
on RentalInfo
to housekeeping;