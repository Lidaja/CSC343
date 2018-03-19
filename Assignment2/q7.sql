-- Alliances

SET SEARCH_PATH TO parlgov;
drop table if exists q7 cascade;

-- You must not change this table definition.

DROP TABLE IF EXISTS q7 CASCADE;
CREATE TABLE q7(
        countryId INT, 
        alliedPartyId1 INT, 
        alliedPartyId2 INT
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS alliancepair CASCADE;
DROP VIEW IF EXISTS countpair CASCADE;
DROP VIEW IF EXISTS countelection CASCADE;
DROP VIEW IF EXISTS countcompare CASCADE;

--Gets all alliance pairs
CREATE VIEW alliancepair AS
SELECT er1.id as id1, er1.election_id as eid1, er1.party_id as pid1, er1.alliance_id as aid1, er2.id as id2, er2.election_id as eid2, er2.party_id as pid2, er2.alliance_id as aid2
FROM election_result as er1, election_result as er2
WHERE (er1.id = er2.alliance_id OR er1.alliance_id = er2.alliance_id) AND er1.party_id < er2.party_id;

--Counts the amount of elections the pairs have been together
CREATE VIEW countpair AS
SELECT pid1,pid2,election.country_id, count(*) as pcount
FROM alliancepair JOIN election ON eid1 = election.id
GROUP BY pid1,pid2, country_id;

--Counts the amount of elections per country
CREATE VIEW countelection AS
SELECT country.id as cid, count(election.id) as ccount
FROM country JOIN election ON country.id = election.country_id
GROUP BY country.id;

--Adds the pair counts and country counts together, to be compared in the final query
CREATE VIEW countcompare AS
SELECT cid, ccount, pid1, pid2, pcount, country_id
FROM countpair JOIN countelection ON countpair.country_id = countelection.cid;

-- the answer to the query 
insert into q7 
SELECT cid as countryId, pid1 as alliedPartyId1, pid2 as alliedPartyId2
FROM countcompare
WHERE pcount > 0.3*ccount;
