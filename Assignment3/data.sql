DELETE FROM response;
DELETE FROM quiz_question;
DELETE FROM quiz;
DELETE FROM truefalse;
DELETE FROM numerichint;
DELETE FROM numeric;
DELETE FROM multiplechoiceoption;
DELETE FROM multiplechoice;
DELETE FROM student_class;
DELETE FROM student;
DELETE FROM class;


INSERT INTO student
VALUES
('0998801234', 'Lena', 'Headey'),
('0010784522', 'Peter', 'Dinklage'),
('0997733991', 'Emilia', 'Clarke'),
('5555555555', 'Kit', 'Harrington'),
('1111111111', 'Sophie', 'Turner'),
('2222222222', 'Maisie', 'Williams');

INSERT INTO class
VALUES
(1, 366, 5, 'Miss Nyers'),
(2, 120, 8, 'Mr Higgins');

INSERT INTO student_class
VALUES
('2222222222',1),
('0998801234',2),
('0010784522',2),
('0997733991',2),
('5555555555',2),
('1111111111',2);

INSERT INTO truefalse
VALUES
(566, 'The Prime Minister, Justin Trudeau, is Canada''s Head of State', False);


INSERT INTO multiplechoice
VALUES
(782, 'What do you promise when you take the oath of citizenship?'),
(625, 'What is the underground railroad?'),
(790, 'During the War of 1812 the Americans burned down the Parliament Buildings in York (now Toronto). What did the British and Canadians do in return?');

INSERT INTO multiplechoiceoption
VALUES
(1,782,'To pledge your loyalty to the Soverign, Queen Elizabeth II', True, NULL),
(2,782,'To pledge your allegiance to the flag and fulfill the duties of a Canadian', False, 'Think regally'),
(3,782,'To pledge your loyalty to Canada from sea to sea', False, NULL),
(4,625,'The first railway to cross Canada',False,'The Underground Railroad was generally south to north, not east-west'),
(5,625,'The CPR''s secret railway line',False,'The underground Railroad was a secret, but it had nothing to do with trains'),
(6,625,'The TTC subway system',False,'The TTC is relatively recent; the Underground railroad was in operation over 100 years ago'),
(7,625,'A network used by slaves who escaped the United States into Canada',True,NULL),
(8,790,'They attacked the Emerican merchant ships',False,NULL),
(9,790,'They expanded their defence system, including Fort York', False, NULL),
(10,790, 'They burned down the White House in Washington D.C.', True, NULL),
(11,790, 'They captured Niagara Falls', False, NULL);

INSERT INTO numeric
VALUES
(601,'During the "Quiet Revolution," Quebec experienced rapid change. In what decade did this occur? (Enter the year that began the decade, e.g., 1840.', 1960);

INSERT INTO numerichint
VALUES
(1,601, 'The Quiet Revolution happened during the 20th Century.', 1800,1900),
(2,601, 'The Quiet Revolution happened some time ago.', 2000,2010),
(3,601, 'The Quiet Revolution has already happened!', 2020,300);

INSERT INTO quiz
VALUES
('Pr1-220310', 'Citizenship Test Practise Questions', '2017-10-01','13:30', 2, True);


INSERT INTO quiz_question
VALUES
(1,'Pr1-220310',NULL,NULL,'601',2),
(2,'Pr1-220310','566',NULL,NULL,1),
(3,'Pr1-220310',NULL,'790',NULL,3),
(4,'Pr1-220310',NULL,'625',NULL,2);

INSERT INTO response
VALUES
('0998801234',1,'1950'),
('0998801234',2,'False'),
('0998801234',3,'They expanded their defence system, including Fort York'),
('0998801234',4,'A network used by slaves who escaped the United States into Canada'),
('0010784522',1,'1960'),
('0010784522',2,'False'),
('0010784522',3,'They burned down the White House in Washington D.C.'),
('0010784522',4,'A network used by slaves who escaped the United States into Canada'),
('0997733991',1,'1960'),
('0997733991',2,'True'),
('0997733991',3,'They burned down the White House in Washington D.C.'),
('0997733991',4,'The CPR''s secret railway line'),
('5555555555',1,NULL),
('5555555555',2,'False'),
('5555555555',3,'They captured Niagara Falls'),
('5555555555',4,NULL),
('1111111111',1,NULL),
('1111111111',2,NULL),
('1111111111',3,NULL),
('1111111111',4,NULL);
