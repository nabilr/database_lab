-- ========================================
-- QUIZ 2 PRACTICE DATABASE SCHEMA
-- Advanced SQL Topics Database
-- ========================================

-- Create database
CREATE DATABASE IF NOT EXISTS quiz2_practice;
USE quiz2_practice;

-- Drop existing tables if they exist (in reverse dependency order)
DROP TABLE IF EXISTS quiz_submission;
DROP TABLE IF EXISTS quiz;
DROP TABLE IF EXISTS enrollment;
DROP TABLE IF EXISTS section;
DROP TABLE IF EXISTS course;
DROP TABLE IF EXISTS prerequisite;
DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS instructor;
DROP TABLE IF EXISTS department;

-- ========================================
-- DEPARTMENT TABLE
-- ========================================
CREATE TABLE department (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    budget DECIMAL(12,2),
    building VARCHAR(50)
);

-- ========================================
-- STUDENT TABLE
-- ========================================
CREATE TABLE student (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    dept_id INT,
    year_level ENUM('Freshman', 'Sophomore', 'Junior', 'Senior') DEFAULT 'Freshman',
    gpa DECIMAL(3,2),
    enrollment_date DATE,
    phone_number VARCHAR(15),
    current_academic_year YEAR,
    FOREIGN KEY (dept_id) REFERENCES department(dept_id) ON DELETE SET NULL
);

-- ========================================
-- INSTRUCTOR TABLE
-- ========================================
CREATE TABLE instructor (
    instructor_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    dept_id INT,
    salary DECIMAL(10,2),
    hire_date DATE,
    FOREIGN KEY (dept_id) REFERENCES department(dept_id) ON DELETE SET NULL
);

-- ========================================
-- COURSE TABLE
-- ========================================
CREATE TABLE course (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    credits TINYINT NOT NULL CHECK (credits BETWEEN 1 AND 6),
    dept_id INT NOT NULL,
    description TEXT,
    FOREIGN KEY (dept_id) REFERENCES department(dept_id) ON DELETE CASCADE
);

-- ========================================
-- PREREQUISITE TABLE
-- ========================================
CREATE TABLE prerequisite (
    course_id INT NOT NULL,
    prereq_id INT NOT NULL,
    PRIMARY KEY (course_id, prereq_id),
    FOREIGN KEY (course_id) REFERENCES course(course_id) ON DELETE CASCADE,
    FOREIGN KEY (prereq_id) REFERENCES course(course_id) ON DELETE CASCADE
);

-- ========================================
-- SECTION TABLE
-- ========================================
CREATE TABLE section (
    section_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT NOT NULL,
    term ENUM('Spring', 'Summer', 'Fall') NOT NULL,
    year_num YEAR NOT NULL,
    instructor_id INT,
    capacity INT DEFAULT 30,
    room VARCHAR(20),
    FOREIGN KEY (course_id) REFERENCES course(course_id) ON DELETE CASCADE,
    FOREIGN KEY (instructor_id) REFERENCES instructor(instructor_id) ON DELETE SET NULL
);

-- ========================================
-- ENROLLMENT TABLE
-- ========================================
CREATE TABLE enrollment (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    section_id INT NOT NULL,
    enrolled_on DATE,
    grade DECIMAL(5,2) CHECK (grade >= 0 AND grade <= 100),
    semester VARCHAR(10),
    year_num YEAR,
    FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE CASCADE,
    FOREIGN KEY (section_id) REFERENCES section(section_id) ON DELETE CASCADE
);

-- ========================================
-- QUIZ TABLE
-- ========================================
CREATE TABLE quiz (
    quiz_id INT PRIMARY KEY AUTO_INCREMENT,
    section_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    max_score DECIMAL(5,2) NOT NULL,
    due_date DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (section_id) REFERENCES section(section_id) ON DELETE CASCADE
);

-- ========================================
-- QUIZ_SUBMISSION TABLE
-- ========================================
CREATE TABLE quiz_submission (
    submission_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    quiz_id INT NOT NULL,
    score DECIMAL(5,2),
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE CASCADE,
    FOREIGN KEY (quiz_id) REFERENCES quiz(quiz_id) ON DELETE CASCADE
);

-- ========================================
-- STUDENT_HISTORY TABLE
-- ========================================
CREATE TABLE student_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    academic_year YEAR NOT NULL,
    semester ENUM('Fall', 'Spring', 'Summer') NOT NULL,
    gpa DECIMAL(4,2),
    credits_attempted INT DEFAULT 0,
    credits_earned INT DEFAULT 0,
    academic_standing ENUM('Good', 'Probation', 'Suspension') DEFAULT 'Good',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE CASCADE
);

-- ========================================
-- INDEXES FOR PERFORMANCE
-- ========================================

-- Indexes for foreign keys
CREATE INDEX idx_student_dept ON student(dept_id);
CREATE INDEX idx_instructor_dept ON instructor(dept_id);
CREATE INDEX idx_course_dept ON course(dept_id);
CREATE INDEX idx_section_course ON section(course_id);
CREATE INDEX idx_section_instructor ON section(instructor_id);
CREATE INDEX idx_enrollment_student ON enrollment(student_id);
CREATE INDEX idx_enrollment_section ON enrollment(section_id);
CREATE INDEX idx_quiz_section ON quiz(section_id);
CREATE INDEX idx_quiz_submission_student ON quiz_submission(student_id);
CREATE INDEX idx_quiz_submission_quiz ON quiz_submission(quiz_id);
CREATE INDEX idx_student_history_student ON student_history(student_id);

-- Indexes for common queries
CREATE INDEX idx_student_gpa ON student(gpa);
CREATE INDEX idx_student_year ON student(year_level);
CREATE INDEX idx_enrollment_grade ON enrollment(grade);
CREATE INDEX idx_quiz_due_date ON quiz(due_date);
CREATE INDEX idx_quiz_submission_score ON quiz_submission(score);

-- ========================================
-- CONSTRAINTS AND CHECKS
-- ========================================

-- Add CHECK constraint for GPA range
ALTER TABLE student ADD CONSTRAINT chk_gpa_range 
CHECK (gpa IS NULL OR (gpa >= 0.0 AND gpa <= 4.0));

-- Add CHECK constraint for salary
ALTER TABLE instructor ADD CONSTRAINT chk_salary_positive 
CHECK (salary IS NULL OR salary > 0);

-- Add CHECK constraint for quiz scores
ALTER TABLE quiz_submission ADD CONSTRAINT chk_quiz_score 
CHECK (score IS NULL OR (score >= 0 AND score <= 100));

-- ========================================
-- VIEWS FOR COMMON QUERIES
-- ========================================

-- Student summary view
CREATE VIEW student_summary AS
SELECT s.student_id, s.name, d.name as department_name, s.gpa, s.year_level
FROM student s
INNER JOIN department d ON s.dept_id = d.dept_id
WHERE s.gpa > 3.0;

-- Department statistics view
CREATE VIEW department_statistics AS
SELECT 
    d.dept_id,
    d.name as department_name,
    d.budget,
    COUNT(DISTINCT s.student_id) as student_count,
    AVG(s.gpa) as avg_gpa,
    COUNT(DISTINCT c.course_id) as course_count,
    COUNT(DISTINCT i.instructor_id) as instructor_count
FROM department d
LEFT JOIN student s ON d.dept_id = s.dept_id
LEFT JOIN course c ON d.dept_id = c.dept_id
LEFT JOIN instructor i ON d.dept_id = i.dept_id
GROUP BY d.dept_id, d.name, d.budget;

-- Instructor workload view
CREATE VIEW instructor_workload AS
SELECT 
    i.instructor_id,
    i.name as instructor_name,
    d.name as department,
    COUNT(DISTINCT sec.section_id) as sections_taught,
    COUNT(DISTINCT e.student_id) as total_students,
    AVG(qs.score) as avg_quiz_scores
FROM instructor i
INNER JOIN department d ON i.dept_id = d.dept_id
LEFT JOIN section sec ON i.instructor_id = sec.instructor_id
LEFT JOIN enrollment e ON sec.section_id = e.section_id
LEFT JOIN quiz q ON sec.section_id = q.section_id
LEFT JOIN quiz_submission qs ON q.quiz_id = qs.quiz_id
GROUP BY i.instructor_id, i.name, d.name;

-- ========================================
-- STORED PROCEDURES FOR COMMON OPERATIONS
-- ========================================

DELIMITER //

-- Procedure to calculate student GPA
CREATE PROCEDURE CalculateStudentGPA(IN student_id_param INT)
BEGIN
    DECLARE calculated_gpa DECIMAL(3,2);
    
    SELECT AVG(grade) INTO calculated_gpa
    FROM enrollment
    WHERE student_id = student_id_param
    AND grade IS NOT NULL;
    
    UPDATE student 
    SET gpa = calculated_gpa 
    WHERE student_id = student_id_param;
    
    SELECT student_id, name, gpa 
    FROM student 
    WHERE student_id = student_id_param;
END//

-- Procedure to get department statistics
CREATE PROCEDURE GetDepartmentStats(IN dept_id_param INT)
BEGIN
    SELECT 
        d.name as department,
        COUNT(DISTINCT s.student_id) as student_count,
        AVG(s.gpa) as avg_gpa,
        COUNT(DISTINCT c.course_id) as course_count,
        COUNT(DISTINCT i.instructor_id) as instructor_count
    FROM department d
    LEFT JOIN student s ON d.dept_id = s.dept_id
    LEFT JOIN course c ON d.dept_id = c.dept_id
    LEFT JOIN instructor i ON d.dept_id = i.dept_id
    WHERE d.dept_id = dept_id_param
    GROUP BY d.dept_id, d.name;
END//

DELIMITER ;

-- ========================================
-- TRIGGERS FOR DATA INTEGRITY
-- ========================================

DELIMITER //

-- Trigger to update student GPA when grades change
CREATE TRIGGER update_student_gpa_after_grade_change
AFTER INSERT ON enrollment
FOR EACH ROW
BEGIN
    UPDATE student s
    SET gpa = (
        SELECT AVG(grade)
        FROM enrollment e
        WHERE e.student_id = NEW.student_id
        AND e.grade IS NOT NULL
    )
    WHERE s.student_id = NEW.student_id;
END//

-- Trigger to prevent enrollment without prerequisites
CREATE TRIGGER check_prerequisites_before_enrollment
BEFORE INSERT ON enrollment
FOR EACH ROW
BEGIN
    DECLARE prereq_count INT DEFAULT 0;
    DECLARE completed_count INT DEFAULT 0;
    
    -- Count required prerequisites
    SELECT COUNT(*) INTO prereq_count
    FROM prerequisite p
    WHERE p.course_id = (
        SELECT course_id FROM section WHERE section_id = NEW.section_id
    );
    
    -- Count completed prerequisites
    SELECT COUNT(*) INTO completed_count
    FROM prerequisite p
    INNER JOIN enrollment e ON p.prereq_id = e.course_id
    WHERE p.course_id = (
        SELECT course_id FROM section WHERE section_id = NEW.section_id
    )
    AND e.student_id = NEW.student_id
    AND e.grade >= 70;
    
    IF prereq_count > 0 AND completed_count < prereq_count THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Prerequisites not met for this course';
    END IF;
END//

DELIMITER ;

-- ========================================
-- SAMPLE DATA INSERTION
-- ========================================

-- Insert departments
INSERT INTO department (name, budget, building) VALUES
('Computer Science', 500000.00, 'Engineering Building'),
('Mathematics', 300000.00, 'Science Building'),
('Physics', 250000.00, 'Science Building'),
('Chemistry', 200000.00, 'Science Building'),
('Biology', 180000.00, 'Life Sciences Building');

-- Insert instructors
INSERT INTO instructor (name, dept_id, salary, hire_date) VALUES
('Dr. Smith', 1, 75000.00, '2020-01-15'),
('Dr. Johnson', 1, 80000.00, '2019-08-20'),
('Dr. Davis', 2, 70000.00, '2021-01-10'),
('Dr. Wilson', 2, 72000.00, '2020-03-01'),
('Dr. Brown', 3, 68000.00, '2021-09-01'),
('Dr. Miller', 4, 65000.00, '2022-01-15'),
('Dr. Garcia', 5, 62000.00, '2022-08-20');

-- Insert students
INSERT INTO student (name, dept_id, year_level, gpa, enrollment_date, phone_number) VALUES
('Alice Johnson', 1, 'Sophomore', 3.5, '2022-09-01', '555-0101'),
('Bob Smith', 1, 'Junior', 3.8, '2021-09-01', '555-0102'),
('Carol Davis', 2, 'Senior', 3.2, '2020-09-01', '555-0103'),
('David Wilson', 1, 'Freshman', 2.8, '2023-09-01', '555-0104'),
('Eve Brown', 2, 'Sophomore', 3.6, '2022-09-01', '555-0105'),
('Frank Miller', 1, 'Senior', 3.9, '2020-09-01', '555-0106'),
('Grace Lee', 3, 'Junior', 3.4, '2021-09-01', '555-0107'),
('Henry Chen', 2, 'Freshman', 3.1, '2023-09-01', '555-0108'),
('Ivy Taylor', 1, 'Sophomore', 3.7, '2022-09-01', '555-0109'),
('Jack Anderson', 3, 'Senior', 3.3, '2020-09-01', '555-0110');

-- Insert courses
INSERT INTO course (title, credits, dept_id, description) VALUES
('Database Systems', 3, 1, 'Introduction to database concepts and SQL'),
('Data Structures', 3, 1, 'Fundamental data structures and algorithms'),
('Calculus I', 4, 2, 'Differential calculus and applications'),
('Linear Algebra', 3, 2, 'Vector spaces and linear transformations'),
('General Physics I', 4, 3, 'Mechanics and thermodynamics'),
('Organic Chemistry', 4, 4, 'Structure and reactions of organic compounds'),
('Cell Biology', 3, 5, 'Structure and function of cells'),
('Software Engineering', 3, 1, 'Software development methodologies'),
('Discrete Mathematics', 3, 2, 'Mathematical foundations for computer science'),
('Statistics', 3, 2, 'Probability and statistical analysis');

-- Insert prerequisites
INSERT INTO prerequisite (course_id, prereq_id) VALUES
(2, 1),  -- Data Structures requires Database Systems
(8, 1),  -- Software Engineering requires Database Systems
(9, 3),  -- Discrete Mathematics requires Calculus I
(10, 3); -- Statistics requires Calculus I

-- Insert sections
INSERT INTO section (course_id, term, year_num, instructor_id, capacity, room) VALUES
(1, 'Fall', 2024, 1, 30, 'ENG-101'),
(2, 'Fall', 2024, 2, 25, 'ENG-102'),
(3, 'Fall', 2024, 3, 35, 'SCI-201'),
(4, 'Fall', 2024, 4, 30, 'SCI-202'),
(5, 'Fall', 2024, 5, 40, 'SCI-301'),
(6, 'Fall', 2024, 6, 25, 'SCI-401'),
(7, 'Fall', 2024, 7, 30, 'LIF-101'),
(8, 'Spring', 2025, 1, 25, 'ENG-103'),
(9, 'Spring', 2025, 3, 30, 'SCI-203'),
(10, 'Spring', 2025, 4, 35, 'SCI-204');

-- Insert enrollments
INSERT INTO enrollment (student_id, section_id, enrolled_on, grade, semester, year_num) VALUES
(1, 1, '2024-08-15', 85.5, 'Fall', 2024),
(2, 1, '2024-08-15', 92.0, 'Fall', 2024),
(1, 2, '2024-08-15', 88.0, 'Fall', 2024),
(3, 3, '2024-08-15', 78.5, 'Fall', 2024),
(5, 3, '2024-08-15', 91.0, 'Fall', 2024),
(6, 1, '2024-08-15', 95.0, 'Fall', 2024),
(7, 5, '2024-08-15', 82.0, 'Fall', 2024),
(8, 3, '2024-08-15', 76.0, 'Fall', 2024),
(9, 1, '2024-08-15', 89.0, 'Fall', 2024),
(10, 5, '2024-08-15', 87.0, 'Fall', 2024);

-- Insert quizzes
INSERT INTO quiz (section_id, title, max_score, due_date) VALUES
(1, 'Quiz 1 - SQL Basics', 100, '2024-09-15 23:59:59'),
(1, 'Quiz 2 - Joins and Subqueries', 100, '2024-10-15 23:59:59'),
(2, 'Quiz 1 - Arrays and Lists', 100, '2024-09-20 23:59:59'),
(3, 'Quiz 1 - Limits and Derivatives', 100, '2024-09-25 23:59:59'),
(4, 'Quiz 1 - Vector Operations', 100, '2024-09-30 23:59:59');

-- Insert quiz submissions
INSERT INTO quiz_submission (student_id, quiz_id, score, submitted_at) VALUES
(1, 1, 85, '2024-09-15 10:00:00'),
(2, 1, 95, '2024-09-15 10:30:00'),
(6, 1, 90, '2024-09-15 11:00:00'),
(9, 1, 88, '2024-09-15 11:30:00'),
(1, 2, 90, '2024-10-15 09:00:00'),
(2, 2, 88, '2024-10-15 09:15:00'),
(6, 2, 92, '2024-10-15 09:30:00'),
(9, 2, 85, '2024-10-15 09:45:00'),
(1, 3, 82, '2024-09-20 11:00:00'),
(3, 4, 78, '2024-09-25 14:00:00'),
(5, 4, 85, '2024-09-25 14:15:00'),
(8, 4, 72, '2024-09-25 14:30:00'),
(3, 5, 80, '2024-09-30 15:00:00'),
(5, 5, 88, '2024-09-30 15:15:00');

-- Insert student history records
INSERT INTO student_history (student_id, academic_year, semester, gpa, credits_attempted, credits_earned, academic_standing) VALUES
(1, 2022, 'Fall', 3.5, 15, 15, 'Good'),
(1, 2023, 'Spring', 3.6, 15, 15, 'Good'),
(2, 2021, 'Fall', 3.8, 15, 15, 'Good'),
(2, 2022, 'Spring', 3.7, 15, 15, 'Good'),
(2, 2022, 'Fall', 3.9, 15, 15, 'Good'),
(3, 2020, 'Fall', 3.2, 15, 15, 'Good'),
(3, 2021, 'Spring', 3.1, 15, 15, 'Good'),
(3, 2021, 'Fall', 3.3, 15, 15, 'Good');

-- ========================================
-- GRANT PERMISSIONS
-- ========================================

-- Grant necessary permissions for practice
GRANT ALL PRIVILEGES ON quiz2_practice.* TO 'root'@'%';
FLUSH PRIVILEGES;
