--Student Details
CREATE TABLE students (
	student_id serial PRIMARY KEY,
	first_name varchar(30) NOT NULL,
	middle_name varchar(30),
	last_name varchar(30) NOT NULL,
	personal_email varchar(100) UNIQUE NOT NULL,	
	phone_num bigint UNIQUE NOT NULL,
	address text NOT NULL,		
	sex varchar(1) NOT NULL
		CHECK (sex IN ('M', 'F')),
	birthdate DATE NOT NULL 
		CHECK (date_part('year', birthdate) > date_part('year', current_date)-100),
	cnic varchar(13) UNIQUE NOT NULL,
	student_email varchar(20) UNIQUE,
	current_semester int NOT NULL DEFAULT 1,
	major varchar(50) NOT NULL,
	completed_ch int DEFAULT 0,
	enrollment_status varchar(20) NOT NULL DEFAULT 'Currently Enrolled',
	current_cgpa decimal(3,2)
);

--ALTER TABLE students ALTER COLUMN current_cgpa type decimal(3,2);

--Setting Student ID to combine admission year and digits
SELECT setval(pg_get_serial_sequence('students', 'student_id'), 
			  CAST(date_part('year', current_date)*1000 AS int));

--Course information
CREATE TABLE courses(
	course_id varchar(5) PRIMARY KEY,
	course_name varchar(100) NOT NULL,
	course_description text,
	credit_hours int NOT NULL 
		CHECK (credit_hours BETWEEN 1 and 4),
	faculty_from varchar(4) NOT NULL 
		CHECK (faculty_from IN ('FCSE', 'FMCE', 'FME', 'FES', 'FCVE', 'FEE', 'MGS'))
);

-- Instructors' Information
CREATE TABLE instructors (
	instructor_id serial PRIMARY KEY,
	first_name varchar(30) NOT NULL,
	middle_name varchar(30),
	last_name varchar(30) NOT NULL,
	personal_email varchar(100) UNIQUE NOT NULL,
	instructor_email varchar(50) UNIQUE,
	phone_num bigint UNIQUE NOT NULL,
	address text NOT NULL,
	ins_role varchar(50) NOT NULL,
	department varchar(50) NOT NULL,
	sex varchar(1) NOT NULL
		CHECK (sex IN ('M', 'F')),
	birthdate DATE NOT NULL
		CHECK (date_part('year', birthdate) > date_part('year', current_date)-100),
	cnic varchar(13) UNIQUE NOT NULL
);

--ALTER TABLE instructors ALTER COLUMN cnic type varchar(13);
--ALTER TABLE instructors ADD CONSTRAINT i_fk FOREIGN KEY(instructor_email) REFERENCES instructor_login(instructor_email);

--Semesters
CREATE TABLE semesters (
	s_id serial PRIMARY KEY,
	s_name varchar(10) NOT NULL 
		CHECK (s_name IN ('Summer', 'Spring', 'Fall')),
	s_year int NOT NULL
);

--Course Sections
CREATE TABLE courses_section (
	course_id varchar(5) REFERENCES courses(course_id),
	c_section varchar(1) NOT NULL,
	instructor_id int REFERENCES instructors(instructor_id),
	PRIMARY KEY(course_id, c_section)
);

--Courses offered in particular semesters
CREATE TABLE semester_courses (
	s_id int REFERENCES semesters(s_id),
	course_id varchar(5), --REFERENCES (course_id),
	c_section varchar(1), --REFERENCES courses_section(c_section),
	PRIMARY KEY (s_id, course_id, c_section),
	FOREIGN KEY (course_id, c_section) REFERENCES courses_section(course_id, c_section) 
);

--Students registered in particular courses
CREATE TABLE student_courses (
	student_id int REFERENCES students(student_id),
	course_id varchar(5), -- REFERENCES courses(course_id),
	c_section varchar(1), -- REFERENCES courses_section(c_section),
	s_id int REFERENCES semesters(s_id),
	attendance_percentage float4,
	grade varchar(2),
	status varchar(20) NOT NULL 
		CHECK (status IN ('Enrolled', 'Unenrolled', 'Pass', 'Fail' )),
	PRIMARY KEY (student_id, course_id),
	FOREIGN KEY (course_id, c_section) REFERENCES courses_section(course_id, c_section) 
);

CREATE TABLE instructor_courses (
	instructor_id int REFERENCES instructors(instructor_id),
	course_id varchar(5),
	c_section varchar(1),
	status varchar(20) NOT NULL CHECK (status IN ('Teaching', 'Taught')),
	PRIMARY KEY (instructor_id, course_id),
	FOREIGN KEY (course_id, c_section) REFERENCES courses_section(course_id, c_section)
);

--Course_division caters to assignments, quizzes, mid and final
CREATE TABLE course_division (
	cd_id serial PRIMARY KEY,
	course_id varchar(5), -- REFERENCES courses(course_id),
	c_section varchar(1), -- REFERENCES courses_section(c_section),
	cd_name varchar(20) NOT NULL, --assignments (1, 2, etc), quizzes, mid or final
	total_marks float4 NOT NULL,
	weightage float4 NOT NULL,
	FOREIGN KEY (course_id, c_section) REFERENCES courses_section(course_id, c_section) 
);
--ALTER TABLE course_division DROP COLUMN due_date;

--Submission status/marks for course division components
CREATE TABLE submissions (
	cd_id int REFERENCES course_division(cd_id),
	student_id int REFERENCES students(student_id),
	submitted boolean NOT NULL,
	marks float4,
	PRIMARY KEY (cd_id, student_id)
);

--Class dates for different courses
/*CREATE TABLE attendance_date(
	course_id varchar(5), -- REFERENCES courses(course_id),
	c_section varchar(1), --REFERENCES courses(course_id),
	att_date date NOT NULL,
	PRIMARY KEY (course_id, c_section, att_date),
	FOREIGN KEY (course_id, c_section) REFERENCES courses_section(course_id, c_section)
);*/

--Attendance record of students for courses
CREATE TABLE attendance_record (
	student_id int REFERENCES students(student_id),
	course_id varchar(5), --REFERENCES attendance_date(,
	c_section varchar(1),
	lecture int, --REFERENCES attendance_date,
	att_status boolean NOT NULL,
	PRIMARY KEY (student_id, course_id, lecture),
	FOREIGN KEY (course_id, c_section) REFERENCES courses_section(course_id, c_section)
);

--DROP TABLE attendance_record;

--Students' GPA
CREATE TABLE students_gpa (
	student_id int REFERENCES students(student_id),
	s_id int REFERENCES semesters(s_id),
	sgpa decimal(3,2),
	cgpa decimal(3,2),
	PRIMARY KEY (student_id, s_id)
);

--Student Login Details for CMS website
CREATE TABLE student_login(
	student_email varchar(20),
	student_password varchar(10) NOT NULL,
	FOREIGN KEY(student_email) REFERENCES students(student_email)
);

--Instructor Login Details for CMS website
CREATE TABLE instructor_login(
	instructor_email varchar(50),
	instructor_password varchar(10) NOT NULL,
	FOREIGN KEY(instructor_email) REFERENCES instructors(instructor_email)
);

--Admin Login Details for CMS website
CREATE TABLE admin_login(
	admin_email varchar(20) PRIMARY KEY,
	admin_password varchar(10) NOT NULL
);

/*
--Courses for which students have registered but approval is pending
CREATE TABLE course_pending() (
	pending_id serial PRIMARY KEY,
	student_id int REFERENCES students(student_id),
	course_id varchar(5) REFERENCES courses(course_id),
	c_section varchar(1) REFERENCES course_sections(c_section),
	s_id int REFERENCES semesters(s_id),
	status varchar(20) NOT NULL DEFAULT 'Pending'
);
--Administrators' Information
CREATE TABLE admin_info (
	admin_id serial PRIMARY KEY,
	first_name varchar(30) NOT NULL,
	last_name varchar(30) NOT NULL,
	admin_email varchar(20)
)
*/