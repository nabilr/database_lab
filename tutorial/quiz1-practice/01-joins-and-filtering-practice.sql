-- ========================================
-- QUIZ 1 PRACTICE: JOINS AND FILTERING
-- ========================================
-- Practice questions for complex joins and filtering scenarios
-- Load the schema first: mysql < employee-database-schema.sql

USE quiz1_practice;

-- ========================================
-- SECTION 1: BASIC JOIN PRACTICE
-- ========================================

-- Practice Question 1.1
-- Find all employees with their department names and manager names
-- Expected: Employee details with department and manager information

-- YOUR SOLUTION HERE:




-- Practice Question 1.2  
-- List all projects with the department name that controls them
-- Expected: Project name, location, and controlling department

-- YOUR SOLUTION HERE:




-- Practice Question 1.3
-- Show all work assignments with employee names and project names
-- Expected: Employee name, project name, hours worked

-- YOUR SOLUTION HERE:




-- ========================================
-- SECTION 2: EMPLOYEES WHO WORK ON ALL PROJECTS IN SPECIFIC LOCATION
-- ========================================

-- Practice Question 2.1
-- Find employees who work on ALL projects located in Houston
-- Hint: Use division operation or NOT EXISTS approach
-- Expected: Employees who are assigned to every Houston project

-- YOUR SOLUTION HERE:




-- Practice Question 2.2 (Variation)
-- Find employees who work on ALL projects controlled by department 5 (Research)
-- Expected: Employees working on every Research department project

-- YOUR SOLUTION HERE:




-- Practice Question 2.3 (Challenge)
-- Find employees who work on ALL projects that their manager also works on
-- Expected: Employees whose project assignments include all their manager's projects

-- YOUR SOLUTION HERE:




-- ========================================
-- SECTION 3: EMPLOYEES WHO WORK ON MULTIPLE PROJECTS
-- ========================================

-- Practice Question 3.1
-- Find employees who work on more than one project
-- Expected: Employee names and count of projects they work on

-- YOUR SOLUTION HERE:




-- Practice Question 3.2 (Variation)
-- Find employees who work on exactly 2 projects
-- Expected: Employees with exactly 2 project assignments

-- YOUR SOLUTION HERE:




-- Practice Question 3.3 (Challenge)
-- Find employees who work on more projects than their supervisor
-- Expected: Employees exceeding their supervisor's project count

-- YOUR SOLUTION HERE:




-- ========================================
-- SECTION 4: EMPLOYEES WITH/WITHOUT DEPENDENTS
-- ========================================

-- Practice Question 4.1
-- Find all employees and their dependents (including employees without dependents)
-- Use LEFT JOIN to include employees without dependents
-- Expected: All employees, with dependent info where available

-- YOUR SOLUTION HERE:




-- Practice Question 4.2
-- Find employees who have dependents
-- Expected: Only employees who have at least one dependent

-- YOUR SOLUTION HERE:




-- Practice Question 4.3
-- Find employees who do NOT have dependents
-- Expected: Employees with no dependents listed

-- YOUR SOLUTION HERE:




-- Practice Question 4.4 (Challenge)
-- Find employees who have more dependents than their manager
-- Expected: Employees with dependent count > manager's dependent count

-- YOUR SOLUTION HERE:




-- ========================================
-- SECTION 5: EMPLOYEES WITH SAME LAST NAME AS MANAGER
-- ========================================

-- Practice Question 5.1
-- Find employees who share the same last name as their supervisor
-- Expected: Employees with matching supervisor last names

-- YOUR SOLUTION HERE:




-- Practice Question 5.2 (Variation)
-- Find employees who share the same first name as their supervisor
-- Expected: Employees with matching supervisor first names

-- YOUR SOLUTION HERE:




-- Practice Question 5.3 (Challenge)
-- Find all pairs of employees (not supervisor-subordinate) who share last names
-- Expected: Employee pairs with same last name (exclude supervisor relationships)

-- YOUR SOLUTION HERE:




-- ========================================
-- SECTION 6: EMPLOYEES WITH DEPENDENTS AND PROJECT ASSIGNMENTS
-- ========================================

-- Practice Question 6.1
-- Find employees who have both dependents AND are assigned to projects
-- Expected: Employees meeting both conditions

-- YOUR SOLUTION HERE:




-- Practice Question 6.2 (Variation)
-- Find employees who have dependents but are NOT assigned to any projects
-- Expected: Employees with dependents but no project work

-- YOUR SOLUTION HERE:




-- Practice Question 6.3 (Challenge)
-- Find employees who have more dependents than projects they work on
-- Expected: Employees where dependent_count > project_count

-- YOUR SOLUTION HERE:




-- ========================================
-- SECTION 7: ADVANCED FILTERING SCENARIOS
-- ========================================

-- Practice Question 7.1
-- Find employees who work in Houston but live in Houston
-- (work location from projects, home address from employee table)
-- Expected: Employees with Houston in both work and home locations

-- YOUR SOLUTION HERE:




-- Practice Question 7.2
-- Find the highest paid employee in each department
-- Expected: Top earner per department

-- YOUR SOLUTION HERE:




-- Practice Question 7.3
-- Find employees who work more total hours than the average
-- Expected: Employees with above-average total work hours

-- YOUR SOLUTION HERE:




-- Practice Question 7.4 (Challenge)
-- Find employees who supervise other employees but have no dependents
-- Expected: Supervisors without dependents

-- YOUR SOLUTION HERE:




-- ========================================
-- SECTION 8: COMPLEX MULTI-TABLE JOINS
-- ========================================

-- Practice Question 8.1
-- Create a comprehensive report showing:
-- Employee name, department, supervisor name, number of projects, 
-- total hours worked, number of dependents
-- Expected: Complete employee summary report

-- YOUR SOLUTION HERE:




-- Practice Question 8.2 (Challenge)
-- Find departments where all employees have at least one dependent
-- Expected: Departments where every employee has dependents

-- YOUR SOLUTION HERE:




-- Practice Question 8.3 (Challenge)
-- Find the employee who works the most hours across all projects in each department
-- Expected: Hardest working employee per department

-- YOUR SOLUTION HERE:




-- ========================================
-- VERIFICATION QUERIES (DO NOT MODIFY)
-- ========================================

-- These queries help verify your results
-- Use them to check if your solutions are reasonable

-- Check data counts for reference
SELECT 'Total Employees' AS Metric, COUNT(*) AS Count FROM EMPLOYEE
UNION ALL
SELECT 'Employees with Dependents', COUNT(DISTINCT Essn) FROM DEPENDENT
UNION ALL
SELECT 'Employees on Projects', COUNT(DISTINCT Essn) FROM WORKS_ON
UNION ALL
SELECT 'Total Projects', COUNT(*) FROM PROJECT
UNION ALL
SELECT 'Houston Projects', COUNT(*) FROM PROJECT WHERE Plocation = 'Houston';

-- Sample correct outputs for reference
-- Employees who work on more than one project (should be 7 employees):
SELECT CONCAT(e.Fname, ' ', e.Lname) AS Employee, COUNT(w.Pno) AS Project_Count
FROM EMPLOYEE e
JOIN WORKS_ON w ON e.Ssn = w.Essn
GROUP BY e.Ssn, e.Fname, e.Lname
HAVING COUNT(w.Pno) > 1
ORDER BY Project_Count DESC, e.Lname;

-- Employees with dependents (should be 5 employees):
SELECT DISTINCT CONCAT(e.Fname, ' ', e.Lname) AS Employee
FROM EMPLOYEE e
JOIN DEPENDENT d ON e.Ssn = d.Essn
ORDER BY e.Lname;

-- ========================================
-- PRACTICE COMPLETE!
-- ========================================
-- Check your solutions against the provided verification queries
-- Then proceed to: 02-integrity-constraints-practice.sql
