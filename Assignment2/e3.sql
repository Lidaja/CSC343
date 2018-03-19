-- VoteRange

SET SEARCH_PATH TO parlgov;

-- You must not change this table definition.
DROP VIEW IF EXISTS e3 CASCADE;

CREATE VIEW e3 AS
SELECT country.id as cid, country.name as cname, election.id as eid, e_date, e_type, start_date, cabinet.id as cabid
FROM country JOIN election ON country.id = election.country_id JOIN cabinet ON cabinet.election_id = election.id
WHERE country.id = 43
ORDER BY e_date DESC, start_date ASC;

SELECT * FROM e3;

