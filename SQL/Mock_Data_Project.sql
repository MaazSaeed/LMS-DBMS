insert into students (first_name, middle_name, last_name, personal_email, phone_num, address, sex, birthdate, cnic, major, current_semester, completed_ch, enrollment_status) 
values 
('Feodora', 'Deirdre', 'Beamont', 'dbeamont0@infoseek.co.jp', 2154607100, '1st Floor', 'F', '6-1-2022', 5477959177302, 'Information Technology', 1, 0, 'Currently Enrolled'),
('Kristel', 'Celestyna', 'Frede', 'cfrede1@last.fm', 6342782414, 'Suite 95', 'F', '12-21-2022', 6335257547546, 'Mechanical Engineering', 1, 0, 'Currently Enrolled'),
('Marcille', 'Kristen', 'Bonnin', 'kbonnin2@netvibes.com', 3709390015, 'PO Box 40812', 'F', '9-18-2022', 6483566020875, 'Information Technology', 1, 0, 'Currently Enrolled'),
('Karin', 'Nanny', 'Beggin', 'nbeggin3@plala.or.jp', 7635884939, 'Suite 57', 'F', '9-18-2022', 9006940701947, 'Materials Science', 1, 0, 'Currently Enrolled'),
('Michaela', 'Adena', 'Bremond', 'abremond4@epa.gov', 7955002275, '19th Floor', 'F', '2-17-2023', 1034882145239, 'Materials Science', 1, 0, 'Currently Enrolled'),
('Bryant', 'Andrew', 'Mullaney', 'amullaney5@indiatimes.com', 4249323829, 'Room 482', 'M', '8-11-2022', 3987754109473, 'Computer Science', 1, 0, 'Currently Enrolled'),
('George', 'Melania', 'Costell', 'mcostell6@biglobe.ne.jp', 2602778642, 'Room 905', 'F', '6-7-2022', 4698734466645, 'Chemical Engineering', 1, 0, 'Currently Enrolled'),
('Elmo', 'Britt', 'Gregr', 'bgregr7@discovery.com', 6548211019, 'Apt 1147', 'M', '7-21-2022', 4674034471511, 'Electrical Engineering', 1, 0, 'Currently Enrolled'),
('Yard', 'Jeremias', 'Folini', 'jfolini8@last.fm', 6702681676, '2nd Floor', 'M', '8-4-2022', 5865155773850, 'Mechanical Engineering', 1, 0, 'Currently Enrolled'),
('William', 'Tibold', 'Pollendine', 'tpollendine9@who.int', 7405269078, 'PO Box 86733', 'M', '10-24-2022', 4663724201833, 'Information Technology', 1, 0, 'Currently Enrolled');


INSERT INTO courses (course_id, course_name, course_description, credit_hours, faculty_from) 
VALUES ('CS101', 'Introduction to Programming', 'Teaches programming fundamentals in C++', 4, 'FCSE'),
('HM101', 'English Language and Communication', 'Communication fundamentals', 3, 'MGS'),
('MT101', 'Calculus 1', 'Basic Calculus', 3, 'FES'),
 ('CH161', 'Occupational Health and Safety', 'No idea', 1, 'FMCE'),
 ('PH103', 'Fundamentals of Mechanics', 'Understanding mechanics', 3, 'FES'),
 ('PH104', 'Electricity and Magnetics', 'Electromagnetics', 3, 'FES');

INSERT INTO instructors (first_name, middle_name, last_name, personal_email, phone_num, address, ins_role, sex, birthdate, cnic, department) 
values ('Gerhardt', 'Liam', 'Dacre', 'ldacre0@ucsd.edu', 6677575694, 'Apt 1519', 'Assistant Professor', 'M', '21-04-1993', 2479833640604, 'Information Technology'),
('Tod', 'Sanderson', 'Chesshire', 'schesshire1@umn.edu', 7545721640, '19th Floor', 'Assistant Professor', 'M', '04-03-1975', 1830861848766, 'Electrical Engineering'),
('Blaire', 'Shell', 'Budding', 'sbudding2@tinyurl.com', 6701268055, 'Apt 1746', 'Full Professor', 'F', '14-05-1989', 4924783009917, 'Mechanical Engineering'),
('Oliviero', 'Stearne', 'Murch', 'smurch3@themeforest.net', 6733049526, 'Room 559', 'Assistant Professor', 'M', '21-06-1979', 8909125227400, 'Electrical Engineering'),
('Lotta', 'Loree', 'Tolchard', 'ltolchard4@mediafire.com', 5326965392, 'PO Box 215', 'Assistant Professor', 'F', '04-04-1982', 4317050804039, 'Industrial Engineering'),
('Ferdy', 'Sawyer', 'Avrahamy', 'savrahamy5@ocn.ne.jp', 8933714024, 'Apt 218', 'Associate Professor', 'M', '05-03-1983', 2187724224737, 'Computer Science'),
('Urbanus', 'Lucas', 'Benard', 'lbenard6@pinterest.com', 5238232853, '13th Floor', 'Lecturer', 'M', '06-05-1992', 9921837360604, 'Information Technology'),
('Gottfried', 'Kerwinn', 'Darrigoe', 'kdarrigoe7@foxnews.com', 6148969181, '8th Floor', 'Associate Professor', 'M', '23-10-1983', 9060833805860, 'Materials Science'),
('Korry', 'Emeline', 'Sheen', 'esheen8@vimeo.com', 9669375716, 'PO Box 28495', 'Associate Professor', 'F', '14-04-1986', 8802292565312, 'Chemical Engineering'),
('Melania', 'Kat', 'O Donoghue', 'kodonoghue9@ebay.co.uk', 2233005251, 'Suite 30', 'Full Professor', 'F', '26-06-1994', 5448431051580, 'Information Technology');

INSERT INTO semesters (s_name, s_year) 
VALUES('Fall', 2023);

INSERT INTO courses_section (course_id,	c_section, instructor_id)
VALUES ('CS101', 'A', 1),
('CS101', 'B', 2),
('CS101', 'C', 2),
('HM101', 'A', 3),
('HM101', 'B', 3),
('HM101', 'C', 4),
('CH161', 'A', 5),
('CH161', 'B', 5),
('CH161', 'C', 5),
('PH103', 'A', 6),
('PH103', 'B', 7),
('PH104', 'A', 7);

INSERT INTO semester_courses (s_id , course_id,	c_section)
VALUES (5, 'CS101', 'A'),
(5, 'CS101', 'B'),
(5, 'HM101', 'A'),
(5, 'HM101', 'B'),
(5, 'CH161', 'A'),
(5, 'CH161', 'B'),
(5, 'PH103', 'A'),
(5, 'PH103', 'B'),
(5, 'PH104', 'A');

INSERT INTO student_courses (student_id, course_id,	c_section, s_id,status)
VALUES (2023001, 'CS101', 'A', 1, 'Enrolled'),
(2023001, 'HM101', 'A', 1, 'Enrolled'),
(2023001, 'CH161', 'A', 1, 'Enrolled'),
(2023001, 'PH103', 'A', 1, 'Enrolled'),
(2023001, 'PH104', 'A', 1, 'Enrolled'),
(2023002, 'CS101', 'A', 1, 'Enrolled'),
(2023002, 'HM101', 'A', 1, 'Enrolled'),
(2023002, 'CH161', 'A', 1, 'Enrolled'),
(2023002, 'PH103', 'A', 1, 'Enrolled'),
(2023002, 'PH104', 'A', 1, 'Enrolled'),
(2023003, 'CS101', 'A', 1, 'Enrolled'),
(2023003, 'HM101', 'A', 1, 'Enrolled'),
(2023003, 'CH161', 'A', 1, 'Enrolled'),
(2023003, 'PH103', 'A', 1, 'Enrolled'),
(2023003, 'PH104', 'A', 1, 'Enrolled'),
(2023004, 'CS101', 'A', 1, 'Enrolled'),
(2023004, 'HM101', 'A', 1, 'Enrolled'),
(2023004, 'CH161', 'A', 1, 'Enrolled'),
(2023004, 'PH103', 'A', 1, 'Enrolled'),
(2023004, 'PH104', 'A', 1, 'Enrolled'),
(2023005, 'CS101', 'A', 1, 'Enrolled'),
(2023005, 'HM101', 'A', 1, 'Enrolled'),
(2023005, 'CH161', 'A', 1, 'Enrolled'),
(2023005, 'PH103', 'A', 1, 'Enrolled'),
(2023005, 'PH104', 'A', 1, 'Enrolled'),
(2023006, 'CS101', 'B', 1, 'Enrolled'),
(2023006, 'HM101', 'B', 1, 'Enrolled'),
(2023006, 'CH161', 'B', 1, 'Enrolled'),
(2023006, 'PH103', 'B', 1, 'Enrolled'),
(2023006, 'PH104', 'A', 1, 'Enrolled'),
(2023007, 'CS101', 'B', 1, 'Enrolled'),
(2023007, 'HM101', 'B', 1, 'Enrolled'),
(2023007, 'CH161', 'B', 1, 'Enrolled'),
(2023007, 'PH103', 'B', 1, 'Enrolled'),
(2023007, 'PH104', 'A', 1, 'Enrolled'),
(2023008, 'CS101', 'B', 1, 'Enrolled'),
(2023008, 'HM101', 'B', 1, 'Enrolled'),
(2023008, 'CH161', 'B', 1, 'Enrolled'),
(2023008, 'PH103', 'B', 1, 'Enrolled'),
(2023008, 'PH104', 'A', 1, 'Enrolled'),
(2023009, 'CS101', 'B', 1, 'Enrolled'),
(2023009, 'HM101', 'B', 1, 'Enrolled'),
(2023009, 'CH161', 'B', 1, 'Enrolled'),
(2023009, 'PH103', 'B', 1, 'Enrolled'),
(2023009, 'PH104', 'A', 1, 'Enrolled'),
(2023010, 'CS101', 'B', 1, 'Enrolled'),
(2023010, 'HM101', 'B', 1, 'Enrolled'),
(2023010, 'CH161', 'B', 1, 'Enrolled'),
(2023010, 'PH103', 'B', 1, 'Enrolled'),
(2023010, 'PH104', 'A', 1, 'Enrolled');

INSERT INTO course_division (course_id, c_section, cd_name, total_marks, weightage)
VALUES (1, 'CS101', 'A', 'Assignment', 'If Else', 10, 2),
(1, 'CS101', 'A', 'Quiz', 'Quiz 1: Loops', 20, 3),
(1, 'CS101', 'A', 'Mid', 'Mid Semester Exam', 30, 30);

INSERT INTO submissions (cd_id,	student_id, submitted, marks)
VALUES (1, 2023001, TRUE, 9),
(2, 2023001, TRUE, 15),
(3, 2023001, TRUE, 25),
(1, 2023002, TRUE, 8),
(2, 2023002, TRUE, 17),
(3, 2023002, TRUE, 20),
(1, 2023003, FALSE, 0),
(2, 2023003, TRUE, 10),
(3, 2023003, TRUE, 15),
(1, 2023004, TRUE, 3),
(2, 2023004, TRUE, 13),
(3, 2023004, TRUE, 22),
(1, 2023005, FALSE, 0),
(2, 2023005, TRUE, 9),
(3, 2023005, TRUE, 19);

INSERT INTO attendance_record (student_id, course_id, lecture, att_status)
VALUES (2023001, 'CS101', 1, TRUE),
(2023001, 'CS101', 2, TRUE),
(2023001, 'CS101', 3, TRUE),
(2023001, 'CS101', 4, TRUE),
(2023001, 'CS101', 5, FALSE),
(2023002, 'CS101', 1, TRUE),
(2023002, 'CS101', 2, FALSE),
(2023002, 'CS101', 3, TRUE),
(2023002, 'CS101', 4, TRUE),
(2023002, 'CS101', 5, TRUE),
(2023003, 'CS101', 1, TRUE),
(2023003, 'CS101', 2, TRUE),
(2023003, 'CS101', 3, TRUE),
(2023003, 'CS101', 4, FALSE),
(2023003, 'CS101', 5, TRUE),
(2023004, 'CS101', 1, FALSE),
(2023004, 'CS101', 2, TRUE),
(2023004, 'CS101', 3, TRUE),
(2023004, 'CS101', 4, FALSE),
(2023004, 'CS101', 5, TRUE),
(2023005, 'CS101', 1, TRUE),
(2023005, 'CS101', 2, FALSE),
(2023005, 'CS101', 3, TRUE),
(2023005, 'CS101', 4, FALSE),
(2023005, 'CS101', 5, TRUE);

INSERT INTO instructor_courses(instructor_id, course_id, c_section, status)
VALUES
(21, 'CS101', 'A', 'Teaching'),
(21, 'HM101', 'A', 'Teaching'),
(21, 'CH161', 'A', 'Teaching'),
(21, 'PH103', 'A', 'Taught');

INSERT INTO admin_login(admin_email, admin_password)
VALUES('admin@giki.edu.pk', 'abcxyz100');