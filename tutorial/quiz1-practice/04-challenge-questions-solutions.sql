-- ========================================
-- SOLUTIONS: 04-challenge-questions-practice.sql
-- ========================================
-- Complete solutions for advanced challenge questions
-- Load the schema first: mysql < employee-database-schema.sql

USE quiz1_practice;

-- ========================================
-- SECTION 1: ADVANCED JOIN VARIATIONS
-- ========================================

-- Challenge 1.1: Modified Column Names
-- Find employees who work on all projects in 'Houston' but display results as:
-- Worker_Name, Worker_ID, Total_Houston_Projects, Department_Name

SELECT 
    CONCAT(e.Fname, ' ', e.Lname) AS Worker_Name,
    e.Ssn AS Worker_ID,
    COUNT(DISTINCT w.Pno) AS Total_Houston_Projects,
    d.Dname AS Department_Name
FROM EMPLOYEE e
JOIN WORKS_ON w ON e.Ssn = w.Essn
JOIN PROJECT p ON w.Pno = p.Pnumber
JOIN DEPARTMENT d ON e.Dno = d.Dnumber
WHERE p.Plocation = 'Houston'
GROUP BY e.Ssn, e.Fname, e.Lname, d.Dname
HAVING COUNT(DISTINCT w.Pno) = (
    SELECT COUNT(*) FROM PROJECT WHERE Plocation = 'Houston'
);

-- Challenge 1.2: Multiple Conditions
-- Find employees who work on more than 2 projects AND have at least 1 dependent AND
-- earn more than the average salary in their department

SELECT 
    CONCAT(e.Fname, ' ', e.Lname) AS Name,
    project_counts.Project_Count,
    COALESCE(dependent_counts.Dependent_Count, 0) AS Dependent_Count,
    e.Salary,
    dept_avg.Dept_Average_Salary
FROM EMPLOYEE e
JOIN (
    SELECT w.Essn, COUNT(w.Pno) AS Project_Count
    FROM WORKS_ON w
    GROUP BY w.Essn
    HAVING COUNT(w.Pno) > 2
) project_counts ON e.Ssn = project_counts.Essn
LEFT JOIN (
    SELECT d.Essn, COUNT(d.Dependent_name) AS Dependent_Count
    FROM DEPENDENT d
    GROUP BY d.Essn
) dependent_counts ON e.Ssn = dependent_counts.Essn
JOIN (
    SELECT Dno, AVG(Salary) AS Dept_Average_Salary
    FROM EMPLOYEE
    GROUP BY Dno
) dept_avg ON e.Dno = dept_avg.Dno
WHERE COALESCE(dependent_counts.Dependent_Count, 0) >= 1
AND e.Salary > dept_avg.Dept_Average_Salary;

-- Challenge 1.3: Complex Filtering
-- Find employees who work on projects in the same location where they live
-- Extract city from address field and match with project location

SELECT DISTINCT
    CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name,
    TRIM(SUBSTRING_INDEX(e.Address, ',', -1)) AS Home_City,
    p.Plocation AS Work_Location
FROM EMPLOYEE e
JOIN WORKS_ON w ON e.Ssn = w.Essn
JOIN PROJECT p ON w.Pno = p.Pnumber
WHERE TRIM(SUBSTRING_INDEX(e.Address, ',', -1)) = p.Plocation
ORDER BY e.Lname;

-- ========================================
-- SECTION 2: ADVANCED CONSTRAINT SCENARIOS
-- ========================================

-- Challenge 2.1: Multi-step Constraint Resolution
-- Design a sequence of operations to safely delete department 5 (Research)

-- Step 1: Analysis - what needs to be handled?
/*
ANALYSIS:
1. Employees assigned to department 5 (Research)
2. Projects controlled by department 5
3. Department manager (if any employee from dept 5 manages other departments)
4. Work assignments on department 5 projects
5. Supervisory relationships within department 5
*/

-- Check current dependencies:
SELECT 'Analysis: Dependencies to Handle' AS Step;

SELECT 'Employees in Research Dept' AS Item, COUNT(*) AS Count
FROM EMPLOYEE WHERE Dno = 5
UNION ALL
SELECT 'Projects in Research Dept', COUNT(*) 
FROM PROJECT WHERE Dnum = 5
UNION ALL
SELECT 'Work Assignments on Research Projects', COUNT(*)
FROM WORKS_ON w JOIN PROJECT p ON w.Pno = p.Pnumber WHERE p.Dnum = 5
UNION ALL
SELECT 'Departments managed by Research employees', COUNT(*)
FROM DEPARTMENT d JOIN EMPLOYEE e ON d.Mgr_ssn = e.Ssn WHERE e.Dno = 5;

-- Step 2: Complete sequence of SQL statements
/*
SAFE DELETION SEQUENCE:
*/

-- Step 2a: Handle department management (if Research employee manages other depts)
UPDATE DEPARTMENT 
SET Mgr_ssn = (
    SELECT Ssn FROM EMPLOYEE 
    WHERE Dno = 1 AND Super_ssn IS NULL 
    LIMIT 1
)
WHERE Mgr_ssn IN (
    SELECT Ssn FROM EMPLOYEE WHERE Dno = 5
) AND Dnumber != 5;

-- Step 2b: Reassign employees to other departments (preserve supervision hierarchy)
UPDATE EMPLOYEE 
SET Dno = 1, 
    Super_ssn = (
        SELECT Ssn FROM EMPLOYEE 
        WHERE Dno = 1 AND Super_ssn IS NULL 
        LIMIT 1
    )
WHERE Dno = 5 AND Super_ssn IS NOT NULL;

-- Step 2c: Handle top-level employees in department 5
UPDATE EMPLOYEE 
SET Dno = 4,
    Super_ssn = (
        SELECT Ssn FROM EMPLOYEE 
        WHERE Dno = 4 AND Super_ssn IS NULL 
        LIMIT 1
    )
WHERE Dno = 5 AND Super_ssn IS NULL;

-- Step 2d: Transfer projects to other departments
UPDATE PROJECT 
SET Dnum = 1 
WHERE Dnum = 5 AND Plocation = 'Houston';

UPDATE PROJECT 
SET Dnum = 4 
WHERE Dnum = 5 AND Plocation != 'Houston';

-- Step 2e: Verify no remaining dependencies
SELECT 'Verification: Remaining Dependencies' AS Step;
SELECT COUNT(*) AS Remaining_Employees FROM EMPLOYEE WHERE Dno = 5;
SELECT COUNT(*) AS Remaining_Projects FROM PROJECT WHERE Dnum = 5;

-- Step 2f: Finally delete the department
-- DELETE FROM DEPARTMENT WHERE Dnumber = 5;

-- Challenge 2.2: Constraint-aware Data Migration
-- Write INSERT statements that would violate constraints, then fix them

-- Violation Examples:
SELECT 'Constraint Violation Examples' AS Section;

-- Example 1: Primary Key Violation
-- INSERT INTO EMPLOYEE (Fname, Lname, Ssn, Dno) 
-- VALUES ('John', 'Duplicate', '123456789', 5);
-- Error: Duplicate primary key

-- Example 2: Foreign Key Violation
-- INSERT INTO EMPLOYEE (Fname, Lname, Ssn, Dno) 
-- VALUES ('Jane', 'InvalidDept', '999888777', 99);
-- Error: Department 99 doesn't exist

-- Example 3: NOT NULL Violation
-- INSERT INTO EMPLOYEE (Lname, Ssn, Dno) 
-- VALUES ('NoFirstName', '999888777', 5);
-- Error: Fname cannot be NULL

-- Example 4: Referential Integrity Violation
-- INSERT INTO WORKS_ON (Essn, Pno, Hours) 
-- VALUES ('999999999', 1, 20.0);
-- Error: Employee doesn't exist

-- Fixed Versions:
-- Fix 1: Use unique primary key
INSERT INTO EMPLOYEE (Fname, Lname, Ssn, Dno) 
VALUES ('John', 'NewEmployee', '999888777', 5);

-- Fix 2: Use existing department
INSERT INTO EMPLOYEE (Fname, Lname, Ssn, Dno) 
VALUES ('Jane', 'ValidDept', '999888778', 5);

-- Fix 3: Provide required fields
INSERT INTO EMPLOYEE (Fname, Lname, Ssn, Dno) 
VALUES ('First', 'Last', '999888779', 5);

-- Fix 4: Ensure referenced employee exists first
INSERT INTO WORKS_ON (Essn, Pno, Hours) 
VALUES ('999888777', 1, 20.0);

-- ========================================
-- SECTION 3: SCHEMA MODIFICATION CHALLENGES
-- ========================================

-- Challenge 3.1: Add New Constraints to Existing Schema

-- Constraint 1: Employee salary must be between 20,000 and 100,000
-- First check current salary range
SELECT 
    MIN(Salary) AS Min_Salary,
    MAX(Salary) AS Max_Salary,
    COUNT(*) AS Total_Employees,
    COUNT(CASE WHEN Salary BETWEEN 20000 AND 100000 THEN 1 END) AS Within_Range
FROM EMPLOYEE;

-- Add constraint (may fail if data violates it)
-- ALTER TABLE EMPLOYEE 
-- ADD CONSTRAINT salary_range_check 
-- CHECK (Salary BETWEEN 20000 AND 100000);

-- If constraint fails, first update violating data:
-- UPDATE EMPLOYEE SET Salary = 20000 WHERE Salary < 20000;
-- UPDATE EMPLOYEE SET Salary = 100000 WHERE Salary > 100000;

-- Constraint 2: Project names must start with 'Project_' or 'Product'
-- Check current project names
SELECT Pname, 
    CASE 
        WHEN Pname LIKE 'Project_%' OR Pname LIKE 'Product%' THEN 'Valid'
        ELSE 'Invalid'
    END AS Name_Status
FROM PROJECT;

-- Add constraint
-- ALTER TABLE PROJECT 
-- ADD CONSTRAINT project_naming_check 
-- CHECK (Pname LIKE 'Project_%' OR Pname LIKE 'Product%');

-- Constraint 3: Employees cannot supervise more than 5 direct reports
-- Check current supervision counts
SELECT 
    CONCAT(e.Fname, ' ', e.Lname) AS Supervisor,
    COUNT(sub.Ssn) AS Direct_Reports
FROM EMPLOYEE e
LEFT JOIN EMPLOYEE sub ON e.Ssn = sub.Super_ssn
GROUP BY e.Ssn, e.Fname, e.Lname
HAVING COUNT(sub.Ssn) > 0
ORDER BY Direct_Reports DESC;

-- This constraint is complex and typically implemented with triggers
-- CREATE TRIGGER check_supervision_limit 
-- BEFORE UPDATE ON EMPLOYEE
-- FOR EACH ROW
-- BEGIN
--     IF (SELECT COUNT(*) FROM EMPLOYEE WHERE Super_ssn = NEW.Super_ssn) >= 5 THEN
--         SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Supervisor cannot have more than 5 direct reports';
--     END IF;
-- END;

-- Challenge 3.2: Create Additional Tables with Complex Constraints

CREATE TABLE SKILLS (
    Skill_id INT PRIMARY KEY AUTO_INCREMENT,
    Skill_name VARCHAR(50) NOT NULL UNIQUE,
    Category VARCHAR(30) NOT NULL,
    Difficulty_level ENUM('Beginner', 'Intermediate', 'Advanced', 'Expert') DEFAULT 'Beginner',
    Description TEXT,
    Created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT skill_name_format CHECK (CHAR_LENGTH(Skill_name) >= 2),
    CONSTRAINT category_format CHECK (Category IN ('Technical', 'Management', 'Communication', 'Other'))
);

CREATE TABLE EMPLOYEE_SKILLS (
    Essn CHAR(9) NOT NULL,
    Skill_id INT NOT NULL,
    Proficiency_level ENUM('Beginner', 'Intermediate', 'Advanced', 'Expert') NOT NULL,
    Date_acquired DATE NOT NULL,
    Years_experience DECIMAL(3,1) DEFAULT 0.0,
    Certified BOOLEAN DEFAULT FALSE,
    
    PRIMARY KEY (Essn, Skill_id),
    FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Skill_id) REFERENCES SKILLS(Skill_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    
    CONSTRAINT experience_realistic CHECK (Years_experience >= 0 AND Years_experience <= 50),
    CONSTRAINT date_not_future CHECK (Date_acquired <= CURDATE()),
    CONSTRAINT proficiency_experience_match CHECK (
        (Proficiency_level = 'Beginner' AND Years_experience <= 2) OR
        (Proficiency_level = 'Intermediate' AND Years_experience >= 1) OR
        (Proficiency_level = 'Advanced' AND Years_experience >= 3) OR
        (Proficiency_level = 'Expert' AND Years_experience >= 5)
    )
);

CREATE TABLE TRAINING_PROGRAMS (
    Program_id INT PRIMARY KEY AUTO_INCREMENT,
    Program_name VARCHAR(100) NOT NULL UNIQUE,
    Duration_hours INT NOT NULL,
    Cost DECIMAL(8,2) NOT NULL,
    Provider VARCHAR(50) NOT NULL,
    Skill_id INT,
    Max_participants INT DEFAULT 20,
    
    FOREIGN KEY (Skill_id) REFERENCES SKILLS(Skill_id) 
        ON DELETE SET NULL ON UPDATE CASCADE,
    
    CONSTRAINT duration_positive CHECK (Duration_hours > 0),
    CONSTRAINT cost_reasonable CHECK (Cost >= 0 AND Cost <= 10000),
    CONSTRAINT participants_limit CHECK (Max_participants > 0 AND Max_participants <= 100)
);

-- ========================================
-- SECTION 4: DDL RECONSTRUCTION CHALLENGE
-- ========================================

-- Challenge 4.1: Reverse Engineer DDL
-- Complete DDL statements for e-commerce system:

CREATE TABLE CUSTOMER (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(20),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT email_format CHECK (email LIKE '%@%.%'),
    CONSTRAINT name_not_empty CHECK (CHAR_LENGTH(TRIM(name)) > 0)
);

CREATE TABLE PRODUCT (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    price DECIMAL(10,2) NOT NULL,
    category VARCHAR(50) NOT NULL,
    description TEXT,
    stock_quantity INT DEFAULT 0,
    
    CONSTRAINT price_positive CHECK (price > 0),
    CONSTRAINT stock_non_negative CHECK (stock_quantity >= 0),
    CONSTRAINT name_not_empty CHECK (CHAR_LENGTH(TRIM(name)) > 0)
);

CREATE TABLE ORDER_TABLE (  -- ORDER is a reserved word
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE DEFAULT (CURDATE()),
    status ENUM('pending', 'shipped', 'delivered') DEFAULT 'pending',
    total_amount DECIMAL(10,2) DEFAULT 0.00,
    
    FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT total_amount_non_negative CHECK (total_amount >= 0)
);

CREATE TABLE ORDER_ITEM (
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES ORDER_TABLE(order_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (product_id) REFERENCES PRODUCT(product_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    CONSTRAINT quantity_positive CHECK (quantity > 0),
    CONSTRAINT price_positive_item CHECK (price > 0)
);

-- Challenge 4.2: Optimize Schema for Query Performance
-- Add appropriate indexes to support common queries:

-- 1. Find all orders for a specific customer
CREATE INDEX idx_order_customer ON ORDER_TABLE(customer_id, order_date);

-- 2. Find all products in a specific category
CREATE INDEX idx_product_category ON PRODUCT(category, name);

-- 3. Find order items by product name (requires join optimization)
CREATE INDEX idx_order_item_product ON ORDER_ITEM(product_id, order_id);
CREATE INDEX idx_product_name ON PRODUCT(name);

-- 4. Find customers by email domain
CREATE INDEX idx_customer_email ON CUSTOMER(email);

-- Additional performance indexes
CREATE INDEX idx_order_status_date ON ORDER_TABLE(status, order_date);
CREATE INDEX idx_product_price ON PRODUCT(price);

-- ========================================
-- SECTION 5: COMPLEX QUERY CHALLENGES
-- ========================================

-- Challenge 5.1: Recursive Query Simulation
-- Find all employees in the hierarchy under 'James E Borg'

-- Level 1: Direct reports to James Borg
SELECT 1 AS Level, 
    CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name,
    e.Ssn,
    'James E Borg' AS Reports_To
FROM EMPLOYEE e
JOIN EMPLOYEE boss ON e.Super_ssn = boss.Ssn
WHERE CONCAT(boss.Fname, ' ', boss.Lname) = 'James E Borg'

UNION ALL

-- Level 2: Reports to direct reports of James Borg
SELECT 2 AS Level,
    CONCAT(e2.Fname, ' ', e2.Lname) AS Employee_Name,
    e2.Ssn,
    CONCAT(e1.Fname, ' ', e1.Lname) AS Reports_To
FROM EMPLOYEE e2
JOIN EMPLOYEE e1 ON e2.Super_ssn = e1.Ssn
JOIN EMPLOYEE boss ON e1.Super_ssn = boss.Ssn
WHERE CONCAT(boss.Fname, ' ', boss.Lname) = 'James E Borg'

UNION ALL

-- Level 3: Continue for additional levels as needed
SELECT 3 AS Level,
    CONCAT(e3.Fname, ' ', e3.Lname) AS Employee_Name,
    e3.Ssn,
    CONCAT(e2.Fname, ' ', e2.Lname) AS Reports_To
FROM EMPLOYEE e3
JOIN EMPLOYEE e2 ON e3.Super_ssn = e2.Ssn
JOIN EMPLOYEE e1 ON e2.Super_ssn = e1.Ssn
JOIN EMPLOYEE boss ON e1.Super_ssn = boss.Ssn
WHERE CONCAT(boss.Fname, ' ', boss.Lname) = 'James E Borg'

ORDER BY Level, Employee_Name;

-- Challenge 5.2: Division Operation Implementation

-- Approach 1: Using NOT EXISTS
SELECT CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name
FROM EMPLOYEE e
WHERE NOT EXISTS (
    SELECT p.Pnumber
    FROM PROJECT p
    WHERE p.Plocation = 'Houston'
    AND NOT EXISTS (
        SELECT w.Pno
        FROM WORKS_ON w
        WHERE w.Essn = e.Ssn AND w.Pno = p.Pnumber
    )
);

-- Approach 2: Using COUNT comparison
SELECT CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name
FROM EMPLOYEE e
WHERE (
    SELECT COUNT(DISTINCT w.Pno)
    FROM WORKS_ON w
    JOIN PROJECT p ON w.Pno = p.Pnumber
    WHERE w.Essn = e.Ssn AND p.Plocation = 'Houston'
) = (
    SELECT COUNT(*)
    FROM PROJECT
    WHERE Plocation = 'Houston'
);

-- Approach 3: Using set operations (simulated with subqueries)
SELECT CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name
FROM EMPLOYEE e
WHERE e.Ssn IN (
    SELECT w.Essn
    FROM WORKS_ON w
    JOIN PROJECT p ON w.Pno = p.Pnumber
    WHERE p.Plocation = 'Houston'
    GROUP BY w.Essn
    HAVING COUNT(DISTINCT w.Pno) = (
        SELECT COUNT(*) FROM PROJECT WHERE Plocation = 'Houston'
    )
);

-- Challenge 5.3: Complex Aggregation - Comprehensive Department Report
SELECT 
    d.Dname AS Department_Name,
    CONCAT(mgr.Fname, ' ', mgr.Lname) AS Manager_Name,
    COUNT(DISTINCT e.Ssn) AS Total_Employees,
    COUNT(DISTINCT p.Pnumber) AS Total_Projects,
    COALESCE(SUM(w.Hours), 0) AS Total_Work_Hours,
    ROUND(AVG(e.Salary), 2) AS Average_Salary,
    MAX(e.Salary) AS Highest_Salary,
    MIN(e.Salary) AS Lowest_Salary,
    COUNT(DISTINCT dep.Essn) AS Employees_With_Dependents,
    GROUP_CONCAT(DISTINCT p.Plocation ORDER BY p.Plocation SEPARATOR ', ') AS Project_Locations
FROM DEPARTMENT d
LEFT JOIN EMPLOYEE mgr ON d.Mgr_ssn = mgr.Ssn
LEFT JOIN EMPLOYEE e ON d.Dnumber = e.Dno
LEFT JOIN PROJECT p ON d.Dnumber = p.Dnum
LEFT JOIN WORKS_ON w ON e.Ssn = w.Essn
LEFT JOIN DEPENDENT dep ON e.Ssn = dep.Essn
GROUP BY d.Dnumber, d.Dname, mgr.Fname, mgr.Lname
ORDER BY d.Dname;

-- ========================================
-- SECTION 6: DATA VALIDATION CHALLENGES
-- ========================================

-- Challenge 6.1: Data Quality Checks

-- Data Quality Query 1: Employees with suspicious salary values
SELECT 
    CONCAT(Fname, ' ', Lname) AS Employee_Name,
    Salary,
    CASE 
        WHEN Salary < 15000 THEN 'Suspiciously Low'
        WHEN Salary > 200000 THEN 'Suspiciously High'
        WHEN Salary IS NULL THEN 'Missing Salary'
        ELSE 'Normal Range'
    END AS Salary_Assessment,
    d.Dname AS Department
FROM EMPLOYEE e
JOIN DEPARTMENT d ON e.Dno = d.Dnumber
WHERE Salary < 15000 OR Salary > 200000 OR Salary IS NULL
ORDER BY Salary_Assessment, Salary;

-- Data Quality Query 2: Projects with no assigned employees
SELECT 
    p.Pname AS Unassigned_Project,
    p.Plocation AS Location,
    d.Dname AS Controlling_Department
FROM PROJECT p
JOIN DEPARTMENT d ON p.Dnum = d.Dnumber
LEFT JOIN WORKS_ON w ON p.Pnumber = w.Pno
WHERE w.Pno IS NULL;

-- Data Quality Query 3: Employees with inconsistent address formats
SELECT 
    CONCAT(Fname, ' ', Lname) AS Employee_Name,
    Address,
    CASE 
        WHEN Address NOT LIKE '%,%' THEN 'Missing comma'
        WHEN Address LIKE ',%' OR Address LIKE '%,' THEN 'Improper comma placement'
        WHEN CHAR_LENGTH(Address) < 10 THEN 'Too short'
        WHEN Address REGEXP '[0-9]' = 0 THEN 'No street number'
        ELSE 'Format OK'
    END AS Address_Issue
FROM EMPLOYEE
WHERE Address NOT LIKE '%,%' 
   OR Address LIKE ',%' 
   OR Address LIKE '%,' 
   OR CHAR_LENGTH(Address) < 10
   OR Address REGEXP '[0-9]' = 0;

-- Data Quality Query 4: Circular supervision chains
SELECT 
    CONCAT(e1.Fname, ' ', e1.Lname) AS Employee1,
    CONCAT(e2.Fname, ' ', e2.Lname) AS Employee2,
    'Potential Circular Reference' AS Issue
FROM EMPLOYEE e1
JOIN EMPLOYEE e2 ON e1.Super_ssn = e2.Ssn
WHERE e2.Super_ssn = e1.Ssn;

-- Challenge 6.2: Constraint Validation Queries

-- Validation Query 1: No orphaned foreign key references
SELECT 'Orphaned Employee Departments' AS Check_Type,
    COUNT(*) AS Violation_Count
FROM EMPLOYEE e
LEFT JOIN DEPARTMENT d ON e.Dno = d.Dnumber
WHERE d.Dnumber IS NULL

UNION ALL

SELECT 'Orphaned Employee Supervisors',
    COUNT(*)
FROM EMPLOYEE e
LEFT JOIN EMPLOYEE s ON e.Super_ssn = s.Ssn
WHERE e.Super_ssn IS NOT NULL AND s.Ssn IS NULL

UNION ALL

SELECT 'Orphaned Work Assignments (Employee)',
    COUNT(*)
FROM WORKS_ON w
LEFT JOIN EMPLOYEE e ON w.Essn = e.Ssn
WHERE e.Ssn IS NULL

UNION ALL

SELECT 'Orphaned Work Assignments (Project)',
    COUNT(*)
FROM WORKS_ON w
LEFT JOIN PROJECT p ON w.Pno = p.Pnumber
WHERE p.Pnumber IS NULL;

-- Validation Query 2: All required fields have values
SELECT 'Missing Required Fields' AS Check_Type,
    SUM(CASE WHEN Fname IS NULL OR Fname = '' THEN 1 ELSE 0 END) AS Missing_FirstName,
    SUM(CASE WHEN Lname IS NULL OR Lname = '' THEN 1 ELSE 0 END) AS Missing_LastName,
    SUM(CASE WHEN Ssn IS NULL THEN 1 ELSE 0 END) AS Missing_SSN,
    SUM(CASE WHEN Dno IS NULL THEN 1 ELSE 0 END) AS Missing_Department
FROM EMPLOYEE;

-- Validation Query 3: All unique constraints satisfied
SELECT 'Duplicate SSNs' AS Check_Type, COUNT(*) - COUNT(DISTINCT Ssn) AS Duplicates
FROM EMPLOYEE
UNION ALL
SELECT 'Duplicate Department Names', COUNT(*) - COUNT(DISTINCT Dname)
FROM DEPARTMENT
UNION ALL
SELECT 'Duplicate Department Numbers', COUNT(*) - COUNT(DISTINCT Dnumber)
FROM DEPARTMENT;

-- Validation Query 4: Business rules followed
SELECT 'Business Rule Violations' AS Check_Type,
    SUM(CASE WHEN Hours < 0 OR Hours > 40 THEN 1 ELSE 0 END) AS Invalid_Work_Hours,
    SUM(CASE WHEN Salary < 0 THEN 1 ELSE 0 END) AS Negative_Salaries
FROM WORKS_ON w
CROSS JOIN EMPLOYEE e;

-- ========================================
-- SECTION 7: PERFORMANCE OPTIMIZATION CHALLENGES
-- ========================================

-- Challenge 7.1: Query Optimization
-- Original inefficient query with comma joins:
/*
SELECT e.Fname, e.Lname, d.Dname, p.Pname
FROM EMPLOYEE e, DEPARTMENT d, PROJECT p, WORKS_ON w
WHERE e.Dno = d.Dnumber 
AND e.Ssn = w.Essn 
AND w.Pno = p.Pnumber
AND d.Dname = 'Research'
AND p.Plocation = 'Houston';
*/

-- Optimized Version with proper JOINs and filtering:
SELECT e.Fname, e.Lname, d.Dname, p.Pname
FROM DEPARTMENT d
INNER JOIN EMPLOYEE e ON d.Dnumber = e.Dno
INNER JOIN WORKS_ON w ON e.Ssn = w.Essn
INNER JOIN PROJECT p ON w.Pno = p.Pnumber
WHERE d.Dname = 'Research'
AND p.Plocation = 'Houston';

-- Further optimization with EXISTS for better performance:
SELECT e.Fname, e.Lname, d.Dname, p.Pname
FROM EMPLOYEE e
INNER JOIN DEPARTMENT d ON e.Dno = d.Dnumber
INNER JOIN WORKS_ON w ON e.Ssn = w.Essn
INNER JOIN PROJECT p ON w.Pno = p.Pnumber
WHERE d.Dname = 'Research'
AND p.Plocation = 'Houston'
AND EXISTS (
    SELECT 1 FROM DEPARTMENT WHERE Dnumber = e.Dno AND Dname = 'Research'
);

-- Challenge 7.2: Index Strategy
-- Comprehensive index strategy for the employee database:

-- Primary performance indexes
CREATE INDEX idx_employee_dno_name ON EMPLOYEE(Dno, Lname, Fname);
CREATE INDEX idx_employee_super ON EMPLOYEE(Super_ssn);
CREATE INDEX idx_works_on_employee ON WORKS_ON(Essn);
CREATE INDEX idx_works_on_project ON WORKS_ON(Pno);
CREATE INDEX idx_project_location ON PROJECT(Plocation);
CREATE INDEX idx_project_department ON PROJECT(Dnum);
CREATE INDEX idx_department_name ON DEPARTMENT(Dname);
CREATE INDEX idx_department_manager ON DEPARTMENT(Mgr_ssn);
CREATE INDEX idx_dependent_employee ON DEPENDENT(Essn);

-- Composite indexes for common query patterns
CREATE INDEX idx_employee_dept_salary ON EMPLOYEE(Dno, Salary);
CREATE INDEX idx_works_on_composite ON WORKS_ON(Essn, Pno, Hours);
CREATE INDEX idx_project_dept_location ON PROJECT(Dnum, Plocation);

-- Covering indexes for specific queries
CREATE INDEX idx_employee_cover_basic ON EMPLOYEE(Dno, Fname, Lname, Ssn);

-- ========================================
-- SECTION 8: ADVANCED CONSTRAINT DESIGN
-- ========================================

-- Challenge 8.1: Business Rule Implementation

-- Business Rule 1: Manager must earn more than supervised employees
-- This requires a trigger since CHECK constraints can't use subqueries effectively
DELIMITER //
CREATE TRIGGER check_manager_salary
BEFORE UPDATE ON EMPLOYEE
FOR EACH ROW
BEGIN
    DECLARE manager_salary DECIMAL(10,2);
    
    IF NEW.Super_ssn IS NOT NULL THEN
        SELECT Salary INTO manager_salary 
        FROM EMPLOYEE 
        WHERE Ssn = NEW.Super_ssn;
        
        IF NEW.Salary >= manager_salary THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Employee salary cannot be greater than or equal to supervisor salary';
        END IF;
    END IF;
END//
DELIMITER ;

-- Business Rule 2: Total work hours per employee cannot exceed 40 per week
-- This also requires a trigger for enforcement
DELIMITER //
CREATE TRIGGER check_total_hours
BEFORE INSERT ON WORKS_ON
FOR EACH ROW
BEGIN
    DECLARE total_hours DECIMAL(5,1);
    
    SELECT COALESCE(SUM(Hours), 0) INTO total_hours
    FROM WORKS_ON
    WHERE Essn = NEW.Essn;
    
    IF (total_hours + NEW.Hours) > 40 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Total work hours cannot exceed 40 per week';
    END IF;
END//
DELIMITER ;

-- Business Rule 3: Dependents must be younger than the employee
-- Requires adding birth_date columns and constraint
-- ALTER TABLE EMPLOYEE ADD COLUMN birth_date DATE;
-- ALTER TABLE DEPENDENT ADD COLUMN birth_date DATE;
-- ALTER TABLE DEPENDENT ADD CONSTRAINT dependent_age_check 
-- CHECK (birth_date > (SELECT birth_date FROM EMPLOYEE WHERE Ssn = Essn));

-- Business Rule 4: Department managers must work in the department they manage
ALTER TABLE DEPARTMENT 
ADD CONSTRAINT manager_in_department 
CHECK (
    Mgr_ssn IS NULL OR 
    Mgr_ssn IN (SELECT Ssn FROM EMPLOYEE WHERE Dno = Dnumber)
);

-- Challenge 8.2: Temporal Constraints
-- Extend the schema with temporal fields and constraints:

-- Add temporal fields
ALTER TABLE EMPLOYEE 
ADD COLUMN hire_date DATE DEFAULT (CURDATE()),
ADD COLUMN birth_date DATE;

ALTER TABLE PROJECT 
ADD COLUMN start_date DATE DEFAULT (CURDATE()),
ADD COLUMN end_date DATE;

ALTER TABLE DEPARTMENT 
ADD COLUMN manager_start_date DATE;

-- Add temporal constraints
ALTER TABLE EMPLOYEE 
ADD CONSTRAINT hire_date_not_future CHECK (hire_date <= CURDATE()),
ADD CONSTRAINT realistic_age CHECK (birth_date <= DATE_SUB(CURDATE(), INTERVAL 16 YEAR));

ALTER TABLE PROJECT 
ADD CONSTRAINT project_date_order CHECK (end_date IS NULL OR start_date <= end_date),
ADD CONSTRAINT start_date_realistic CHECK (start_date >= '1900-01-01');

-- ========================================
-- SOLUTIONS COMPLETE!
-- ========================================
-- These challenge solutions demonstrate:
-- - Advanced query techniques and optimization
-- - Complex constraint design and implementation
-- - Schema modification and enhancement strategies  
-- - Data validation and quality assurance methods
-- - Performance optimization through proper indexing
-- - Real-world business rule implementation
-- ========================================
