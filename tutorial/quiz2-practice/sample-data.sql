-- ========================================
-- QUIZ 2 PRACTICE SAMPLE DATA
-- Additional test data for comprehensive practice
-- ========================================

USE quiz2_practice;

-- ========================================
-- ADDITIONAL DEPARTMENTS
-- ========================================
INSERT INTO department (name, budget, building) VALUES
('Business Administration', 400000.00, 'Business Building'),
('Psychology', 150000.00, 'Social Sciences Building'),
('English Literature', 120000.00, 'Humanities Building'),
('History', 100000.00, 'Humanities Building'),
('Art', 80000.00, 'Arts Building');

-- ========================================
-- ADDITIONAL INSTRUCTORS
-- ========================================
INSERT INTO instructor (name, dept_id, salary, hire_date) VALUES
('Dr. Martinez', 6, 70000.00, '2021-01-15'),
('Dr. Thompson', 7, 65000.00, '2021-08-20'),
('Dr. White', 8, 60000.00, '2022-01-10'),
('Dr. Harris', 9, 58000.00, '2022-03-01'),
('Dr. Clark', 10, 55000.00, '2022-09-01');

-- ========================================
-- ADDITIONAL STUDENTS
-- ========================================
INSERT INTO student (name, dept_id, year_level, gpa, enrollment_date, phone_number) VALUES
('Katherine Adams', 1, 'Junior', 3.9, '2021-09-01', '555-0201'),
('Liam O\'Connor', 2, 'Sophomore', 3.4, '2022-09-01', '555-0202'),
('Maya Patel', 3, 'Senior', 3.1, '2020-09-01', '555-0203'),
('Noah Kim', 1, 'Freshman', 2.9, '2023-09-01', '555-0204'),
('Olivia Rodriguez', 4, 'Junior', 3.5, '2021-09-01', '555-0205'),
('Parker Johnson', 2, 'Senior', 3.7, '2020-09-01', '555-0206'),
('Quinn Smith', 5, 'Sophomore', 3.2, '2022-09-01', '555-0207'),
('Riley Davis', 1, 'Junior', 3.6, '2021-09-01', '555-0208'),
('Sophia Wilson', 3, 'Freshman', 3.0, '2023-09-01', '555-0209'),
('Tyler Brown', 2, 'Senior', 3.8, '2020-09-01', '555-0210'),
('Uma Chen', 4, 'Sophomore', 3.3, '2022-09-01', '555-0211'),
('Victor Lee', 1, 'Junior', 3.4, '2021-09-01', '555-0212'),
('Wendy Taylor', 5, 'Senior', 3.1, '2020-09-01', '555-0213'),
('Xavier Anderson', 2, 'Freshman', 2.7, '2023-09-01', '555-0214'),
('Yara Garcia', 3, 'Sophomore', 3.5, '2022-09-01', '555-0215');

-- ========================================
-- ADDITIONAL COURSES
-- ========================================
INSERT INTO course (title, credits, dept_id, description) VALUES
('Advanced Database Design', 3, 1, 'Advanced database modeling and optimization'),
('Machine Learning', 3, 1, 'Introduction to machine learning algorithms'),
('Calculus II', 4, 2, 'Integral calculus and series'),
('Probability Theory', 3, 2, 'Mathematical probability and distributions'),
('Quantum Physics', 4, 3, 'Introduction to quantum mechanics'),
('Organic Chemistry II', 4, 4, 'Advanced organic chemistry'),
('Genetics', 3, 5, 'Principles of heredity and variation'),
('Business Analytics', 3, 6, 'Data analysis for business decisions'),
('Cognitive Psychology', 3, 7, 'Study of mental processes'),
('Creative Writing', 3, 8, 'Advanced creative writing techniques'),
('World History', 3, 9, 'Survey of world civilizations'),
('Digital Art', 3, 10, 'Computer-based artistic expression');

-- ========================================
-- ADDITIONAL PREREQUISITES
-- ========================================
INSERT INTO prerequisite (course_id, prereq_id) VALUES
(11, 1),  -- Advanced Database Design requires Database Systems
(12, 2),  -- Machine Learning requires Data Structures
(13, 3),  -- Calculus II requires Calculus I
(14, 3),  -- Probability Theory requires Calculus I
(15, 5),  -- Quantum Physics requires General Physics I
(16, 6),  -- Organic Chemistry II requires Organic Chemistry
(17, 7),  -- Genetics requires Cell Biology
(18, 1),  -- Business Analytics requires Database Systems
(19, 7),  -- Cognitive Psychology requires Cell Biology
(20, 8),  -- Creative Writing requires Software Engineering
(21, 9),  -- World History requires Discrete Mathematics
(22, 10); -- Digital Art requires Statistics

-- ========================================
-- ADDITIONAL SECTIONS
-- ========================================
INSERT INTO section (course_id, term, year_num, instructor_id, capacity, room) VALUES
(11, 'Spring', 2025, 1, 25, 'ENG-201'),
(12, 'Spring', 2025, 2, 20, 'ENG-202'),
(13, 'Spring', 2025, 3, 30, 'SCI-301'),
(14, 'Spring', 2025, 4, 25, 'SCI-302'),
(15, 'Spring', 2025, 5, 35, 'SCI-401'),
(16, 'Spring', 2025, 6, 20, 'SCI-501'),
(17, 'Spring', 2025, 7, 25, 'LIF-201'),
(18, 'Fall', 2025, 8, 30, 'BUS-101'),
(19, 'Fall', 2025, 9, 25, 'SOC-201'),
(20, 'Fall', 2025, 10, 20, 'HUM-301'),
(21, 'Fall', 2025, 11, 30, 'HUM-401'),
(22, 'Fall', 2025, 12, 15, 'ART-101');

-- ========================================
-- ADDITIONAL ENROLLMENTS
-- ========================================
-- Temporarily drop prerequisite check trigger for sample data loading
DROP TRIGGER IF EXISTS check_prerequisites_before_enrollment;

INSERT INTO enrollment (student_id, section_id, enrolled_on, grade, semester, year_num) VALUES
-- Spring 2025 enrollments
(11, 11, '2025-01-15', 92.0, 'Spring', 2025),
(12, 12, '2025-01-15', 88.0, 'Spring', 2025),
(13, 13, '2025-01-15', 85.0, 'Spring', 2025),
(14, 14, '2025-01-15', 78.0, 'Spring', 2025),
(15, 15, '2025-01-15', 90.0, 'Spring', 2025),
(16, 16, '2025-01-15', 87.0, 'Spring', 2025),
(17, 17, '2025-01-15', 83.0, 'Spring', 2025),
(18, 18, '2025-01-15', 89.0, 'Spring', 2025),
(19, 19, '2025-01-15', 86.0, 'Spring', 2025),
(20, 20, '2025-01-15', 91.0, 'Spring', 2025),
(21, 21, '2025-01-15', 84.0, 'Spring', 2025),
(22, 22, '2025-01-15', 88.0, 'Spring', 2025),
(23, 11, '2025-01-15', 95.0, 'Spring', 2025),
(24, 12, '2025-01-15', 82.0, 'Spring', 2025),
(25, 13, '2025-01-15', 79.0, 'Spring', 2025);

-- ========================================
-- ADDITIONAL QUIZZES
-- ========================================
INSERT INTO quiz (section_id, title, max_score, due_date) VALUES
(11, 'Quiz 1 - Advanced SQL', 100, '2025-02-15 23:59:59'),
(11, 'Quiz 2 - Database Optimization', 100, '2025-03-15 23:59:59'),
(12, 'Quiz 1 - Machine Learning Basics', 100, '2025-02-20 23:59:59'),
(13, 'Quiz 1 - Integration Techniques', 100, '2025-02-25 23:59:59'),
(14, 'Quiz 1 - Probability Distributions', 100, '2025-03-01 23:59:59'),
(15, 'Quiz 1 - Quantum Mechanics', 100, '2025-03-05 23:59:59'),
(16, 'Quiz 1 - Advanced Organic Reactions', 100, '2025-03-10 23:59:59'),
(17, 'Quiz 1 - Genetic Inheritance', 100, '2025-03-15 23:59:59'),
(18, 'Quiz 1 - Business Data Analysis', 100, '2025-02-28 23:59:59'),
(19, 'Quiz 1 - Cognitive Processes', 100, '2025-03-05 23:59:59'),
(20, 'Quiz 1 - Creative Writing Techniques', 100, '2025-03-10 23:59:59'),
(21, 'Quiz 1 - Historical Analysis', 100, '2025-03-15 23:59:59'),
(22, 'Quiz 1 - Digital Art Principles', 100, '2025-03-20 23:59:59');

-- ========================================
-- ADDITIONAL QUIZ SUBMISSIONS
-- ========================================
INSERT INTO quiz_submission (student_id, quiz_id, score, submitted_at) VALUES
-- Advanced Database Design quiz submissions
(11, 6, 92, '2025-02-15 10:00:00'),
(23, 6, 95, '2025-02-15 10:30:00'),
(11, 7, 88, '2025-03-15 09:00:00'),
(23, 7, 90, '2025-03-15 09:15:00'),

-- Machine Learning quiz submissions
(12, 8, 85, '2025-02-20 11:00:00'),
(24, 8, 82, '2025-02-20 11:30:00'),

-- Calculus II quiz submissions
(13, 9, 90, '2025-02-25 14:00:00'),
(25, 9, 85, '2025-02-25 14:15:00'),

-- Probability Theory quiz submissions
(14, 10, 78, '2025-03-01 15:00:00'),

-- Quantum Physics quiz submissions
(15, 11, 88, '2025-03-05 16:00:00'),

-- Organic Chemistry II quiz submissions
(16, 12, 87, '2025-03-10 10:00:00'),

-- Genetics quiz submissions
(17, 13, 83, '2025-03-15 11:00:00'),

-- Business Analytics quiz submissions
(18, 14, 89, '2025-02-28 12:00:00'),

-- Cognitive Psychology quiz submissions
(19, 15, 86, '2025-03-05 13:00:00'),

-- Creative Writing quiz submissions
(20, 16, 91, '2025-03-10 14:00:00'),

-- World History quiz submissions
(21, 17, 84, '2025-03-15 15:00:00'),

-- Digital Art quiz submissions
(22, 18, 88, '2025-03-20 16:00:00');

-- ========================================
-- ADDITIONAL STUDENT HISTORY RECORDS
-- ========================================
INSERT INTO student_history (student_id, academic_year, semester, gpa, credits_attempted, credits_earned, academic_standing) VALUES
-- Historical records for new students
(11, 2021, 'Fall', 3.9, 15, 15, 'Good'),
(11, 2022, 'Spring', 3.8, 15, 15, 'Good'),
(11, 2022, 'Fall', 3.9, 15, 15, 'Good'),
(12, 2022, 'Fall', 3.4, 15, 15, 'Good'),
(12, 2023, 'Spring', 3.5, 15, 15, 'Good'),
(13, 2020, 'Fall', 3.1, 15, 15, 'Good'),
(13, 2021, 'Spring', 3.0, 15, 15, 'Good'),
(13, 2021, 'Fall', 3.2, 15, 15, 'Good'),
(14, 2023, 'Fall', 2.9, 12, 12, 'Good'),
(15, 2021, 'Fall', 3.5, 15, 15, 'Good'),
(15, 2022, 'Spring', 3.4, 15, 15, 'Good'),
(15, 2022, 'Fall', 3.6, 15, 15, 'Good'),
(16, 2020, 'Fall', 3.7, 15, 15, 'Good'),
(16, 2021, 'Spring', 3.6, 15, 15, 'Good'),
(16, 2021, 'Fall', 3.8, 15, 15, 'Good'),
(17, 2022, 'Fall', 3.2, 15, 15, 'Good'),
(17, 2023, 'Spring', 3.3, 15, 15, 'Good'),
(18, 2021, 'Fall', 3.5, 15, 15, 'Good'),
(18, 2022, 'Spring', 3.4, 15, 15, 'Good'),
(18, 2022, 'Fall', 3.6, 15, 15, 'Good'),
(19, 2023, 'Fall', 3.0, 12, 12, 'Good'),
(20, 2020, 'Fall', 3.1, 15, 15, 'Good'),
(20, 2021, 'Spring', 3.2, 15, 15, 'Good'),
(20, 2021, 'Fall', 3.3, 15, 15, 'Good'),
(21, 2022, 'Fall', 3.3, 15, 15, 'Good'),
(21, 2023, 'Spring', 3.4, 15, 15, 'Good'),
(22, 2021, 'Fall', 3.4, 15, 15, 'Good'),
(22, 2022, 'Spring', 3.3, 15, 15, 'Good'),
(22, 2022, 'Fall', 3.5, 15, 15, 'Good'),
(23, 2023, 'Fall', 2.7, 12, 12, 'Good'),
(24, 2022, 'Fall', 3.5, 15, 15, 'Good'),
(24, 2023, 'Spring', 3.4, 15, 15, 'Good'),
(25, 2023, 'Fall', 3.1, 12, 12, 'Good');

-- ========================================
-- UPDATE STUDENT GPAs BASED ON ENROLLMENT GRADES
-- ========================================

-- Update GPAs for students with enrollment grades (convert 0-100 scale to 0-4 scale)
UPDATE student s
SET gpa = (
    SELECT AVG(grade) / 25.0  -- Convert from 0-100 scale to 0-4 scale
    FROM enrollment e
    WHERE e.student_id = s.student_id
    AND e.grade IS NOT NULL
)
WHERE s.student_id IN (
    SELECT DISTINCT student_id 
    FROM enrollment 
    WHERE grade IS NOT NULL
);

-- ========================================
-- CREATE ADDITIONAL VIEWS FOR PRACTICE
-- ========================================

-- View for student performance analysis
CREATE VIEW student_performance AS
SELECT 
    s.student_id,
    s.name,
    d.name as department,
    s.year_level,
    s.gpa,
    COUNT(DISTINCT e.section_id) as courses_taken,
    COUNT(DISTINCT qs.quiz_id) as quizzes_taken,
    AVG(qs.score) as avg_quiz_score
FROM student s
INNER JOIN department d ON s.dept_id = d.dept_id
LEFT JOIN enrollment e ON s.student_id = e.student_id
LEFT JOIN quiz_submission qs ON s.student_id = qs.student_id
GROUP BY s.student_id, s.name, d.name, s.year_level, s.gpa;

-- View for course enrollment statistics
CREATE VIEW course_enrollment_stats AS
SELECT 
    c.course_id,
    c.title,
    d.name as department,
    c.credits,
    COUNT(DISTINCT e.student_id) as enrolled_students,
    COUNT(DISTINCT sec.section_id) as sections_offered,
    AVG(e.grade) as avg_grade,
    COUNT(DISTINCT q.quiz_id) as quizzes_created
FROM course c
INNER JOIN department d ON c.dept_id = d.dept_id
LEFT JOIN section sec ON c.course_id = sec.course_id
LEFT JOIN enrollment e ON sec.section_id = e.section_id
LEFT JOIN quiz q ON sec.section_id = q.section_id
GROUP BY c.course_id, c.title, d.name, c.credits;

-- View for instructor teaching load
CREATE VIEW instructor_teaching_load AS
SELECT 
    i.instructor_id,
    i.name,
    d.name as department,
    i.salary,
    COUNT(DISTINCT sec.section_id) as sections_taught,
    COUNT(DISTINCT e.student_id) as students_taught,
    AVG(qs.score) as avg_student_performance,
    SUM(c.credits) as total_credits_taught
FROM instructor i
INNER JOIN department d ON i.dept_id = d.dept_id
LEFT JOIN section sec ON i.instructor_id = sec.instructor_id
LEFT JOIN course c ON sec.course_id = c.course_id
LEFT JOIN enrollment e ON sec.section_id = e.section_id
LEFT JOIN quiz q ON sec.section_id = q.section_id
LEFT JOIN quiz_submission qs ON q.quiz_id = qs.quiz_id
GROUP BY i.instructor_id, i.name, d.name, i.salary;

-- ========================================
-- CREATE ADDITIONAL STORED PROCEDURES
-- ========================================

DELIMITER //

-- Procedure to get student academic summary
CREATE PROCEDURE GetStudentAcademicSummary(IN student_id_param INT)
BEGIN
    SELECT 
        s.student_id,
        s.name,
        d.name as department,
        s.year_level,
        s.gpa,
        COUNT(DISTINCT e.section_id) as courses_taken,
        COUNT(DISTINCT qs.quiz_id) as quizzes_taken,
        AVG(qs.score) as avg_quiz_score,
        CASE 
            WHEN s.gpa >= 3.7 THEN 'Dean\'s List'
            WHEN s.gpa >= 3.0 THEN 'Good Standing'
            WHEN s.gpa >= 2.0 THEN 'Satisfactory'
            ELSE 'Academic Probation'
        END as academic_standing
    FROM student s
    INNER JOIN department d ON s.dept_id = d.dept_id
    LEFT JOIN enrollment e ON s.student_id = e.student_id
    LEFT JOIN quiz_submission qs ON s.student_id = qs.student_id
    WHERE s.student_id = student_id_param
    GROUP BY s.student_id, s.name, d.name, s.year_level, s.gpa;
END//

-- Procedure to get department performance report
CREATE PROCEDURE GetDepartmentPerformanceReport(IN dept_id_param INT)
BEGIN
    SELECT 
        d.name as department,
        d.budget,
        COUNT(DISTINCT s.student_id) as total_students,
        AVG(s.gpa) as avg_gpa,
        COUNT(DISTINCT c.course_id) as courses_offered,
        COUNT(DISTINCT i.instructor_id) as faculty_count,
        ROUND(COUNT(DISTINCT s.student_id) / NULLIF(COUNT(DISTINCT i.instructor_id), 0), 2) as student_faculty_ratio,
        ROUND(d.budget / NULLIF(COUNT(DISTINCT s.student_id), 0), 2) as budget_per_student
    FROM department d
    LEFT JOIN student s ON d.dept_id = s.dept_id
    LEFT JOIN course c ON d.dept_id = c.dept_id
    LEFT JOIN instructor i ON d.dept_id = i.dept_id
    WHERE d.dept_id = dept_id_param
    GROUP BY d.dept_id, d.name, d.budget;
END//

DELIMITER ;

-- ========================================
-- RECREATE PREREQUISITE CHECK TRIGGER
-- ========================================
DELIMITER //

CREATE TRIGGER check_prerequisites_before_enrollment
BEFORE INSERT ON enrollment
FOR EACH ROW
BEGIN
    DECLARE prereq_count INT DEFAULT 0;
    DECLARE completed_count INT DEFAULT 0;
    DECLARE enrolling_course_id INT;
    
    -- Get the course_id for the section being enrolled in
    SELECT course_id INTO enrolling_course_id
    FROM section
    WHERE section_id = NEW.section_id;
    
    -- Count required prerequisites
    SELECT COUNT(*) INTO prereq_count
    FROM prerequisite p
    WHERE p.course_id = enrolling_course_id;
    
    -- Count completed prerequisites
    SELECT COUNT(DISTINCT p.prereq_id) INTO completed_count
    FROM prerequisite p
    INNER JOIN section sec ON sec.course_id = p.prereq_id
    INNER JOIN enrollment e ON e.section_id = sec.section_id
    WHERE p.course_id = enrolling_course_id
    AND e.student_id = NEW.student_id
    AND e.grade >= 70;
    
    IF prereq_count > 0 AND completed_count < prereq_count THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Prerequisites not met for this course';
    END IF;
END//

DELIMITER ;

-- ========================================
-- FINAL DATA VERIFICATION
-- ========================================

-- Show table counts for verification
SELECT 'DEPARTMENT' as table_name, COUNT(*) as record_count FROM department
UNION ALL
SELECT 'STUDENT', COUNT(*) FROM student
UNION ALL
SELECT 'INSTRUCTOR', COUNT(*) FROM instructor
UNION ALL
SELECT 'COURSE', COUNT(*) FROM course
UNION ALL
SELECT 'SECTION', COUNT(*) FROM section
UNION ALL
SELECT 'ENROLLMENT', COUNT(*) FROM enrollment
UNION ALL
SELECT 'QUIZ', COUNT(*) FROM quiz
UNION ALL
SELECT 'QUIZ_SUBMISSION', COUNT(*) FROM quiz_submission
UNION ALL
SELECT 'STUDENT_HISTORY', COUNT(*) FROM student_history
ORDER BY table_name;
