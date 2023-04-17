-- Create table for students
CREATE TABLE students (
  student_id INT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  middle_name VARCHAR(50) NOT NULL, --changes made
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  major VARCHAR(50) NOT NULL,
  cgpa DECIMAL(3,2) CHECK (cgpa BETWEEN 0 AND 4),
  sex VARCHAR(1) CHECK IN ('m', 'f'), --changes made
  birthdate DATE NOT NULL, --changes made
  CNIC INT NOT NULL --changes made
);
 
-- Create table for courses
CREATE TABLE courses (
  course_id INT,
  section VARCHAR(1) NOT NULL,
  course_name VARCHAR(100) NOT NULL,
  course_description TEXT,
  credits INT NOT NULL,
  faculty VARCHAR(4) CHECK IN ('FCSE', 'FMCE', 'FME', 'FES', 'FCVE', 'FEE'),
  c_type VARCHAR(10) CHECK IN ('core', 'elective'),
  PRIMARY KEY(course_id, section),
  FOREIGN KEY(instructor_id) REFERENCES instructors(instructor_id)
);

-- Create junction table for student-courses relationship
CREATE TABLE student_courses (
  student_id INT NOT NULL,
  course_id INT NOT NULL,
  PRIMARY KEY (student_id, course_id),
  FOREIGN KEY (student_id) REFERENCES students(student_id),
  FOREIGN KEY (course_id) REFERENCES courses(course_id)
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
  enrollment_id INT PRIMARY KEY,
  student_id INT NOT NULL,
  course_id INT NOT NULL,
  enrollment_date DATE NOT NULL,
  grade VARCHAR(2),
  FOREIGN KEY (student_id) REFERENCES students(student_id),
  FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

--course_division caters to assignments, quizzes, mid and final
CREATE TABLE course_division (
  cd_id INT PRIMARY KEY,
  cd_name VARCHAR(100) NOT NULL,
  weightage DECIMAL(3,2) NOT NULL,
  cd_type VARCHAR(20) NOT NULL,
  due_date DATE NOT NULL,
  course_id INT NOT NULL,
  FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- Create table for submissions
CREATE TABLE submissions (
  cd_id INT NOT NULL,
  student_id INT NOT NULL,
  submission_date DATE NOT NULL,
  grade VARCHAR(2),
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
  semester_id INT PRIMARY KEY,
  semester_name VARCHAR(20) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL
);

CREATE TABLE semester_courses (
  semester_id INT NOT NULL,
  course_id INT NOT NULL,
  PRIMARY KEY (semester_id, course_id),
  FOREIGN KEY (semester_id) REFERENCES semesters(semester_id),
  FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

CREATE TABLE attendance (
  student_id INT NOT NULL,
  course_id INT NOT NULL,
  att_date DATE NOT NULL,
  att_status BOOLEAN NOT NULL,
  FOREIGN KEY (student_id) REFERENCES students(student_id),
  FOREIGN KEY (course_id) REFERENCES courses(course_id),
  PRIMARY KEY (student_id, course_id, att_date)
);
