from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = "postgresql://postgres:pgadmin@localhost:5432/Project"
app.config['SECRET_KEY'] = '192b9bdd22ab9ed4d12e236c78afcb9a393ec15f71bbf5dc987d54727823bcbf'
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"

db = SQLAlchemy(app)

class Student(db.Model):
    __tablename__ = 'students'
    student_id = db.Column(db.Integer, primary_key=True)
    first_name = db.Column(db.String(30), nullable=False)
    middle_name = db.Column(db.String(30))
    last_name = db.Column(db.String(30), nullable=False)
    personal_email = db.Column(db.String(100), unique=True, nullable=False)
    phone_num = db.Column(db.BigInteger, unique=True, nullable=False)
    address = db.Column(db.Text, nullable=False)
    sex = db.Column(db.String(1), nullable=False)
    birthdate = db.Column(db.Date, nullable=False)
    cnic = db.Column(db.String(13), unique=True, nullable=False)
    student_email = db.Column(db.String(20), unique=True)
    current_semester = db.Column(db.Integer, nullable=False, default=1)
    major = db.Column(db.String(50), nullable=False)
    completed_ch = db.Column(db.Integer, default=0)
    enrollment_status = db.Column(db.String(20), nullable=False, default='Currently Enrolled')
    current_cgpa = db.Column(db.Numeric(3, 2))

class Semester(db.Model):
    __tablename__ = 'semesters'
    s_id = db.Column(db.Integer, primary_key=True)
    s_name = db.Column(db.String(10), nullable=False, check_constraint="s_name IN ('Summer', 'Spring', 'Fall')")
    s_year = db.Column(db.Integer, nullable=False)

class CourseSection(db.Model):
    __tablename__ = 'courses_section'
    course_id = db.Column(db.String(5), db.ForeignKey('courses.course_id'), primary_key=True)
    c_section = db.Column(db.String(1), nullable=False)
    instructor_id = db.Column(db.Integer, db.ForeignKey('instructors.instructor_id'))

class SemesterCourse(db.Model):
    __tablename__ = 'semester_courses'
    s_id = db.Column(db.Integer, db.ForeignKey('semesters.s_id'), primary_key=True)
    course_id = db.Column(db.String(5), db.ForeignKey('courses.course_id'), primary_key=True)
    c_section = db.Column(db.String(1), db.ForeignKey('courses_section.c_section'), primary_key=True)

class Course(db.Model):
    __tablename__ = 'courses'
    course_id = db.Column(db.String(5), primary_key=True)
    course_name = db.Column(db.String(100), nullable=False)
    course_description = db.Column(db.Text)
    credit_hours = db.Column(db.Integer, nullable=False, check_constraint='credit_hours BETWEEN 1 and 4')
    faculty_from = db.Column(db.String(4), nullable=False, check_constraint="faculty_from IN ('FCSE', 'FMCE', 'FME', 'FES', 'FCVE', 'FEE', 'MGS')")

class Instructor(db.Model):
    __tablename__ = 'instructors'
    instructor_id = db.Column(db.Integer, primary_key=True)
    first_name = db.Column(db.String(30), nullable=False)
    middle_name = db.Column(db.String(30))
    last_name = db.Column(db.String(30), nullable=False)
    personal_email = db.Column(db.String(100), unique=True, nullable=False)
    instructor_email = db.Column(db.String(50), unique=True)
    phone_num = db.Column(db.BigInteger, unique=True, nullable=False)
    address = db.Column(db.Text, nullable=False)
    ins_role = db.Column(db.String(50), nullable=False)
    department = db.Column(db.String(50), nullable=False)
    sex = db.Column(db.String(1), nullable=False, check_constraint="sex IN ('M', 'F')")
    birthdate = db.Column(db.Date, nullable=False, check_constraint="date_part('year', birthdate) > date_part('year', current_date)-100")
    cnic = db.Column(db.String(13), unique=True, nullable=False)

class StudentCourse(db.Model):
    __tablename__ = 'student_courses'
    student_id = db.Column(db.Integer, db.ForeignKey('students.student_id'), primary_key=True)
    course_id = db.Column(db.String(5))
    c_section = db.Column(db.String(1))
    s_id = db.Column(db.Integer, db.ForeignKey('semesters.s_id'))
    attendance_percentage = db.Column(db.Float)
    grade = db.Column(db.String(2))
    status = db.Column(db.String(20), nullable=False, check_constraint="status IN ('Enrolled', 'Unenrolled', 'Pass', 'Fail')")
    __table_args__ = (
        db.ForeignKeyConstraint([course_id, c_section], ['courses_section.course_id', 'courses_section.c_section']),
    )

class InstructorCourse(db.Model):
    __tablename__ = 'instructor_courses'
    instructor_id = db.Column(db.Integer, db.ForeignKey('instructors.instructor_id'), primary_key=True)
    course_id = db.Column(db.String(5), primary_key=True)
    c_section = db.Column(db.String(1), primary_key=True)
    status = db.Column(db.String(20), nullable=False, default='Teaching', server_default='Teaching')
    
    __table_args__ = (
        db.ForeignKeyConstraint(['course_id', 'c_section'], ['courses_section.course_id', 'courses_section.c_section']),
    )

class CourseDivision(db.Model):
    __tablename__ = 'course_division'
    cd_id = db.Column(db.Integer, primary_key=True)
    course_id = db.Column(db.String(5))
    c_section = db.Column(db.String(1))
    cd_name = db.Column(db.String(20), nullable=False)
    total_marks = db.Column(db.Float, nullable=False)
    weightage = db.Column(db.Float, nullable=False)
    __table_args__ = (
        db.ForeignKeyConstraint([course_id, c_section], ['courses_section.course_id', 'courses_section.c_section']),
    )

class Submission(db.Model):
    __tablename__ = 'submissions'
    cd_id = db.Column(db.Integer, db.ForeignKey('course_division.cd_id'), primary_key=True)
    student_id = db.Column(db.Integer, db.ForeignKey('students.student_id'), primary_key=True)
    submitted = db.Column(db.Boolean, nullable=False)
    marks = db.Column(db.Float)
    __table_args__ = (
        db.ForeignKeyConstraint([cd_id], ['course_division.cd_id']),
    )

class AttendanceRecord(db.Model):
    __tablename__ = 'attendance_record'
    student_id = db.Column(db.Integer, db.ForeignKey('students.student_id'), primary_key=True)
    course_id = db.Column(db.String(5))
    c_section = db.Column(db.String(1))
    lecture = db.Column(db.Integer)
    att_status = db.Column(db.Boolean, nullable=False)
    __table_args__ = (
        db.ForeignKeyConstraint([course_id, c_section], ['courses_section.course_id', 'courses_section.c_section']),
    )

class StudentsGPA(db.Model):
    __tablename__ = 'students_gpa'
    student_id = db.Column(db.Integer, db.ForeignKey('students.student_id'), primary_key=True)
    s_id = db.Column(db.Integer, db.ForeignKey('semesters.s_id'), primary_key=True)
    sgpa = db.Column(db.Numeric(3, 2))
    cgpa = db.Column(db.Numeric(3, 2))

class StudentLogin(db.Model):
    __tablename__ = 'student_login'
    student_email = db.Column(db.String(20), db.ForeignKey('students.student_email'), primary_key=True)
    student_password = db.Column(db.String(10), nullable=False)

class InstructorLogin(db.Model):
    __tablename__ = 'instructor_login'
    instructor_email = db.Column(db.String(50), db.ForeignKey('instructors.instructor_email'), primary_key=True)
    instructor_password = db.Column(db.String(10), nullable=False)

class AdminLogin(db.Model):
    __tablename__ = 'admin_login'
    admin_email = db.Column(db.String(20), primary_key=True)
    admin_password = db.Column(db.String(10), nullable=False)
