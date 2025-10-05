-- ========================================
-- MIDTERM REVIEW ANSWERS
-- SQL Database Design and Querying Solutions (Basic Level)
-- ========================================
-- Complete solutions for all 36 questions

USE midterm_review;

-- ========================================
-- STUDENT-COURSE DATABASE ANSWERS
-- ========================================

-- Question 1: Easy - Table Creation
-- Concept: DDL, Data Types, Primary Keys
-- ========================================
CREATE TABLE DEPARTMENT (
    dept_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    budget DECIMAL(12,2),
    building VARCHAR(50)
);

-- ========================================

-- Question 2: Easy - Table Creation
-- Concept: DDL, Data Types, Primary Keys, Foreign Keys
-- ========================================
CREATE TABLE STUDENT (
    student_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dept_id INT,
    year_level ENUM('Freshman','Sophomore','Junior','Senior') DEFAULT 'Freshman',
    enrollment_date DATE,
    gpa DECIMAL(3,2),
    FOREIGN KEY (dept_id) REFERENCES DEPARTMENT(dept_id)
);

-- ========================================

-- Question 3: Easy - Table Creation
-- Concept: DDL, Data Types, Primary Keys, Foreign Keys
-- ========================================
CREATE TABLE COURSE (
    course_id INT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    credits TINYINT NOT NULL CHECK (credits BETWEEN 1 AND 6),
    dept_id INT NOT NULL,
    description TEXT,
    FOREIGN KEY (dept_id) REFERENCES DEPARTMENT(dept_id)
);

-- ========================================

-- Question 4: Easy - Table Creation
-- Concept: DDL, Composite Primary Key, Foreign Keys
-- ========================================
CREATE TABLE PREREQUISITE (
    course_id INT NOT NULL,
    prereq_id INT NOT NULL,
    PRIMARY KEY (course_id, prereq_id),
    FOREIGN KEY (course_id) REFERENCES COURSE(course_id),
    FOREIGN KEY (prereq_id) REFERENCES COURSE(course_id)
);

-- ========================================

-- Question 5: Easy - Table Creation
-- Concept: DDL, Data Types, Primary Keys, Foreign Keys
-- ========================================
CREATE TABLE SECTION (
    section_id INT PRIMARY KEY,
    course_id INT NOT NULL,
    term ENUM('Spring','Summer','Fall') NOT NULL,
    year_num YEAR NOT NULL,
    capacity INT DEFAULT 30,
    instructor_name VARCHAR(100),
    FOREIGN KEY (course_id) REFERENCES COURSE(course_id)
);

-- ========================================

-- Question 6: Easy - Table Creation
-- Concept: DDL, Composite Primary Key, Foreign Keys, Check Constraints
-- ========================================
CREATE TABLE GRADE_REPORT (
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    section_id INT NOT NULL,
    grade DECIMAL(5,2) CHECK (grade >= 0 AND grade <= 100),
    semester VARCHAR(10),
    year_num YEAR,
    PRIMARY KEY (student_id, course_id, section_id),
    FOREIGN KEY (student_id) REFERENCES STUDENT(student_id),
    FOREIGN KEY (course_id) REFERENCES COURSE(course_id),
    FOREIGN KEY (section_id) REFERENCES SECTION(section_id)
);

-- ========================================

-- Question 7: Easy - Basic SELECT with WHERE
-- Concept: SELECT, WHERE, LIKE
-- ========================================
SELECT student_id, name, year_level
FROM STUDENT 
WHERE name LIKE 'A%' 
  AND year_level IN ('Junior', 'Senior');

-- Expected Result: Alice Johnson (1001, Junior)

-- ========================================

-- Question 8: Easy - CROSS JOIN with WHERE Filtering
-- Concept: CROSS JOIN, WHERE filtering
-- ========================================
SELECT s.student_id, s.name, sec.section_id, sec.term, sec.year_num
FROM STUDENT s
CROSS JOIN SECTION sec
JOIN COURSE c ON sec.course_id = c.course_id
JOIN DEPARTMENT d ON c.dept_id = d.dept_id
WHERE d.name = 'Computer Science';

-- Expected Result: All students who could enroll in Computer Science sections

-- ========================================

-- Question 9: Easy - Basic Filtering with WHERE
-- Concept: WHERE, Comparison Operators
-- ========================================
SELECT student_id, name, gpa
FROM STUDENT
WHERE gpa > 3.5;

-- Expected Result: Students with GPA > 3.5

-- ========================================

-- Question 10: Easy - IN and NOT IN
-- Concept: WHERE, IN, NOT IN
-- ========================================
SELECT student_id, name, dept_id
FROM STUDENT
WHERE dept_id NOT IN (1, 2);

-- Expected Result: Students not in Computer Science (1) or Mathematics (2) departments

-- ========================================

-- Question 11: Easy - BETWEEN and Date Functions
-- Concept: WHERE, BETWEEN, Date Functions
-- ========================================
SELECT student_id, name, enrollment_date
FROM STUDENT
WHERE YEAR(enrollment_date) BETWEEN 2022 AND 2023;

-- Expected Result: Students enrolled between 2022-2023

-- ========================================

-- Question 12: Easy - NULL Handling
-- Concept: WHERE, IS NULL, IS NOT NULL
-- ========================================
SELECT student_id, name, gpa
FROM STUDENT
WHERE gpa IS NULL;

-- Expected Result: Students with NULL GPA

-- ========================================

-- Question 13: Easy - ORDER BY
-- Concept: ORDER BY, ASC, DESC
-- ========================================
SELECT student_id, name, gpa
FROM STUDENT
ORDER BY gpa DESC, name ASC;

-- Expected Result: Students ordered by GPA (desc) then name (asc)

-- ========================================

-- Question 14: Easy - DISTINCT
-- Concept: DISTINCT, Duplicate Removal
-- ========================================
SELECT DISTINCT dept_id
FROM STUDENT;

-- Expected Result: Unique department IDs from STUDENT table

-- ========================================

-- Question 15: Easy - Simple Subquery
-- Concept: Subquery, IN
-- ========================================
SELECT student_id, name
FROM STUDENT
WHERE student_id IN (
    SELECT student_id
    FROM GRADE_REPORT
);

-- Expected Result: Students who have taken courses

-- ========================================

-- Question 16: Easy - Basic INSERT
-- Concept: INSERT, Data Manipulation
-- ========================================
INSERT INTO STUDENT (student_id, name, dept_id, year_level, enrollment_date, gpa)
VALUES (1016, 'Test Student', 1, 'Freshman', '2024-09-01', 3.0);

-- Expected Result: New student inserted

-- ========================================

-- Question 17: Easy - Basic UPDATE
-- Concept: UPDATE, Data Manipulation
-- ========================================
UPDATE STUDENT
SET gpa = 3.85
WHERE student_id = 1001;

-- Expected Result: Alice Johnson's GPA updated to 3.85

-- ========================================

-- Question 18: Easy - Basic DELETE
-- Concept: DELETE, Data Manipulation
-- ========================================
DELETE FROM STUDENT
WHERE student_id = 1016;

-- Expected Result: Test student deleted

-- ========================================
-- COMPANY DATABASE ANSWERS
-- ========================================

-- Question 19: Easy - Table Creation
-- Concept: DDL, Data Types, Primary Keys, UNIQUE
-- ========================================
CREATE TABLE COMPANY_DEPARTMENT (
    Dname VARCHAR(25) NOT NULL UNIQUE,
    Dnumber INT PRIMARY KEY,
    Mgr_ssn CHAR(9),
    Mgr_start_date DATE
);

-- ========================================

-- Question 20: Easy - Table Creation with Constraints
-- Concept: DDL, Foreign Keys, Check Constraints
-- ========================================
CREATE TABLE EMPLOYEE (
    Ssn CHAR(9) PRIMARY KEY,
    Fname VARCHAR(15) NOT NULL,
    Lname VARCHAR(15) NOT NULL,
    Minit CHAR(1),
    Bdate DATE,
    Address VARCHAR(30),
    Sex CHAR(1),
    Salary DECIMAL(10,2) CHECK (Salary > 0),
    Super_ssn CHAR(9),
    Dno INT NOT NULL,
    FOREIGN KEY (Super_ssn) REFERENCES EMPLOYEE(Ssn),
    FOREIGN KEY (Dno) REFERENCES COMPANY_DEPARTMENT(Dnumber)
);

-- ========================================

-- Question 21: Easy - Table Creation
-- Concept: DDL, Primary Keys, Foreign Keys, UNIQUE
-- ========================================
CREATE TABLE PROJECT (
    Pname VARCHAR(25) NOT NULL UNIQUE,
    Pnumber INT PRIMARY KEY,
    Plocation VARCHAR(15),
    Dnum INT NOT NULL,
    FOREIGN KEY (Dnum) REFERENCES COMPANY_DEPARTMENT(Dnumber)
);

-- ========================================

-- Question 22: Easy - Table Creation
-- Concept: DDL, Composite Primary Key, Foreign Keys, Check Constraints
-- ========================================
CREATE TABLE WORKS_ON (
    Essn CHAR(9) NOT NULL,
    Pno INT NOT NULL,
    Hours DECIMAL(3,1) NOT NULL CHECK (Hours > 0),
    PRIMARY KEY (Essn, Pno),
    FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn),
    FOREIGN KEY (Pno) REFERENCES PROJECT(Pnumber)
);

-- ========================================

-- Question 23: Easy - Table Creation
-- Concept: DDL, Composite Primary Key, Foreign Keys
-- ========================================
CREATE TABLE DEPENDENT (
    Essn CHAR(9) NOT NULL,
    Dependent_name VARCHAR(15) NOT NULL,
    Sex CHAR(1),
    Bdate DATE,
    Relationship VARCHAR(8),
    PRIMARY KEY (Essn, Dependent_name),
    FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn)
);

-- ========================================

-- Question 24: Easy - Table Creation
-- Concept: DDL, Composite Primary Key, Foreign Keys
-- ========================================
CREATE TABLE DEPT_LOCATIONS (
    Dnumber INT NOT NULL,
    Dlocation VARCHAR(15) NOT NULL,
    PRIMARY KEY (Dnumber, Dlocation),
    FOREIGN KEY (Dnumber) REFERENCES COMPANY_DEPARTMENT(Dnumber)
);

-- ========================================

-- Question 25: Easy - Basic Filtering with WHERE
-- Concept: SELECT, WHERE, Comparison Operators
-- ========================================
SELECT Fname, Lname, Salary
FROM EMPLOYEE
WHERE Salary > 35000 AND Dno = 5;

-- Expected Result: Franklin Wong, Ramesh Narayan (Research dept, salary > 35000)

-- ========================================

-- Question 26: Easy - CROSS JOIN with WHERE Filtering
-- Concept: CROSS JOIN, WHERE filtering
-- ========================================
SELECT e.Ssn, e.Fname, e.Lname, p.Pnumber, p.Pname, p.Plocation
FROM EMPLOYEE e
CROSS JOIN PROJECT p
WHERE p.Plocation = 'Houston';

-- Expected Result: All employees who could work on Houston projects

-- ========================================

-- Question 27: Easy - Basic Filtering with WHERE
-- Concept: WHERE, Comparison Operators
-- ========================================
SELECT Ssn, Fname, Lname
FROM EMPLOYEE
WHERE Fname LIKE 'J%';

-- Expected Result: Employees whose first name starts with 'J'

-- ========================================

-- Question 28: Easy - IN and NOT IN
-- Concept: WHERE, IN, NOT IN
-- ========================================
SELECT Ssn, Fname, Lname, Dno
FROM EMPLOYEE
WHERE Dno IN (1, 4, 5);

-- Expected Result: Employees in departments 1, 4, or 5

-- ========================================

-- Question 29: Easy - BETWEEN and Date Functions
-- Concept: Date Functions, WHERE, BETWEEN
-- ========================================
SELECT Dependent_name, Bdate, Relationship
FROM DEPENDENT
WHERE YEAR(Bdate) BETWEEN 1980 AND 1995;

-- Expected Result: Dependents born between 1980-1995

-- ========================================

-- Question 30: Easy - NULL Handling
-- Concept: WHERE, IS NULL, IS NOT NULL
-- ========================================
SELECT Ssn, Fname, Lname, Super_ssn
FROM EMPLOYEE
WHERE Super_ssn IS NULL;

-- Expected Result: Employees with no supervisor (top-level managers)

-- ========================================

-- Question 31: Easy - ORDER BY
-- Concept: ORDER BY, ASC, DESC
-- ========================================
SELECT Ssn, Fname, Lname, Salary
FROM EMPLOYEE
ORDER BY Salary DESC, Lname ASC;

-- Expected Result: Employees ordered by salary (desc) then last name (asc)

-- ========================================

-- Question 32: Easy - DISTINCT
-- Concept: DISTINCT, Duplicate Removal
-- ========================================
SELECT DISTINCT Dno
FROM EMPLOYEE;

-- Expected Result: Unique department numbers from EMPLOYEE table

-- ========================================

-- Question 33: Easy - Simple Subquery
-- Concept: Subquery, IN
-- ========================================
SELECT Ssn, Fname, Lname
FROM EMPLOYEE
WHERE Ssn IN (
    SELECT Essn
    FROM DEPENDENT
);

-- Expected Result: Employees who have dependents

-- ========================================

-- Question 34: Easy - Basic INSERT
-- Concept: INSERT, Data Manipulation
-- ========================================
INSERT INTO EMPLOYEE (Ssn, Fname, Lname, Salary, Dno)
VALUES ('999999999', 'Test', 'Employee', 30000, 1);

-- Expected Result: New employee inserted

-- ========================================

-- Question 35: Easy - Basic UPDATE
-- Concept: UPDATE, Data Manipulation
-- ========================================
UPDATE EMPLOYEE
SET Salary = 32000
WHERE Ssn = '123456789';

-- Expected Result: John Smith's salary updated to 32000

-- ========================================

-- Question 36: Easy - Basic DELETE
-- Concept: DELETE, Data Manipulation
-- ========================================
DELETE FROM EMPLOYEE
WHERE Ssn = '999999999';

-- Expected Result: Test employee deleted

-- ========================================
-- END OF ANSWERS
-- ========================================
-- 
-- Summary:
-- - 36 complete solutions with expected results
-- - All Easy level - Basic SQL operations
-- - Focus: DDL, basic DML, CROSS JOIN, simple filtering
-- - No aggregate functions or complex JOINs
-- - Test all queries with the provided sample data
-- ========================================
