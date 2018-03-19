-- Constraints that could not be enforced: 
-- 1.Having the student id be exactly 10 digits. I could make it a string but then letters can be in it, or I can make it an int, but then numbers starting with 0 will be truncated.
-- 2.Enforcing atleast 1 student in each class.
-- 3. Unique ids between different types of questions.
-- 4. Multiple choice questions must have atleast 2 option.
-- 5. A quiz has atleast 1 question

-- Constraints that could be enforced but were not:
-- 1. Multiple choice questions must have an option which is an answer
-- 2. Only a student in the class that was assigned a quiz can answer its questions

DROP SCHEMA IF EXISTS quizschema CASCADE;
CREATE SCHEMA quizschema;

SET SEARCH_PATH to quizschema;


CREATE TABLE student(
	id VARCHAR(10) primary key,
	firstname VARCHAR(50) NOT NULL,
	lastname VARCHAR(50) NOT NULL
);

CREATE TABLE class(
	id INT primary key,
	room INT NOT NULL,
	grade INT NOT NULL,
	teacher VARCHAR(50) NOT NULL,
	UNIQUE(room,teacher)
);

CREATE TABLE student_class(
	sid VARCHAR(10) references student(id) NOT NULL,
	cid INT references class(id) NOT NULL,
	UNIQUE(sid,cid)
);

CREATE TABLE truefalse(
	id INT primary key,
	text VARCHAR(200) NOT NULL,
	answer boolean NOT NULL
);


CREATE TABLE multiplechoice(
	id INT primary key,
	text VARCHAR(200) NOT NULL
);

CREATE TABLE multiplechoiceoption(
	id INT primary key,
	mid INT references multiplechoice(id) NOT NULL,
	text VARCHAR(200) NOT NULL,
	isAnswer boolean NOT NULL,
	hint VARCHAR(200),
	check ((isAnswer is true and hint is NULL) or (isAnswer is false))
);

CREATE TABLE numeric(
	id INT primary key,
	text VARCHAR(200) NOT NULL,
	answer INT NOT NULL
);

CREATE TABLE numerichint(
	id INT primary key,
	nid INT references numeric(id) NOT NULL,
	hint VARCHAR(100) NOT NULL,
	hintlower INT NOT NULL,
	hintupper INT NOT NULL
);

CREATE TABLE quiz(
	id VARCHAR(50) primary key,
	title VARCHAR(100) NOT NULL,
	due_date DATE NOT NULL,
	due_time time NOT NULL,
	class INT references class(id) NOT NULL,
	hints boolean NOT NULL
);

CREATE TABLE quiz_question(
	qid INT primary key,
	quiz_id VARCHAR(50) references quiz(id) NOT NULL,
	tid INT references truefalse(id),
	mid INT references multiplechoice(id),
	nid INT references numeric(id),
	weight INT NOT NULL,
	UNIQUE(quiz_id,tid,mid,nid),
	check ((tid is NULL and mid is NULL and nid is not NULL) or (tid is NULL and mid is not NULL and nid is NULL) or (tid is not NULL and mid is NULL and nid is NULL)));

CREATE table response(
	student_id VARCHAR(10) references student(id) NOT NULL,
	question_id INT references quiz_question(qid) NOT NULL,
	answer VARCHAR(100),
	UNIQUE(student_id, question_id)
);
