CREATE TABLE students (
  student_id INT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  middle_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  major VARCHAR(50) NOT NULL,
  cgpa DECIMAL(3,2) -- check constraint removed as cgpa will be calculated using data in db
  sex VARCHAR(1) CHECK sex IN ('m', 'f'),
  birthdate DATE NOT NULL,
  CNIC INT NOT NULL
);
 
CREATE TABLE courses (
  course_id INT NOT NULL,
  section VARCHAR(1) NOT NULL,
  course_name VARCHAR(100) NOT NULL,
  course_description TEXT,
  credits INT NOT NULL,
  faculty VARCHAR(4) CHECK faculty IN ('FCSE', 'FMCE', 'FME', 'FES', 'FCVE', 'FEE'),
  c_type VARCHAR(10) CHECK c_type IN ('core', 'elective'),
  CONSTRAINT cr_pk PRIMARY KEY(course_id, section),
  FOREIGN KEY(instructor_id) REFERENCES instructors(instructor_id)
);

CREATE TABLE student_courses (
  student_id INT NOT NULL,
  course_id INT NOT NULL,
  section VARCHAR(1) NOT NULL,
  grade VARCHAR(2),
  PRIMARY KEY (student_id, course_id),
  FOREIGN KEY (student_id) REFERENCES students(student_id),
  FOREIGN KEY (course_id, section) REFERENCES courses(course_id, section)
);

-- Create table for instructors
CREATE TABLE instructors (
  instructor_id INT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  middle_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  department VARCHAR(50) NOT NULL,
  sex VARCHAR(1) CHECK sex IN ('m', 'f'),
  birthdate DATE NOT NULL,
  CNIC INT NOT NULL
);

CREATE TABLE enrollments (
  --have a primary key made of student_id, course_id and section
  student_id INT NOT NULL,
  course_id INT NOT NULL,
  section VARCHAR(1) NOT NULL,
  enrollment_date DATE NOT NULL,
  grade VARCHAR(2), --can be NULL
  PRIMARY KEY (student_id, course_id, section),
  FOREIGN KEY (student_id) REFERENCES students(student_id),
  FOREIGN KEY (course_id, section) REFERENCES courses(course_id, section)
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
  section VARCHAR(1) NOT NULL,
  FOREIGN KEY (course_id, section) REFERENCES courses(course_id, section)
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
  s_name VARCHAR(10) NOT NULL CHECK s_name IN ('summer', 'spring', 'fall'),
  CONSTRAINT pk_sem PRIMARY KEY (s_year, s_name)
);

CREATE TABLE semester_courses (
  s_year INT NOT NULL,
  s_name VARCHAR(10) NOT NULL CHECK s_name IN ('summer', 'spring', 'fall'),
  course_id INT NOT NULL,
  PRIMARY KEY (semester_id, course_id),
  FOREIGN KEY (s_year, s_name) REFERENCES semesters(s_year, s_name),
  FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

CREATE TABLE attendance (
  student_id INT NOT NULL,
  course_id INT NOT NULL,
  section VARCHAR (1) NOT NULL,
  att_date DATE NOT NULL,
  att_status BOOLEAN NOT NULL,
  PRIMARY KEY (student_id, course_id, section, att_date),
  FOREIGN KEY (student_id) REFERENCES students(student_id),
  FOREIGN KEY (course_id, section) REFERENCES courses(course_id, section)
);

CREATE TABLE crs_result (
  res_id SERIAL PRIMARY KEY,
  grade VARCHAR(2) NOT NULL, --calculated using marks, total marks and weightage
  student_id INT NOT NULL,
  course_id INT NOT NULL,
  section VARCHAR(1) NOT NULL,
  s_year INT NOT NULL,
  s_name VARCHAR(10) NOT NULL CHECK s_name IN ('summer', 'spring', 'fall'),
  FOREIGN KEY (student_id) REFERENCES students(student_id),
  FOREIGN KEY (course_id, section) REFERENCES courses(course_id, section),
  FOREIGN KEY (s_name, s_year) REFERENCES (s_name, s_year)
);

CREATE TABLE sem_gpa (
  student_id INT NOT NULL,
  s_year INT NOT NULL,
  s_name VARCHAR(10) NOT NULL CHECK s_name IN ('summer', 'spring', 'fall'),
  gpa DECIMAL(3,2) NOT NULL,
  PRIMARY KEY (student_id, s_year, s_name),
  FOREIGN KEY (student_id) REFERENCES students(student_id)
);