-- ========================================
-- MIDTERM REVIEW DATABASE SCHEMA
-- ========================================
-- Contains both STUDENT-COURSE and COMPANY schemas
-- for comprehensive SQL practice

CREATE DATABASE IF NOT EXISTS midterm_review;
USE midterm_review;

-- ========================================
-- STUDENT-COURSE DATABASE SCHEMA
-- ========================================

-- Departments table
CREATE TABLE DEPARTMENT (
    dept_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    budget DECIMAL(12,2),
    building VARCHAR(50)
);

-- Students table
CREATE TABLE STUDENT (
    student_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dept_id INT,
    year_level ENUM('Freshman','Sophomore','Junior','Senior') DEFAULT 'Freshman',
    enrollment_date DATE,
    gpa DECIMAL(3,2),
    FOREIGN KEY (dept_id) REFERENCES DEPARTMENT(dept_id)
);

-- Courses table
CREATE TABLE COURSE (
    course_id INT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    credits TINYINT NOT NULL CHECK (credits BETWEEN 1 AND 6),
    dept_id INT NOT NULL,
    description TEXT,
    FOREIGN KEY (dept_id) REFERENCES DEPARTMENT(dept_id)
);

-- Prerequisites table
CREATE TABLE PREREQUISITE (
    course_id INT NOT NULL,
    prereq_id INT NOT NULL,
    PRIMARY KEY (course_id, prereq_id),
    FOREIGN KEY (course_id) REFERENCES COURSE(course_id) ON DELETE CASCADE,
    FOREIGN KEY (prereq_id) REFERENCES COURSE(course_id) ON DELETE RESTRICT
);

-- Sections table
CREATE TABLE SECTION (
    section_id INT PRIMARY KEY,
    course_id INT NOT NULL,
    term ENUM('Spring','Summer','Fall') NOT NULL,
    year_num YEAR NOT NULL,
    capacity INT DEFAULT 30,
    instructor_name VARCHAR(100),
    FOREIGN KEY (course_id) REFERENCES COURSE(course_id)
);

-- Grade report table
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
-- COMPANY DATABASE SCHEMA
-- ========================================

-- Department table
CREATE TABLE COMPANY_DEPARTMENT (
    Dname VARCHAR(25) NOT NULL,
    Dnumber INT PRIMARY KEY,
    Mgr_ssn CHAR(9),
    Mgr_start_date DATE,
    UNIQUE (Dname)
);

-- Employee table
CREATE TABLE EMPLOYEE (
    Fname VARCHAR(15) NOT NULL,
    Minit CHAR(1),
    Lname VARCHAR(15) NOT NULL,
    Ssn CHAR(9) PRIMARY KEY,
    Bdate DATE,
    Address VARCHAR(30),
    Sex CHAR(1),
    Salary DECIMAL(10,2),
    Super_ssn CHAR(9),
    Dno INT NOT NULL,
    FOREIGN KEY (Super_ssn) REFERENCES EMPLOYEE(Ssn),
    FOREIGN KEY (Dno) REFERENCES COMPANY_DEPARTMENT(Dnumber)
);

-- Add foreign key from DEPARTMENT to EMPLOYEE (circular reference)
ALTER TABLE COMPANY_DEPARTMENT 
ADD FOREIGN KEY (Mgr_ssn) REFERENCES EMPLOYEE(Ssn);

-- Project table
CREATE TABLE PROJECT (
    Pname VARCHAR(25) NOT NULL UNIQUE,
    Pnumber INT PRIMARY KEY,
    Plocation VARCHAR(15),
    Dnum INT NOT NULL,
    FOREIGN KEY (Dnum) REFERENCES COMPANY_DEPARTMENT(Dnumber)
);

-- Works on table (Many-to-Many relationship)
CREATE TABLE WORKS_ON (
    Essn CHAR(9),
    Pno INT,
    Hours DECIMAL(3,1) NOT NULL,
    PRIMARY KEY (Essn, Pno),
    FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn),
    FOREIGN KEY (Pno) REFERENCES PROJECT(Pnumber)
);

-- Dependent table
CREATE TABLE DEPENDENT (
    Essn CHAR(9),
    Dependent_name VARCHAR(15),
    Sex CHAR(1),
    Bdate DATE,
    Relationship VARCHAR(8),
    PRIMARY KEY (Essn, Dependent_name),
    FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn)
);

-- Department locations table
CREATE TABLE DEPT_LOCATIONS (
    Dnumber INT NOT NULL,
    Dlocation VARCHAR(15) NOT NULL,
    PRIMARY KEY (Dnumber, Dlocation),
    FOREIGN KEY (Dnumber) REFERENCES COMPANY_DEPARTMENT(Dnumber)
);

-- ========================================
-- INDEXES FOR PERFORMANCE
-- ========================================

-- Student-Course indexes
CREATE INDEX idx_student_dept ON STUDENT(dept_id);
CREATE INDEX idx_course_dept ON COURSE(dept_id);
CREATE INDEX idx_grade_student ON GRADE_REPORT(student_id);
CREATE INDEX idx_grade_course ON GRADE_REPORT(course_id);
CREATE INDEX idx_section_course ON SECTION(course_id);

-- Company indexes
CREATE INDEX idx_employee_dno ON EMPLOYEE(Dno);
CREATE INDEX idx_employee_super ON EMPLOYEE(Super_ssn);
CREATE INDEX idx_project_dnum ON PROJECT(Dnum);
CREATE INDEX idx_works_on_essn ON WORKS_ON(Essn);
CREATE INDEX idx_works_on_pno ON WORKS_ON(Pno);
CREATE INDEX idx_dependent_essn ON DEPENDENT(Essn);

-- ========================================
-- VIEWS FOR COMMON QUERIES
-- ========================================

-- Student details with department
CREATE VIEW StudentDetails AS
SELECT 
    s.student_id, s.name, s.year_level, s.gpa,
    d.name AS department_name, d.building
FROM STUDENT s
JOIN DEPARTMENT d ON s.dept_id = d.dept_id;

-- Employee details with department and manager
CREATE VIEW EmployeeDetails AS
SELECT 
    e.Fname, e.Minit, e.Lname, e.Ssn, e.Salary,
    d.Dname AS Department,
    CONCAT(m.Fname, ' ', m.Lname) AS Manager_Name
FROM EMPLOYEE e
JOIN COMPANY_DEPARTMENT d ON e.Dno = d.Dnumber
LEFT JOIN EMPLOYEE m ON e.Super_ssn = m.Ssn;

-- Project assignments summary
CREATE VIEW ProjectAssignments AS
SELECT 
    CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name,
    e.Ssn,
    p.Pname AS Project_Name,
    p.Plocation AS Project_Location,
    w.Hours,
    d.Dname AS Department
FROM EMPLOYEE e
JOIN WORKS_ON w ON e.Ssn = w.Essn
JOIN PROJECT p ON w.Pno = p.Pnumber
JOIN COMPANY_DEPARTMENT d ON e.Dno = d.Dnumber;
