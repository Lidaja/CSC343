-- VoteRange

SET SEARCH_PATH TO parlgov;
drop table if exists q1 cascade;

-- You must not change this table definition.

create table q1(
year INT,
countryName VARCHAR(50),
voteRange VARCHAR(20),
partyName VARCHAR(100)
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS electionparty CASCADE;
DROP VIEW IF EXISTS electionclean CASCADE;
DROP VIEW IF EXISTS range0t5 CASCADE;
DROP VIEW IF EXISTS range5t10 CASCADE;
DROP VIEW IF EXISTS range10t20 CASCADE;
DROP VIEW IF EXISTS range20t30 CASCADE;
DROP VIEW IF EXISTS range30t40 CASCADE;
DROP VIEW IF EXISTS range40t100 CASCADE;

-- Gets all information on each party and how they did on the election
CREATE VIEW electionparty AS
SELECT EXTRACT(YEAR FROM e_date) as year, party.country_id as cid,country.name as cname,election_result.id as erid, election_result.party_id as pid, party.name_short as pname, election.id as eid, election_result.votes / (election.votes_valid * 1.0) as range
FROM election_result JOIN election ON election_result.election_id = election.id JOIN party ON election_result.party_id = party.id JOIN country ON party.country_id = country.id
WHERE EXTRACT(YEAR FROM e_date) >= 1996 AND votes_valid IS NOT NULL AND votes IS NOT NULL;

--Cleans up the previous view and gets the range of votes for each year, country, and party combination, 
CREATE VIEW electionclean AS
SELECT year,cname,pname, avg(range) as range
FROM electionparty
GROUP BY year, cname, pname;

--Gets all year, country, and party triplets that have a voting range between 0 and 5
CREATE VIEW range0t5 AS
SELECT year, cname as countryName, '(0-5]' as voteRange, pname as partyName
FROM electionclean
WHERE range > 0 AND range <= 0.05;

--Gets all year, country, and party triplets that have a voting range between 5 and 10
CREATE VIEW range5t10 AS
SELECT year, cname as countryName, '(5-10]' as voteRange, pname as partyName
FROM electionclean
WHERE range > 0.05 AND range <= 0.1;

--Gets all year, country, and party triplets that have a voting range between 10 and 20
CREATE VIEW range10t20 AS
SELECT year, cname as countryName, '(10-20]' as voteRange, pname as partyName
FROM electionclean
WHERE range > 0.1 AND range <= 0.2;

--Gets all year, country, and party triplets that have a voting range between 20 and 30
CREATE VIEW range20t30 AS
SELECT year, cname as countryName, '(20-30]' as voteRange, pname as partyName
FROM electionclean
WHERE range > 0.2 AND range <= 0.3;

--Gets all year, country, and party triplets that have a voting range between 30 and 40
CREATE VIEW range30t40 AS
SELECT year, cname as countryName, '(30-40]' as voteRange, pname as partyName
FROM electionclean
WHERE range > 0.3 AND range <= 0.4;

--Gets all year, country, and party triplets that have a voting range between 40 and 100
CREATE VIEW range40t100 AS
SELECT year, cname as countryName, '(40-100]' as voteRange, pname as partyName
FROM electionclean
WHERE range > 0.4;

-- the answer to the query 
insert into q1
SELECT * FROM range0t5
UNION
SELECT * FROM range5t10
UNION
SELECT * FROM range10t20
UNION
SELECT * FROM range20t30
UNION
SELECT * FROM range30t40
UNION
SELECT * FROM range40t100;
