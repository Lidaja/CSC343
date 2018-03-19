-- Sequences

SET SEARCH_PATH TO parlgov;
drop table if exists q6 cascade;

-- You must not change this table definition.

CREATE TABLE q6(
        countryName VARCHAR(50),
        cabinetId INT, 
        startDate DATE,
        endDate DATE,
        pmParty VARCHAR(100)
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS cabinetcombo CASCADE;
DROP VIEW IF EXISTS cabinetlist CASCADE;
DROP VIEW IF EXISTS endcabinets CASCADE;
DROP VIEW IF EXISTS allcabinets CASCADE;
DROP VIEW IF EXISTS cabinetT CASCADE;
DROP VIEW IF EXISTS cabinetF CASCADE;
DROP VIEW IF EXISTS cabinetdiff CASCADE;
DROP VIEW IF EXISTS cabinetinfo CASCADE;

--Gets all cabinet sequenced pairs
CREATE VIEW cabinetcombo AS
SELECT c1.id as cid1, c1.name as cname1, c1.start_date as start_date1, c1.previous_cabinet_id, c2.id as cid2, c2.name as cname2, c2.start_date as start_date2
FROM cabinet as c1,cabinet as c2
WHERE c1.previous_cabinet_id = c2.id;

--Creates a chain of them using the start and end dates
CREATE VIEW cabinetlist as
SELECT cid2 as cid, cname2 as cname, start_date2 as start_date, start_date1 as end_date
FROM cabinetcombo;

--Gets the cabinets on the end
CREATE VIEW endcabinets as
SELECT cabinet.id as cid, cabinet.name as cname, start_date
FROM cabinet EXCEPT(SELECT cid,cname,start_date FROM cabinetlist);

--Combines the two to get all cabinets
CREATE VIEW allcabinets as
SELECT *, NULL as end_date
FROM endcabinets
UNION
SELECT *
FROM cabinetlist;

--Gets all cabinet, party combinations with a pm in the party
CREATE VIEW cabinetT as
SELECT cid, cname, start_date, end_date, party.name as pmParty
FROM allcabinets JOIN cabinet_party ON cabinet_id = cid JOIN party ON party_id = party.id
WHERE pm = 't';

--Gets all cabinet, party combinations without a pm in the party
CREATE VIEW cabinetF as
SELECT cid,cname,start_date,end_date
FROM allcabinets JOIN cabinet_party ON cabinet_id = cid
WHERE pm = 'f';

--Gets the difference of the two, to find cabinet party combinations that don't have a pm
CREATE VIEW cabinetdiff AS
SELECT *
FROM cabinetF EXCEPT(SELECT cid,cname,start_date,end_date FROM cabinetT);

--Unions the two together
CREATE VIEW cabinetinfo AS
SELECT *, NULL as pmParty
FROM cabinetdiff
UNION
SELECT *
FROM cabinetT;

-- the answer to the query 
insert into q6
SELECT country.name as countryName, cid as cabinetId, cabinetinfo.start_date as startDate, end_date as endDate, pmParty
FROM cabinetinfo JOIN cabinet ON cabinetinfo.cid = cabinet.id JOIN country on country_id = country.id;
