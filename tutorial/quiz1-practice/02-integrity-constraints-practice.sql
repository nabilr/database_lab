-- ========================================
-- QUIZ 1 PRACTICE: INTEGRITY CONSTRAINTS
-- ========================================
-- Practice scenarios for understanding constraint violations
-- Load the schema first: mysql < employee-database-schema.sql

USE quiz1_practice;

-- ========================================
-- SECTION 1: PRIMARY KEY VIOLATIONS
-- ========================================

-- Practice Scenario 1.1: Duplicate Primary Key
-- Try to insert an employee with an existing SSN
-- PREDICTION: What will happen? Will this succeed or fail? Why?

-- YOUR PREDICTION:




-- Test it:
-- INSERT INTO EMPLOYEE (Fname, Lname, Ssn, Dno) 
-- VALUES ('John', 'Duplicate', '123456789', 5);

-- RESULT EXPLANATION:




-- Practice Scenario 1.2: NULL Primary Key
-- Try to insert an employee without an SSN (NULL primary key)
-- PREDICTION: What will happen?

-- YOUR PREDICTION:




-- Test it:
-- INSERT INTO EMPLOYEE (Fname, Lname, Ssn, Dno) 
-- VALUES ('Jane', 'NoSSN', NULL, 5);

-- RESULT EXPLANATION:




-- ========================================
-- SECTION 2: FOREIGN KEY VIOLATIONS
-- ========================================

-- Practice Scenario 2.1: Non-existent Department
-- Try to assign an employee to a department that doesn't exist
-- PREDICTION: What will happen?

-- YOUR PREDICTION:




-- Test it:
-- INSERT INTO EMPLOYEE (Fname, Lname, Ssn, Dno) 
-- VALUES ('Bob', 'NoDept', '111111111', 99);

-- RESULT EXPLANATION:




-- Practice Scenario 2.2: Non-existent Supervisor
-- Try to assign a supervisor who doesn't exist in the EMPLOYEE table
-- PREDICTION: What will happen?

-- YOUR PREDICTION:




-- Test it:
-- INSERT INTO EMPLOYEE (Fname, Lname, Ssn, Super_ssn, Dno) 
-- VALUES ('Alice', 'NoSuper', '222222222', '999999999', 5);

-- RESULT EXPLANATION:




-- Practice Scenario 2.3: Project with Non-existent Department
-- Try to create a project for a department that doesn't exist
-- PREDICTION: What will happen?

-- YOUR PREDICTION:




-- Test it:
-- INSERT INTO PROJECT (Pname, Pnumber, Dnum) 
-- VALUES ('Invalid Project', 999, 88);

-- RESULT EXPLANATION:




-- ========================================
-- SECTION 3: DELETE CASCADE EFFECTS
-- ========================================

-- Practice Scenario 3.1: Delete Department with Employees
-- What happens when we try to delete a department that has employees?
-- PREDICTION: Will this succeed? What about related records?

-- First, check what would be affected:
SELECT 'Employees in Research Dept' AS Description, COUNT(*) AS Count
FROM EMPLOYEE WHERE Dno = 5;

SELECT 'Projects in Research Dept' AS Description, COUNT(*) AS Count  
FROM PROJECT WHERE Dnum = 5;

-- YOUR PREDICTION:




-- Test it:
-- DELETE FROM DEPARTMENT WHERE Dnumber = 5;

-- RESULT EXPLANATION:




-- Practice Scenario 3.2: Delete Employee with Dependents
-- What happens when we delete an employee who has dependents?
-- PREDICTION: Will this succeed? What about the dependents?

-- Check what would be affected:
SELECT 'Dependents of John Smith' AS Description, COUNT(*) AS Count
FROM DEPENDENT WHERE Essn = '123456789';

-- YOUR PREDICTION:




-- Test it:
-- DELETE FROM EMPLOYEE WHERE Ssn = '123456789';

-- RESULT EXPLANATION:




-- Practice Scenario 3.3: Delete Employee Who Is a Supervisor
-- What happens when we delete an employee who supervises others?
-- PREDICTION: Will this succeed? What about supervised employees?

-- Check what would be affected:
SELECT 'Employees supervised by Wong' AS Description, COUNT(*) AS Count
FROM EMPLOYEE WHERE Super_ssn = '333445555';

-- YOUR PREDICTION:




-- Test it:
-- DELETE FROM EMPLOYEE WHERE Ssn = '333445555';

-- RESULT EXPLANATION:




-- ========================================
-- SECTION 4: UPDATE VIOLATIONS
-- ========================================

-- Practice Scenario 4.1: Update Primary Key to Existing Value
-- Try to change an employee's SSN to one that already exists
-- PREDICTION: What will happen?

-- YOUR PREDICTION:




-- Test it:
-- UPDATE EMPLOYEE SET Ssn = '987654321' WHERE Ssn = '123456789';

-- RESULT EXPLANATION:




-- Practice Scenario 4.2: Update Foreign Key to Non-existent Value
-- Try to change an employee's department to one that doesn't exist
-- PREDICTION: What will happen?

-- YOUR PREDICTION:




-- Test it:
-- UPDATE EMPLOYEE SET Dno = 99 WHERE Ssn = '123456789';

-- RESULT EXPLANATION:




-- Practice Scenario 4.3: Update Department Manager to Non-existent Employee
-- Try to set a department manager to an employee who doesn't exist
-- PREDICTION: What will happen?

-- YOUR PREDICTION:




-- Test it:
-- UPDATE DEPARTMENT SET Mgr_ssn = '999999999' WHERE Dnumber = 5;

-- RESULT EXPLANATION:




-- ========================================
-- SECTION 5: NULL VALUE HANDLING
-- ========================================

-- Practice Scenario 5.1: NULL in Foreign Key Column
-- What happens when we set a foreign key to NULL?
-- PREDICTION: Is this allowed? Why or why not?

-- YOUR PREDICTION:




-- Test it:
-- UPDATE EMPLOYEE SET Super_ssn = NULL WHERE Ssn = '123456789';

-- RESULT EXPLANATION:




-- Practice Scenario 5.2: NULL in NOT NULL Column
-- Try to set a required field to NULL
-- PREDICTION: What will happen?

-- YOUR PREDICTION:




-- Test it:
-- UPDATE EMPLOYEE SET Fname = NULL WHERE Ssn = '123456789';

-- RESULT EXPLANATION:




-- ========================================
-- SECTION 6: UNIQUE CONSTRAINT VIOLATIONS
-- ========================================

-- Practice Scenario 6.1: Duplicate Department Name
-- Try to create a department with a name that already exists
-- PREDICTION: What will happen?

-- YOUR PREDICTION:




-- Test it:
-- INSERT INTO DEPARTMENT (Dname, Dnumber) VALUES ('Research', 8);

-- RESULT EXPLANATION:




-- Practice Scenario 6.2: Duplicate Project Name
-- Try to create a project with a name that already exists
-- PREDICTION: What will happen?

-- YOUR PREDICTION:




-- Test it:
-- INSERT INTO PROJECT (Pname, Pnumber, Dnum) VALUES ('ProductX', 100, 5);

-- RESULT EXPLANATION:




-- ========================================
-- SECTION 7: COMPLEX CONSTRAINT SCENARIOS
-- ========================================

-- Practice Scenario 7.1: Circular Reference Issue
-- What happens when we try to insert a department manager before the employee exists?
-- This relates to the circular reference between DEPARTMENT and EMPLOYEE tables

-- Step 1: Try to insert a new department with a manager who doesn't exist yet
-- YOUR PREDICTION:




-- Test it:
-- INSERT INTO DEPARTMENT (Dname, Dnumber, Mgr_ssn) VALUES ('NewDept', 8, '555555555');

-- RESULT EXPLANATION:




-- Step 2: What if we insert the department first with NULL manager, then add employee, then update?
-- YOUR PREDICTION for this approach:




-- Practice Scenario 7.2: Work Assignment Violations
-- Try to assign an employee to work on a project when either doesn't exist

-- Test non-existent employee:
-- INSERT INTO WORKS_ON (Essn, Pno, Hours) VALUES ('999999999', 1, 20.0);

-- Test non-existent project:
-- INSERT INTO WORKS_ON (Essn, Pno, Hours) VALUES ('123456789', 999, 20.0);

-- YOUR PREDICTIONS AND EXPLANATIONS:




-- Practice Scenario 7.3: Dependent Constraint
-- Try to add a dependent for an employee who doesn't exist
-- YOUR PREDICTION:




-- Test it:
-- INSERT INTO DEPENDENT (Essn, Dependent_name, Relationship) 
-- VALUES ('999999999', 'John Jr', 'Son');

-- RESULT EXPLANATION:




-- ========================================
-- SECTION 8: CONSTRAINT MODIFICATION SCENARIOS
-- ========================================

-- Practice Scenario 8.1: What if we want to temporarily disable constraints?
-- Research how to disable foreign key checks in MySQL
-- When might this be useful? What are the risks?

-- YOUR RESEARCH AND EXPLANATION:




-- Practice Scenario 8.2: Adding new constraints to existing data
-- What happens when we try to add a new constraint that existing data violates?

-- Example: Try to add a CHECK constraint that salary must be > 20000
-- But we have employees earning exactly 25000
-- YOUR PREDICTION:




-- Test it (MySQL 8.0+):
-- ALTER TABLE EMPLOYEE ADD CONSTRAINT salary_check CHECK (Salary > 30000);

-- RESULT EXPLANATION:




-- ========================================
-- SECTION 9: REAL-WORLD SCENARIOS
-- ========================================

-- Scenario 9.1: Company Reorganization
-- A department is being dissolved. What steps are needed to safely delete it?
-- Consider: employees, projects, managers, etc.

-- YOUR STEP-BY-STEP PLAN:




-- Scenario 9.2: Employee Transfer
-- An employee is transferring to a different department. 
-- What constraints must be considered? What order of operations?

-- YOUR ANALYSIS:




-- Scenario 9.3: Project Cancellation
-- A project is being cancelled. What constraints are involved in deleting it?
-- Consider: work assignments, project dependencies, etc.

-- YOUR ANALYSIS:




-- ========================================
-- VERIFICATION AND TESTING QUERIES
-- ========================================

-- Check current constraint status
SELECT 
    TABLE_NAME,
    CONSTRAINT_NAME,
    CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
WHERE TABLE_SCHEMA = 'quiz1_practice'
ORDER BY TABLE_NAME, CONSTRAINT_TYPE;

-- Check foreign key relationships
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
WHERE TABLE_SCHEMA = 'quiz1_practice' 
AND REFERENCED_TABLE_NAME IS NOT NULL;

-- ========================================
-- PRACTICE COMPLETE!
-- ========================================
-- Review your predictions and explanations
-- Understanding WHY constraints work helps in database design
-- Next: 03-multiple-choice-practice.sql
