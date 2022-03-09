--Exercise 1: Using Joins

--Question 1
--Write and execute a SQL query to list the school names, 
--community names and average attendance for communities
--with a hardship index of 98.

select * from chicago_public_schools;

select * from census_data;


--Exercise 1: Using Joins

--Question 1:
--Write and execute a SQL query to list the school names, 
--community names and average attendance for communities
--with a hardship index of 98.

select CPS.name_of_school, CPS.community_area_name 
as CPS_community_area_name, 
CPS.average_student_attendance, CD.hardship_index, 
CD.community_area_name as CD_community_area_name,
CPS.community_area_number as CPS_community_area_number,
CD.community_area_number as CD_community_area_number from
chicago_public_schools as CPS left outer join
census_data as CD
on CPS.community_area_number =
CD.community_area_number
where CD.hardship_index = 98;

--Exercise 1: Using Joins

--Question 1:
--Write and execute a SQL query to list the school names, 
--community names and average attendance for communities
--with a hardship index of 98.

select CPS.name_of_school, CPS.community_area_name, 
CPS.average_student_attendance from
chicago_public_schools as CPS left outer join
census_data as CD
on CPS.community_area_number =
CD.community_area_number
where CD.hardship_index = 98;



--Exercise 1: Using Joins

--Question 2: 
--Write and execute a SQL query to list all crimes that took place
--at a school. Include case number, crime type and community name.

select CCD.case_number, CCD.primary_type,
CD.community_area_name, CCD.location_description,
CCD.community_area_number
from chicago_crime_data as CCD left outer join
census_data as CD
on CCD.community_area_number = CD.community_area_number
where location_description like '%SCHOOL%';



--Exercise 1: Using Joins

--Question 2: 
--Write and execute a SQL query to list all crimes that took place
--at a school. Include case number, crime type and community name.

select CCD.case_number, CCD.primary_type,
CD.community_area_name from
chicago_crime_data as CCD 
left outer join census_data as CD
on CCD.community_area_number = CD.community_area_number
where location_description like '%SCHOOL%';



select * from CPS_VIEW;

drop view CPS_VIEW;




--Exercise 2: Creating a View

--Question 1:
--Write and execute a SQL statement to create a view 
--showing the columns listed in the following table, 
--with new column names as shown in the second column.

create view CPS_VIEW as
select name_of_school as "School_Name",
Safety_Icon as "Safety_Rating",
Family_Involvement_Icon as "Family_Rating",
Environment_Icon as "Environment_Rating",
Instruction_Icon as "Instruction_Rating",
Leaders_Icon as "Leaders_Rating",
Teachers_Icon as "Teachers_Rating"
from chicago_public_schools;

--Write and execute a SQL statement that returns
--all of the columns from the view.

select * from CPS_VIEW;




--Exercise 2: Creating a View

--Question 1:
--Write and execute a SQL statement to create a view 
--showing the columns listed in the following table, 
--with new column names as shown in the second column.

--Write and execute a SQL statement that returns
--just the school name and leaders rating from the view.

select "School_Name", "Leaders_Rating"
from CPS_VIEW;




alter table chicago_public_schools
alter column Leaders_Icon set data type varchar(20);

call UPDATE_LEADERS_SCORE(610038, 101);

select * from chicago_public_schools;



--Exercise 3

--Question 1
--Write the structure of a query to create or replace
--a stored procedure called UPDATE_LEADERS_SCORE that
--takes a in_School_ID parameter as an integer
--and a in_Leader_Score parameter as an integer. 
--Don't forget to use the #SET TERMINATOR statement
--to use the @ for the CREATE statement terminator.

--#SET TERMINATOR @
create or replace procedure UPDATE_LEADERS_SCORE (
	in in_School_ID INTEGER, in in_Leader_Score INTEGER)
LANGUAGE SQL                                                -- Language used in this routine
MODIFIES SQL DATA                                           -- This routine will only write/modify data in the table
BEGIN
END
@                                                           -- Routine termination character




select * from chicago_public_schools;



--Exercise 3

--Question 2

--Inside your stored procedure, write a SQL statement
--to update the Leaders_Score field in the CHICAGO_PUBLIC_SCHOOLS table
--for the school identified by in_School_ID to the value in the in_Leader_Score parameter.


--#SET TERMINATOR @
create or replace procedure UPDATE_LEADERS_SCORE (
	in in_School_ID INTEGER, in in_Leader_Score INTEGER)
LANGUAGE SQL                                                -- Language used in this routine
MODIFIES SQL DATA                                           -- This routine will only write/modify data in the table
BEGIN
	update CHICAGO_PUBLIC_SCHOOLS
	SET Leaders_Score = in_Leader_Score
	where school_id = in_School_ID;
END
@                                                           -- Routine termination character



--Exercise 3

--Question 3

--Inside your stored procedure, write a SQL IF statement
--to update the Leaders_Icon field in the CHICAGO_PUBLIC_SCHOOLS table
-- for the school identified by in_School_ID using the following information.


--#SET TERMINATOR @
create or replace procedure UPDATE_LEADERS_SCORE (
	in in_School_ID INTEGER, in in_Leader_Score INTEGER)
LANGUAGE SQL                                                -- Language used in this routine
MODIFIES SQL DATA                                           -- This routine will only write/modify data in the table
BEGIN
	update CHICAGO_PUBLIC_SCHOOLS
	SET Leaders_Score = in_Leader_Score
	where school_id = in_School_ID;
  IF in_Leader_Score > 0 AND in_Leader_Score < 20 THEN
	 update CHICAGO_PUBLIC_SCHOOLS
	 set Leaders_Icon = 'Very weak'
	 where school_id = in_School_ID;
  ELSEIF in_Leader_Score < 40 THEN
	 update CHICAGO_PUBLIC_SCHOOLS
	 set Leaders_Icon = 'Weak'
	 where school_id = in_School_ID;
  ELSEIF in_Leader_Score < 60 THEN
	 update CHICAGO_PUBLIC_SCHOOLS
	 set Leaders_Icon = 'Average'
	 where school_id = in_School_ID;	 
  ELSEIF in_Leader_Score < 80 THEN
	 update CHICAGO_PUBLIC_SCHOOLS
	 set Leaders_Icon = 'Strong'
	 where school_id = in_School_ID;
  ELSEIF in_Leader_Score < 100 THEN
    update CHICAGO_PUBLIC_SCHOOLS
	 set Leaders_Icon = 'Very strong'
	 where school_id = in_School_ID;
END IF;
END
@                                                           -- Routine termination character




--Exercise 4: Using Transactions

--Question 1: 
--Update your stored procedure definition.
--Add a generic ELSE clause to the IF statement that
--rolls back the current work if the score did not
--fit any of the preceding categories.

--#SET TERMINATOR @
create or replace procedure UPDATE_LEADERS_SCORE (
	in in_School_ID INTEGER, in in_Leader_Score INTEGER)
LANGUAGE SQL                                                -- Language used in this routine
MODIFIES SQL DATA                                           -- This routine will only write/modify data in the table
BEGIN
	update CHICAGO_PUBLIC_SCHOOLS
	SET Leaders_Score = in_Leader_Score
	where school_id = in_School_ID;
	
	IF in_Leader_Score > 0 AND in_Leader_Score < 20 THEN

	 update CHICAGO_PUBLIC_SCHOOLS
	 set Leaders_Icon = 'Very weak'
	 where school_id = in_School_ID;

	ELSEIF in_Leader_Score < 40 THEN

	 update CHICAGO_PUBLIC_SCHOOLS
	 set Leaders_Icon = 'Weak'
	 where school_id = in_School_ID;


   ELSEIF in_Leader_Score < 60 THEN

	 update CHICAGO_PUBLIC_SCHOOLS
	 set Leaders_Icon = 'Average'
	 where school_id = in_School_ID;
	 
   ELSEIF in_Leader_Score < 80 THEN

	 update CHICAGO_PUBLIC_SCHOOLS
	 set Leaders_Icon = 'Strong'
	 where school_id = in_School_ID;

   ELSEIF in_Leader_Score < 100 THEN

    update CHICAGO_PUBLIC_SCHOOLS
	 set Leaders_Icon = 'Very strong'
	 where school_id = in_School_ID;
	
	ELSE
	  ROLLBACK WORK;

END IF;

END
@                                                           -- Routine termination character



--Exercise 4: Using Transactions

--Question 2: 
--Update your stored procedure definition again.
--Add a statement to commit the current unit of work at the end of the procedure.


--#SET TERMINATOR @
create or replace procedure UPDATE_LEADERS_SCORE (
	in in_School_ID INTEGER, in in_Leader_Score INTEGER)
LANGUAGE SQL                                                -- Language used in this routine
MODIFIES SQL DATA                                           -- This routine will only write/modify data in the table
BEGIN
	update CHICAGO_PUBLIC_SCHOOLS
	SET Leaders_Score = in_Leader_Score
	where school_id = in_School_ID;
	
	IF in_Leader_Score > 0 AND in_Leader_Score < 20 THEN

	 update CHICAGO_PUBLIC_SCHOOLS
	 set Leaders_Icon = 'Very weak'
	 where school_id = in_School_ID;

	ELSEIF in_Leader_Score < 40 THEN

	 update CHICAGO_PUBLIC_SCHOOLS
	 set Leaders_Icon = 'Weak'
	 where school_id = in_School_ID;


   ELSEIF in_Leader_Score < 60 THEN

	 update CHICAGO_PUBLIC_SCHOOLS
	 set Leaders_Icon = 'Average'
	 where school_id = in_School_ID;
	 
   ELSEIF in_Leader_Score < 80 THEN

	 update CHICAGO_PUBLIC_SCHOOLS
	 set Leaders_Icon = 'Strong'
	 where school_id = in_School_ID;

   ELSEIF in_Leader_Score < 100 THEN

    update CHICAGO_PUBLIC_SCHOOLS
	 set Leaders_Icon = 'Very strong'
	 where school_id = in_School_ID;
	
	ELSE
	  ROLLBACK WORK;

END IF;

COMMIT WORK;

END
@                                                           -- Routine termination character



drop view CPS_VIEW;



select * from chicago_crime_data;

select * from chicago_public_schools
where community_area_name = 'Riverdale';

select * from chicago_public_schools
where community_area_number = 54;
