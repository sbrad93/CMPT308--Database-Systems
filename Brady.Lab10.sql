-- Shannon Brady
-- Professor Labouseur
-- CMPT308
-- 1 December 2020
--------------------------------------------------------------------------------------------

-- 1.
create or replace function PreReqsFor (INT, REFCURSOR) returns refcursor as
$$
DECLARE
	courseSearch INT    := $1;
	resultset REFCURSOR := $2;
BEGIN
	open resultset for
		select p.preReqNum
		from Courses c left outer join Prerequisites p on c.num = p.coursenum
		where p.courseNum = courseSearch;
	return resultset;
end;
$$
language plpgsql;

select PreReqsFor (308, 'res');
fetch all from res;

select PreReqsFor (221, 'res1');
fetch all from res1;

-- 2.
create or replace function IsPreReqFor (INT, REFCURSOR) returns refcursor as
$$
DECLARE
	courseSearch INT    := $1;
	resultset REFCURSOR := $2;
BEGIN
	open resultset for
		select c.num, c.name
		from Courses c left outer join Prerequisites p on c.num = p.coursenum
		where p.preReqNum = courseSearch;
	return resultset;
end;
$$
language plpgsql;
		
select IsPreReqFor (308, 'res');
fetch all from res;

select IsPreReqFor (120, 'res1');
fetch all from res1;