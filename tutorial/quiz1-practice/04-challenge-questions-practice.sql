-- ========================================
-- QUIZ 1 PRACTICE: CHALLENGE QUESTIONS
-- ========================================
-- Advanced variations and challenge problems
-- Load the schema first: mysql < employee-database-schema.sql

USE quiz1_practice;

-- ========================================
-- SECTION 1: ADVANCED JOIN VARIATIONS
-- ========================================

-- Challenge 1.1: Modified Column Names
-- Create variations of join queries using different column aliases
-- Find employees who work on all projects in 'Houston' but display results as:
-- Worker_Name, Worker_ID, Total_Houston_Projects, Department_Name

-- YOUR SOLUTION:




-- Challenge 1.2: Multiple Conditions
-- Find employees who:
-- 1. Work on more than 2 projects AND
-- 2. Have at least 1 dependent AND  
-- 3. Earn more than the average salary in their department
-- Display: Name, Project_Count, Dependent_Count, Salary, Dept_Average_Salary

-- YOUR SOLUTION:




-- Challenge 1.3: Complex Filtering
-- Find employees who work on projects in the same location where they live
-- (Match project location with employee address city)
-- Challenge: Extract city from address field and match with project location

-- YOUR SOLUTION:




-- ========================================
-- SECTION 2: ADVANCED CONSTRAINT SCENARIOS
-- ========================================

-- Challenge 2.1: Multi-step Constraint Resolution
-- Design a sequence of operations to safely delete department 5 (Research)
-- Consider: reassigning employees, transferring projects, updating managers

-- Step 1: Analysis - what needs to be handled?
-- YOUR ANALYSIS:




-- Step 2: Write the complete sequence of SQL statements
-- YOUR SOLUTION:




-- Challenge 2.2: Constraint-aware Data Migration
-- Write INSERT statements that would violate constraints, then fix them
-- Include examples for each type of constraint violation

-- Violation Examples:
-- YOUR VIOLATION EXAMPLES:




-- Fixed Versions:
-- YOUR FIXED VERSIONS:




-- ========================================
-- SECTION 3: SCHEMA MODIFICATION CHALLENGES
-- ========================================

-- Challenge 3.1: Add New Constraints to Existing Schema
-- Add the following constraints and handle any violations:
-- 1. Employee salary must be between 20,000 and 100,000
-- 2. Project names must start with 'Project_' or 'Product'
-- 3. Employees cannot supervise more than 5 direct reports

-- Constraint 1: Salary Range
-- YOUR SOLUTION:




-- Constraint 2: Project Naming Convention
-- YOUR SOLUTION:




-- Constraint 3: Supervision Limit
-- YOUR SOLUTION:




-- Challenge 3.2: Create Additional Tables with Complex Constraints
-- Create new tables: SKILLS, EMPLOYEE_SKILLS, TRAINING_PROGRAMS
-- Include appropriate constraints and foreign keys

-- YOUR SCHEMA DESIGN:




-- ========================================
-- SECTION 4: DDL RECONSTRUCTION CHALLENGE
-- ========================================

-- Challenge 4.1: Reverse Engineer DDL
-- Based on the following requirements, write complete DDL statements:
-- 
-- CUSTOMER table: customer_id (PK), name (required), email (unique), phone
-- ORDER table: order_id (PK), customer_id (FK), order_date (default today), status
-- ORDER_ITEM table: order_id (FK), product_id (FK), quantity (required), price
-- PRODUCT table: product_id (PK), name (required, unique), price (>0), category
--
-- Additional constraints:
-- - Order status must be 'pending', 'shipped', or 'delivered'
-- - Quantity must be positive
-- - Customer email must contain '@'

-- YOUR DDL STATEMENTS:




-- Challenge 4.2: Optimize Schema for Query Performance
-- Add appropriate indexes to support these common queries:
-- 1. Find all orders for a specific customer
-- 2. Find all products in a specific category
-- 3. Find order items by product name
-- 4. Find customers by email domain

-- YOUR INDEX STATEMENTS:




-- ========================================
-- SECTION 5: COMPLEX QUERY CHALLENGES
-- ========================================

-- Challenge 5.1: Recursive Query Simulation
-- Find all employees in the hierarchy under 'James E Borg' (including sub-supervisors)
-- Since MySQL doesn't support recursive CTEs easily, use a different approach

-- YOUR SOLUTION:




-- Challenge 5.2: Division Operation Implementation
-- Implement division: "Find employees who work on ALL projects located in Houston"
-- Provide at least 3 different solution approaches:

-- Approach 1: Using NOT EXISTS
-- YOUR SOLUTION:




-- Approach 2: Using COUNT comparison
-- YOUR SOLUTION:




-- Approach 3: Using set operations (if available)
-- YOUR SOLUTION:




-- Challenge 5.3: Complex Aggregation
-- Create a comprehensive department report showing:
-- - Department name and manager
-- - Total employees, total projects, total work hours
-- - Average salary, highest salary, lowest salary
-- - Number of employees with dependents
-- - List of project locations (comma-separated)

-- YOUR SOLUTION:




-- ========================================
-- SECTION 6: DATA VALIDATION CHALLENGES
-- ========================================

-- Challenge 6.1: Data Quality Checks
-- Write queries to identify potential data quality issues:
-- 1. Employees with suspicious salary values (too high/low)
-- 2. Projects with no assigned employees
-- 3. Employees with inconsistent address formats
-- 4. Circular supervision chains

-- Data Quality Query 1:
-- YOUR SOLUTION:




-- Data Quality Query 2:
-- YOUR SOLUTION:




-- Data Quality Query 3:
-- YOUR SOLUTION:




-- Data Quality Query 4:
-- YOUR SOLUTION:




-- Challenge 6.2: Constraint Validation Queries
-- Write queries that verify all constraints are satisfied:
-- 1. No orphaned foreign key references
-- 2. All required fields have values
-- 3. All unique constraints are satisfied
-- 4. All business rules are followed

-- Validation Query 1:
-- YOUR SOLUTION:




-- Validation Query 2:
-- YOUR SOLUTION:




-- Validation Query 3:
-- YOUR SOLUTION:




-- Validation Query 4:
-- YOUR SOLUTION:




-- ========================================
-- SECTION 7: PERFORMANCE OPTIMIZATION CHALLENGES
-- ========================================

-- Challenge 7.1: Query Optimization
-- Optimize this query for better performance:
/*
SELECT e.Fname, e.Lname, d.Dname, p.Pname
FROM EMPLOYEE e, DEPARTMENT d, PROJECT p, WORKS_ON w
WHERE e.Dno = d.Dnumber 
AND e.Ssn = w.Essn 
AND w.Pno = p.Pnumber
AND d.Dname = 'Research'
AND p.Plocation = 'Houston';
*/

-- Optimized Version:
-- YOUR SOLUTION:




-- Challenge 7.2: Index Strategy
-- Design an optimal index strategy for the employee database
-- Consider: query patterns, update frequency, storage space

-- YOUR INDEX STRATEGY:




-- ========================================
-- SECTION 8: ADVANCED CONSTRAINT DESIGN
-- ========================================

-- Challenge 8.1: Business Rule Implementation
-- Implement these business rules using constraints:
-- 1. A manager must earn more than all employees they supervise
-- 2. Total work hours per employee cannot exceed 40 per week
-- 3. Dependents must be younger than the employee
-- 4. Department managers must work in the department they manage

-- Business Rule 1:
-- YOUR SOLUTION:




-- Business Rule 2:
-- YOUR SOLUTION:




-- Business Rule 3:
-- YOUR SOLUTION:




-- Business Rule 4:
-- YOUR SOLUTION:




-- Challenge 8.2: Temporal Constraints
-- Add time-based constraints to the schema:
-- 1. Employee hire date cannot be in the future
-- 2. Project start date must be before end date
-- 3. Work assignments must be within project duration
-- 4. Manager start date must be after employee hire date

-- Extend the schema with temporal fields and constraints:
-- YOUR SOLUTION:




-- ========================================
-- SECTION 9: INTEGRATION CHALLENGES
-- ========================================

-- Challenge 9.1: Cross-Database Constraints
-- Design constraints that would work across multiple databases:
-- - Employee database (current)
-- - Payroll database (separate)
-- - HR database (separate)

-- YOUR DESIGN APPROACH:




-- Challenge 9.2: Migration Strategy
-- Plan a migration strategy to move from the current schema to a new normalized schema:
-- - Separate person information (employees, dependents)
-- - Separate organizational structure
-- - Maintain referential integrity during migration

-- YOUR MIGRATION PLAN:




-- ========================================
-- SECTION 10: TESTING AND VALIDATION
-- ========================================

-- Challenge 10.1: Comprehensive Test Suite
-- Create a test suite that validates all aspects of the database:
-- 1. Constraint enforcement
-- 2. Data integrity
-- 3. Query correctness
-- 4. Performance benchmarks

-- Test Suite Framework:
-- YOUR TEST FRAMEWORK:




-- Challenge 10.2: Error Handling Scenarios
-- Create test cases for all possible error scenarios:
-- 1. Constraint violations
-- 2. Data type mismatches
-- 3. Null value handling
-- 4. Circular reference resolution

-- Error Test Cases:
-- YOUR TEST CASES:




-- ========================================
-- VERIFICATION QUERIES FOR CHALLENGES
-- ========================================

-- Use these to verify your challenge solutions

-- Verify employees working on all Houston projects
SELECT COUNT(*) AS Houston_Projects FROM PROJECT WHERE Plocation = 'Houston';

-- Verify department statistics
SELECT 
    d.Dname,
    COUNT(e.Ssn) AS Employee_Count,
    COUNT(DISTINCT w.Pno) AS Project_Count,
    ROUND(AVG(e.Salary), 2) AS Avg_Salary
FROM DEPARTMENT d
LEFT JOIN EMPLOYEE e ON d.Dnumber = e.Dno
LEFT JOIN WORKS_ON w ON e.Ssn = w.Essn
GROUP BY d.Dnumber, d.Dname
ORDER BY d.Dname;

-- Verify constraint status
SELECT 
    TABLE_NAME,
    CONSTRAINT_NAME,
    CONSTRAINT_TYPE,
    IS_DEFERRABLE,
    INITIALLY_DEFERRED
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
WHERE TABLE_SCHEMA = 'quiz1_practice'
ORDER BY TABLE_NAME, CONSTRAINT_TYPE;

-- ========================================
-- CHALLENGE COMPLETE!
-- ========================================
-- These challenges test advanced understanding of:
-- - Complex query construction
-- - Constraint design and implementation
-- - Schema modification and optimization
-- - Data integrity and validation
-- - Performance considerations
-- 
-- Next: Check your solutions against the complete solutions file
-- Then: Practice with additional variations you create yourself
-- ========================================
