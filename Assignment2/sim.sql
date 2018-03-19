-- VoteRange

SET SEARCH_PATH TO parlgov;

DROP VIEW IF EXISTS sim CASCADE;

CREATE VIEW sim AS
SELECT p1.id as id1, p1.description as desc1, p1.comment as com1, p2.id as id2, p2.comment as com2, p2.description as desc2
FROM politician_president as p1, politician_president as p2
WHERE p1.id = 148 AND p1.id < p2.id;

SELECT * FROM sim;
