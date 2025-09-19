-- ========================================
-- DATABASE FOUNDATIONS TUTORIAL (SIMPLIFIED)
-- ========================================
-- This section covers database creation, basic data types, and simple constraints
-- Topics: CREATE DATABASE, Common Data Types, PRIMARY KEY, FOREIGN KEY

-- Section 1: Database Creation
-- ========================================

-- 1.1 Create a new database
CREATE DATABASE IF NOT EXISTS simple_school;

-- 1.2 Use the database
USE simple_school;

-- Section 2: Basic Data Types
-- ========================================

-- 2.1 Simple table with most common data types
CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,      -- Auto-incrementing number
    name VARCHAR(100) NOT NULL,             -- Text up to 100 characters
    age INT,                               -- Whole number
    grade DECIMAL(3,1),                    -- Decimal: 95.5, 88.7, etc.
    is_active BOOLEAN DEFAULT TRUE,        -- TRUE or FALSE
    birth_date DATE,                       -- Date: YYYY-MM-DD
    enrollment_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- Auto timestamp
);

-- 2.2 Insert simple sample data
INSERT INTO students (name, age, grade, birth_date) VALUES
    ('Alice Johnson', 20, 95.5, '2004-03-15'),
    ('Bob Smith', 19, 87.2, '2005-07-22'),
    ('Carol Davis', 21, 92.8, '2003-11-08');

-- 2.3 View the data
SELECT * FROM students;

-- 2.4 Show table structure
DESCRIBE students;

-- Section 3: Simple Constraints
-- ========================================

-- 3.1 Table with basic constraints
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,      -- Required field
    credits INT NOT NULL,
    instructor VARCHAR(50)
);

-- 3.2 Table with UNIQUE constraint
CREATE TABLE teachers (
    teacher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE               -- Must be unique
);

-- 3.3 Insert sample data
INSERT INTO courses (course_name, credits, instructor) VALUES
    ('Math 101', 3, 'Dr. Smith'),
    ('History 101', 3, 'Prof. Johnson'),
    ('Biology 101', 4, 'Dr. Brown');

INSERT INTO teachers (name, email) VALUES
    ('Dr. Smith', 'smith@school.edu'),
    ('Prof. Johnson', 'johnson@school.edu'),
    ('Dr. Brown', 'brown@school.edu');

-- Section 4: Foreign Key Relationships (SIMPLE)
-- ========================================

-- 4.1 Simple enrollment table linking students to courses
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    
    -- Foreign key constraints
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- 4.2 Insert enrollment data
INSERT INTO enrollments (student_id, course_id) VALUES
    (1, 1),    -- Alice enrolls in Math 101
    (1, 2),    -- Alice enrolls in History 101
    (2, 1),    -- Bob enrolls in Math 101
    (3, 3);    -- Carol enrolls in Biology 101

-- Section 5: Simple Queries to Test Everything
-- ========================================

-- 5.1 View all students
SELECT * FROM students;

-- 5.2 View all courses
SELECT * FROM courses;

-- 5.3 View enrollments with student and course names
SELECT 
    s.name as student_name,
    c.course_name,
    c.credits
FROM enrollments e
JOIN students s ON e.student_id = s.id
JOIN courses c ON e.course_id = c.course_id;

-- 5.4 Show table structures
SHOW TABLES;

-- Section 6: Common Mistakes (What NOT to do)
-- ========================================

-- These would fail - examples of constraint violations:

-- 6.1 Try to insert student without required name
-- INSERT INTO students (age) VALUES (20);  -- ERROR: name is required

-- 6.2 Try to insert duplicate email for teacher
-- INSERT INTO teachers (name, email) VALUES ('New Teacher', 'smith@school.edu');  -- ERROR: email must be unique

-- 6.3 Try to enroll student in non-existent course
-- INSERT INTO enrollments (student_id, course_id) VALUES (1, 999);  -- ERROR: course doesn't exist

-- SUMMARY:
-- ========================================
-- 1. CREATE DATABASE - makes a new database
-- 2. Common data types: INT, VARCHAR, DATE, BOOLEAN
-- 3. PRIMARY KEY - unique identifier for each row
-- 4. NOT NULL - field must have a value
-- 5. UNIQUE - no duplicates allowed
-- 6. FOREIGN KEY - links tables together
-- 7. Always test your constraints work!
