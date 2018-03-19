-- Winners

SET SEARCH_PATH TO parlgov;
drop table if exists q2 cascade;

-- You must not change this table definition.

create table q2(
countryName VARCHaR(100),
partyName VARCHaR(100),
partyFamily VARCHaR(100),
wonElections INT,
mostRecentlyWonElectionId INT,
mostRecentlyWonElectionYear INT
);


-- You may find it convenient to do this for each of the views
-- that define your intermediate steps.  (But give them better names!)
DROP VIEW IF EXISTS electionlosers CASCADE;
DROP VIEW IF EXISTS electionwinners CASCADE;
DROP VIEW IF EXISTS partywinners CASCADE;
DROP VIEW IF EXISTS countryparties CASCADE;
DROP VIEW IF EXISTS countryavg CASCADE;
DROP VIEW IF EXISTS partiesAboveAvg CASCADE;
DROP VIEW IF EXISTS latestWinYear CASCADE;
DROP VIEW IF EXISTS latestWinInfo CASCADE;

--Gets all losers of election results
CREATE VIEW electionlosers AS
SELECT er1.id as erid, er1.election_id as eid, er1.party_id as pid, er1.votes as votes
FROM election_result as er1, election_result as er2
WHERE (er1.election_id = er2.election_id AND er1.votes < er2.votes) OR er1.votes IS NULL;

--Subtracts the losers view from all election results to get the winning results and corresponding party
CREATE VIEW electionwinners AS
SELECT election_id as eid,party_id as pid
FROM election_result EXCEPT(SELECT eid, pid FROM electionlosers);

--Get view of all parties, and how many they won
CREATE VIEW partywinners AS
SELECT pid, count(eid) as pwins
FROM electionwinners
GROUP BY pid;

--Gets how many parties each country has
CREATE VIEW countryparties AS
SELECT country.id as cid, count(party.id) as pcount
FROM country JOIN party ON country.id = party.country_id
GROUP BY country.id;

--Gets the average number of wins for parties each country has
CREATE VIEW countryavg AS
SELECT cid, sum(pwins) / (pcount * 1.0) as avgwins
FROM partywinners JOIN party ON pid = party.id JOIN countryparties ON cid = party.country_id
GROUP BY cid,pcount;

--Gets the latest winning election info from a winning party
CREATE VIEW latestWinInfo AS
SELECT pid, eid, e_date
FROM electionwinners JOIN election ON eid = election.id
WHERE (pid,e_date) in
	(SELECT pid, max(e_date)
	FROM electionwinners JOIN election ON eid = election.id
	GROUP BY pid);

--Gets all parties that satisfy the > 3*average party wins
CREATE VIEW partiesAboveAvg AS
SELECT party.name as partyName,partywinners.pid, cid, pwins, avgwins, country.name as countryName, family, eid as latestWinId, EXTRACT(YEAR FROM e_date) as year
FROM partywinners JOIN party ON partywinners.pid = party.id JOIN countryavg ON country_id = cid JOIN country ON cid = country.id LEFT JOIN party_family ON pid = party_family.party_id JOIN latestWinInfo ON partywinners.pid = latestWinInfo.pid
WHERE pwins > 3* avgwins;

-- the answer to the query
insert into q2
SELECT countryName, partyName, family as partyFamily, pwins as wonElections, latestWinId as mostRecentlyWonElectionId, year as mostRecentlyWonElectionYear
FROM partiesAboveAvg;



