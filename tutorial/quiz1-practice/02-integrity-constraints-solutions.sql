-- ========================================
-- SOLUTIONS: 02-integrity-constraints-practice.sql
-- ========================================
-- Complete solutions and explanations for integrity constraint practice scenarios
-- Load the schema first: mysql < employee-database-schema.sql

USE quiz1_practice;

-- ========================================
-- SECTION 1: PRIMARY KEY VIOLATIONS
-- ========================================

-- Practice Scenario 1.1: Duplicate Primary Key
-- PREDICTION: This will FAIL with a duplicate entry error
-- Primary keys must be unique, and '123456789' already exists

-- Test it:
-- INSERT INTO EMPLOYEE (Fname, Lname, Ssn, Dno) 
-- VALUES ('John', 'Duplicate', '123456789', 5);

-- RESULT EXPLANATION:
-- Error: Duplicate entry '123456789' for key 'PRIMARY'
-- The database enforces entity integrity by rejecting duplicate primary key values

-- Practice Scenario 1.2: NULL Primary Key
-- PREDICTION: This will FAIL with a "cannot be null" error
-- Primary key attributes cannot contain NULL values

-- Test it:
-- INSERT INTO EMPLOYEE (Fname, Lname, Ssn, Dno) 
-- VALUES ('Jane', 'NoSSN', NULL, 5);

-- RESULT EXPLANATION:
-- Error: Column 'Ssn' cannot be null
-- Entity integrity requires primary keys to be NOT NULL and UNIQUE

-- ========================================
-- SECTION 2: FOREIGN KEY VIOLATIONS
-- ========================================

-- Practice Scenario 2.1: Non-existent Department
-- PREDICTION: This will FAIL with a foreign key constraint violation
-- Department 99 doesn't exist in the DEPARTMENT table

-- Test it:
-- INSERT INTO EMPLOYEE (Fname, Lname, Ssn, Dno) 
-- VALUES ('Bob', 'NoDept', '111111111', 99);

-- RESULT EXPLANATION:
-- Error: Cannot add or update a child row: a foreign key constraint fails
-- Referential integrity requires foreign key values to exist in referenced table

-- Practice Scenario 2.2: Non-existent Supervisor
-- PREDICTION: This will FAIL with a foreign key constraint violation
-- Employee with SSN '999999999' doesn't exist

-- Test it:
-- INSERT INTO EMPLOYEE (Fname, Lname, Ssn, Super_ssn, Dno) 
-- VALUES ('Alice', 'NoSuper', '222222222', '999999999', 5);

-- RESULT EXPLANATION:
-- Error: Cannot add or update a child row: a foreign key constraint fails
-- Self-referencing foreign key still requires the referenced value to exist

-- Practice Scenario 2.3: Project with Non-existent Department
-- PREDICTION: This will FAIL with a foreign key constraint violation
-- Department 88 doesn't exist

-- Test it:
-- INSERT INTO PROJECT (Pname, Pnumber, Dnum) 
-- VALUES ('Invalid Project', 999, 88);

-- RESULT EXPLANATION:
-- Error: Cannot add or update a child row: a foreign key constraint fails
-- All foreign key references must point to valid primary key values

-- ========================================
-- SECTION 3: DELETE CASCADE EFFECTS
-- ========================================

-- Practice Scenario 3.1: Delete Department with Employees
-- PREDICTION: This will FAIL because employees reference this department
-- Without CASCADE DELETE, cannot delete parent records with children

-- First, check what would be affected:
SELECT 'Employees in Research Dept' AS Description, COUNT(*) AS Count
FROM EMPLOYEE WHERE Dno = 5;

SELECT 'Projects in Research Dept' AS Description, COUNT(*) AS Count  
FROM PROJECT WHERE Dnum = 5;

-- ANALYSIS: Research department has 4 employees and 3 projects

-- Test it:
-- DELETE FROM DEPARTMENT WHERE Dnumber = 5;

-- RESULT EXPLANATION:
-- Error: Cannot delete or update a parent row: a foreign key constraint fails
-- Must handle dependent records first (reassign employees, transfer projects)

-- SAFE DELETION APPROACH:
-- Step 1: Reassign employees to other departments
-- UPDATE EMPLOYEE SET Dno = 1 WHERE Dno = 5;
-- Step 2: Transfer projects to other departments
-- UPDATE PROJECT SET Dnum = 1 WHERE Dnum = 5;
-- Step 3: Update any manager references
-- UPDATE DEPARTMENT SET Mgr_ssn = NULL WHERE Mgr_ssn IN (SELECT Ssn FROM EMPLOYEE WHERE Dno = 5);
-- Step 4: Now safe to delete
-- DELETE FROM DEPARTMENT WHERE Dnumber = 5;

-- Practice Scenario 3.2: Delete Employee with Dependents
-- PREDICTION: This depends on the CASCADE setting for DEPENDENT table
-- If CASCADE DELETE is set, dependents will be automatically deleted

-- Check what would be affected:
SELECT 'Dependents of John Smith' AS Description, COUNT(*) AS Count
FROM DEPENDENT WHERE Essn = '123456789';

-- Test it:
-- DELETE FROM EMPLOYEE WHERE Ssn = '123456789';

-- RESULT EXPLANATION:
-- If ON DELETE CASCADE: Employee and dependents both deleted successfully
-- If ON DELETE RESTRICT/NO ACTION: Error - cannot delete parent row
-- Current schema likely has CASCADE, so deletion succeeds with dependent cleanup

-- Practice Scenario 3.3: Delete Employee Who Is a Supervisor
-- PREDICTION: This will likely FAIL unless CASCADE is set for supervisor relationship
-- Supervised employees would become orphaned

-- Check what would be affected:
SELECT 'Employees supervised by Wong' AS Description, COUNT(*) AS Count
FROM EMPLOYEE WHERE Super_ssn = '333445555';

-- Test it:
-- DELETE FROM EMPLOYEE WHERE Ssn = '333445555';

-- RESULT EXPLANATION:
-- Error: Cannot delete or update a parent row: a foreign key constraint fails
-- Must first handle supervised employees (reassign or set Super_ssn to NULL)

-- ========================================
-- SECTION 4: UPDATE VIOLATIONS
-- ========================================

-- Practice Scenario 4.1: Update Primary Key to Existing Value
-- PREDICTION: This will FAIL with a duplicate entry error
-- Cannot change primary key to a value that already exists

-- Test it:
-- UPDATE EMPLOYEE SET Ssn = '987654321' WHERE Ssn = '123456789';

-- RESULT EXPLANATION:
-- Error: Duplicate entry '987654321' for key 'PRIMARY'
-- Primary key uniqueness is enforced even during updates

-- Practice Scenario 4.2: Update Foreign Key to Non-existent Value
-- PREDICTION: This will FAIL with a foreign key constraint violation
-- Department 99 doesn't exist

-- Test it:
-- UPDATE EMPLOYEE SET Dno = 99 WHERE Ssn = '123456789';

-- RESULT EXPLANATION:
-- Error: Cannot add or update a child row: a foreign key constraint fails
-- All foreign key updates must reference valid primary key values

-- Practice Scenario 4.3: Update Department Manager to Non-existent Employee
-- PREDICTION: This will FAIL with a foreign key constraint violation
-- Employee '999999999' doesn't exist

-- Test it:
-- UPDATE DEPARTMENT SET Mgr_ssn = '999999999' WHERE Dnumber = 5;

-- RESULT EXPLANATION:
-- Error: Cannot add or update a child row: a foreign key constraint fails
-- Manager must be a valid employee in the EMPLOYEE table

-- ========================================
-- SECTION 5: NULL VALUE HANDLING
-- ========================================

-- Practice Scenario 5.1: NULL in Foreign Key Column
-- PREDICTION: This will SUCCEED
-- Foreign keys can be NULL unless explicitly restricted with NOT NULL

-- Test it:
-- UPDATE EMPLOYEE SET Super_ssn = NULL WHERE Ssn = '123456789';

-- RESULT EXPLANATION:
-- Success: UPDATE completed successfully
-- NULL values are allowed in foreign key columns (represents "no supervisor")
-- This is different from primary keys which cannot be NULL

-- Practice Scenario 5.2: NULL in NOT NULL Column
-- PREDICTION: This will FAIL with a "cannot be null" error
-- Fname is defined as NOT NULL

-- Test it:
-- UPDATE EMPLOYEE SET Fname = NULL WHERE Ssn = '123456789';

-- RESULT EXPLANATION:
-- Error: Column 'Fname' cannot be null
-- NOT NULL constraints prevent NULL values regardless of key type

-- ========================================
-- SECTION 6: UNIQUE CONSTRAINT VIOLATIONS
-- ========================================

-- Practice Scenario 6.1: Duplicate Department Name
-- PREDICTION: This will FAIL with a duplicate entry error
-- Department names must be unique

-- Test it:
-- INSERT INTO DEPARTMENT (Dname, Dnumber) VALUES ('Research', 8);

-- RESULT EXPLANATION:
-- Error: Duplicate entry 'Research' for key 'Dname'
-- UNIQUE constraints prevent duplicate values in specified columns

-- Practice Scenario 6.2: Duplicate Project Name
-- PREDICTION: This will FAIL if project names have UNIQUE constraint
-- Otherwise it might succeed (depends on schema definition)

-- Test it:
-- INSERT INTO PROJECT (Pname, Pnumber, Dnum) VALUES ('ProductX', 100, 5);

-- RESULT EXPLANATION:
-- If UNIQUE constraint exists: Error - Duplicate entry for key
-- If no UNIQUE constraint: Success - duplicate names allowed
-- Check schema: SHOW CREATE TABLE PROJECT;

-- ========================================
-- SECTION 7: COMPLEX CONSTRAINT SCENARIOS
-- ========================================

-- Practice Scenario 7.1: Circular Reference Issue
-- PREDICTION: This will FAIL with a foreign key constraint violation
-- Cannot reference an employee who doesn't exist yet

-- Test it:
-- INSERT INTO DEPARTMENT (Dname, Dnumber, Mgr_ssn) VALUES ('NewDept', 8, '555555555');

-- RESULT EXPLANATION:
-- Error: Cannot add or update a child row: a foreign key constraint fails
-- Employee '555555555' must exist before being referenced as manager

-- SOLUTION APPROACH:
-- Step 1: Insert department with NULL manager
-- INSERT INTO DEPARTMENT (Dname, Dnumber, Mgr_ssn) VALUES ('NewDept', 8, NULL);
-- Step 2: Insert the employee
-- INSERT INTO EMPLOYEE (Fname, Lname, Ssn, Dno) VALUES ('Manager', 'New', '555555555', 8);
-- Step 3: Update department with manager
-- UPDATE DEPARTMENT SET Mgr_ssn = '555555555' WHERE Dnumber = 8;

-- Practice Scenario 7.2: Work Assignment Violations
-- PREDICTION: Both will FAIL with foreign key constraint violations

-- Test non-existent employee:
-- INSERT INTO WORKS_ON (Essn, Pno, Hours) VALUES ('999999999', 1, 20.0);
-- Error: Employee '999999999' doesn't exist

-- Test non-existent project:
-- INSERT INTO WORKS_ON (Essn, Pno, Hours) VALUES ('123456789', 999, 20.0);
-- Error: Project 999 doesn't exist

-- EXPLANATION:
-- WORKS_ON table has foreign keys to both EMPLOYEE and PROJECT
-- Both referenced records must exist for the assignment to be valid

-- Practice Scenario 7.3: Dependent Constraint
-- PREDICTION: This will FAIL with a foreign key constraint violation
-- Employee '999999999' doesn't exist

-- Test it:
-- INSERT INTO DEPENDENT (Essn, Dependent_name, Relationship) 
-- VALUES ('999999999', 'John Jr', 'Son');

-- RESULT EXPLANATION:
-- Error: Cannot add or update a child row: a foreign key constraint fails
-- Dependents must be associated with existing employees

-- ========================================
-- SECTION 8: CONSTRAINT MODIFICATION SCENARIOS
-- ========================================

-- Practice Scenario 8.1: Disabling Foreign Key Checks
-- RESEARCH: In MySQL, you can temporarily disable foreign key checks

-- To disable:
-- SET FOREIGN_KEY_CHECKS = 0;

-- To enable:
-- SET FOREIGN_KEY_CHECKS = 1;

-- WHEN USEFUL:
-- - Data migration between systems
-- - Loading data in different order than constraints require
-- - Temporarily resolving circular reference issues

-- RISKS:
-- - Data integrity not enforced
-- - Orphaned records possible
-- - Must manually ensure referential integrity
-- - Easy to forget to re-enable checks

-- Practice Scenario 8.2: Adding New Constraints to Existing Data
-- PREDICTION: This will FAIL if existing data violates the constraint
-- Some employees earn exactly 25000, which violates the > 30000 check

-- Test it (MySQL 8.0+):
-- ALTER TABLE EMPLOYEE ADD CONSTRAINT salary_check CHECK (Salary > 30000);

-- RESULT EXPLANATION:
-- Error: Check constraint 'salary_check' is violated
-- Cannot add constraints that existing data violates
-- Must first update data to satisfy constraint, then add constraint

-- SOLUTION APPROACH:
-- Step 1: Update violating records
-- UPDATE EMPLOYEE SET Salary = 30001 WHERE Salary <= 30000;
-- Step 2: Add constraint
-- ALTER TABLE EMPLOYEE ADD CONSTRAINT salary_check CHECK (Salary > 30000);

-- ========================================
-- SECTION 9: REAL-WORLD SCENARIOS
-- ========================================

-- Scenario 9.1: Company Reorganization - Department Dissolution
-- STEP-BY-STEP PLAN:

-- Step 1: Identify all dependencies
-- SELECT 'Employees' AS Type, COUNT(*) AS Count FROM EMPLOYEE WHERE Dno = 5
-- UNION ALL
-- SELECT 'Projects', COUNT(*) FROM PROJECT WHERE Dnum = 5
-- UNION ALL  
-- SELECT 'Managers', COUNT(*) FROM DEPARTMENT WHERE Mgr_ssn IN (SELECT Ssn FROM EMPLOYEE WHERE Dno = 5);

-- Step 2: Reassign employees to other departments
-- UPDATE EMPLOYEE SET Dno = 1 WHERE Dno = 5 AND Super_ssn IS NOT NULL;
-- UPDATE EMPLOYEE SET Dno = 4 WHERE Dno = 5 AND Super_ssn IS NULL;

-- Step 3: Transfer projects to other departments
-- UPDATE PROJECT SET Dnum = 1 WHERE Dnum = 5 AND Plocation = 'Houston';
-- UPDATE PROJECT SET Dnum = 4 WHERE Dnum = 5 AND Plocation != 'Houston';

-- Step 4: Handle management references
-- UPDATE DEPARTMENT SET Mgr_ssn = (SELECT Ssn FROM EMPLOYEE WHERE Dno = 1 LIMIT 1) WHERE Mgr_ssn IN (SELECT Ssn FROM EMPLOYEE WHERE Dno = 5);

-- Step 5: Clean up work assignments (if needed)
-- UPDATE WORKS_ON SET Pno = new_project_id WHERE Pno IN (SELECT Pnumber FROM PROJECT WHERE Dnum = 5);

-- Step 6: Finally delete the department
-- DELETE FROM DEPARTMENT WHERE Dnumber = 5;

-- Scenario 9.2: Employee Transfer
-- ANALYSIS: Consider these constraints when transferring employees:

-- 1. Department foreign key (Dno) - must reference valid department
-- 2. Supervisor relationship - new supervisor must be in target department
-- 3. Project assignments - may need adjustment if projects department-specific
-- 4. Management roles - if employee manages department, need new manager
-- 5. Work assignments - ensure projects still accessible from new department

-- SAFE TRANSFER PROCEDURE:
-- UPDATE EMPLOYEE SET Dno = new_dept, Super_ssn = new_supervisor WHERE Ssn = employee_ssn;

-- Scenario 9.3: Project Cancellation
-- ANALYSIS: Constraints involved in project deletion:

-- 1. Work assignments (WORKS_ON) - employees assigned to project
-- 2. Department control (PROJECT.Dnum) - department losing project
-- 3. Dependent projects - if project dependencies exist

-- SAFE CANCELLATION PROCEDURE:
-- Step 1: Remove work assignments
-- DELETE FROM WORKS_ON WHERE Pno = project_number;
-- Step 2: Delete the project
-- DELETE FROM PROJECT WHERE Pnumber = project_number;

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

-- Verify referential integrity
SELECT 'Integrity Check' AS Test, 
CASE 
    WHEN (
        SELECT COUNT(*) FROM EMPLOYEE e 
        LEFT JOIN DEPARTMENT d ON e.Dno = d.Dnumber 
        WHERE d.Dnumber IS NULL
    ) = 0 THEN 'PASSED'
    ELSE 'FAILED'
END AS Employee_Department_FK;

-- Test for orphaned records
SELECT 'Orphaned Dependents' AS Test,
CASE 
    WHEN (
        SELECT COUNT(*) FROM DEPENDENT dep
        LEFT JOIN EMPLOYEE e ON dep.Essn = e.Ssn
        WHERE e.Ssn IS NULL
    ) = 0 THEN 'NONE'
    ELSE 'FOUND'
END AS Status;

-- ========================================
-- CONSTRAINT SOLUTIONS COMPLETE!
-- ========================================
-- Key principles demonstrated:
-- - Entity integrity: Primary keys must be NOT NULL and UNIQUE
-- - Referential integrity: Foreign keys must reference existing values
-- - Domain constraints: Data types and CHECK constraints limit values
-- - NULL handling: Different rules for different constraint types
-- - Cascade operations: Automatic handling of dependent records
-- - Constraint timing: When violations are detected and handled
-- ========================================
