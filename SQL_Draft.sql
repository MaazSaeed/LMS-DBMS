-- Create table for students
CREATE TABLE students (
  student_id INT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  middle_name VARCHAR(50) NOT NULL, --changes made
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  major VARCHAR(50) NOT NULL,
  cgpa DECIMAL(3,2) CHECK (cgpa BETWEEN 0 AND 4),
  sex VARCHAR(1) CHECK sex IN ('m', 'f'), --changes made
  birthdate DATE NOT NULL, --changes made
  CNIC INT NOT NULL --changes made
);
 
-- Create table for courses
CREATE TABLE courses (
  course_id INT NOT NULL,
  section VARCHAR(1) NOT NULL,
  course_name VARCHAR(100) NOT NULL,
  course_description TEXT,
  credits INT NOT NULL,
  faculty VARCHAR(4) CHECK faculty IN ('FCSE', 'FMCE', 'FME', 'FES', 'FCVE', 'FEE'),
  c_type VARCHAR(10) CHECK c_type IN ('core', 'elective'),
  PRIMARY KEY(course_id, section),
  FOREIGN KEY(instructor_id) REFERENCES instructors(instructor_id)
);

-- Create table for instructors
CREATE TABLE instructors (
  instructor_id INT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  department VARCHAR(50) NOT NULL
);

-- Create table for enrollments
CREATE TABLE enrollments (
  --have a primary key made of student_id, course_id and section
  student_id INT NOT NULL,
  course_id INT NOT NULL,
  enrollment_date DATE NOT NULL,
  grade VARCHAR(2), --can be NULL
  section VARCHAR(1) NOT NULL,
  PRIMARY KEY (student_id, course_id, section),
  FOREIGN KEY (student_id) REFERENCES students(student_id),
  FOREIGN KEY (course_id, section) REFERENCES courses(course_id, section)
);

--course_division caters to assignments, quizzes, mid and final
CREATE TABLE course_division (
  cd_id INT PRIMARY KEY, --do we need this?
  cd_name VARCHAR(100) NOT NULL,
  weightage DECIMAL(3,2) NOT NULL,
  cd_type VARCHAR(20) NOT NULL,
  due_date DATE NOT NULL,
  course_id INT NOT NULL,
  section VARCHAR(1) NOT NULL,
  FOREIGN KEY (course_id, section) REFERENCES courses(course_id, section)
);

-- I think we should combine this with course_division 
-- as it just has two extra attributes: submission_date and marks
CREATE TABLE submissions (
  cd_id INT NOT NULL,
  student_id INT NOT NULL,
  submission_date DATE NOT NULL,
  marks INT,
  PRIMARY KEY (cd_id, student_id),
  FOREIGN KEY (cd_id) REFERENCES course_division(cd_id),
  FOREIGN KEY (student_id) REFERENCES students(student_id)
);

CREATE TABLE student_gpa (
  student_id INT NOT NULL,
  semester VARCHAR(10) NOT NULL,
  gpa DECIMAL(3,2) NOT NULL,
  PRIMARY KEY (student_id, semester),
  FOREIGN KEY (student_id) REFERENCES students(student_id)
);

CREATE TABLE semesters (
  s_year INT NOT NULL,
  s_name VARCHAR(10) NOT NULL CHECK s_name IN ('summer', 'spring', 'fall'),
  CONSTRAINT pk_sem PRIMARY KEY (s_year, s_name)
);

-- need to update this, should I revert semesters' primary key to semester_id and leave this table as it is, or translate the sem_id to the composite keys (s_name and s_year)?
CREATE TABLE semester_courses (
  semester_id INT NOT NULL,
  course_id INT NOT NULL,
  PRIMARY KEY (semester_id, course_id),
  FOREIGN KEY (semester_id) REFERENCES semesters(semester_id),
  FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

CREATE TABLE attendance (
  student_id INT NOT NULL,
  course_division_id INT NOT NULL,
  att_date DATE NOT NULL,
  status BOOLEAN NOT NULL,
  PRIMARY KEY (student_id, course_division_id, date),
  FOREIGN KEY (student_id) REFERENCES students(student_id),
  FOREIGN KEY (course_division_id) REFERENCES course_division(cd_id)
);

