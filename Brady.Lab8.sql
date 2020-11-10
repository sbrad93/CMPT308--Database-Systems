-- Shannon Brady
-- Professor Labouseur
-- CMPT308
-- 10 November 2020
-- Lab 8

drop table if exists MovieDirectors;
drop table if exists MovieActors;
drop table if exists MovieSales;
drop table if exists Movies;
drop table if exists PeopleAddresses;
drop table if exists Addresses;
drop table if exists Cities;
drop table if exists Countries;
drop table if exists SpouseNames;
drop table if exists Directors;
drop table if exists Actors;
drop table if exists People;

-- People --
CREATE TABLE People (
	pid			int not null,
	firstName	text,
	lastName	text,
primary key(pid)
);

-- Actors --
CREATE TABLE Actors (
	pid					int not null references People(pid),
	hairColor			text,
	eyeColor			text,
	heightIN			int,
	weightLBS			int,
	favColor			text,
	guildAnniversary	date,
primary key(pid)
);

-- Directors --
CREATE TABLE Directors (
	pid 				int not null references People(pid),
	filmSchool			text,
	favLensMaker		text,
	guildAnniversary	date,
primary key(pid)
);

-- SpouseNames --
CREATE TABLE SpouseNames (
	pid		int not null references People(pid),
	first	text,
	last	text,
primary key(pid)
);

-- Countries --
CREATE TABLE Countries (
	countryCode		text not null,
	name			text,
primary key(countryCode)
);

-- Cities --
CREATE TABLE Cities (
	postalCode		text not null,
	name			text,
	countryCode		text not null references Countries(countryCode),
primary key(postalCode)
);

-- Addresses --
CREATE TABLE Addresses (
	addressID		int not null,
	streetAddress	text,
	postalCode		text,
	countryCode		text,
primary key(addressID)
);

-- PeopleAddresses --
CREATE TABLE PeopleAddresses (
	addressID		int not null references Addresses(addressID),
	pid				int not null references People(pid),
primary key(addressID)
);

-- Movies --
CREATE TABLE Movies (
	MPAAnum		int not null,
	name		text,
	releaseYear	int,
primary key(MPAAnum)
);

-- MovieSales --
CREATE TABLE MovieSales (
	MPAAnum				int not null references Movies(MPAAnum),
	domesticBoxOffice	decimal(10),
	foreignBoxOffice	decimal(10),
	DVD					decimal(10),
	bluray				decimal(10),
primary key(MPAAnum)
);

-- MovieActors --
CREATE TABLE MovieActors (
	actorID		int not null references Actors(pid),
	MPAAnum		int not null references Movies(MPAAnum),
primary key(actorID, MPAAnum)
);

-- MovieDirectors --
CREATE TABLE MovieDirectors (
	directorID		int not null references Directors(pid),
	MPAAnum			int not null references Movies(MPAAnum),
primary key(directorID, MPAAnum)
);

-- People --
INSERT INTO People (pid, firstName, lastName)
VALUES
(001, 'Roger',        'Moore'),
(002, 'Christopher',  'Nolan'),
(003, 'Tom',          'Cruise');

-- Actors --
INSERT INTO Actors (pid)
VALUES
(001), 
(003);

-- Directors --
INSERT INTO Directors (pid)
VALUES
(002), 
(003);

-- Movies --
INSERT INTO Movies (MPAAnum, name, releaseYear)
VALUES
(10012, 'Movie Title', 2018);

-- MovieActors --
INSERT INTO MovieActors (actorID, MPAAnum)
VALUES
(001, 10012);

-- MovieDirectors --
INSERT INTO MovieDirectors (directorID, MPAAnum)
VALUES
(002, 10012),
(003, 10012);

-- All the directors with whom actor "Roger Moore" has worked
select firstName, lastName
from People
where pid in (select directorID
				from MovieActors a inner join MovieDirectors d on a.MPAAnum = d.MPAAnum
				where a.actorID in (select pid
				 						from People
				 						where firstName = 'Roger' and lastName = 'Moore'));