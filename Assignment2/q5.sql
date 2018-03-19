-- Committed

SET SEARCH_PATH TO parlgov;
drop table if exists q5 cascade;

-- You must not change this table definition.

CREATE TABLE q5(
        countryName VARCHAR(50),
        partyName VARCHAR(100),
        partyFamily VARCHAR(50),
        stateMarket REAL
);

-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS partycab CASCADE;
DROP VIEW IF EXISTS everypartycab CASCADE;
DROP VIEW IF EXISTS notcommitted CASCADE;
DROP VIEW IF EXISTS committed CASCADE;
DROP VIEW IF EXISTS cparty CASCADE;
DROP VIEW IF EXISTS partyinfo CASCADE;

--cabinet cabinet_party combinations above 1996
CREATE VIEW partycab AS
SELECT cabinet.id as cid, party_id as pid, country_id
FROM cabinet_party JOIN cabinet ON cabinet.id = cabinet_id
WHERE EXTRACT(YEAR FROM start_date) >= 1996;

--Every party cabinet combination
CREATE VIEW everypartycab AS
SELECT cabinet.id as cid,party.id as pid, party.country_id
FROM cabinet JOIN party ON cabinet.country_id = party.country_id
WHERE EXTRACT(YEAR FROM start_date) >= 1996;

--Gets all non commited parties
CREATE VIEW notcommitted AS
SELECT *
FROM everypartycab EXCEPT (
	SELECT * FROM partycab);

--Subtracts the previous view from every party cabinet combination to get committed parties
CREATE VIEW committed AS
SELECT party.id as pid, country_id
FROM party EXCEPT (
	SELECT pid, country_id FROM notcommitted);

--Gets all necessary information on said committed parties
CREATE VIEW partyinfo AS
SELECT party.country_id, party.name as partyName, family as partyFamily, state_market as stateMarket
FROM committed JOIN party ON committed.pid = party.id JOIN party_family on party.id = party_family.party_id JOIN party_position ON party.id = party_position.party_id;

-- the answer to the query 
insert into q5
SELECT DISTINCT country.name as countryName, partyName, partyFamily, stateMarket
FROM country JOIN partyinfo ON partyinfo.country_id = country.id;
