-- VoteRange

SET SEARCH_PATH TO quizschema;
drop table if exists q2 cascade;

-- You must not change this table definition.

create table q2(
	id INT,
	text VARCHAR(200),
	numhints INT
);

DROP VIEW IF EXISTS tf CASCADE;
DROP VIEW IF EXISTS mc CASCADE;
DROP VIEW IF EXISTS mcnull CASCADE;
DROP VIEW IF EXISTS mctotal CASCADE;
DROP VIEW IF EXISTS n CASCADE;
DROP VIEW IF EXISTS nnull CASCADE;
DROP VIEW IF EXISTS ntotal CASCADE;

--Get the number of hints from true/false questions
CREATE VIEW tf AS
SELECT id,text,NULL as numhints
FROM truefalse;

--Get the number of hints from multiple choice questions with atleast 1 hint
CREATE VIEW mc AS
SELECT multiplechoice.id, multiplechoice.text, count(multiplechoiceoption.id) as numhints
FROM multiplechoice JOIN multiplechoiceoption ON multiplechoice.id = multiplechoiceoption.mid
WHERE multiplechoiceoption.hint is not NULL
GROUP BY multiplechoice.id,multiplechoice.text;

--Get the questions with 0 hints
CREATE VIEW mcnull AS
SELECT multiplechoice.id,multiplechoice.text
FROM multiplechoice JOIN multiplechoiceoption ON multiplechoice.id = multiplechoiceoption.mid EXCEPT(SELECT id, text FROM mc);

--combine the two
CREATE VIEW mctotal AS
SELECT id,text,0 as numhints
FROM mcnull
UNION
SELECT *
FROM mc;

--Get the number of hints from numeric questions with atleast one hint
CREATE VIEW n AS
SELECT numeric.id,numeric.text, count(numerichint.id) as numhints
FROM numeric JOIN numerichint ON numeric.id = numerichint.nid
GROUP BY numeric.id, numeric.text;

--Get the numeric questions with 0 hints
CREATE VIEW nnull AS
SELECT numeric.id,numeric.text
FROM numeric JOIN numerichint ON numeric.id = numerichint.nid EXCEPT(SELECT id, text
FROM n);

--combine the two
CREATE VIEW ntotal AS
SELECT id,text, 0 as numhints
FROM nnull
UNION
SELECT *
FROM n;

--Merge them together
insert into q2
SELECT *
FROM tf
UNION
SELECT *
FROM mctotal
UNION
SELECT *
FROM ntotal;

SELECT id, substring(text from 1 for 50) as text, numhints from q2;
