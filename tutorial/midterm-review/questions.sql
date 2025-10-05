-- ========================================
-- MIDTERM REVIEW QUESTIONS
-- SQL Database Design and Querying (Basic Level)
-- ========================================
-- Based on two relational schemas:
-- 1️⃣ STUDENT–COURSE Database Schema  
--    (STUDENT, GRADE_REPORT, SECTION, COURSE, PREREQUISITE, DEPARTMENT)
-- 2️⃣ COMPANY Database Schema  
--    (EMPLOYEE, DEPARTMENT, DEPT_LOCATIONS, PROJECT, WORKS_ON, DEPENDENT)

-- Focus: Basic queries, CROSS JOIN, simple filtering, no aggregates
-- ========================================

-- ========================================
-- STUDENT-COURSE DATABASE QUESTIONS
-- ========================================

-- Question 1: Easy - Table Creation
-- Concept: DDL, Data Types, Primary Keys
-- ========================================
-- Create the DEPARTMENT table with the following specifications:
-- - dept_id (INT, Primary Key)
-- - name (VARCHAR(100), NOT NULL, UNIQUE)
-- - budget (DECIMAL(12,2))
-- - building (VARCHAR(50))

-- ========================================

-- Question 2: Easy - Table Creation
-- Concept: DDL, Data Types, Primary Keys, Foreign Keys
-- ========================================
-- Create the STUDENT table with the following specifications:
-- - student_id (INT, Primary Key)
-- - name (VARCHAR(100), NOT NULL)
-- - dept_id (INT, Foreign Key to DEPARTMENT)
-- - year_level (ENUM: 'Freshman','Sophomore','Junior','Senior', default 'Freshman')
-- - enrollment_date (DATE)
-- - gpa (DECIMAL(3,2))

-- ========================================

-- Question 3: Easy - Table Creation
-- Concept: DDL, Data Types, Primary Keys, Foreign Keys
-- ========================================
-- Create the COURSE table with the following specifications:
-- - course_id (INT, Primary Key)
-- - title (VARCHAR(200), NOT NULL)
-- - credits (TINYINT, NOT NULL, must be between 1 and 6)
-- - dept_id (INT, NOT NULL, Foreign Key to DEPARTMENT)
-- - description (TEXT)

-- ========================================

-- Question 4: Easy - Table Creation
-- Concept: DDL, Composite Primary Key, Foreign Keys
-- ========================================
-- Create the PREREQUISITE table with the following specifications:
-- - course_id (INT, NOT NULL, Foreign Key to COURSE)
-- - prereq_id (INT, NOT NULL, Foreign Key to COURSE)
-- - Composite Primary Key: (course_id, prereq_id)

-- ========================================

-- Question 5: Easy - Table Creation
-- Concept: DDL, Data Types, Primary Keys, Foreign Keys
-- ========================================
-- Create the SECTION table with the following specifications:
-- - section_id (INT, Primary Key)
-- - course_id (INT, NOT NULL, Foreign Key to COURSE)
-- - term (ENUM: 'Spring','Summer','Fall', NOT NULL)
-- - year_num (YEAR, NOT NULL)
-- - capacity (INT, default 30)
-- - instructor_name (VARCHAR(100))

-- ========================================

-- Question 6: Easy - Table Creation
-- Concept: DDL, Composite Primary Key, Foreign Keys, Check Constraints
-- ========================================
-- Create the GRADE_REPORT table with the following specifications:
-- - student_id (INT, NOT NULL, Foreign Key to STUDENT)
-- - course_id (INT, NOT NULL, Foreign Key to COURSE)
-- - section_id (INT, NOT NULL, Foreign Key to SECTION)
-- - grade (DECIMAL(5,2), must be between 0 and 100)
-- - semester (VARCHAR(10))
-- - year_num (YEAR)
-- - Composite Primary Key: (student_id, course_id, section_id)

-- ========================================

-- Question 7: Easy - Basic SELECT with WHERE
-- Concept: SELECT, WHERE, LIKE
-- ========================================
-- Find all students whose names start with 'A' and are in their Junior or Senior year.

-- ========================================

-- Question 8: Easy - CROSS JOIN with WHERE Filtering
-- Concept: CROSS JOIN, WHERE filtering
-- ========================================
-- Find all students who could potentially enroll in Computer Science sections using CROSS JOIN.

-- ========================================

-- Question 9: Easy - Basic Filtering with WHERE
-- Concept: WHERE, Comparison Operators
-- ========================================
-- Find all students with GPA greater than 3.5.

-- ========================================

-- Question 10: Easy - IN and NOT IN
-- Concept: WHERE, IN, NOT IN
-- ========================================
-- Find all students who are NOT in the Computer Science or Mathematics departments.

-- ========================================

-- Question 11: Easy - BETWEEN and Date Functions
-- Concept: WHERE, BETWEEN, Date Functions
-- ========================================
-- Find all students who enrolled between 2022 and 2023.

-- ========================================

-- Question 12: Easy - NULL Handling
-- Concept: WHERE, IS NULL, IS NOT NULL
-- ========================================
-- Find all students who have a NULL GPA.

-- ========================================

-- Question 13: Easy - ORDER BY
-- Concept: ORDER BY, ASC, DESC
-- ========================================
-- List all students ordered by GPA in descending order, then by name in ascending order.

-- ========================================

-- Question 14: Easy - DISTINCT
-- Concept: DISTINCT, Duplicate Removal
-- ========================================
-- Find all unique department names from the STUDENT table.

-- ========================================

-- Question 15: Easy - Simple Subquery
-- Concept: Subquery, IN
-- ========================================
-- Find all students who have taken courses (exist in GRADE_REPORT table).

-- ========================================

-- Question 16: Easy - Basic INSERT
-- Concept: INSERT, Data Manipulation
-- ========================================
-- Insert a new student with the following data:
-- student_id: 1016, name: 'Test Student', dept_id: 1, year_level: 'Freshman', enrollment_date: '2024-09-01', gpa: 3.0

-- ========================================

-- Question 17: Easy - Basic UPDATE
-- Concept: UPDATE, Data Manipulation
-- ========================================
-- Update the GPA of student with ID 1001 to 3.85.

-- ========================================

-- Question 18: Easy - Basic DELETE
-- Concept: DELETE, Data Manipulation
-- ========================================
-- Delete the student with ID 1016 (the test student you just inserted).

-- ========================================
-- COMPANY DATABASE QUESTIONS
-- ========================================

-- Question 19: Easy - Table Creation
-- Concept: DDL, Data Types, Primary Keys, UNIQUE
-- ========================================
-- Create the COMPANY_DEPARTMENT table with the following specifications:
-- - Dname (VARCHAR(25), NOT NULL, UNIQUE)
-- - Dnumber (INT, Primary Key)
-- - Mgr_ssn (CHAR(9), Foreign Key to EMPLOYEE - will be added later)
-- - Mgr_start_date (DATE)

-- ========================================

-- Question 20: Easy - Table Creation with Constraints
-- Concept: DDL, Foreign Keys, Check Constraints
-- ========================================
-- Create the EMPLOYEE table with proper constraints:
-- - Ssn (CHAR(9), Primary Key)
-- - Fname, Lname (VARCHAR(15), NOT NULL)
-- - Minit (CHAR(1))
-- - Bdate (DATE)
-- - Address (VARCHAR(30))
-- - Sex (CHAR(1))
-- - Salary (DECIMAL(10,2), must be > 0)
-- - Super_ssn (CHAR(9), Foreign Key to EMPLOYEE)
-- - Dno (INT, NOT NULL, Foreign Key to COMPANY_DEPARTMENT)

-- ========================================

-- Question 21: Easy - Table Creation
-- Concept: DDL, Primary Keys, Foreign Keys, UNIQUE
-- ========================================
-- Create the PROJECT table with the following specifications:
-- - Pname (VARCHAR(25), NOT NULL, UNIQUE)
-- - Pnumber (INT, Primary Key)
-- - Plocation (VARCHAR(15))
-- - Dnum (INT, NOT NULL, Foreign Key to COMPANY_DEPARTMENT)

-- ========================================

-- Question 22: Easy - Table Creation
-- Concept: DDL, Composite Primary Key, Foreign Keys, Check Constraints
-- ========================================
-- Create the WORKS_ON table with the following specifications:
-- - Essn (CHAR(9), NOT NULL, Foreign Key to EMPLOYEE)
-- - Pno (INT, NOT NULL, Foreign Key to PROJECT)
-- - Hours (DECIMAL(3,1), NOT NULL, must be > 0)
-- - Composite Primary Key: (Essn, Pno)

-- ========================================

-- Question 23: Easy - Table Creation
-- Concept: DDL, Composite Primary Key, Foreign Keys
-- ========================================
-- Create the DEPENDENT table with the following specifications:
-- - Essn (CHAR(9), NOT NULL, Foreign Key to EMPLOYEE)
-- - Dependent_name (VARCHAR(15), NOT NULL)
-- - Sex (CHAR(1))
-- - Bdate (DATE)
-- - Relationship (VARCHAR(8))
-- - Composite Primary Key: (Essn, Dependent_name)

-- ========================================

-- Question 24: Easy - Table Creation
-- Concept: DDL, Composite Primary Key, Foreign Keys
-- ========================================
-- Create the DEPT_LOCATIONS table with the following specifications:
-- - Dnumber (INT, NOT NULL, Foreign Key to COMPANY_DEPARTMENT)
-- - Dlocation (VARCHAR(15), NOT NULL)
-- - Composite Primary Key: (Dnumber, Dlocation)

-- ========================================

-- Question 25: Easy - Basic Filtering with WHERE
-- Concept: SELECT, WHERE, Comparison Operators
-- ========================================
-- Find all employees who earn more than $35,000 and work in department 5.

-- ========================================

-- Question 26: Easy - CROSS JOIN with WHERE Filtering
-- Concept: CROSS JOIN, WHERE filtering
-- ========================================
-- Find all employees who could potentially work on projects in Houston using CROSS JOIN.

-- ========================================

-- Question 27: Easy - Basic Filtering with WHERE
-- Concept: WHERE, Comparison Operators
-- ========================================
-- Find all employees whose first name starts with 'J'.

-- ========================================

-- Question 28: Easy - IN and NOT IN
-- Concept: WHERE, IN, NOT IN
-- ========================================
-- Find all employees who work in departments 1, 4, or 5.

-- ========================================

-- Question 29: Easy - BETWEEN and Date Functions
-- Concept: Date Functions, WHERE, BETWEEN
-- ========================================
-- Find all dependents who were born between 1980 and 1995.

-- ========================================

-- Question 30: Easy - NULL Handling
-- Concept: WHERE, IS NULL, IS NOT NULL
-- ========================================
-- Find all employees who have a NULL supervisor (Super_ssn is NULL).

-- ========================================

-- Question 31: Easy - ORDER BY
-- Concept: ORDER BY, ASC, DESC
-- ========================================
-- List all employees ordered by salary in descending order, then by last name in ascending order.

-- ========================================

-- Question 32: Easy - DISTINCT
-- Concept: DISTINCT, Duplicate Removal
-- ========================================
-- Find all unique department numbers from the EMPLOYEE table.

-- ========================================

-- Question 33: Easy - Simple Subquery
-- Concept: Subquery, IN
-- ========================================
-- Find all employees who have dependents (exist in DEPENDENT table).

-- ========================================

-- Question 34: Easy - Basic INSERT
-- Concept: INSERT, Data Manipulation
-- ========================================
-- Insert a new employee with the following data:
-- Ssn: '999999999', Fname: 'Test', Lname: 'Employee', Salary: 30000, Dno: 1

-- ========================================

-- Question 35: Easy - Basic UPDATE
-- Concept: UPDATE, Data Manipulation
-- ========================================
-- Update the salary of employee with SSN '123456789' to 32000.

-- ========================================

-- Question 36: Easy - Basic DELETE
-- Concept: DELETE, Data Manipulation
-- ========================================
-- Delete the employee with SSN '999999999' (the test employee you just inserted).

-- ========================================
-- END OF QUESTIONS
-- ========================================
-- 
-- Instructions:
-- 1. Use the provided sample data to test your queries
-- 2. Each question tests basic SQL concepts
-- 3. Difficulty level: All Easy - Basic SQL operations
-- 4. Focus: DDL, basic DML, CROSS JOIN, simple filtering
-- 5. No aggregate functions (COUNT, SUM, AVG, etc.)
-- 6. No complex JOINs (only CROSS JOIN)
-- 7. Test all queries with the sample data provided
-- 8. Total: 36 questions (18 from each schema)
-- ========================================
