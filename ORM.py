class students:
    def __init__(self, student_id, first_name, middle_name, last_name, personal_email, phone_num, address, sex, birthdate, cnic, student_email, current_semester, major, completed_ch, enrollment_status):
        self.student_id = student_id
        self.first_name = first_name
        self.middle_name = middle_name
        self.last_name = last_name
        self.personal_email = personal_email
        self.phone_num = phone_num
        self.address = address
        self.sex = sex
        self.birthdate = birthdate
        self.cnic = cnic
        self.student_email = student_email
        self.current_semester = current_semester
        self.major = major
        self.completed_ch = completed_ch
        self.enrollment_status = enrollment_status

student_obj = students(student[0]['student_id'], student[0]['first_name'], student[0]['middle_name'], student[0]['last_name'], student[0]['personal_email'], student[0]['phone_num'], student[0]['address'], student[0]['sex'], student[0]['birthdate'], student[0]['cnic'], student[0]['student_email'], student[0]['current_semester'], student[0]['major'], student[0]['completed_ch'], student[0]['enrollment_status'])


class courses:
    def __init__(self, course_id, course_name, course_description, credit_hours, faculty_from):
        self.course_id = course_id
        self.course_name = course_name
        self.course_description = course_description
        self.credit_hours = credit_hours
        self.faculty_from = faculty_from

course = courses(result[0]['course_id'], result[0]['course_name'], result[0]['course_description'], result[0]['credit_hours'], result[0]['faculty_from'])

class instructors:
    def __init__(self, instructor_id, first_name, middle_name, last_name, personal_email, instructor_email, phone_num, address, ins_role, department, sex, birthdate, cnic):
        self.first_name = first_name
        self.instructor_id = instructor_id
        self.middle_name = middle_name
        self.last_name = last_name
        self.personal_email = personal_email
        self.instructor_email = instructor_email
        self.phone_num = phone_num
        self.address = address
        self.ins_role = ins_role
        self.department = department
        self.sex = sex
        self.birthdate = birthdate
        self.cnic = cnic

instructor = instructors(result[0]['instructor_id'], result[0]['first_name'], result[0]['middle_name'], result[0]['last_name'], result[0]['personal_email'], result[0]['instructor_email'], result[0]['phone_num'], result[0]['address'], result[0]['ins_role'], result[0]['department'], result[0]['sex'], result[0]['birthdate'], result[0]['cnic'])

class semesters:
    def __init__(self, s_id s_name, s_year):
        self.s_id = s_id
        self.s_name = s_name
        self.s_year = s_year

semester = semesters(result[0]['s_id'], result[0]['s_name'], result[0]['s_year'])

class courses_section:
    def __init__(self, course_id, c_section, instructor_id, c_type):
        self.course_id = course_id
        self.c_section = c_section
        self.instructor_id = instructor_id
        self.c_type = c_type

course_section = courses_section(result[0]['course_id'], result[0]['c_section'], result[0]['instructor_id'], result[0]['c_type'])

class semester_courses:
    def __init__(self, s_id, course_id, c_section):
        self.s_id = s_id
        self.course_id = course_id
        self.c_section = c_section

semester_course = semester_courses(result[0]['s_id'], result[0]['course_id'], result[0]['c_section'])

class student_courses:
    def __init__(self, student_id, course_id, c_section, s_id, attendance_percentage, grade):
        self.student_id = student_id
        self.course_id = course_id
        self.c_section = c_section
        self.s_id = s_id
        self.attendance_percentage = attendance_percentage
        self.grade = grade

student_course = student_courses(result[0]['student_id'], result[0]['course_id'], result[0]['c_section'], result[0]['s_id'], result[0]['attendance_percentage'], result[0]['grade'])

class course_division:
    def __init__(self, course_id, c_section, cd_name, total_marks, weightage, due_date):
        self.cd_id = cd_id
        self.course_id = course_id
        self.c_section = c_section
        self.cd_name = cd_name
        self.total_marks = total_marks
        self.weightage = weightage

course_div = course_division(result[0]['course_id'], result[0]['c_section'], result[0]['cd_name'], result[0]['total_marks'], result[0]['weightage'], result[0]['due_date'])

class submissions:
    def __init__(self, cd_id, student_id, submitted, marks):
        self.cd_id = cd_id
        self.student_id = student_id
        self.submitted = submitted
        self.marks = marks

submission = submissions(result[0]['cd_id'], result[0]['student_id'], result[0]['submitted'], result[0]['marks'])

class attendance_record:
    def __init__(self, student_id, course_id, att_date, att_status):
        self.student_id = student_id
        self.course_id = course_id
        self.att_date = att_date
        self.att_status = att_status

attendance = attendance_record(result[0]['student_id'], result[0]['course_id'], result[0]['att_date'], result[0]['att_status'])

class students_gpa:
    def __init__(self, student_id, s_id, sgpa, cgpa):
        self.student_id = student_id
        self.s_id = s_id
        self.sgpa = sgpa
        self.cgpa = cgpa

gpa = students_gpa(result[0]['student_id'], result[0]['s_id'], result[0]['sgpa'], result[0]['cgpa'])

class student_login:
    def __init__(self, student_email, student_password):
        self.student_email = student_email
        self.student_password = student_password

login = student_login(result[0]['student_email'], result[0]['student_password'])

class instructor_login:
    def __init__(self, instructor_email, instructor_password):
        self.instructor_email = instructor_email
        self.instructor_password = instructor_password

login = instructor_login(result[0]['instructor_email'], result[0]['instructor_password'])
