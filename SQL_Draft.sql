CREATE TABLE students (
  student_id INT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  middle_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  major VARCHAR(50) NOT NULL,
  cgpa DECIMAL(3,2), -- check constraint removed as cgpa will be calculated using data in db
  sex VARCHAR(1), -- check constraint not working in ElephantSQL
  birthdate DATE NOT NULL,
  cnic INT UNIQUE NOT NULL
);

-- INSTRUCTORS TABLE IS REPEATED -- 
CREATE TABLE instructors (
  instructor_id INT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  middle_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  department VARCHAR(50) NOT NULL,
  sex VARCHAR(1) CHECK (sex IN ('m', 'f')),
  birthdate DATE NOT NULL,
  cnic INT NOT NULL
);

CREATE TABLE courses (
  course_id INT NOT NULL,
  c_section VARCHAR(1) NOT NULL,
  course_name VARCHAR(100) NOT NULL,
  instructor_id INT,
  course_description TEXT,
  credits INT NOT NULL,
  faculty VARCHAR(4) CHECK (faculty IN ('FCSE', 'FMCE', 'FME', 'FES', 'FCVE', 'FEE')),
  c_type VARCHAR(10) CHECK (c_type IN ('core', 'elective')),
  CONSTRAINT cr_pk PRIMARY KEY(course_id, c_section),
  FOREIGN KEY(instructor_id) REFERENCES instructors(instructor_id)
);

CREATE TABLE student_courses (
  student_id INT NOT NULL,
  course_id INT NOT NULL,
  c_section VARCHAR(1) NOT NULL,
  grade VARCHAR(2),
  PRIMARY KEY (student_id, course_id),
  FOREIGN KEY (student_id) REFERENCES students(student_id),
  FOREIGN KEY (course_id, c_section) REFERENCES courses(course_id, c_section)
);

-- Create table for instructors
CREATE TABLE instructors (
  instructor_id INT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  middle_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  department VARCHAR(50) NOT NULL,
  sex VARCHAR(1) CHECK (sex IN ('m', 'f')),
  birthdate DATE NOT NULL,
  CNIC INT NOT NULL
);

CREATE TABLE enrollments (
  --have a primary key made of student_id, course_id and section
  student_id INT NOT NULL,
  course_id INT NOT NULL,
  c_section VARCHAR(1) NOT NULL,
  enrollment_date DATE NOT NULL,
  grade VARCHAR(2), --can be NULL
  PRIMARY KEY (student_id, course_id, c_section),
  FOREIGN KEY (student_id) REFERENCES students(student_id),
  FOREIGN KEY (course_id, c_section) REFERENCES courses(course_id, c_section)
);

--course_division caters to assignments, quizzes, mid and final
CREATE TABLE course_division (
  cd_id SERIAL PRIMARY KEY,
  cd_type VARCHAR(20) NOT NULL, --assignments, quizzes, mid or final
  cd_name VARCHAR(100) NOT NULL,
  total_marks INT NOT NULL,
  weightage DECIMAL(3,2) NOT NULL,
  due_date DATE NOT NULL,
  course_id INT NOT NULL,
  c_section VARCHAR(1) NOT NULL,
  FOREIGN KEY (course_id, c_section) REFERENCES courses(course_id, c_section)
);

CREATE TABLE submissions (
  cd_id SERIAL,
  student_id INT NOT NULL,
  submitted BOOLEAN NOT NULL,
  marks INT,
  PRIMARY KEY (cd_id, student_id),
  FOREIGN KEY (cd_id) REFERENCES course_division(cd_id),
  FOREIGN KEY (student_id) REFERENCES students(student_id)
);


CREATE TABLE semesters (
  s_year INT NOT NULL,
  s_name VARCHAR(10) NOT NULL CHECK (s_name IN ('summer', 'spring', 'fall')),
  CONSTRAINT pk_sem PRIMARY KEY (s_year, s_name)
);

CREATE TABLE semester_courses (
  s_year INT NOT NULL,
  s_name VARCHAR(10) NOT NULL CHECK (s_name IN ('summer', 'spring', 'fall')),
  course_id INT NOT NULL,
  semester_id INT NOT NULL,
  c_section varchar(1) NOT NULL,
  PRIMARY KEY (semester_id, course_id),
  FOREIGN KEY (s_year, s_name) REFERENCES semesters(s_year, s_name),
  FOREIGN KEY (course_id, c_section) REFERENCES courses(course_id, c_section)
);

CREATE TABLE attendance (
  student_id INT NOT NULL,
  course_id INT NOT NULL,
  c_section VARCHAR (1) NOT NULL,
  att_date DATE NOT NULL,
  att_status BOOLEAN NOT NULL,
  PRIMARY KEY (student_id, course_id, c_section, att_date),
  FOREIGN KEY (student_id) REFERENCES students(student_id),
  FOREIGN KEY (course_id, c_section) REFERENCES courses(course_id, c_section)
);

CREATE TABLE crs_result (
  res_id SERIAL PRIMARY KEY,
  grade VARCHAR(2) NOT NULL, --calculated using marks, total marks and weightage
  student_id INT NOT NULL,
  course_id INT NOT NULL,
  c_section VARCHAR(1) NOT NULL,
  s_year INT NOT NULL,
  s_name VARCHAR(10) NOT NULL CHECK (s_name IN ('summer', 'spring', 'fall')),
  FOREIGN KEY (student_id) REFERENCES students(student_id),
  FOREIGN KEY (course_id, c_section) REFERENCES courses(course_id, c_section),
  FOREIGN KEY (s_name, s_year) REFERENCES semesters(s_name, s_year)
);

CREATE TABLE sem_gpa (
  student_id INT NOT NULL,
  s_year INT NOT NULL,
  s_name VARCHAR(10) NOT NULL CHECK (s_name IN ('summer', 'spring', 'fall')),
  gpa DECIMAL(3,2) NOT NULL,
  PRIMARY KEY (student_id, s_year, s_name),
  FOREIGN KEY (student_id) REFERENCES students(student_id)
);

CREATE VIEW student_marks AS
	SELECT s.cd_id, s.marks s_marks, cd.total_marks s_total_marks, cd.weightage s_weightage 
	FROM course_division cd, submissions s
	WHERE s.student_id = 1;
	
DROP VIEW student_marks;
DROP FUNCTION gradeCalculate();

CREATE OR REPLACE FUNCTION gradeCalculate()
RETURNS char(2)
LANGUAGE plpgsql
AS $$
DECLARE
	grade char(2);
	weighted_marks int := 0;
	totalmarks int:= 0;
	weightage int:= 0;
	marks int:= 0;
	cursor_totalmarks CURSOR FOR SELECT s_total_marks FROM student_marks;
	cursor_weightage CURSOR FOR SELECT s_weightage FROM student_marks;
	cursor_marks CURSOR FOR SELECT s_marks FROM student_marks; 
BEGIN
	OPEN cursor_totalmarks;
	OPEN cursor_weightage;
	OPEN cursor_marks;
	LOOP
		FETCH cursor_totalmarks INTO totalmarks;
		FETCH cursor_weightage INTO weightage;
		FETCH cursor_marks INTO marks;
		EXIT WHEN NOT FOUND;		
		weighted_marks := weighted_marks + ((marks/totalmarks)*weightage);
	END LOOP;
	CLOSE cursor_totalmarks;
	CLOSE cursor_weightage;
	CLOSE cursor_marks;
	IF weighted_marks > 90 THEN 
		grade = 'A';
	ELSE
		grade = 'B';
	END IF;
	RETURN grade;			
END; $$;

INSERT INTO students(student_id, first_name, middle_name, last_name, email, major, cgpa, sex, birthdate, cnic)
VALUES(1, 'Arv',	'Noreen', 'Oliphand',	'noliphand0@columbia.edu',	'FCSE',	NULL, 'm', '01-01-2001', 123456789);

insert into courses(course_id, c_section, course_name, instructor_id, course_description, credits, faculty, c_type)
values(121, 'A', 'Criminology', 169, 'Intro to crimes', 3, 'FCSE', 'core');

INSERT INTO instructors(instructor_id, first_name, middle_name, last_name, email, department, sex, birthdate, cnic)
VALUES(169, 'Mohsin', 'M', 'Zafar', 'xyz@gmail.com', 'FCSE', 'm', '01-01-1980', 19234578);

INSERT INTO course_division(cd_type, cd_name, total_marks, weightage, due_date, course_id, c_section)
VALUES('a', 'b', 50, 45, '01-01-2023', 121, 'A'),
('a', 'b', 45,55, '01-01-2023', 121, 'A');

INSERT INTO submissions (cd_id, student_id, submitted, marks)
VALUES(3, 1, TRUE, 50),
(4, 1, TRUE, 45);

UPDATE submissions SET marks = 10 WHERE cd_id = 3;
UPDATE submissions SET marks = 10 WHERE cd_id = 4;
SELECT * FROM course_division;

SELECT gradeCalculate();
