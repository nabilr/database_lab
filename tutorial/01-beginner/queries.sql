-- ========================================
-- BEGINNER SQL TUTORIAL
-- ========================================
-- This section covers fundamental SQL operations
-- Topics: SELECT, WHERE, ORDER BY, LIMIT, basic JOINs

-- Section 1: Basic SELECT Statements
-- ========================================

-- 1.1 Select all columns from a table
SELECT * FROM department;

-- 1.2 Select specific columns
SELECT name FROM department;

-- 1.3 Select with column aliases
SELECT dept_id AS id, name AS department_name FROM department;

-- Section 2: Filtering with WHERE
-- ========================================

-- 2.1 Filter by exact match
SELECT * FROM student WHERE year_level = 'Freshman';

-- 2.2 Filter by comparison operators
SELECT * FROM course WHERE credits > 3;

-- 2.3 Filter with multiple conditions (AND)
SELECT * FROM student WHERE dept_id = 1 AND year_level = 'Junior';

-- 2.4 Filter with multiple conditions (OR)
SELECT * FROM student WHERE year_level = 'Freshman' OR year_level = 'Senior';

-- 2.5 Filter with IN operator
SELECT * FROM student WHERE year_level IN ('Freshman', 'Sophomore');

-- 2.6 Filter with LIKE pattern matching
SELECT * FROM course WHERE title LIKE 'CS%';

-- 2.7 Filter with NULL values
SELECT * FROM student WHERE dept_id IS NULL;

-- Section 3: Sorting and Limiting
-- ========================================

-- 3.1 Sort by single column (ascending)
SELECT * FROM student ORDER BY name;

-- 3.2 Sort by single column (descending)
SELECT * FROM course ORDER BY credits DESC;

-- 3.3 Sort by multiple columns
SELECT * FROM student ORDER BY dept_id, year_level, name;

-- 3.4 Limit results
SELECT * FROM student ORDER BY name LIMIT 2;

-- Section 4: Basic Joins
-- ========================================

-- 4.1 INNER JOIN - Students with their departments
SELECT s.name AS student_name, d.name AS department_name
FROM student s
INNER JOIN department d ON s.dept_id = d.dept_id;

-- 4.2 LEFT JOIN - All students, including those without departments
SELECT s.name AS student_name, d.name AS department_name
FROM student s
LEFT JOIN department d ON s.dept_id = d.dept_id;

-- 4.3 Multiple table JOIN - Students, their departments, and enrollments
SELECT s.name AS student_name, d.name AS department, c.title AS course_title
FROM student s
INNER JOIN department d ON s.dept_id = d.dept_id
INNER JOIN enrollment e ON s.student_id = e.student_id
INNER JOIN section sec ON e.section_id = sec.section_id
INNER JOIN course c ON sec.course_id = c.course_id;

-- Section 5: Practice Exercises
-- ========================================

-- Exercise 1: Find all Computer Science courses
-- Expected: CS101: Intro to Programming, CS201: Data Structures
SELECT title FROM course 
WHERE dept_id = (SELECT dept_id FROM department WHERE name = 'Computer Science');

-- Exercise 2: List students enrolled in Fall 2025 courses
SELECT DISTINCT s.name 
FROM student s
INNER JOIN enrollment e ON s.student_id = e.student_id
INNER JOIN section sec ON e.section_id = sec.section_id
WHERE sec.term = 'Fall' AND sec.year_num = 2025;

-- Exercise 3: Show instructors and the number of sections they teach
SELECT i.name, COUNT(s.section_id) as sections_taught
FROM instructor i
LEFT JOIN section s ON i.instructor_id = s.instructor_id
GROUP BY i.instructor_id, i.name;

-- Exercise 4: Find courses with no prerequisites
SELECT c.title
FROM course c
LEFT JOIN prerequisite p ON c.course_id = p.course_id
WHERE p.course_id IS NULL;

-- Exercise 5: List all rooms and their current usage
SELECT r.room_id, r.building, 
       CASE WHEN s.section_id IS NOT NULL THEN 'In Use' ELSE 'Available' END as status
FROM room r
LEFT JOIN section s ON r.room_id = s.room_id
WHERE s.term = 'Fall' AND s.year_num = 2025;
