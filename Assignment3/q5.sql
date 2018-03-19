-- VoteRange

SET SEARCH_PATH TO quizschema;
drop table if exists q5 cascade;

-- You must not change this table definition.

create table q5(
	question_id INT,
	numright INT,
	numwrong INT,
	numnull INT
);

DROP VIEW IF EXISTS rightstudents CASCADE;
DROP VIEW IF EXISTS studentresponse;
DROP VIEW IF EXISTS responsequestion;
DROP VIEW IF EXISTS multiplechoiceanswer;
DROP VIEW IF EXISTS multiplechoiceright;
DROP VIEW IF EXISTS numericright;
DROP VIEW IF EXISTS truefalseright;
DROP VIEW IF EXISTS truefalsewrong;
DROP VIEW IF EXISTS truefalsenull;
DROP VIEW IF EXISTS numericwrong;
DROP VIEW IF EXISTS numericnull;
DROP VIEW IF EXISTS multiplechoicewrong;
DROP VIEW IF EXISTS multiplechoicenull;


--Students in the proper class
CREATE VIEW rightstudents AS
SELECT sid,lastname,cid
FROM student_class JOIN class ON student_class.cid = class.id JOIN student ON student_class.sid = student.id
WHERE class.teacher = 'Mr Higgins' AND class.room = 120 AND class.grade = 8;

--Responses from those students
CREATE VIEW studentresponse AS
SELECT *
FROM rightstudents JOIN response ON sid = student_id;

--Responses to the quiz questions from the proper quiz
CREATE VIEW responsequestion AS
SELECT *
FROM studentresponse JOIN quiz_question ON question_id = qid
WHERE quiz_question.quiz_id = 'Pr1-220310';

--Get all the right answers from the numeric questions
CREATE VIEW numericright AS
SELECT id, count(sid) as numright
FROM responsequestion JOIN numeric ON nid = numeric.id
WHERE responsequestion.answer::INT = numeric.answer
GROUP BY id;

--Get all the wrong answers from the numeric questions
CREATE VIEW numericwrong AS
SELECT id, count(sid) as numwrong
FROM responsequestion JOIN numeric ON nid = numeric.id
WHERE responsequestion.answer IS NOT NULL AND responsequestion.answer::INT != numeric.answer
GROUP BY id;

--Get all the empty answers from the numeric questions
CREATE VIEW numericnull AS
SELECT id, count(sid) as numnull
FROM responsequestion JOIN numeric ON nid = numeric.id
WHERE responsequestion.answer IS NULL
GROUP BY id;

--Get all the right answers from the true/false questions
CREATE VIEW truefalseright AS
SELECT id, count(sid) as numright
FROM responsequestion JOIN truefalse ON tid = truefalse.id
WHERE responsequestion.answer::boolean = truefalse.answer
GROUP BY id;

--Get all the wrong answers from the true/false questions
CREATE VIEW truefalsewrong AS
SELECT id,count(sid) as numwrong
FROM responsequestion JOIN truefalse ON tid = truefalse.id
WHERE responsequestion.answer IS NOT NULL AND responsequestion.answer::boolean != truefalse.answer
GROUP BY id;

--Get all the empty answers from the true/false questions
CREATE VIEW truefalsenull as 
SELECT id,count(sid) as numnull
FROM responsequestion JOIN truefalse ON tid = truefalse.id
WHERE responsequestion.answer IS NULL
GROUP BY id;

--Get the true answers to the multiple choice questions
CREATE VIEW multiplechoiceanswer AS
SELECT mid, multiplechoiceoption.text as answer
FROM multiplechoice JOIN multiplechoiceoption ON multiplechoiceoption.mid = multiplechoice.id
WHERE isAnswer = True;

--Get all the right answers to the multiple choice questions
CREATE VIEW multiplechoiceright AS
SELECT responsequestion.mid as id,count(sid) as numright
FROM responsequestion JOIN multiplechoiceanswer ON responsequestion.mid = multiplechoiceanswer.mid
WHERE responsequestion.answer = multiplechoiceanswer.answer
GROUP BY responsequestion.mid;

--Get all the wrong answers from the multiple choice questions
CREATE VIEW multiplechoicewrong AS
SELECT responsequestion.mid as id, count(sid) as numwrong
FROM responsequestion JOIN multiplechoiceanswer ON responsequestion.mid = multiplechoiceanswer.mid
WHERE responsequestion.answer IS NOT NULL AND responsequestion.answer != multiplechoiceanswer.answer
GROUP BY responsequestion.mid;

--Get all the empty answers from the null questions
CREATE VIEW multiplechoicenull AS
SELECT responsequestion.mid as id, count(sid) as numnull
FROM responsequestion JOIN multiplechoiceanswer ON responsequestion.mid = multiplechoiceanswer.mid
WHERE responsequestion.answer IS NULL
GROUP BY responsequestion.mid;

--Merge them all together
INSERT INTO q5
SELECT multiplechoiceright.id as question_id, numright, numwrong, numnull
FROM multiplechoiceright JOIN multiplechoicewrong ON multiplechoiceright.id = multiplechoicewrong.id JOIN multiplechoicenull ON multiplechoiceright.id = multiplechoicenull.id
UNION
SELECT numericright.id as question_id, numright, numwrong, numnull
FROM numericright JOIN numericwrong ON numericright.id = numericwrong.id JOIN numericnull ON numericright.id = numericnull.id
UNION
SELECT truefalseright.id as question_id, numright, numwrong, numnull
FROM truefalseright JOIN truefalsewrong ON truefalseright.id = truefalsewrong.id JOIN truefalsenull ON truefalseright.id = truefalsenull.id;

SELECT * FROM q5;




