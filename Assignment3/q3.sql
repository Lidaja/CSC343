-- VoteRange

SET SEARCH_PATH TO quizschema;
drop table if exists q3 cascade;

-- You must not change this table definition.

create table q3(
	student_id VARCHAR(10),
	lastname VARCHAR(200),
	score INT
);

DROP VIEW IF EXISTS rightstudents CASCADE;
DROP VIEW IF EXISTS studentresponse;
DROP VIEW IF EXISTS responsequestion;
DROP VIEW IF EXISTS multiplechoiceanswer;
DROP VIEW IF EXISTS numericresponse;
DROP VIEW IF EXISTS truefalseresponse;
DROP VIEW IF EXISTS correct;
DROP VIEW IF EXISTS scores;

--Get the students from the proper class
CREATE VIEW rightstudents AS
SELECT sid,lastname,cid
FROM student_class JOIN class ON student_class.cid = class.id JOIN student ON student_class.sid = student.id
WHERE class.teacher = 'Mr Higgins' AND class.room = 120 AND class.grade = 8;

--Get their responses
CREATE VIEW studentresponse AS
SELECT *
FROM rightstudents JOIN response ON sid = student_id;

--Compare them to the quiz questions from the proper quiz
CREATE VIEW responsequestion AS
SELECT *
FROM studentresponse JOIN quiz_question ON question_id = qid
WHERE quiz_question.quiz_id = 'Pr1-220310';

--Get all the correct numeric responses
CREATE VIEW numericresponse AS
SELECT sid, lastname, qid, weight
FROM responsequestion JOIN numeric ON nid = numeric.id
WHERE responsequestion.answer::INT = numeric.answer;

--Get all the incorrect true/false responses
CREATE VIEW truefalseresponse AS
SELECT sid, lastname, qid, weight
FROM responsequestion JOIN truefalse ON tid = truefalse.id
WHERE responsequestion.answer::boolean = truefalse.answer;

--Get the true answer to the multiple choice questions
CREATE VIEW multiplechoiceanswer AS
SELECT mid, multiplechoiceoption.text as answer
FROM multiplechoice JOIN multiplechoiceoption ON multiplechoiceoption.mid = multiplechoice.id
WHERE isAnswer = True;

--Get all the correct multiple choice responses
CREATE VIEW multiplechoiceresponse AS
SELECT sid, lastname, qid,weight
FROM responsequestion JOIN multiplechoiceanswer ON responsequestion.mid = multiplechoiceanswer.mid
WHERE responsequestion.answer = multiplechoiceanswer.answer;

--Merge them together
CREATE VIEW correct AS
SELECT * FROM multiplechoiceresponse
UNION
SELECT * FROM truefalseresponse
UNION
SELECT * FROM numericresponse;

--Tally their scores
CREATE VIEW scores AS
SELECT sid as student_id, lastname, sum(weight) as score
FROM correct
GROUP BY (student_id,lastname);

--Get the ones with none correct
CREATE VIEW gotzero AS
SELECT sid as student_id, lastname
FROM rightstudents EXCEPT(select student_id,lastname FROM scores);

INSERT INTO q3
SELECT student_id,lastname, 0 as score
FROM gotzero
UNION
SELECT *
FROM scores;

SELECT * FROM q3;


