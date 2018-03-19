-- Left-right

SET SEARCH_PATH TO parlgov;
drop table if exists q4 cascade;

-- You must not change this table definition.


CREATE TABLE q4(
        countryName VARCHAR(50),
        r0_2 INT,
        r2_4 INT,
        r4_6 INT,
        r6_8 INT,
        r8_10 INT
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS countrypositions CASCADE;

DROP VIEW IF EXISTS positions02 CASCADE;
DROP VIEW IF EXISTS positions02null CASCADE;
DROP VIEW IF EXISTS positions02total CASCADE;

DROP VIEW IF EXISTS positions24 CASCADE;
DROP VIEW IF EXISTS positions24null CASCADE;
DROP VIEW IF EXISTS positions24total CASCADE;

DROP VIEW IF EXISTS positions46 CASCADE;
DROP VIEW IF EXISTS positions46null CASCADE;
DROP VIEW IF EXISTS positions46total CASCADE;

DROP VIEW IF EXISTS positions68 CASCADE;
DROP VIEW IF EXISTS positions68null CASCADE;
DROP VIEW IF EXISTS positions68total CASCADE;

DROP VIEW IF EXISTS positions810 CASCADE;
DROP VIEW IF EXISTS positions810null CASCADE;
DROP VIEW IF EXISTS positions810total CASCADE;

--Getting all country,party,party position triplets
CREATE VIEW countrypositions AS
SELECT country.name as cname, country.id as cid, party.id as pid, party.name as pname, party_position.left_right as left_right
FROM country JOIN party ON country.id = party.country_id JOIN party_position ON party.id = party_position.party_id;

--Gets all positions between 0 and 2
CREATE VIEW positions02 AS
SELECT cname as countryName, count(left_right) as r0_2
FROM countrypositions
WHERE left_right >= 0 AND left_right < 2
GROUP BY cname;

--Gets all the countries that had 0 for 0 to 2
CREATE VIEW positions02null AS
SELECT country.name as countryname
FROM country EXCEPT(SELECT countryname FROM positions02);

--Totals them together
CREATE VIEW positions02total AS
SELECT *
FROM positions02
UNION
SELECT *, 0 as r0_2
FROM positions02null;

--Gets all the positions between 2 and 4
CREATE VIEW positions24 AS
SELECT cname as countryName, count(left_right) as r2_4
FROM countrypositions
WHERE left_right >= 2 AND left_right < 4
GROUP BY cname;

--Gets all the countries that had 0 for 2 to 4
CREATE VIEW positions24null AS
SELECT country.name as countryname
FROM country EXCEPT(SELECT countryname FROM positions24);

--Totals them together
CREATE VIEW positions24total AS
SELECT *
FROM positions24
UNION
SELECT *, 0 as r2_4
FROM positions24null;

--Gets all the positions between 4 and 6
CREATE VIEW positions46 AS
SELECT cname as countryName, count(left_right) as r4_6
FROM countrypositions
WHERE left_right >= 4 AND left_right < 6
GROUP BY cname;

--Gets all the countries that had 0 for 4 to 6
CREATE VIEW positions46null AS
SELECT country.name as countryname
FROM country EXCEPT(SELECT countryname FROM positions46);

--Totals them together
CREATE VIEW positions46total AS
SELECT *
FROM positions46
UNION
SELECT *, 0 as r4_6
FROM positions46null;

--Gets all the positions between 6 and 8
CREATE VIEW positions68 AS
SELECT cname as countryName, count(left_right) as r6_8
FROM countrypositions
WHERE left_right >= 6 AND left_right < 8
GROUP BY cname;

--Gets all the countries that had 0 for 6 to 8
CREATE VIEW positions68null AS
SELECT country.name as countryname
FROM country EXCEPT(SELECT countryname FROM positions68);

--Totals them together
CREATE VIEW positions68total AS
SELECT *
FROM positions68
UNION
SELECT *, 0 as r6_8
FROM positions68null;

--Gets all the positions between 8 and 10
CREATE VIEW positions810 AS
SELECT cname as countryName, count(left_right) as r8_10
FROM countrypositions
WHERE left_right >= 8 AND left_right < 10
GROUP BY cname;

--Gets all the countries that had 0 for 8 to 10
CREATE VIEW positions810null AS
SELECT country.name as countryname
FROM country EXCEPT(SELECT countryname FROM positions810);

--Totals them together
CREATE VIEW positions810total AS
SELECT *
FROM positions810
UNION
SELECT *, 0 as r8_10
FROM positions810null;

-- the answer to the query 
INSERT INTO q4
SELECT positions02total.countryName as countryName, r0_2, r2_4, r4_6, r6_8, r8_10
FROM positions02total NATURAL JOIN positions24total NATURAL JOIN positions46total NATURAL JOIN positions68total NATURAL JOIN positions810total;
