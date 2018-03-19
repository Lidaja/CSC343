-- Participate

SET SEARCH_PATH TO parlgov;
drop table if exists q3 cascade;

-- You must not change this table definition.

create table q3(
        countryName varchar(50),
        year int,
        participationRatio real
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS electioncountry CASCADE;
DROP VIEW IF EXISTS electionavg CASCADE;
DROP VIEW IF EXISTS nonmono CASCADE;
DROP VIEW IF EXISTS mono CASCADE;

--Get's all country's elections past 2001 and election information
CREATE VIEW electioncountry AS
SELECT country.id as cid, country.name as cname, election.id as eid, EXTRACT(YEAR FROM e_date) as year, votes_cast, electorate
FROM country JOIN election ON country.id = election.country_id
WHERE EXTRACT(YEAR FROM e_date) > 2001;

--Gets the average votes for the country in that year
CREATE VIEW electionavg AS
SELECT year, cid, avg(votes_cast) / avg(electorate) as ratio
FROM electioncountry
WHERE votes_cast IS NOT NULL AND electorate IS NOT NULL
GROUP BY year, cid;

--Gets all countries with that are not monotonically decreasing
CREATE VIEW nonmono AS
SELECT e1.cid
FROM electionavg as e1 JOIN electionavg as e2 ON e1.cid = e2.cid
WHERE e1.year < e2.year AND e1.ratio > e2.ratio;

--Gets countries that are monotonically decreasing
CREATE VIEW mono AS
SELECT year,cid,ratio
FROM electionavg
WHERE cid NOT IN (SELECT * FROM nonmono);

-- the answer to the query 
insert into q3
SELECT country.name as countryName, year, ratio as participationRatio
FROM country JOIN mono ON mono.cid = country.id;

