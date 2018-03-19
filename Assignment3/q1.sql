-- VoteRange

SET SEARCH_PATH TO quizschema;
drop table if exists q1 cascade;

-- You must not change this table definition.

create table q1(
	studentnumber VARCHAR(50),
	firstname VARCHAR(50),
	lastname VARCHAR(50)
);

--Get all the students in the database
insert into q1
SELECT *
FROM student;

SELECT * from q1;
