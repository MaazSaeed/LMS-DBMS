	--Calculate grades for all students enrolled in particular course
CREATE OR REPLACE VIEW st_marks AS
	SELECT s.student_id st_no, s.cd_id cd_no, s.marks num, cd.total_marks tm, cd.weightage w
	FROM course_division cd
	INNER JOIN submissions s
	ON cd.cd_id = s.cd_id;

SELECT * FROM st_marks;
--CALL gradeCalculateAll('CS101', 'A');
CREATE OR REPLACE FUNCTION gradeCalculate(st_id int)
RETURNS varchar(2)
LANGUAGE plpgsql
AS $$
DECLARE
	c_grade char(2);
	marks float4:= 0;
	totalmarks float4 := 0;
	weightage float4 := 0;
	weighted_marks float4:= 0;
	stRecord st_marks%ROWTYPE;
BEGIN
	FOR stRecord IN SELECT * FROM st_marks WHERE st_id = st_no
	LOOP
		marks = stRecord.num;
		totalmarks = stRecord.tm;
		weightage = stRecord.w;
		weighted_marks = weighted_marks + ((marks/totalmarks)*weightage);
	END LOOP;
	IF weighted_marks >= 90 THEN
		c_grade = 'A+';
	ELSIF weighted_marks >= 80 THEN
		c_grade = 'A';
	ELSIF weighted_marks >= 70 THEN
		c_grade = 'B';
	ELSIF weighted_marks >= 60 THEN
		c_grade = 'C';
	ELSIF weighted_marks >= 50 THEN
		c_grade = 'D';
--	ELSIF weighted_marks >= 40 THEN
--		c_grade = 'E';
	ELSE
		c_grade = 'F';
	END IF;
	RETURN c_grade;
END; $$;

CREATE OR REPLACE PROCEDURE gradeCalculateAll(c_id varchar(5), c_sect varchar(1))
LANGUAGE plpgsql
AS $$
DECLARE
	crsRecord student_courses%ROWTYPE;
BEGIN
	FOR crsRecord IN SELECT * FROM student_courses WHERE course_id = c_id AND c_section = c_sect
	LOOP
		UPDATE student_courses 
		SET grade = gradeCalculate(crsRecord.student_id)
		WHERE student_id = crsRecord.student_id AND course_id = crsRecord.course_id;
	END LOOP;
END; $$;

SELECT * FROM student_courses;

--Student Login
CREATE OR REPLACE FUNCTION generateStLogin()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
	st_id_int int = NEW.student_id;
	st_id varchar(7) = NEW.student_id::varchar(7); 
	st_email varchar(20);
	st_password varchar(10);
BEGIN
	st_email := concat('u', st_id, '@giki.edu.pk');
	UPDATE students SET student_email = st_email WHERE student_id = st_id_int;
	st_password := substr(md5(random()::text), 0, 9);
	INSERT INTO student_login(student_email, student_password)
		VALUES(st_email, st_password);
	RETURN NEW;
END; $$;

CREATE OR REPLACE TRIGGER trig_generateStLogin
AFTER INSERT ON students
FOR EACH ROW
EXECUTE PROCEDURE generateStLogin();

--Instructor Login
CREATE OR REPLACE FUNCTION generateInsLogin()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
	ins_id int = NEW.instructor_id;
	ins_firstname varchar(30) = NEW.first_name;
	ins_lastname varchar(30) = NEW.last_name;
	ins_email_c varchar(50);
	ins_email varchar(50);
	ins_password varchar(10);
	exist boolean = FALSE;
	ins_emailCursor CURSOR FOR SELECT instructor_email FROM instructors;
BEGIN
	ins_email := concat(ins_firstname,'.', ins_lastname, '@giki.edu.pk');
	OPEN ins_emailCursor;
	LOOP
		FETCH ins_emailCursor INTO ins_email_c;
		IF (ins_email_c = ins_email) THEN
			exist := TRUE;
		END IF;
		EXIT WHEN NOT FOUND;
	END LOOP;
	CLOSE ins_emailCursor;
	
	IF exist = TRUE THEN
		ins_email := concat(ins_firstname,'.', ins_lastname, ins_id::varchar, '@giki.edu.pk');
	END IF;
	ins_email := lower(ins_email);
	UPDATE instructors SET instructor_email = ins_email WHERE instructor_id = ins_id;
	ins_password := substr(md5(random()::text), 0, 9);
	INSERT INTO instructor_login(instructor_email, instructor_password)
		VALUES(ins_email, ins_password);
	RETURN NEW;  
END; $$;

CREATE OR REPLACE TRIGGER trig_generateInsLogin
AFTER INSERT ON instructors
FOR EACH ROW
EXECUTE PROCEDURE generateInsLogin();

--Admin Login
/*CREATE OR REPLACE FUNCTION generateAdminLogin()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
	adm_id int = NEW.instructor_id;
	adm_firstname varchar(30) = NEW.first_name;
	adm_lastname varchar(30) = NEW.last_name;
	adm_email_c varchar(50);
	adm_email varchar(50);
	adm_password varchar(10);
	exist boolean = FALSE;
	admin_emailCursor CURSOR FOR SELECT admin_email FROM admin_info;
BEGIN
	adm_email := concat(adm_firstname,'.', adm_lastname, '@giki.edu.pk');
	OPEN admin_emailCursor;
	LOOP
		FETCH admin_emailCursor INTO adm_email_c;
		IF (adm_email_c = adm_email) THEN
			exist := TRUE;
		END IF;
		EXIT WHEN NOT FOUND;
	END LOOP;
	CLOSE admin_emailCursor;
	
	IF exist = TRUE THEN
		adm_email := concat(adm_firstname,'.', adm_lastname, adm_id::varchar, '@giki.edu.pk');
	END IF;
	adm_email := lower(adm_email);
	UPDATE admin_info SET admin_email = adm_email WHERE admin_id = adm_id;
	adm_password := substr(md5(random()::text), 0, 9);
	INSERT INTO admin_login(admin_email, admin_password)
		VALUES(adm_email, adm_password);
	RETURN NEW;  
END; $$;

CREATE OR REPLACE TRIGGER trig_generateAdminLogin
AFTER INSERT ON admin_info
FOR EACH ROW
EXECUTE PROCEDURE generateAdminLogin();*/

--Calculate SGPA
CREATE OR REPLACE FUNCTION gp (grade varchar(2))
RETURNS float4
LANGUAGE plpgsql
AS $$
DECLARE
	gradepoint float4;
BEGIN
	CASE grade 
		WHEN 'A+' THEN gradepoint = 4.0;
		WHEN 'A' THEN gradepoint = 3.5;
		WHEN 'B' THEN gradepoint = 3.0;
		WHEN 'C' THEN gradepoint = 2.5;
		WHEN 'D' THEN gradepoint = 2.0;
	END CASE;
	RETURN gradepoint;
END; $$;

CREATE OR REPLACE PROCEDURE gpaCalculate(std_id int, sem_id int)
LANGUAGE plpgsql
AS $$
DECLARE
	ch_temp int;
	gp_sum float4:= 0;
	credithours_sum int:= 0;
	s_gpa float4;
	c_gpa float4;
	stdRecord student_courses%ROWTYPE;
BEGIN
	FOR stdRecord IN SELECT * FROM student_courses 
		WHERE student_id = std_id AND s_id = sem_id AND status = 'Enrolled' AND grade <> 'F' 
	LOOP
		ch_temp := CAST((SELECT credit_hours FROM courses WHERE course_id = stdRecord.course_id) AS int);
		gp_sum = gp_sum + (gp(stdRecord.grade) * ch_temp);
		credithours_sum = credithours_sum + ch_temp;
	END LOOP;
	IF credithours_sum = 0 THEN credithours_sum = 1; END IF;
	s_gpa = gp_sum/credithours_sum;
	c_gpa:= (SELECT AVG(sgpa) FROM students_gpa WHERE student_id = std_id)::float4;
	UPDATE students_gpa SET sgpa = s_gpa, cgpa = c_gpa  WHERE student_id = std_id;
	UPDATE students SET completed_ch = completed_ch + credithours_sum, current_cgpa = c_gpa 
		WHERE student_id = std_id;
	IF s_gpa > 2.0 THEN
		UPDATE students SET current_semester = current_semester + 1 
			WHERE student_id = std_id;
	END IF;
END; $$;

CREATE OR REPLACE PROCEDURE gpaCalculateAll(sem_name varchar(10), sem_year int)
LANGUAGE plpgsql
AS $$
DECLARE
	sem_id int = (SELECT s_id FROM semesters WHERE s_name = sem_name AND s_year = sem_year)::int;
	gpaRecord students_gpa%ROWTYPE;
BEGIN
	FOR gpaRecord IN SELECT * FROM students_gpa WHERE s_id = sem_id
	LOOP
		CALL gpaCalculate(gpaRecord.student_id, sem_id);
	END LOOP;
END; $$;

CALL gpaCalculateAll('Fall', '2023');
SELECT current_cgpa FROM students;
SELECT * FROM students_gpa;

--Attendance Calculation
CREATE OR REPLACE PROCEDURE attendanceCalculate(std_id int, crs_id varchar(5))
LANGUAGE plpgsql
AS $$
DECLARE
	att_total float4 := CAST((SELECT COUNT(*) FROM (SELECT student_id FROM attendance_record WHERE student_id = std_id AND course_id = crs_id) AS count_) AS float4);
	att_present float4:= CAST((SELECT COUNT(*) FROM (SELECT student_id FROM attendance_record WHERE student_id = std_id AND course_id = crs_id AND att_status = TRUE) AS count_1) AS float4);
	att_percentage float4 := (att_present/att_total) * 100;
BEGIN
	UPDATE student_courses 
	SET attendance_percentage = att_percentage 
	WHERE student_id = std_id AND course_id = crs_id;
END; $$;

CREATE OR REPLACE PROCEDURE attendanceCalculateAll(crs_id varchar(5))
LANGUAGE plpgsql
AS $$
DECLARE
	stCrsRecord student_courses%ROWTYPE;
BEGIN
	FOR stCrsRecord IN SELECT * FROM student_courses WHERE course_id = crs_id
	LOOP
		CALL attendanceCalculate(stCrsRecord.student_id, stCrsRecord.course_id);
	END LOOP;
END; $$;

--Academic Status
CREATE OR REPLACE FUNCTION academicStatus(cgpa numeric)
RETURNS varchar(50)
LANGUAGE plpgsql
AS $$
DECLARE
	academic_st varchar(20);
BEGIN
	IF cgpa >= 3.5 THEN
		academic_st = 'Excellent';
	ELSIF cgpa >= 3.0 THEN
		academic_st = 'Good';
	ELSIF cgpa >= 2.5 THEN
		academic_st = 'Adequate';
	ELSIF cgpa >= 2.0 THEN
		academic_st = 'Minimum acceptable';
	ELSE
		academic_st = 'Fail';
	END IF;
	RETURN academic_st;
END; $$;

--Entering Information in Students GPA Table via Trigger
CREATE OR REPLACE FUNCTION insertStudents()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
	sem_id int = NEW.s_id;
	stCursor CURSOR FOR SELECT student_id FROM students;
	st_id int := 0;
BEGIN
	OPEN stCursor;
	LOOP
		FETCH stCursor INTO st_id;
		IF st_id IS NOT NULL THEN
			INSERT INTO students_gpa(student_id, s_id) VALUES(st_id, sem_id);
		END IF;
		EXIT WHEN NOT FOUND;
	END LOOP;
	CLOSE stCursor;
	RETURN NEW;
END; $$;

CREATE OR REPLACE TRIGGER insert_students
AFTER INSERT ON semesters
FOR EACH ROW
EXECUTE PROCEDURE insertStudents();