-- ========================================
-- MIDTERM REVIEW QUESTIONS
-- SQL Database Design and Querying
-- ========================================
-- Based on two relational schemas:
-- 1️⃣ STUDENT–COURSE Database Schema  
--    (STUDENT, GRADE_REPORT, SECTION, COURSE, PREREQUISITE)
-- 2️⃣ COMPANY Database Schema  
--    (EMPLOYEE, DEPARTMENT, DEPT_LOCATIONS, PROJECT, WORKS_ON, DEPENDENT)

-- ========================================
-- STUDENT-COURSE DATABASE SCHEMA QUESTIONS
-- ========================================

-- Question 1: Easy - Table Creation
-- Concept: DDL, Data Types, Primary Keys
-- ========================================
-- Create the STUDENT table with the following specifications:
-- - student_id (INT, Primary Key)
-- - name (VARCHAR(100), NOT NULL)
-- - dept_id (INT, Foreign Key to DEPARTMENT)
-- - year_level (ENUM: 'Freshman','Sophomore','Junior','Senior', default 'Freshman')
-- - enrollment_date (DATE)

-- Expected Answer:
CREATE TABLE STUDENT (
    student_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dept_id INT,
    year_level ENUM('Freshman','Sophomore','Junior','Senior') DEFAULT 'Freshman',
    enrollment_date DATE,
    FOREIGN KEY (dept_id) REFERENCES DEPARTMENT(dept_id)
);

-- ========================================

-- Question 2: Easy - Basic SELECT with WHERE
-- Concept: SELECT, WHERE, LIKE
-- ========================================
-- Find all students whose names start with 'A' and are in their Junior or Senior year.

-- Expected Answer:
SELECT student_id, name, year_level
FROM STUDENT 
WHERE name LIKE 'A%' 
  AND year_level IN ('Junior', 'Senior');

-- ========================================

-- Question 3: Medium - INNER JOIN
-- Concept: JOIN, Table Aliases
-- ========================================
-- List all students with their department names, but only for students enrolled after 2023.

-- Expected Answer:
SELECT s.student_id, s.name, d.name AS department_name, s.enrollment_date
FROM STUDENT s
INNER JOIN DEPARTMENT d ON s.dept_id = d.dept_id
WHERE s.enrollment_date > '2023-01-01';

-- ========================================

-- Question 4: Medium - Aggregation with GROUP BY
-- Concept: COUNT, GROUP BY, HAVING
-- ========================================
-- Find departments that have more than 5 students enrolled.

-- Expected Answer:
SELECT d.name AS department_name, COUNT(s.student_id) AS student_count
FROM DEPARTMENT d
LEFT JOIN STUDENT s ON d.dept_id = s.dept_id
GROUP BY d.dept_id, d.name
HAVING COUNT(s.student_id) > 5;

-- ========================================

-- Question 5: Medium - Subquery with EXISTS
-- Concept: Subquery, EXISTS
-- ========================================
-- Find all students who have taken at least one course (exist in GRADE_REPORT table).

-- Expected Answer:
SELECT s.student_id, s.name
FROM STUDENT s
WHERE EXISTS (
    SELECT 1 
    FROM GRADE_REPORT gr 
    WHERE gr.student_id = s.student_id
);

-- ========================================

-- Question 6: Hard - Complex JOIN with Multiple Tables
-- Concept: Multiple JOINs, CASE
-- ========================================
-- For each student, show their name, the number of courses taken, and their average grade.
-- Include students who haven't taken any courses (show 0 courses and NULL average).

-- Expected Answer:
SELECT 
    s.student_id,
    s.name,
    COUNT(gr.course_id) AS courses_taken,
    CASE 
        WHEN COUNT(gr.course_id) > 0 THEN AVG(gr.grade)
        ELSE NULL 
    END AS average_grade
FROM STUDENT s
LEFT JOIN GRADE_REPORT gr ON s.student_id = gr.student_id
GROUP BY s.student_id, s.name;

-- ========================================

-- Question 7: Hard - Correlated Subquery
-- Concept: Correlated Subquery, Aggregation
-- ========================================
-- Find students who have a higher average grade than the average grade of all students in their department.

-- Expected Answer:
SELECT s.student_id, s.name, AVG(gr.grade) AS student_avg
FROM STUDENT s
JOIN GRADE_REPORT gr ON s.student_id = gr.student_id
GROUP BY s.student_id, s.name, s.dept_id
HAVING AVG(gr.grade) > (
    SELECT AVG(gr2.grade)
    FROM STUDENT s2
    JOIN GRADE_REPORT gr2 ON s2.student_id = gr2.student_id
    WHERE s2.dept_id = s.dept_id
);

-- ========================================

-- Question 8: Medium - UNION Query
-- Concept: UNION, Set Operations
-- ========================================
-- Create a list of all course IDs that are either prerequisites for other courses OR have prerequisites.

-- Expected Answer:
SELECT course_id FROM PREREQUISITE
UNION
SELECT prereq_id FROM PREREQUISITE;

-- ========================================

-- Question 9: Easy - BETWEEN and Date Functions
-- Concept: WHERE, BETWEEN, Date Functions
-- ========================================
-- Find all courses offered in sections during the Fall 2024 semester.

-- Expected Answer:
SELECT DISTINCT c.course_id, c.title
FROM COURSE c
JOIN SECTION s ON c.course_id = s.course_id
WHERE s.term = 'Fall' AND s.year_num = 2024;

-- ========================================

-- Question 10: Medium - Window Functions
-- Concept: Window Functions, ROW_NUMBER
-- ========================================
-- Rank students by their average grade within their department (highest grade gets rank 1).

-- Expected Answer:
SELECT 
    s.student_id,
    s.name,
    d.name AS department,
    AVG(gr.grade) AS avg_grade,
    ROW_NUMBER() OVER (PARTITION BY s.dept_id ORDER BY AVG(gr.grade) DESC) AS dept_rank
FROM STUDENT s
JOIN DEPARTMENT d ON s.dept_id = d.dept_id
JOIN GRADE_REPORT gr ON s.student_id = gr.student_id
GROUP BY s.student_id, s.name, d.name, s.dept_id;

-- ========================================

-- Question 11: Hard - Division Operation
-- Concept: Division, NOT EXISTS, Subqueries
-- ========================================
-- Find students who have taken ALL courses offered by the Computer Science department.

-- Expected Answer:
SELECT s.student_id, s.name
FROM STUDENT s
WHERE NOT EXISTS (
    SELECT c.course_id
    FROM COURSE c
    JOIN DEPARTMENT d ON c.dept_id = d.dept_id
    WHERE d.name = 'Computer Science'
    AND c.course_id NOT IN (
        SELECT gr.course_id
        FROM GRADE_REPORT gr
        WHERE gr.student_id = s.student_id
    )
);

-- ========================================

-- Question 12: Medium - Constraint Violation Analysis
-- Concept: Referential Integrity, Foreign Keys
-- ========================================
-- Identify what would happen if you try to delete a department that has students enrolled.
-- Explain the constraint behavior and provide a solution.

-- Expected Answer:
-- This would violate referential integrity because students reference the department.
-- Options:
-- 1. Use ON DELETE SET NULL to set student dept_id to NULL
-- 2. Use ON DELETE RESTRICT to prevent deletion
-- 3. First reassign or delete all students, then delete department

-- Example constraint modification:
ALTER TABLE STUDENT 
DROP FOREIGN KEY fk_student_dept,
ADD CONSTRAINT fk_student_dept 
FOREIGN KEY (dept_id) REFERENCES DEPARTMENT(dept_id) 
ON DELETE SET NULL;

-- ========================================

-- Question 13: Easy - Data Type Selection
-- Concept: Data Types, Domain Constraints
-- ========================================
-- Choose appropriate data types for the following attributes in a GRADE_REPORT table:
-- - student_id: INT (Primary Key, references STUDENT)
-- - course_id: INT (Primary Key, references COURSE)  
-- - section_id: INT (references SECTION)
-- - grade: DECIMAL(5,2) (allows grades like 95.75)
-- - semester: VARCHAR(10) (e.g., 'Fall2024')
-- - year_num: YEAR (e.g., 2024)

-- Expected Answer:
CREATE TABLE GRADE_REPORT (
    student_id INT,
    course_id INT,
    section_id INT,
    grade DECIMAL(5,2) CHECK (grade >= 0 AND grade <= 100),
    semester VARCHAR(10),
    year_num YEAR,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES STUDENT(student_id),
    FOREIGN KEY (course_id) REFERENCES COURSE(course_id),
    FOREIGN KEY (section_id) REFERENCES SECTION(section_id)
);

-- ========================================

-- Question 14: Medium - Complex Aggregation
-- Concept: GROUP BY, HAVING, Multiple Aggregations
-- ========================================
-- For each department, find the average number of credits per course, 
-- but only include departments with more than 3 courses.

-- Expected Answer:
SELECT 
    d.name AS department_name,
    COUNT(c.course_id) AS course_count,
    AVG(c.credits) AS avg_credits_per_course
FROM DEPARTMENT d
JOIN COURSE c ON d.dept_id = c.dept_id
GROUP BY d.dept_id, d.name
HAVING COUNT(c.course_id) > 3;

-- ========================================

-- Question 15: Hard - Recursive Query with CTE
-- Concept: CTE, Recursive Queries, Hierarchies
-- ========================================
-- Find all prerequisite chains for a given course (e.g., course_id = 300).
-- Show the complete prerequisite path.

-- Expected Answer:
WITH RECURSIVE PrereqChain AS (
    -- Base case: direct prerequisites
    SELECT course_id, prereq_id, 1 AS level, 
           CAST(prereq_id AS CHAR(1000)) AS path
    FROM PREREQUISITE 
    WHERE course_id = 300
    
    UNION ALL
    
    -- Recursive case: prerequisites of prerequisites
    SELECT p.course_id, p.prereq_id, pc.level + 1,
           CONCAT(pc.path, ' -> ', p.prereq_id)
    FROM PREREQUISITE p
    JOIN PrereqChain pc ON p.course_id = pc.prereq_id
)
SELECT * FROM PrereqChain ORDER BY level, path;

-- ========================================
-- COMPANY DATABASE SCHEMA QUESTIONS
-- ========================================

-- Question 16: Easy - Table Creation with Constraints
-- Concept: DDL, Foreign Keys, Check Constraints
-- ========================================
-- Create the EMPLOYEE table with proper constraints:
-- - Ssn (CHAR(9), Primary Key)
-- - Fname, Lname (VARCHAR(15), NOT NULL)
-- - Salary (DECIMAL(10,2), must be > 0)
-- - Dno (INT, Foreign Key to DEPARTMENT)
-- - Super_ssn (CHAR(9), Foreign Key to EMPLOYEE)

-- Expected Answer:
CREATE TABLE EMPLOYEE (
    Ssn CHAR(9) PRIMARY KEY,
    Fname VARCHAR(15) NOT NULL,
    Lname VARCHAR(15) NOT NULL,
    Salary DECIMAL(10,2) CHECK (Salary > 0),
    Dno INT NOT NULL,
    Super_ssn CHAR(9),
    FOREIGN KEY (Dno) REFERENCES DEPARTMENT(Dnumber),
    FOREIGN KEY (Super_ssn) REFERENCES EMPLOYEE(Ssn)
);

-- ========================================

-- Question 17: Easy - Basic Filtering with WHERE
-- Concept: SELECT, WHERE, Comparison Operators
-- ========================================
-- Find all employees who earn more than $40,000 and work in department 5.

-- Expected Answer:
SELECT Fname, Lname, Salary
FROM EMPLOYEE
WHERE Salary > 40000 AND Dno = 5;

-- ========================================

-- Question 18: Medium - LEFT JOIN
-- Concept: LEFT JOIN, NULL Handling
-- ========================================
-- List all employees with their supervisor names. Include employees who don't have supervisors.

-- Expected Answer:
SELECT 
    e.Fname, e.Lname,
    s.Fname AS Supervisor_First, 
    s.Lname AS Supervisor_Last
FROM EMPLOYEE e
LEFT JOIN EMPLOYEE s ON e.Super_ssn = s.Ssn;

-- ========================================

-- Question 19: Medium - Aggregation with GROUP BY
-- Concept: COUNT, GROUP BY, ORDER BY
-- ========================================
-- Find the number of employees in each department, ordered by department number.

-- Expected Answer:
SELECT Dno, COUNT(*) AS employee_count
FROM EMPLOYEE
GROUP BY Dno
ORDER BY Dno;

-- ========================================

-- Question 20: Medium - Subquery with IN
-- Concept: Subquery, IN, Aggregation
-- ========================================
-- Find employees who work on projects located in 'Houston'.

-- Expected Answer:
SELECT Fname, Lname
FROM EMPLOYEE
WHERE Ssn IN (
    SELECT Essn
    FROM WORKS_ON
    WHERE Pno IN (
        SELECT Pnumber
        FROM PROJECT
        WHERE Plocation = 'Houston'
    )
);

-- ========================================

-- Question 21: Hard - Complex JOIN with Aggregation
-- Concept: Multiple JOINs, GROUP BY, HAVING
-- ========================================
-- Find all employees who work on more than 2 projects, showing their name, 
-- department, and project count.

-- Expected Answer:
SELECT 
    e.Fname, e.Lname, d.Dname AS department,
    COUNT(w.Pno) AS project_count
FROM EMPLOYEE e
JOIN DEPARTMENT d ON e.Dno = d.Dnumber
JOIN WORKS_ON w ON e.Ssn = w.Essn
GROUP BY e.Ssn, e.Fname, e.Lname, d.Dname
HAVING COUNT(w.Pno) > 2;

-- ========================================

-- Question 22: Hard - Correlated Subquery with EXISTS
-- Concept: Correlated Subquery, EXISTS, Aggregation
-- ========================================
-- Find employees who have a salary higher than the average salary in their department.

-- Expected Answer:
SELECT Fname, Lname, Salary, Dno
FROM EMPLOYEE e1
WHERE Salary > (
    SELECT AVG(Salary)
    FROM EMPLOYEE e2
    WHERE e2.Dno = e1.Dno
);

-- ========================================

-- Question 23: Medium - UNION with Different Tables
-- Concept: UNION, Set Operations, Data Type Compatibility
-- ========================================
-- Create a list of all project numbers and department numbers.

-- Expected Answer:
SELECT Pnumber AS number, 'Project' AS type
FROM PROJECT
UNION
SELECT Dnumber AS number, 'Department' AS type
FROM DEPARTMENT
ORDER BY number;

-- ========================================

-- Question 24: Easy - Date Functions and BETWEEN
-- Concept: Date Functions, WHERE, BETWEEN
-- ========================================
-- Find all dependents who were born between 1980 and 1990.

-- Expected Answer:
SELECT Dependent_name, Bdate, Relationship
FROM DEPENDENT
WHERE YEAR(Bdate) BETWEEN 1980 AND 1990;

-- ========================================

-- Question 25: Hard - Window Functions with Partitioning
-- Concept: Window Functions, RANK, PARTITION BY
-- ========================================
-- Rank employees by salary within their department (highest salary gets rank 1).

-- Expected Answer:
SELECT 
    Fname, Lname, Salary, Dno,
    RANK() OVER (PARTITION BY Dno ORDER BY Salary DESC) AS salary_rank
FROM EMPLOYEE;

-- ========================================

-- Question 26: Hard - Division Operation
-- Concept: Division, NOT EXISTS, Complex Logic
-- ========================================
-- Find employees who work on ALL projects in their department.

-- Expected Answer:
SELECT e.Fname, e.Lname
FROM EMPLOYEE e
WHERE NOT EXISTS (
    SELECT p.Pnumber
    FROM PROJECT p
    WHERE p.Dnum = e.Dno
    AND p.Pnumber NOT IN (
        SELECT w.Pno
        FROM WORKS_ON w
        WHERE w.Essn = e.Ssn
    )
);

-- ========================================

-- Question 27: Medium - Constraint Analysis
-- Concept: Referential Integrity, Cascade Options
-- ========================================
-- What happens when you delete an employee who is a manager of a department?
-- Explain the constraint behavior and provide solutions.

-- Expected Answer:
-- This would violate referential integrity because the department references the employee.
-- Options:
-- 1. Use ON DELETE SET NULL to set Mgr_ssn to NULL
-- 2. Use ON DELETE RESTRICT to prevent deletion
-- 3. First reassign the department manager, then delete employee

-- Example constraint modification:
ALTER TABLE DEPARTMENT 
DROP FOREIGN KEY fk_dept_mgr,
ADD CONSTRAINT fk_dept_mgr 
FOREIGN KEY (Mgr_ssn) REFERENCES EMPLOYEE(Ssn) 
ON DELETE SET NULL;

-- ========================================

-- Question 28: Easy - Data Type Selection
-- Concept: Data Types, Domain Constraints
-- ========================================
-- Choose appropriate data types for the following attributes:
-- - Ssn: CHAR(9) (Social Security Number, fixed length)
-- - Salary: DECIMAL(10,2) (monetary value with 2 decimal places)
-- - Hours: DECIMAL(3,1) (work hours, allows values like 40.5)
-- - Bdate: DATE (birth date)
-- - Relationship: VARCHAR(8) (e.g., 'Spouse', 'Child')

-- Expected Answer:
CREATE TABLE DEPENDENT (
    Essn CHAR(9),
    Dependent_name VARCHAR(15),
    Sex CHAR(1),
    Bdate DATE,
    Relationship VARCHAR(8),
    PRIMARY KEY (Essn, Dependent_name),
    FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn)
);

-- ========================================

-- Question 29: Medium - Complex Aggregation
-- Concept: GROUP BY, HAVING, Multiple Aggregations
-- ========================================
-- For each department, find the total hours worked on projects, 
-- but only include departments with more than 100 total hours.

-- Expected Answer:
SELECT 
    d.Dname AS department_name,
    SUM(w.Hours) AS total_hours
FROM DEPARTMENT d
JOIN EMPLOYEE e ON d.Dnumber = e.Dno
JOIN WORKS_ON w ON e.Ssn = w.Essn
GROUP BY d.Dnumber, d.Dname
HAVING SUM(w.Hours) > 100;

-- ========================================

-- Question 30: Hard - Recursive Query for Hierarchy
-- Concept: CTE, Recursive Queries, Employee Hierarchy
-- ========================================
-- Find the complete management hierarchy starting from employee '888665555' (James Borg).
-- Show all employees who report to him directly or indirectly.

-- Expected Answer:
WITH RECURSIVE ManagementHierarchy AS (
    -- Base case: direct reports
    SELECT Ssn, Fname, Lname, Super_ssn, 1 AS level
    FROM EMPLOYEE
    WHERE Super_ssn = '888665555'
    
    UNION ALL
    
    -- Recursive case: reports of reports
    SELECT e.Ssn, e.Fname, e.Lname, e.Super_ssn, mh.level + 1
    FROM EMPLOYEE e
    JOIN ManagementHierarchy mh ON e.Super_ssn = mh.Ssn
)
SELECT * FROM ManagementHierarchy ORDER BY level, Lname;

-- ========================================
-- END OF MIDTERM REVIEW QUESTIONS
-- ========================================
-- 
-- Summary:
-- - 30 total questions (15 from each schema)
-- - Difficulty distribution: ~10 Easy, ~12 Medium, ~8 Hard
-- - Concepts covered:
--   * Table creation and constraints
--   * SELECT queries with filtering
--   * JOINs (INNER, LEFT, CROSS)
--   * Aggregations and GROUP BY/HAVING
--   * Subqueries (scalar, correlated, EXISTS)
--   * UNION and set operations
--   * Window functions
--   * Recursive queries with CTEs
--   * Referential integrity and constraints
--   * Data type selection
--   * Division operations
--   * Complex business scenarios
-- ========================================
