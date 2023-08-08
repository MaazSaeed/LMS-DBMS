from flask import Flask, render_template, request, redirect, url_for, session
from flask_session import Session
from sqlalchemy import text
from ORM import *
from sqlalchemy.exc import SQLAlchemyError

@app.route("/" )
def home():
    return render_template("login.html") 

# ------------LOGIN-----------------#
@app.route("/login", methods = ['POST'])
def login():
    if request.method == 'POST':
        session['email'] = request.form.get('email')
        session['password'] = request.form.get('password')

    user = StudentLogin.query.filter_by(student_email = session["email"]).first()
    
    if user:
        st_password = user.student_password
        if st_password == session['password']:
            return redirect("/index")
        else:
            return redirect("/")
    
    else:
        user = InstructorLogin.query.filter_by(instructor_email = session["email"]).first()
        if user:
            inst_password = user.instructor_password
            if inst_password == session['password']:
                return redirect("/ins_index")
            else:
                return redirect("/")
        else:
            user = AdminLogin.query.filter_by(admin_email = session["email"]).first()
            if user:
                admin_password = user.admin_password
                if admin_password == session['password']:
                    return render_template("admin_index.html")
                else:
                    return redirect("/")
        

        return redirect("/")


# ------------STUDENT-----------------#
@app.route("/index")
def index():
    student_obj = Student.query.filter_by(student_email = session['email']).first()

    query = text("SELECT academicStatus(:param);")
    qparam = {"param": student_obj.current_cgpa}
    academic_status = (db.session.execute(query, qparam)).fetchone()
    acS = academic_status[0]
    # function_ac = acS[0]

    query = text("SELECT * FROM st_course WHERE st_id = (:param);")
    qparam = {"param": student_obj.student_id}
    student_courses = (db.session.execute(query, qparam)).fetchall()
    # stc = student_courses.fetchall()

    return render_template("index.html", student = student_obj, ac = acS, courses = student_courses)

@app.route("/courses")
def courses():
    student_obj = Student.query.filter_by(student_email = session['email']).first()
    query = text("SELECT * FROM st_cd WHERE s_id = (:param);")
    qparam = {"param": student_obj.student_id}
    std_crs_cd = (db.session.execute(query, qparam)).fetchall()

    query = text("SELECT sc.course_id, crs.course_name FROM student_courses sc INNER JOIN courses crs ON sc.course_id = crs.course_id WHERE sc.student_id = (:param);")
    qparam = {"param": student_obj.student_id}
    std_crs = (db.session.execute(query, qparam)).fetchall()

    return render_template("courses.html", course_division = std_crs_cd, crs = std_crs, std = student_obj)

@app.route("/results")
def results():
    student_obj = Student.query.filter_by(student_email = session['email']).first()

    query = text("SELECT * FROM student_result WHERE stid = (:param);")
    qparam = {"param": student_obj.student_id}
    std_result = (db.session.execute(query, qparam)).fetchall()
    
    query = text("SELECT * FROM st_semester WHERE st_id = (:param);")
    qparam = {"param": student_obj.student_id}
    std_sem = (db.session.execute(query, qparam)).fetchall()

    query = text("SELECT s_id, sgpa, cgpa FROM students_gpa WHERE s_id IN (SELECT sem.s_id FROM student_courses stdcrs INNER JOIN semesters sem ON sem.s_id = stdcrs.s_id GROUP BY sem.s_id) AND student_id = (:param);")
    qparam = {"param": student_obj.student_id}
    std_gpa = (db.session.execute(query, qparam)).fetchall()

    return render_template("results.html", std_result = std_result, std_sem = std_sem, std_gpa = std_gpa, stdid = student_obj.student_id)

@app.route("/info")
def info():
    student_obj = Student.query.filter_by(student_email = session['email']).first()

    return render_template("info.html", std = student_obj)

@app.route("/attendance")
def attendance():
    student_obj = Student.query.filter_by(student_email = session['email']).first()

    query = text("SELECT * FROM std_att WHERE stid = (:param);")
    qparam = {"param": student_obj.student_id}
    std_att = (db.session.execute(query, qparam)).fetchall()

    query = text("SELECT course_id FROM student_courses WHERE student_id = (:param) AND status = 'Enrolled';")
    qparam = {"param": student_obj.student_id}
    enrcrs = (db.session.execute(query, qparam)).fetchall()

    print("print: ", std_att)

    return render_template("attendance.html", std_att = std_att, enrcrs = enrcrs, stdid = student_obj.student_id)

# ------------INSTRUCTOR-----------------#

@app.route("/ins_index")
def ins_index():
    instructor_obj = Instructor.query.filter_by(instructor_email = session['email']).first()

    query = text("SELECT * FROM courses_teaching WHERE instructor_id = (:param);")
    qparam = {"param": instructor_obj.instructor_id}
    instructor_courses = (db.session.execute(query, qparam)).fetchall()
    # stc = student_courses.fetchall()

    return render_template("ins_index.html", inst = instructor_obj, courses = instructor_courses)

@app.route("/ins_info")
def ins_info():
    instructor_obj = Instructor.query.filter_by(instructor_email = session['email']).first()

    return render_template("ins_info.html", inst = instructor_obj)

@app.route("/marks")
def marks():
    instructor_obj = Instructor.query.filter_by(instructor_email = session['email']).first()
    ins_courses = InstructorCourse.query.filter_by(instructor_id = instructor_obj.instructor_id).all()

    course = request.form.get('course_id')

    query = text("SELECT * FROM student_ins;")
    qparam = {"param": instructor_obj.instructor_id}
    students = (db.session.execute(query, qparam)).fetchall()

    return render_template("ins_marks.html", ins = instructor_obj, courses = ins_courses, students = students)

@app.route("/ins_attendance")
def ins_attendance():
    instructor_obj = Instructor.query.filter_by(instructor_email = session['email']).first()
    ins_courses = InstructorCourse.query.filter_by(instructor_id = instructor_obj.instructor_id).all()

    query = text("SELECT * FROM student_ins;")
    qparam = {"param": instructor_obj.instructor_id}
    students = (db.session.execute(query, qparam)).fetchall()

    return render_template("ins_attendance.html", ins = instructor_obj, courses = ins_courses, students = students)


@app.route("/upload_marks", methods=['POST'])
def upload_marks():
        
    course_division = request.form.get('course_division')
    total_marks = request.form.get('total_marks')
    weightage = request.form.get('weightage')

    for key, value in request.form.items():
        if key.startswith('marks_'):
            student_id = key.split('_')[1]
            marks = value

@app.route("/upload_attendance")
def upload_attendance():
    course = request.get.form('course')
    attendance = request.form.get("attendance")

    for key, value in request.form.items():
        if key.startswith('att_'):
            student_id = key.split('_')[1]
            marks = value

# ------------ADMIN-----------------#
@app.route("/gpa_calc", methods = ['POST'])
def gpa_calc():
    if request.method == 'POST':
        s_name = request.form.get('s_name')
        s_year = request.form.get('s_year')

        sem = Semester.query.filter_by(s_name = s_name, s_year = s_year).first()
        if sem:
            query = text("CALL gpaCalculateAll(:param1, :param2)")
            qparam = {"param1": s_name, "param2": int(s_year)}
            db.session.execute(query, qparam) 
            msg = "GPA calculated successfully"
            return render_template("admin_index.html", msg1 = msg)
        else:
            msg = "Error: Semester does not exist"
            return render_template("admin_index.html", msg1 = msg)


@app.route("/advance_sem", methods = ['POST'])
def advance_sem():
    if request.method == 'POST':
        s_name = request.form.get('sem_name')
        s_year = request.form.get('sem_year')
        s_year = int(s_year)

        sem = Semester.query.filter_by(s_name = s_name, s_year = s_year).first()

        if sem is not None:
            msg = "Error: Semester already added"
            return render_template("admin_index.html", msg1 = msg)
        
        else:
            try:
                sem_obj = Semester(s_name = s_name, s_year = s_year)
                db.session.add(sem_obj)
                db.session.commit()
                msg = "Semester added successfully"
                return render_template("admin_index.html", msg1 = msg)
        
            except SQLAlchemyError as error:
                db.session.rollback()
                msg = "Error: Could not add the semester"
                return render_template("admin_index.html", msg1 = msg)


@app.route("/add_course", methods = ['POST'])
def add_course():
    if request.method == 'POST':
        course_code = request.form.get('course_code')
        year = request.form.get('year')
        digits = request.form.get('digits')
        course_name = request.form.get('course_name')
        course_description = request.form.get('course_description')
        course_ch = request.form.get('course_ch')
        faculty = request.form.get('faculty')

        course_id = course_code + year + digits

        existing_course = Course.query.filter_by(course_id = course_id).first()
        if existing_course:
            msg = "Error: Course already exists"
            return render_template("admin_index.html", msg3 = msg)

        course_ch = int(course_ch)
        newcourse = Course(course_id = course_id, course_name = course_name, course_description = course_description, credit_hours = course_ch, faculty_from = faculty)

        try:
            db.session.add(newcourse)
            db.session.commit()

            msg = "Course added successfully"
            return render_template("admin_index.html", msg3 = msg)
        
        except SQLAlchemyError as error:
            db.session.rollback()
            msg = "Error: Could not add course"
            return render_template("admin_index.html", msg3 = msg)

@app.route("/delete_course", methods = ['POST'])
def delete_course():
    if request.method == 'POST':
        course_id = request.form.get('course_id')

        course = Course.query.filter_by(course_id = course_id).first()
        if course:
            try:
                db.session.delete(course)
                db.session.commit()
                # query = text("DELETE FROM courses WHERE course_id = (:param);")
                # qparam = {"param": course_id}
                # db.session.execute(query, qparam)
                
                msg = "Course deleted successfully"
                return render_template("admin_index.html", msg4 = msg)
            
            except SQLAlchemyError as error:
                db.session.rollback()
                msg = "Error: Course not deleted"
                return render_template("admin_index.html", msg4 = msg)
        else:
            msg = "Error: Course not found"
            return render_template("admin_index.html", msg4 = msg)

# ------------LOGOUT-----------------#
@app.after_request
def remove_if_invalid(response): 
    if "__invalidate__" in session:
        response.delete_cookie(app.session_cookie_name)
    return response

@app.route("/logout")
def logout():
    session["email"] = None
    session["password"] = None
    session.clear()
    session["__invalidate__"] = True
    return redirect("/") 

if __name__ == '__main__':
    app.run(debug=True)