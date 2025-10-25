-- ========================================
-- QUIZ 2 PRACTICE SOLUTIONS
-- Advanced SQL Topics for Database Lab
-- ========================================
-- Complete solutions with explanations for all practice questions

-- ========================================
-- SECTION 1: MORE COMPLEX SQL RETRIEVAL QUERIES
-- ========================================

-- Solution 1.1: Complex WHERE with Multiple Conditions
-- Find all students who are in CS or Math departments, have GPA between 3.0 and 3.8,
-- enrolled after 2020, and are not Freshmen

SELECT s.student_id, s.name, s.gpa, s.year_level, d.name as department
FROM student s
INNER JOIN department d ON s.dept_id = d.dept_id
WHERE d.name IN ('Computer Science', 'Mathematics')
  AND s.gpa BETWEEN 3.0 AND 3.8
  AND s.enrollment_date > '2020-12-31'
  AND s.year_level != 'Freshman';

-- Explanation: This query demonstrates complex WHERE conditions with:
-- - IN operator for multiple department names
-- - BETWEEN for range conditions
-- - Date comparisons
-- - String comparisons with !=

-- Solution 1.2: Advanced JOIN with Multiple Tables
-- Find students enrolled in courses taught by high-earning instructors

SELECT s.name as student_name, 
       c.title as course_title, 
       i.name as instructor_name, 
       i.salary
FROM student s
INNER JOIN enrollment e ON s.student_id = e.student_id
INNER JOIN section sec ON e.section_id = sec.section_id
INNER JOIN course c ON sec.course_id = c.course_id
INNER JOIN instructor i ON sec.instructor_id = i.instructor_id
WHERE i.salary > 60000
  AND c.credits > 2;

-- Explanation: This query demonstrates:
-- - Multiple table joins (5 tables)
-- - Complex relationships through foreign keys
-- - Filtering on joined table columns

-- Solution 1.3: Complex ORDER BY with CASE
-- Custom ordering by department, then GPA, then name

SELECT s.name, s.gpa, d.name as department
FROM student s
INNER JOIN department d ON s.dept_id = d.dept_id
ORDER BY 
  CASE d.name 
    WHEN 'Computer Science' THEN 1
    WHEN 'Mathematics' THEN 2
    ELSE 3
  END,
  s.gpa DESC,
  s.name ASC;

-- Explanation: CASE in ORDER BY allows custom sorting logic
-- that's not possible with simple column ordering

-- ========================================
-- SECTION 2: SPECIFYING CONSTRAINTS AS ASSERTIONS AND ACTIONS AS TRIGGERS
-- ========================================

-- Solution 2.1: Creating Assertions
-- Ensure no instructor teaches more than 4 sections in a semester

-- Note: MySQL doesn't support ASSERTION, but here's the concept:
-- CREATE ASSERTION max_sections_per_instructor
-- CHECK (
--   NOT EXISTS (
--     SELECT instructor_id, term, year_num
--     FROM section
--     GROUP BY instructor_id, term, year_num
--     HAVING COUNT(*) > 4
--   )
-- );

-- Alternative using CHECK constraint on a view:
CREATE VIEW instructor_section_count AS
SELECT instructor_id, term, year_num, COUNT(*) as section_count
FROM section
GROUP BY instructor_id, term, year_num;

-- Add CHECK constraint (MySQL 8.0.16+):
-- ALTER TABLE section ADD CONSTRAINT chk_max_sections
-- CHECK (
--   (SELECT COUNT(*) FROM section s2 
--    WHERE s2.instructor_id = section.instructor_id 
--    AND s2.term = section.term 
--    AND s2.year_num = section.year_num) <= 4
-- );

-- Solution 2.2: Trigger for GPA Updates
-- Automatically update student GPA when grades change

DELIMITER //
CREATE TRIGGER update_student_gpa
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
DELIMITER ;

-- Explanation: This trigger:
-- - Fires AFTER INSERT on enrollment table
-- - Recalculates GPA for the affected student
-- - Handles NULL grades appropriately

-- Solution 2.3: Trigger for Prerequisites
-- Prevent enrollment without prerequisites

DELIMITER //
CREATE TRIGGER check_prerequisites
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
    AND e.grade >= 70; -- Assuming 70 is passing grade
    
    IF prereq_count > 0 AND completed_count < prereq_count THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Prerequisites not met for this course';
    END IF;
END//
DELIMITER ;

-- Explanation: This trigger:
-- - Fires BEFORE INSERT to prevent invalid data
-- - Checks prerequisite completion
-- - Uses SIGNAL to raise custom error

-- ========================================
-- SECTION 3: VIEWS (VIRTUAL TABLES) IN SQL
-- ========================================

-- Solution 3.1: Simple View Creation
-- Student summary view for high-performing students

CREATE VIEW student_summary AS
SELECT s.student_id, s.name, d.name as department_name, s.gpa
FROM student s
INNER JOIN department d ON s.dept_id = d.dept_id
WHERE s.gpa > 3.0;

-- Usage:
-- SELECT * FROM student_summary ORDER BY gpa DESC;

-- Solution 3.2: Complex View with Aggregations
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

-- Usage:
-- SELECT * FROM department_statistics WHERE student_count > 0;

-- Solution 3.3: Updatable View
-- Student contacts view (updatable)

CREATE VIEW student_contacts AS
SELECT s.student_id, s.name, d.name as department_name, s.dept_id
FROM student s
INNER JOIN department d ON s.dept_id = d.dept_id;

-- This view is updatable because:
-- - It's based on a single table (student) with JOIN to lookup table
-- - No aggregate functions
-- - No DISTINCT
-- - No GROUP BY or HAVING

-- Usage for updates:
-- UPDATE student_contacts 
-- SET name = 'New Name' 
-- WHERE student_id = 101;

-- ========================================
-- SECTION 4: SCHEMA CHANGE STATEMENTS IN SQL
-- ========================================

-- Solution 4.1: Adding Columns
-- Add phone_number column to STUDENT table

ALTER TABLE student 
ADD COLUMN phone_number VARCHAR(15);

-- Solution 4.2: Modifying Column Properties
-- Modify GPA column to allow NULL and change precision

ALTER TABLE student 
MODIFY COLUMN gpa DECIMAL(4,2) NULL;

-- Solution 4.3: Adding Constraints
-- Add CHECK constraint for GPA range

ALTER TABLE student 
ADD CONSTRAINT chk_gpa_range 
CHECK (gpa IS NULL OR (gpa >= 0.0 AND gpa <= 4.0));

-- Solution 4.4: Creating New Table and Modifying References
-- Create STUDENT_HISTORY table

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
    FOREIGN KEY (student_id) REFERENCES student(student_id)
);

-- Add reference to student table
ALTER TABLE student 
ADD COLUMN current_academic_year YEAR;

-- ========================================
-- SECTION 5: COMPARISONS INVOLVING NULL AND THREE-VALUED LOGIC
-- ========================================

-- Solution 5.1: NULL Comparisons
-- Find students with NULL and non-NULL GPA values

-- Students with NULL GPA
SELECT student_id, name, 'NULL GPA' as gpa_status
FROM student 
WHERE gpa IS NULL;

-- Students with non-NULL GPA
SELECT student_id, name, gpa, 'Has GPA' as gpa_status
FROM student 
WHERE gpa IS NOT NULL;

-- Solution 5.2: Three-Valued Logic with AND/OR
-- Demonstrate how NULL affects logical operations

SELECT student_id, name, gpa, dept_id,
       (gpa > 3.5) as gpa_condition,
       (dept_id = 1) as dept_condition,
       (gpa > 3.5 OR dept_id = 1) as combined_condition
FROM student;

-- Explanation of three-valued logic:
-- TRUE OR NULL = TRUE
-- FALSE OR NULL = NULL
-- NULL OR NULL = NULL
-- TRUE AND NULL = NULL
-- FALSE AND NULL = FALSE
-- NULL AND NULL = NULL

-- Solution 5.3: COALESCE and NULLIF Functions
-- Handle NULL values and division by zero

SELECT student_id, name,
       COALESCE(gpa, 0.0) as gpa_with_default,
       CASE 
           WHEN gpa IS NULL THEN 'No GPA recorded'
           WHEN gpa = 0 THEN 'Zero GPA'
           ELSE CONCAT('GPA: ', gpa)
       END as gpa_description,
       -- Safe division (avoid division by zero)
       CASE 
           WHEN gpa IS NULL OR gpa = 0 THEN NULL
           ELSE 4.0 / gpa
       END as gpa_ratio
FROM student;

-- ========================================
-- SECTION 6: NESTED QUERIES, TUPLES, AND SET/MULTISET COMPARISONS
-- ========================================

-- Solution 6.1: Scalar Subqueries
-- Students with GPA higher than average

SELECT student_id, name, gpa
FROM student
WHERE gpa > (SELECT AVG(gpa) FROM student WHERE gpa IS NOT NULL);

-- Solution 6.2: Subqueries with IN and NOT IN
-- Students enrolled in CS department courses

SELECT DISTINCT s.student_id, s.name
FROM student s
INNER JOIN enrollment e ON s.student_id = e.student_id
INNER JOIN section sec ON e.section_id = sec.section_id
INNER JOIN course c ON sec.course_id = c.course_id
WHERE c.dept_id IN (
    SELECT dept_id FROM department WHERE name = 'Computer Science'
);

-- Solution 6.3: Tuple Comparisons
-- Students with same GPA and department as others

SELECT s1.student_id, s1.name, s1.gpa, d.name as department
FROM student s1
INNER JOIN department d ON s1.dept_id = d.dept_id
WHERE EXISTS (
    SELECT 1 FROM student s2
    WHERE s2.student_id != s1.student_id
    AND s2.dept_id = s1.dept_id
    AND s2.gpa = s1.gpa
    AND s1.gpa IS NOT NULL
    AND s2.gpa IS NOT NULL
);

-- Solution 6.4: Set Operations
-- UNION: Students in CS or Math departments
SELECT s.student_id, s.name, d.name as department
FROM student s
INNER JOIN department d ON s.dept_id = d.dept_id
WHERE d.name = 'Computer Science'
UNION
SELECT s.student_id, s.name, d.name as department
FROM student s
INNER JOIN department d ON s.dept_id = d.dept_id
WHERE d.name = 'Mathematics';

-- INTERSECT: CS students with GPA > 3.5 (MySQL doesn't support INTERSECT, use INNER JOIN)
SELECT s.student_id, s.name
FROM student s
INNER JOIN department d ON s.dept_id = d.dept_id
WHERE d.name = 'Computer Science'
AND s.gpa > 3.5;

-- EXCEPT: CS students who don't have GPA > 3.5 (MySQL doesn't support EXCEPT, use NOT IN)
SELECT s.student_id, s.name
FROM student s
INNER JOIN department d ON s.dept_id = d.dept_id
WHERE d.name = 'Computer Science'
AND s.student_id NOT IN (
    SELECT student_id FROM student WHERE gpa > 3.5
);

-- ========================================
-- SECTION 7: CORRELATED NESTED QUERIES
-- ========================================

-- Solution 7.1: Basic Correlated Subquery
-- Students with GPA higher than department average

SELECT s.student_id, s.name, s.gpa, d.name as department
FROM student s
INNER JOIN department d ON s.dept_id = d.dept_id
WHERE s.gpa > (
    SELECT AVG(s2.gpa)
    FROM student s2
    WHERE s2.dept_id = s.dept_id
    AND s2.gpa IS NOT NULL
);

-- Solution 7.2: Correlated Subquery with EXISTS
-- Departments with at least one student with GPA > 3.5

SELECT d.dept_id, d.name
FROM department d
WHERE EXISTS (
    SELECT 1 FROM student s
    WHERE s.dept_id = d.dept_id
    AND s.gpa > 3.5
);

-- Solution 7.3: Multiple Correlated Subqueries
-- Students meeting multiple criteria

SELECT s.student_id, s.name, s.gpa, d.name as department
FROM student s
INNER JOIN department d ON s.dept_id = d.dept_id
WHERE s.gpa > (
    SELECT AVG(s2.gpa)
    FROM student s2
    WHERE s2.dept_id = s.dept_id
    AND s2.gpa IS NOT NULL
)
AND (
    SELECT COUNT(*)
    FROM enrollment e
    WHERE e.student_id = s.student_id
) > (
    SELECT AVG(enrollment_count)
    FROM (
        SELECT COUNT(*) as enrollment_count
        FROM enrollment
        GROUP BY student_id
    ) as avg_enrollments
)
AND EXISTS (
    SELECT 1 FROM quiz_submission qs
    WHERE qs.student_id = s.student_id
);

-- ========================================
-- SECTION 8: THE EXISTS AND UNIQUE FUNCTIONS IN SQL
-- ========================================

-- Solution 8.1: EXISTS Function
-- Students who have submitted at least one quiz

SELECT s.student_id, s.name
FROM student s
WHERE EXISTS (
    SELECT 1 FROM quiz_submission qs
    WHERE qs.student_id = s.student_id
);

-- Solution 8.2: NOT EXISTS Function
-- Students who have never submitted any quiz

SELECT s.student_id, s.name
FROM student s
WHERE NOT EXISTS (
    SELECT 1 FROM quiz_submission qs
    WHERE qs.student_id = s.student_id
);

-- Solution 8.3: UNIQUE Function
-- Departments where all students have unique GPAs
-- Note: MySQL doesn't support UNIQUE function, but here's the concept:

SELECT d.dept_id, d.name
FROM department d
WHERE NOT EXISTS (
    SELECT 1 FROM student s1, student s2
    WHERE s1.dept_id = d.dept_id
    AND s2.dept_id = d.dept_id
    AND s1.student_id != s2.student_id
    AND s1.gpa = s2.gpa
    AND s1.gpa IS NOT NULL
    AND s2.gpa IS NOT NULL
);

-- Solution 8.4: EXISTS vs IN Performance
-- EXISTS approach (generally more efficient)
SELECT s.student_id, s.name
FROM student s
WHERE EXISTS (
    SELECT 1 FROM enrollment e
    WHERE e.student_id = s.student_id
);

-- IN approach (can be less efficient with large datasets)
SELECT s.student_id, s.name
FROM student s
WHERE s.student_id IN (
    SELECT DISTINCT student_id FROM enrollment
);

-- Performance differences:
-- EXISTS: Stops at first match, better for large subquery results
-- IN: Must evaluate entire subquery, better for small subquery results

-- ========================================
-- SECTION 9: EXPLICIT SETS AND RENAMING OF ATTRIBUTES IN SQL
-- ========================================

-- Solution 9.1: Explicit Sets with IN
-- Students in specific year levels

SELECT student_id, name, year_level
FROM student
WHERE year_level IN ('Sophomore', 'Junior', 'Senior');

-- Solution 9.2: Attribute Renaming
-- Descriptive column names

SELECT 
    student_id AS Student_ID,
    name AS Full_Name,
    gpa AS Grade_Point_Average,
    year_level AS Academic_Level
FROM student;

-- Solution 9.3: Complex Renaming with Expressions
-- Calculated columns with descriptive names

SELECT 
    student_id,
    name,
    gpa,
    CASE 
        WHEN gpa >= 3.7 THEN 'Dean\'s List'
        WHEN gpa >= 3.0 THEN 'Good Standing'
        WHEN gpa >= 2.0 THEN 'Satisfactory'
        ELSE 'Academic Probation'
    END AS Academic_Standing,
    YEAR(CURDATE()) - YEAR(enrollment_date) AS Years_Enrolled,
    ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY gpa DESC) AS Department_Rank
FROM student;

-- ========================================
-- SECTION 10: GROUPING - THE GROUP BY AND HAVING CLAUSES
-- ========================================

-- Solution 10.1: Basic GROUP BY
-- Count students by department

SELECT d.name as department, COUNT(s.student_id) as student_count
FROM department d
LEFT JOIN student s ON d.dept_id = s.dept_id
GROUP BY d.dept_id, d.name;

-- Solution 10.2: GROUP BY with Multiple Columns
-- Average GPA by department and year level

SELECT d.name as department, s.year_level, AVG(s.gpa) as avg_gpa
FROM department d
INNER JOIN student s ON d.dept_id = s.dept_id
WHERE s.gpa IS NOT NULL
GROUP BY d.dept_id, d.name, s.year_level
ORDER BY d.name, s.year_level;

-- Solution 10.3: HAVING Clause
-- Departments with more than 5 students and avg GPA > 3.0

SELECT d.name as department, 
       COUNT(s.student_id) as student_count,
       AVG(s.gpa) as avg_gpa
FROM department d
INNER JOIN student s ON d.dept_id = s.dept_id
WHERE s.gpa IS NOT NULL
GROUP BY d.dept_id, d.name
HAVING COUNT(s.student_id) > 5 
   AND AVG(s.gpa) > 3.0;

-- Solution 10.4: Complex GROUP BY with JOINs
-- Average quiz score by department and year level

SELECT d.name as department, 
       s.year_level,
       AVG(qs.score) as avg_quiz_score,
       COUNT(DISTINCT s.student_id) as student_count
FROM department d
INNER JOIN student s ON d.dept_id = s.dept_id
INNER JOIN quiz_submission qs ON s.student_id = qs.student_id
GROUP BY d.dept_id, d.name, s.year_level
HAVING COUNT(DISTINCT s.student_id) > 2
ORDER BY d.name, s.year_level;

-- ========================================
-- SECTION 11: AGGREGATE FUNCTIONS IN SQL
-- ========================================

-- Solution 11.1: Basic Aggregate Functions
-- GPA statistics

SELECT 
    COUNT(*) as total_students,
    COUNT(gpa) as students_with_gpa,
    MIN(gpa) as min_gpa,
    MAX(gpa) as max_gpa,
    AVG(gpa) as avg_gpa,
    SUM(gpa) as total_gpa_sum
FROM student;

-- Solution 11.2: Aggregate Functions with GROUP BY
-- Department statistics

SELECT 
    d.name as department,
    d.budget,
    COUNT(DISTINCT s.student_id) as student_count,
    AVG(s.gpa) as avg_gpa,
    COUNT(DISTINCT c.course_id) as course_count,
    COUNT(DISTINCT i.instructor_id) as instructor_count,
    AVG(i.salary) as avg_salary
FROM department d
LEFT JOIN student s ON d.dept_id = s.dept_id
LEFT JOIN course c ON d.dept_id = c.dept_id
LEFT JOIN instructor i ON d.dept_id = i.dept_id
GROUP BY d.dept_id, d.name, d.budget;

-- Solution 11.3: Conditional Aggregates
-- Student statistics by GPA category

SELECT 
    COUNT(*) as total_students,
    SUM(CASE WHEN gpa > 3.0 THEN 1 ELSE 0 END) as high_gpa_students,
    SUM(CASE WHEN gpa <= 3.0 THEN 1 ELSE 0 END) as low_gpa_students,
    AVG(CASE WHEN gpa > 3.0 THEN gpa END) as avg_high_gpa,
    AVG(CASE WHEN gpa <= 3.0 THEN gpa END) as avg_low_gpa
FROM student
WHERE gpa IS NOT NULL;

-- Solution 11.4: Window Functions with Aggregates
-- Student GPA with department and overall context

SELECT 
    s.student_id,
    s.name,
    s.gpa,
    d.name as department,
    AVG(s.gpa) OVER (PARTITION BY s.dept_id) as dept_avg_gpa,
    AVG(s.gpa) OVER () as overall_avg_gpa,
    RANK() OVER (PARTITION BY s.dept_id ORDER BY s.gpa DESC) as dept_rank,
    PERCENT_RANK() OVER (PARTITION BY s.dept_id ORDER BY s.gpa) as dept_percentile
FROM student s
INNER JOIN department d ON s.dept_id = d.dept_id
WHERE s.gpa IS NOT NULL
ORDER BY s.dept_id, s.gpa DESC;

-- ========================================
-- SECTION 12: DISCUSSION AND SUMMARY OF SQL QUERIES
-- ========================================

-- Solution 12.1: Query Optimization Analysis
-- Original query (inefficient):
-- SELECT s.name, d.name, c.title
-- FROM student s, department d, course c, enrollment e
-- WHERE s.dept_id = d.dept_id 
--   AND e.student_id = s.student_id 
--   AND c.course_id = e.course_id
--   AND s.gpa > 3.0;

-- Optimized query:
SELECT s.name, d.name, c.title
FROM student s
INNER JOIN department d ON s.dept_id = d.dept_id
INNER JOIN enrollment e ON s.student_id = e.student_id
INNER JOIN course c ON e.course_id = c.course_id
WHERE s.gpa > 3.0;

-- Optimizations made:
-- 1. Use explicit JOINs instead of comma-separated tables
-- 2. Apply WHERE conditions early to reduce intermediate result sets
-- 3. Use INNER JOIN to avoid Cartesian products

-- Solution 12.2: Query Equivalence
-- Three different approaches to find CS students:

-- Method 1: Using IN with subquery
SELECT s.student_id, s.name
FROM student s
WHERE s.dept_id IN (
    SELECT dept_id FROM department WHERE name = 'Computer Science'
);

-- Method 2: Using EXISTS with subquery
SELECT s.student_id, s.name
FROM student s
WHERE EXISTS (
    SELECT 1 FROM department d
    WHERE d.dept_id = s.dept_id
    AND d.name = 'Computer Science'
);

-- Method 3: Using JOIN
SELECT s.student_id, s.name
FROM student s
INNER JOIN department d ON s.dept_id = d.dept_id
WHERE d.name = 'Computer Science';

-- All three produce the same result but with different performance characteristics

-- Solution 12.3: Performance Analysis
-- Compare IN vs EXISTS vs JOIN performance:

-- IN approach (good for small subquery results):
SELECT s.student_id, s.name
FROM student s
WHERE s.student_id IN (
    SELECT DISTINCT student_id FROM enrollment
);

-- EXISTS approach (good for large subquery results):
SELECT s.student_id, s.name
FROM student s
WHERE EXISTS (
    SELECT 1 FROM enrollment e
    WHERE e.student_id = s.student_id
);

-- JOIN approach (good for complex relationships):
SELECT DISTINCT s.student_id, s.name
FROM student s
INNER JOIN enrollment e ON s.student_id = e.student_id;

-- Performance considerations:
-- - IN: Must evaluate entire subquery, good for small result sets
-- - EXISTS: Stops at first match, good for large result sets
-- - JOIN: Can use indexes effectively, good for complex queries

-- ========================================
-- SECTION 13: TUTORIAL EXAMPLES OF SQL QUERIES
-- ========================================

-- Solution 13.1: Real-World Business Query
-- Student academic report

SELECT 
    s.student_id,
    s.name as student_name,
    d.name as department,
    s.year_level,
    s.gpa,
    COUNT(DISTINCT e.section_id) as courses_enrolled,
    AVG(qs.score) as avg_quiz_score,
    CASE 
        WHEN s.gpa >= 3.7 THEN 'Dean\'s List'
        WHEN s.gpa >= 3.0 THEN 'Good Standing'
        WHEN s.gpa >= 2.0 THEN 'Satisfactory'
        ELSE 'Academic Probation'
    END as academic_standing,
    RANK() OVER (PARTITION BY s.dept_id ORDER BY s.gpa DESC) as dept_rank
FROM student s
INNER JOIN department d ON s.dept_id = d.dept_id
LEFT JOIN enrollment e ON s.student_id = e.student_id
LEFT JOIN quiz_submission qs ON s.student_id = qs.student_id
GROUP BY s.student_id, s.name, d.name, s.year_level, s.gpa, s.dept_id
ORDER BY s.dept_id, s.gpa DESC;

-- Solution 13.2: Data Analysis Query
-- Instructor workload analysis

SELECT 
    i.instructor_id,
    i.name as instructor_name,
    d.name as department,
    COUNT(DISTINCT sec.section_id) as sections_taught,
    COUNT(DISTINCT e.student_id) as total_students,
    AVG(qs.score) as avg_quiz_scores,
    SUM(c.credits) as total_credits,
    CASE 
        WHEN COUNT(DISTINCT sec.section_id) > 4 THEN 'Overloaded'
        WHEN COUNT(DISTINCT sec.section_id) >= 3 THEN 'Full Load'
        WHEN COUNT(DISTINCT sec.section_id) > 0 THEN 'Light Load'
        ELSE 'No Teaching'
    END as workload_status
FROM instructor i
INNER JOIN department d ON i.dept_id = d.dept_id
LEFT JOIN section sec ON i.instructor_id = sec.instructor_id
LEFT JOIN course c ON sec.course_id = c.course_id
LEFT JOIN enrollment e ON sec.section_id = e.section_id
LEFT JOIN quiz q ON sec.section_id = q.section_id
LEFT JOIN quiz_submission qs ON q.quiz_id = qs.quiz_id
GROUP BY i.instructor_id, i.name, d.name
ORDER BY sections_taught DESC;

-- Solution 13.3: Reporting Query
-- Department performance report

WITH dept_metrics AS (
    SELECT 
        d.dept_id,
        d.name as department_name,
        d.budget,
        COUNT(DISTINCT s.student_id) as total_students,
        AVG(s.gpa) as avg_gpa,
        COUNT(DISTINCT c.course_id) as courses_offered,
        COUNT(DISTINCT i.instructor_id) as faculty_count,
        COUNT(DISTINCT e.section_id) as total_enrollments
    FROM department d
    LEFT JOIN student s ON d.dept_id = s.dept_id
    LEFT JOIN course c ON d.dept_id = c.dept_id
    LEFT JOIN instructor i ON d.dept_id = i.dept_id
    LEFT JOIN section sec ON c.course_id = sec.course_id
    LEFT JOIN enrollment e ON sec.section_id = e.section_id
    GROUP BY d.dept_id, d.name, d.budget
),
year_level_breakdown AS (
    SELECT 
        d.dept_id,
        s.year_level,
        COUNT(*) as student_count,
        AVG(s.gpa) as avg_gpa
    FROM department d
    INNER JOIN student s ON d.dept_id = s.dept_id
    WHERE s.gpa IS NOT NULL
    GROUP BY d.dept_id, s.year_level
)
SELECT 
    dm.department_name,
    dm.budget,
    dm.total_students,
    dm.avg_gpa,
    dm.courses_offered,
    dm.faculty_count,
    ROUND(dm.total_students / NULLIF(dm.faculty_count, 0), 2) as student_faculty_ratio,
    ROUND(dm.budget / NULLIF(dm.total_students, 0), 2) as budget_per_student,
    -- Year level breakdown
    SUM(CASE WHEN ylb.year_level = 'Freshman' THEN ylb.student_count ELSE 0 END) as freshmen,
    SUM(CASE WHEN ylb.year_level = 'Sophomore' THEN ylb.student_count ELSE 0 END) as sophomores,
    SUM(CASE WHEN ylb.year_level = 'Junior' THEN ylb.student_count ELSE 0 END) as juniors,
    SUM(CASE WHEN ylb.year_level = 'Senior' THEN ylb.student_count ELSE 0 END) as seniors,
    -- Performance metrics
    CASE 
        WHEN dm.avg_gpa >= 3.5 THEN 'Excellent'
        WHEN dm.avg_gpa >= 3.0 THEN 'Good'
        WHEN dm.avg_gpa >= 2.5 THEN 'Average'
        ELSE 'Needs Improvement'
    END as performance_rating
FROM dept_metrics dm
LEFT JOIN year_level_breakdown ylb ON dm.dept_id = ylb.dept_id
GROUP BY dm.dept_id, dm.department_name, dm.budget, dm.total_students, 
         dm.avg_gpa, dm.courses_offered, dm.faculty_count
ORDER BY dm.avg_gpa DESC;

-- ========================================
-- END OF SOLUTIONS
-- ========================================
-- 
-- Key Learning Points:
-- 1. Complex queries often require multiple techniques combined
-- 2. Performance optimization is crucial for large datasets
-- 3. Understanding NULL handling and three-valued logic is essential
-- 4. Views provide abstraction and security benefits
-- 5. Triggers and constraints maintain data integrity
-- 6. Window functions enable sophisticated analytics
-- 7. Proper indexing and query structure affect performance significantly
-- ========================================
