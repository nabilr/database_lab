-- ========================================
-- QUIZ 1 PRACTICE: COMPLETE SOLUTIONS
-- ========================================
-- Detailed solutions with explanations for all practice questions
-- Load the schema first: mysql < employee-database-schema.sql

USE quiz1_practice;

-- ========================================
-- SOLUTIONS: JOINS AND FILTERING
-- ========================================

-- Solution 1.1: Employee details with department and manager
SELECT 
    CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name,
    e.Ssn,
    d.Dname AS Department,
    CONCAT(m.Fname, ' ', m.Lname) AS Manager_Name
FROM EMPLOYEE e
JOIN DEPARTMENT d ON e.Dno = d.Dnumber
LEFT JOIN EMPLOYEE m ON e.Super_ssn = m.Ssn
ORDER BY e.Lname, e.Fname;

-- Solution 1.2: Projects with controlling departments
SELECT 
    p.Pname AS Project_Name,
    p.Plocation AS Location,
    d.Dname AS Controlling_Department
FROM PROJECT p
JOIN DEPARTMENT d ON p.Dnum = d.Dnumber
ORDER BY d.Dname, p.Pname;

-- Solution 1.3: Work assignments with employee and project names
SELECT 
    CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name,
    p.Pname AS Project_Name,
    w.Hours AS Hours_Worked
FROM EMPLOYEE e
JOIN WORKS_ON w ON e.Ssn = w.Essn
JOIN PROJECT p ON w.Pno = p.Pnumber
ORDER BY e.Lname, p.Pname;

-- Solution 2.1: Employees who work on ALL Houston projects
-- Method 1: Using NOT EXISTS (Division operation)
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

-- Method 2: Using COUNT comparison
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

-- Solution 2.2: Employees who work on ALL Research department projects
SELECT CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name
FROM EMPLOYEE e
WHERE NOT EXISTS (
    SELECT p.Pnumber
    FROM PROJECT p
    WHERE p.Dnum = 5  -- Research department
    AND NOT EXISTS (
        SELECT w.Pno
        FROM WORKS_ON w
        WHERE w.Essn = e.Ssn AND w.Pno = p.Pnumber
    )
);

-- Solution 3.1: Employees who work on more than one project
SELECT 
    CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name,
    COUNT(w.Pno) AS Project_Count
FROM EMPLOYEE e
JOIN WORKS_ON w ON e.Ssn = w.Essn
GROUP BY e.Ssn, e.Fname, e.Lname
HAVING COUNT(w.Pno) > 1
ORDER BY Project_Count DESC, e.Lname;

-- Solution 3.2: Employees who work on exactly 2 projects
SELECT 
    CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name,
    COUNT(w.Pno) AS Project_Count
FROM EMPLOYEE e
JOIN WORKS_ON w ON e.Ssn = w.Essn
GROUP BY e.Ssn, e.Fname, e.Lname
HAVING COUNT(w.Pno) = 2
ORDER BY e.Lname;

-- Solution 3.3: Employees who work on more projects than their supervisor
SELECT 
    CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name,
    emp_projects.Project_Count AS Employee_Projects,
    COALESCE(sup_projects.Project_Count, 0) AS Supervisor_Projects
FROM EMPLOYEE e
JOIN (
    SELECT w.Essn, COUNT(w.Pno) AS Project_Count
    FROM WORKS_ON w
    GROUP BY w.Essn
) emp_projects ON e.Ssn = emp_projects.Essn
LEFT JOIN EMPLOYEE s ON e.Super_ssn = s.Ssn
LEFT JOIN (
    SELECT w.Essn, COUNT(w.Pno) AS Project_Count
    FROM WORKS_ON w
    GROUP BY w.Essn
) sup_projects ON s.Ssn = sup_projects.Essn
WHERE emp_projects.Project_Count > COALESCE(sup_projects.Project_Count, 0);

-- Solution 4.1: All employees with their dependents (LEFT JOIN)
SELECT 
    CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name,
    COALESCE(d.Dependent_name, 'No Dependents') AS Dependent_Name,
    d.Relationship
FROM EMPLOYEE e
LEFT JOIN DEPENDENT d ON e.Ssn = d.Essn
ORDER BY e.Lname, e.Fname, d.Dependent_name;

-- Solution 4.2: Employees who have dependents
SELECT DISTINCT
    CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name,
    COUNT(d.Dependent_name) AS Dependent_Count
FROM EMPLOYEE e
JOIN DEPENDENT d ON e.Ssn = d.Essn
GROUP BY e.Ssn, e.Fname, e.Lname
ORDER BY Dependent_Count DESC, e.Lname;

-- Solution 4.3: Employees who do NOT have dependents
SELECT CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name
FROM EMPLOYEE e
LEFT JOIN DEPENDENT d ON e.Ssn = d.Essn
WHERE d.Essn IS NULL
ORDER BY e.Lname;

-- Solution 4.4: Employees with more dependents than their manager
SELECT 
    CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name,
    emp_deps.Dependent_Count AS Employee_Dependents,
    COALESCE(mgr_deps.Dependent_Count, 0) AS Manager_Dependents
FROM EMPLOYEE e
JOIN (
    SELECT d.Essn, COUNT(d.Dependent_name) AS Dependent_Count
    FROM DEPENDENT d
    GROUP BY d.Essn
) emp_deps ON e.Ssn = emp_deps.Essn
LEFT JOIN EMPLOYEE m ON e.Super_ssn = m.Ssn
LEFT JOIN (
    SELECT d.Essn, COUNT(d.Dependent_name) AS Dependent_Count
    FROM DEPENDENT d
    GROUP BY d.Essn
) mgr_deps ON m.Ssn = mgr_deps.Essn
WHERE emp_deps.Dependent_Count > COALESCE(mgr_deps.Dependent_Count, 0);

-- Solution 5.1: Employees with same last name as supervisor
SELECT 
    CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name,
    CONCAT(s.Fname, ' ', s.Lname) AS Supervisor_Name
FROM EMPLOYEE e
JOIN EMPLOYEE s ON e.Super_ssn = s.Ssn
WHERE e.Lname = s.Lname;

-- Solution 5.2: Employees with same first name as supervisor
SELECT 
    CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name,
    CONCAT(s.Fname, ' ', s.Lname) AS Supervisor_Name
FROM EMPLOYEE e
JOIN EMPLOYEE s ON e.Super_ssn = s.Ssn
WHERE e.Fname = s.Fname;

-- Solution 6.1: Employees with both dependents AND project assignments
SELECT DISTINCT CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name
FROM EMPLOYEE e
JOIN DEPENDENT d ON e.Ssn = d.Essn
JOIN WORKS_ON w ON e.Ssn = w.Essn
ORDER BY e.Lname;

-- Solution 6.2: Employees with dependents but NO project assignments
SELECT CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name
FROM EMPLOYEE e
JOIN DEPENDENT d ON e.Ssn = d.Essn
LEFT JOIN WORKS_ON w ON e.Ssn = w.Essn
WHERE w.Essn IS NULL
GROUP BY e.Ssn, e.Fname, e.Lname;

-- Solution 7.1: Employees who work and live in Houston
SELECT CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name
FROM EMPLOYEE e
JOIN WORKS_ON w ON e.Ssn = w.Essn
JOIN PROJECT p ON w.Pno = p.Pnumber
WHERE p.Plocation = 'Houston'
AND e.Address LIKE '%Houston%'
GROUP BY e.Ssn, e.Fname, e.Lname;

-- Solution 7.2: Highest paid employee in each department
SELECT 
    d.Dname AS Department,
    CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name,
    e.Salary
FROM EMPLOYEE e
JOIN DEPARTMENT d ON e.Dno = d.Dnumber
WHERE e.Salary = (
    SELECT MAX(e2.Salary)
    FROM EMPLOYEE e2
    WHERE e2.Dno = e.Dno
)
ORDER BY d.Dname;

-- Solution 7.3: Employees with above-average total work hours
SELECT 
    CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name,
    SUM(w.Hours) AS Total_Hours
FROM EMPLOYEE e
JOIN WORKS_ON w ON e.Ssn = w.Essn
GROUP BY e.Ssn, e.Fname, e.Lname
HAVING SUM(w.Hours) > (
    SELECT AVG(total_hours.hours_sum)
    FROM (
        SELECT SUM(w2.Hours) AS hours_sum
        FROM WORKS_ON w2
        GROUP BY w2.Essn
    ) total_hours
)
ORDER BY Total_Hours DESC;

-- Solution 8.1: Comprehensive employee report
SELECT 
    CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name,
    d.Dname AS Department,
    COALESCE(CONCAT(s.Fname, ' ', s.Lname), 'No Supervisor') AS Supervisor,
    COUNT(DISTINCT w.Pno) AS Project_Count,
    COALESCE(SUM(w.Hours), 0) AS Total_Hours,
    COUNT(DISTINCT dep.Dependent_name) AS Dependent_Count
FROM EMPLOYEE e
JOIN DEPARTMENT d ON e.Dno = d.Dnumber
LEFT JOIN EMPLOYEE s ON e.Super_ssn = s.Ssn
LEFT JOIN WORKS_ON w ON e.Ssn = w.Essn
LEFT JOIN DEPENDENT dep ON e.Ssn = dep.Essn
GROUP BY e.Ssn, e.Fname, e.Lname, d.Dname, s.Fname, s.Lname
ORDER BY d.Dname, e.Lname;

-- ========================================
-- SOLUTIONS: INTEGRITY CONSTRAINTS
-- ========================================

-- The constraint violation examples demonstrate:

-- Primary Key Violations:
-- INSERT INTO EMPLOYEE (Fname, Lname, Ssn, Dno) VALUES ('John', 'Duplicate', '123456789', 5);
-- Result: Error - Duplicate entry for primary key

-- INSERT INTO EMPLOYEE (Fname, Lname, Ssn, Dno) VALUES ('Jane', 'NoSSN', NULL, 5);
-- Result: Error - Column 'Ssn' cannot be null

-- Foreign Key Violations:
-- INSERT INTO EMPLOYEE (Fname, Lname, Ssn, Dno) VALUES ('Bob', 'NoDept', '111111111', 99);
-- Result: Error - Cannot add or update child row: foreign key constraint fails

-- DELETE FROM DEPARTMENT WHERE Dnumber = 5;
-- Result: Error - Cannot delete or update parent row: foreign key constraint fails

-- Safe deletion approach for department:
-- 1. Reassign employees to other departments
-- 2. Transfer projects to other departments  
-- 3. Update any manager references
-- 4. Then delete the department

-- ========================================
-- SOLUTIONS: CHALLENGE QUESTIONS
-- ========================================

-- Challenge: Modified column names version
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

-- Challenge: Multiple conditions
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

-- Challenge: DDL for new schema
CREATE TABLE SKILLS (
    Skill_id INT PRIMARY KEY AUTO_INCREMENT,
    Skill_name VARCHAR(50) NOT NULL UNIQUE,
    Category VARCHAR(30),
    Description TEXT
);

CREATE TABLE EMPLOYEE_SKILLS (
    Essn CHAR(9),
    Skill_id INT,
    Proficiency_level ENUM('Beginner', 'Intermediate', 'Advanced', 'Expert'),
    Date_acquired DATE,
    
    PRIMARY KEY (Essn, Skill_id),
    FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn) ON DELETE CASCADE,
    FOREIGN KEY (Skill_id) REFERENCES SKILLS(Skill_id) ON DELETE CASCADE
);

-- Challenge: Business rule constraints
-- Manager earns more than supervisees
ALTER TABLE EMPLOYEE 
ADD CONSTRAINT check_manager_salary 
CHECK (
    Super_ssn IS NULL OR 
    Salary <= (SELECT Salary FROM EMPLOYEE e2 WHERE e2.Ssn = Super_ssn)
);

-- Note: This CHECK constraint has limitations in MySQL due to subquery restrictions
-- Better implemented with triggers or application logic

-- Challenge: Data quality validation
-- Find employees with suspicious salaries
SELECT 
    CONCAT(Fname, ' ', Lname) AS Employee,
    Salary,
    CASE 
        WHEN Salary < 20000 THEN 'Suspiciously Low'
        WHEN Salary > 100000 THEN 'Suspiciously High'
        ELSE 'Normal Range'
    END AS Salary_Assessment
FROM EMPLOYEE
WHERE Salary < 20000 OR Salary > 100000;

-- Find projects with no assigned employees
SELECT p.Pname AS Unassigned_Project
FROM PROJECT p
LEFT JOIN WORKS_ON w ON p.Pnumber = w.Pno
WHERE w.Pno IS NULL;

-- ========================================
-- PERFORMANCE OPTIMIZATION SOLUTIONS
-- ========================================

-- Optimized query using proper JOIN syntax
SELECT e.Fname, e.Lname, d.Dname, p.Pname
FROM EMPLOYEE e
INNER JOIN DEPARTMENT d ON e.Dno = d.Dnumber
INNER JOIN WORKS_ON w ON e.Ssn = w.Essn
INNER JOIN PROJECT p ON w.Pno = p.Pnumber
WHERE d.Dname = 'Research'
AND p.Plocation = 'Houston';

-- Recommended indexes for performance
CREATE INDEX idx_employee_dno_name ON EMPLOYEE(Dno, Lname, Fname);
CREATE INDEX idx_project_location ON PROJECT(Plocation);
CREATE INDEX idx_department_name ON DEPARTMENT(Dname);
CREATE INDEX idx_works_on_composite ON WORKS_ON(Essn, Pno, Hours);

-- ========================================
-- COMPLETE VERIFICATION SUITE
-- ========================================

-- Verify all relationships work correctly
SELECT 'Data Integrity Check' AS Test_Category, 'PASSED' AS Status
FROM (
    -- Check that all foreign keys have valid references
    SELECT COUNT(*) AS invalid_refs
    FROM EMPLOYEE e
    LEFT JOIN DEPARTMENT d ON e.Dno = d.Dnumber
    WHERE d.Dnumber IS NULL
    
    UNION ALL
    
    SELECT COUNT(*)
    FROM EMPLOYEE e
    LEFT JOIN EMPLOYEE s ON e.Super_ssn = s.Ssn
    WHERE e.Super_ssn IS NOT NULL AND s.Ssn IS NULL
    
    UNION ALL
    
    SELECT COUNT(*)
    FROM WORKS_ON w
    LEFT JOIN EMPLOYEE e ON w.Essn = e.Ssn
    WHERE e.Ssn IS NULL
    
    UNION ALL
    
    SELECT COUNT(*)
    FROM WORKS_ON w
    LEFT JOIN PROJECT p ON w.Pno = p.Pnumber
    WHERE p.Pnumber IS NULL
) integrity_check
WHERE invalid_refs = 0;

-- Summary statistics for validation
SELECT 
    'Database Summary' AS Report_Type,
    (SELECT COUNT(*) FROM EMPLOYEE) AS Total_Employees,
    (SELECT COUNT(*) FROM DEPARTMENT) AS Total_Departments,
    (SELECT COUNT(*) FROM PROJECT) AS Total_Projects,
    (SELECT COUNT(*) FROM WORKS_ON) AS Total_Assignments,
    (SELECT COUNT(*) FROM DEPENDENT) AS Total_Dependents;

-- ========================================
-- SOLUTIONS COMPLETE!
-- ========================================
-- These solutions demonstrate:
-- - Proper JOIN syntax and techniques
-- - Constraint handling and violation resolution
-- - Complex query construction
-- - Performance optimization strategies
-- - Data validation and quality assurance
-- - Schema design best practices
-- 
-- Practice these solutions and create your own variations!
-- ========================================
