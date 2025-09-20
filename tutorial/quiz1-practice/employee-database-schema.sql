-- ========================================
-- QUIZ 1 PRACTICE: EMPLOYEE DATABASE SCHEMA
-- ========================================
-- Complete schema for practicing joins, constraints, and integrity violations
-- Based on classic EMPLOYEE-DEPARTMENT-PROJECT database design

-- Section 1: Database Setup
-- ========================================

CREATE DATABASE IF NOT EXISTS quiz1_practice;
USE quiz1_practice;

-- Drop tables if they exist (for clean restart)
DROP TABLE IF EXISTS WORKS_ON;
DROP TABLE IF EXISTS DEPENDENT;
DROP TABLE IF EXISTS PROJECT;
DROP TABLE IF EXISTS EMPLOYEE;
DROP TABLE IF EXISTS DEPARTMENT;

-- Section 2: Core Tables with Integrity Constraints
-- ========================================

-- 2.1 DEPARTMENT Table
CREATE TABLE DEPARTMENT (
    Dname VARCHAR(25) NOT NULL,
    Dnumber INT PRIMARY KEY,
    Mgr_ssn CHAR(9),
    Mgr_start_date DATE,
    UNIQUE (Dname)
);

-- 2.2 EMPLOYEE Table
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
    
    -- Foreign key constraints
    FOREIGN KEY (Super_ssn) REFERENCES EMPLOYEE(Ssn),
    FOREIGN KEY (Dno) REFERENCES DEPARTMENT(Dnumber)
);

-- 2.3 Add foreign key from DEPARTMENT to EMPLOYEE (circular reference)
ALTER TABLE DEPARTMENT 
ADD FOREIGN KEY (Mgr_ssn) REFERENCES EMPLOYEE(Ssn);

-- 2.4 PROJECT Table
CREATE TABLE PROJECT (
    Pname VARCHAR(25) NOT NULL UNIQUE,
    Pnumber INT PRIMARY KEY,
    Plocation VARCHAR(15),
    Dnum INT NOT NULL,
    
    FOREIGN KEY (Dnum) REFERENCES DEPARTMENT(Dnumber)
);

-- 2.5 WORKS_ON Table (Many-to-Many relationship)
CREATE TABLE WORKS_ON (
    Essn CHAR(9),
    Pno INT,
    Hours DECIMAL(3,1) NOT NULL,
    
    PRIMARY KEY (Essn, Pno),
    FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn),
    FOREIGN KEY (Pno) REFERENCES PROJECT(Pnumber)
);

-- 2.6 DEPENDENT Table
CREATE TABLE DEPENDENT (
    Essn CHAR(9),
    Dependent_name VARCHAR(15),
    Sex CHAR(1),
    Bdate DATE,
    Relationship VARCHAR(8),
    
    PRIMARY KEY (Essn, Dependent_name),
    FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn)
);

-- Section 3: Sample Data for Practice
-- ========================================

-- 3.1 Insert Departments (Note: Mgr_ssn will be updated after employees are inserted)
INSERT INTO DEPARTMENT (Dname, Dnumber, Mgr_ssn, Mgr_start_date) VALUES
('Research', 5, NULL, '1988-05-22'),
('Administration', 4, NULL, '1995-01-01'),
('Headquarters', 1, NULL, '1981-06-19'),
('Software', 6, NULL, '1999-05-15'),
('Hardware', 7, NULL, '2000-03-01');

-- 3.2 Insert Employees
INSERT INTO EMPLOYEE (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno) VALUES
('John', 'B', 'Smith', '123456789', '1965-01-09', '731 Fondren, Houston, TX', 'M', 30000, NULL, 5),
('Franklin', 'T', 'Wong', '333445555', '1955-12-08', '638 Voss, Houston, TX', 'M', 40000, NULL, 5),
('Alicia', 'J', 'Zelaya', '999887777', '1968-01-19', '3321 Castle, Spring, TX', 'F', 25000, '333445555', 4),
('Jennifer', 'S', 'Wallace', '987654321', '1941-06-20', '291 Berry, Bellaire, TX', 'F', 43000, NULL, 4),
('Ramesh', 'K', 'Narayan', '666884444', '1962-09-15', '975 Fire Oak, Humble, TX', 'M', 38000, '333445555', 5),
('Joyce', 'A', 'English', '453453453', '1972-07-31', '5631 Rice, Houston, TX', 'F', 25000, '333445555', 5),
('Ahmad', 'V', 'Jabbar', '987987987', '1969-03-29', '980 Dallas, Houston, TX', 'M', 25000, '987654321', 4),
('James', 'E', 'Borg', '888665555', '1937-11-10', '450 Stone, Houston, TX', 'M', 55000, NULL, 1),
('Robert', 'F', 'Scott', '444444400', '1942-06-15', '563 Rice, Houston, TX', 'M', 58000, '888665555', 1),
('Maria', 'D', 'Rodriguez', '444444401', '1959-04-15', '123 Main, Dallas, TX', 'F', 45000, '888665555', 6),
('David', 'S', 'Johnson', '444444402', '1963-08-22', '456 Oak, Austin, TX', 'M', 42000, '444444401', 6),
('Lisa', 'M', 'Anderson', '444444403', '1970-12-03', '789 Pine, Houston, TX', 'F', 35000, '444444401', 7),
('Michael', 'T', 'Brown', '444444404', '1967-05-18', '321 Elm, Dallas, TX', 'M', 48000, '888665555', 7);

-- 3.3 Update Department Managers
UPDATE DEPARTMENT SET Mgr_ssn = '333445555' WHERE Dnumber = 5;  -- Research
UPDATE DEPARTMENT SET Mgr_ssn = '987654321' WHERE Dnumber = 4;  -- Administration  
UPDATE DEPARTMENT SET Mgr_ssn = '888665555' WHERE Dnumber = 1;  -- Headquarters
UPDATE DEPARTMENT SET Mgr_ssn = '444444401' WHERE Dnumber = 6;  -- Software
UPDATE DEPARTMENT SET Mgr_ssn = '444444404' WHERE Dnumber = 7;  -- Hardware

-- 3.4 Update Employee Supervisors
UPDATE EMPLOYEE SET Super_ssn = '888665555' WHERE Ssn = '333445555';  -- Wong reports to Borg
UPDATE EMPLOYEE SET Super_ssn = '888665555' WHERE Ssn = '987654321';  -- Wallace reports to Borg
UPDATE EMPLOYEE SET Super_ssn = '333445555' WHERE Ssn = '123456789';  -- Smith reports to Wong

-- 3.5 Insert Projects
INSERT INTO PROJECT (Pname, Pnumber, Plocation, Dnum) VALUES
('ProductX', 1, 'Bellaire', 5),
('ProductY', 2, 'Sugarland', 5),
('ProductZ', 3, 'Houston', 5),
('Computerization', 10, 'Stafford', 4),
('Reorganization', 20, 'Houston', 1),
('Newbenefits', 30, 'Stafford', 4),
('Software Development', 40, 'Houston', 6),
('Hardware Testing', 50, 'Dallas', 7),
('Mobile App', 60, 'Austin', 6),
('Network Security', 70, 'Houston', 7);

-- 3.6 Insert Work Assignments
INSERT INTO WORKS_ON (Essn, Pno, Hours) VALUES
('123456789', 1, 32.5),
('123456789', 2, 7.5),
('666884444', 3, 40.0),
('453453453', 1, 20.0),
('453453453', 2, 20.0),
('333445555', 2, 10.0),
('333445555', 3, 10.0),
('333445555', 10, 10.0),
('333445555', 20, 10.0),
('999887777', 30, 30.0),
('999887777', 10, 10.0),
('987987987', 10, 35.0),
('987987987', 30, 5.0),
('987654321', 30, 20.0),
('987654321', 20, 15.0),
('888665555', 20, 16.0),
('444444401', 40, 40.0),
('444444402', 40, 20.0),
('444444402', 60, 20.0),
('444444403', 50, 40.0),
('444444404', 50, 30.0),
('444444404', 70, 10.0);

-- 3.7 Insert Dependents
INSERT INTO DEPENDENT (Essn, Dependent_name, Sex, Bdate, Relationship) VALUES
('333445555', 'Alice', 'F', '1986-04-05', 'Daughter'),
('333445555', 'Theodore', 'M', '1983-10-25', 'Son'),
('333445555', 'Joy', 'F', '1958-05-03', 'Spouse'),
('987654321', 'Abner', 'M', '1942-02-28', 'Spouse'),
('123456789', 'Michael', 'M', '1988-01-04', 'Son'),
('123456789', 'Alice', 'F', '1988-12-30', 'Daughter'),
('123456789', 'Elizabeth', 'F', '1967-05-05', 'Spouse'),
('444444401', 'Carlos', 'M', '1985-03-15', 'Son'),
('444444401', 'Sofia', 'F', '1960-08-20', 'Spouse'),
('444444403', 'Emma', 'F', '1995-07-12', 'Daughter');

-- Section 4: Views for Common Queries
-- ========================================

-- 4.1 Employee Details with Department and Manager Information
CREATE VIEW EmployeeDetails AS
SELECT 
    e.Fname, e.Minit, e.Lname, e.Ssn, e.Salary,
    d.Dname AS Department,
    CONCAT(m.Fname, ' ', m.Lname) AS Manager_Name,
    m.Ssn AS Manager_Ssn
FROM EMPLOYEE e
JOIN DEPARTMENT d ON e.Dno = d.Dnumber
LEFT JOIN EMPLOYEE m ON e.Super_ssn = m.Ssn;

-- 4.2 Project Assignments Summary
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
JOIN DEPARTMENT d ON e.Dno = d.Dnumber;

-- Section 5: Indexes for Performance
-- ========================================

-- 5.1 Common query indexes
CREATE INDEX idx_employee_dno ON EMPLOYEE(Dno);
CREATE INDEX idx_employee_super ON EMPLOYEE(Super_ssn);
CREATE INDEX idx_project_dnum ON PROJECT(Dnum);
CREATE INDEX idx_works_on_essn ON WORKS_ON(Essn);
CREATE INDEX idx_works_on_pno ON WORKS_ON(Pno);
CREATE INDEX idx_dependent_essn ON DEPENDENT(Essn);

-- Section 6: Verification Queries
-- ========================================

-- 6.1 Show all tables
SHOW TABLES;

-- 6.2 Show table structures
DESCRIBE EMPLOYEE;
DESCRIBE DEPARTMENT;
DESCRIBE PROJECT;
DESCRIBE WORKS_ON;
DESCRIBE DEPENDENT;

-- 6.3 Quick data verification
SELECT 'Employees' AS Table_Name, COUNT(*) AS Record_Count FROM EMPLOYEE
UNION ALL
SELECT 'Departments', COUNT(*) FROM DEPARTMENT
UNION ALL
SELECT 'Projects', COUNT(*) FROM PROJECT
UNION ALL
SELECT 'Work Assignments', COUNT(*) FROM WORKS_ON
UNION ALL
SELECT 'Dependents', COUNT(*) FROM DEPENDENT;

-- 6.4 Sample join to verify relationships work
SELECT 
    CONCAT(e.Fname, ' ', e.Lname) AS Employee,
    d.Dname AS Department,
    COUNT(w.Pno) AS Projects_Count
FROM EMPLOYEE e
JOIN DEPARTMENT d ON e.Dno = d.Dnumber
LEFT JOIN WORKS_ON w ON e.Ssn = w.Essn
GROUP BY e.Ssn, e.Fname, e.Lname, d.Dname
ORDER BY e.Lname, e.Fname;

-- ========================================
-- SCHEMA READY FOR QUIZ 1 PRACTICE!
-- ========================================
-- This schema includes:
-- - Proper primary and foreign key constraints
-- - Circular references (Department-Employee)
-- - Many-to-many relationships (Employee-Project)
-- - Sample data for comprehensive testing
-- - Views for common query patterns
-- - Indexes for performance
-- 
-- Use this as the foundation for practicing:
-- 1. Complex joins and filtering
-- 2. Integrity constraint violations  
-- 3. Multiple choice reasoning
-- 4. Challenge questions and DDL
-- ========================================
