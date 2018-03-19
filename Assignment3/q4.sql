-- VoteRange

SET SEARCH_PATH TO quizschema;
drop table if exists q4 cascade;

-- You must not change this table definition.

create table q4(
	student_id VARCHAR(10),
	question_id INT,
	text VARCHAR(200)
);

DROP VIEW IF EXISTS rightstudents CASCADE;
DROP VIEW IF EXISTS studentresponse;
DROP VIEW IF EXISTS responsequestion;
DROP VIEW IF EXISTS numericresponse;
DROP VIEW IF EXISTS truefalseresponse;
DROP VIEW IF EXISTS multiplechoiceanswer;

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
WHERE quiz_id = 'Pr1-220310';

--Get all the numeric responses
CREATE VIEW numericresponse AS
SELECT sid, id, numeric.text
FROM responsequestion JOIN numeric ON nid = numeric.id
WHERE responsequestion.answer IS NULL;

--Get all the true/false responses
CREATE VIEW truefalseresponse AS
SELECT sid, id, truefalse.text
FROM responsequestion JOIN truefalse ON tid = truefalse.id
WHERE responsequestion.answer IS NULL;

--Get all the multiple choice responses
CREATE VIEW multiplechoiceresponse AS
SELECT sid, id, multiplechoice.text
FROM responsequestion JOIN multiplechoice ON mid = multiplechoice.id
WHERE responsequestion.answer IS NULL;

--Merge them
INSERT INTO q4
SELECT sid as student_id,id as question_id, text as question_text
FROM numericresponse
UNION
SELECT sid as student_id,id as question_id, text as question_text
FROM truefalseresponse
UNION
SELECT sid as student_id,id as question_id, text as question_text
FROM multiplechoiceresponse;

SELECT student_id, question_id, substring(text from 1 for 50) as text FROM q4;


