CREATE OR REPLACE VIEW st_course AS
SELECT sc.student_id st_id, crs.course_id cid, crs.course_name cname, sc.grade cgrade, crs.credit_hours ch, sc.attendance_percentage, sc.s_id sid
FROM student_courses sc
RIGHT JOIN courses crs ON crs.course_id = sc.course_id
WHERE sc.status = 'Enrolled';

CREATE OR REPLACE VIEW st_cd AS
SELECT cd.course_id c_id, cd.cd_name cdname, cd.total_marks total_marks, cd.weightage cd_weightage, s.student_id s_id, s.marks s_marks, s.submitted s_submitted
FROM course_division cd
INNER JOIN submissions s
ON cd.cd_id = s.cd_id;

SELECT sc.course_id, crs.course_name FROM student_courses sc  
INNER JOIN courses crs ON sc.course_id = crs.course_id 
WHERE sc.student_id = (:param);

CREATE OR REPLACE VIEW student_result AS
SELECT stcrs.st_id stid, sem.s_id sid, stcrs.cid, stcrs.cname, stcrs.cgrade, stcrs.ch
FROM semesters sem
INNER JOIN st_course stcrs ON sem.s_id = stcrs.sid;

-- for retrieving all the semesters the student has been in vcffcdedfghjkl
CREATE OR REPLACE VIEW st_semester AS
SELECT stdcrs.student_id stid, sem.s_id, s_name, s_year FROM student_courses stdcrs zz
INNER JOIN semesters sem ON sem.s_id = stdcrs.s_id
GROUP BY sem.s_id;

SELECT s_id, sgpa, cgpa FROM students_gpa WHERE s_id IN (SELECT sem.s_id FROM student_courses stdcrs INNER JOIN semesters sem ON sem.s_id = stdcrs.s_id GROUP BY sem.s_id) AND student_id = 2023001;

CREATE OR REPLACE VIEW std_att AS
SELECT student_id stid, course_id cid, lecture lec, att_status st FROM attendance_record
WHERE course_id IN (SELECT course_id FROM student_courses WHERE status = 'Enrolled');

CREATE OR REPLACE VIEW courses_teaching AS
SELECT ic.instructor_id, ic.course_id, crs.course_name, ic.c_section FROM instructor_courses ic
INNER JOIN courses crs ON ic.course_id = crs.course_id
WHERE status = 'Teaching';

CREATE OR REPLACE VIEW courses_studying AS
SELECT std.student_id, stdcrs.course_id, c_section, first_name, middle_name, last_name, status
FROM student_courses stdcrs
INNER JOIN students std ON std.student_id = stdcrs.student_id
WHERE status = 'Enrolled';

CREATE OR REPLACE VIEW student_ins AS
SELECT cs.student_id, cs.course_id, cs.c_section, cs.first_name, cs.middle_name, cs.last_name
FROM courses_teaching ct
INNER JOIN courses_studying cs ON (cs.course_id = ct.course_id AND cs.c_section = ct.c_section);

SELECT * FROM instructor_login;
SELECT * FROM courses_teaching;