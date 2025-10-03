-- ========================================
-- SOLUTIONS: 01-joins-and-filtering-practice.sql
-- ========================================
-- Complete solutions for joins and filtering practice questions
-- Load the schema first: mysql < employee-database-schema.sql

USE quiz1_practice;

-- ========================================
-- SECTION 1: BASIC JOIN PRACTICE
-- ========================================

-- Practice Question 1.1: Find all employees with their department names and manager names
SELECT 
    CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name,
    e.Ssn,
    d.Dname AS Department,
    CONCAT(m.Fname, ' ', m.Lname) AS Manager_Name
FROM EMPLOYEE e
JOIN DEPARTMENT d ON e.Dno = d.Dnumber
LEFT JOIN EMPLOYEE m ON e.Super_ssn = m.Ssn
ORDER BY e.Lname, e.Fname;

-- Practice Question 1.2: List all projects with the department name that controls them
SELECT 
    p.Pname AS Project_Name,
    p.Plocation AS Location,
    d.Dname AS Controlling_Department
FROM PROJECT p
JOIN DEPARTMENT d ON p.Dnum = d.Dnumber
ORDER BY d.Dname, p.Pname;

-- Practice Question 1.3: Show all work assignments with employee names and project names
SELECT 
    CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name,
    p.Pname AS Project_Name,
    w.Hours AS Hours_Worked
FROM EMPLOYEE e
JOIN WORKS_ON w ON e.Ssn = w.Essn
JOIN PROJECT p ON w.Pno = p.Pnumber
ORDER BY e.Lname, p.Pname;

-- ========================================
-- SECTION 2: EMPLOYEES WHO WORK ON ALL PROJECTS IN SPECIFIC LOCATION
-- ========================================

-- Practice Question 2.1: Find employees who work on ALL projects located in Houston
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

-- Practice Question 2.2: Find employees who work on ALL projects controlled by department 5 (Research)
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

-- Practice Question 2.3: Find employees who work on ALL projects that their manager also works on
SELECT CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name
FROM EMPLOYEE e
WHERE e.Super_ssn IS NOT NULL
AND NOT EXISTS (
    SELECT w_mgr.Pno
    FROM WORKS_ON w_mgr
    WHERE w_mgr.Essn = e.Super_ssn
    AND NOT EXISTS (
        SELECT w_emp.Pno
        FROM WORKS_ON w_emp
        WHERE w_emp.Essn = e.Ssn AND w_emp.Pno = w_mgr.Pno
    )
);

-- ========================================
-- SECTION 3: EMPLOYEES WHO WORK ON MULTIPLE PROJECTS
-- ========================================

-- Practice Question 3.1: Find employees who work on more than one project
SELECT 
    CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name,
    COUNT(w.Pno) AS Project_Count
FROM EMPLOYEE e
JOIN WORKS_ON w ON e.Ssn = w.Essn
GROUP BY e.Ssn, e.Fname, e.Lname
HAVING COUNT(w.Pno) > 1
ORDER BY Project_Count DESC, e.Lname;

-- Practice Question 3.2: Find employees who work on exactly 2 projects
SELECT 
    CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name,
    COUNT(w.Pno) AS Project_Count
FROM EMPLOYEE e
JOIN WORKS_ON w ON e.Ssn = w.Essn
GROUP BY e.Ssn, e.Fname, e.Lname
HAVING COUNT(w.Pno) = 2
ORDER BY e.Lname;

-- Practice Question 3.3: Find employees who work on more projects than their supervisor
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

-- ========================================
-- SECTION 4: EMPLOYEES WITH/WITHOUT DEPENDENTS
-- ========================================

-- Practice Question 4.1: Find all employees and their dependents (including employees without dependents)
SELECT 
    CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name,
    COALESCE(d.Dependent_name, 'No Dependents') AS Dependent_Name,
    d.Relationship
FROM EMPLOYEE e
LEFT JOIN DEPENDENT d ON e.Ssn = d.Essn
ORDER BY e.Lname, e.Fname, d.Dependent_name;

-- Practice Question 4.2: Find employees who have dependents
SELECT DISTINCT
    CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name,
    COUNT(d.Dependent_name) AS Dependent_Count
FROM EMPLOYEE e
JOIN DEPENDENT d ON e.Ssn = d.Essn
GROUP BY e.Ssn, e.Fname, e.Lname
ORDER BY Dependent_Count DESC, e.Lname;

-- Practice Question 4.3: Find employees who do NOT have dependents
SELECT CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name
FROM EMPLOYEE e
LEFT JOIN DEPENDENT d ON e.Ssn = d.Essn
WHERE d.Essn IS NULL
ORDER BY e.Lname;

-- Practice Question 4.4: Find employees who have more dependents than their manager
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

-- ========================================
-- SECTION 5: EMPLOYEES WITH SAME LAST NAME AS MANAGER
-- ========================================

-- Practice Question 5.1: Find employees who share the same last name as their supervisor
SELECT 
    CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name,
    CONCAT(s.Fname, ' ', s.Lname) AS Supervisor_Name
FROM EMPLOYEE e
JOIN EMPLOYEE s ON e.Super_ssn = s.Ssn
WHERE e.Lname = s.Lname;

-- Practice Question 5.2: Find employees who share the same first name as their supervisor
SELECT 
    CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name,
    CONCAT(s.Fname, ' ', s.Lname) AS Supervisor_Name
FROM EMPLOYEE e
JOIN EMPLOYEE s ON e.Super_ssn = s.Ssn
WHERE e.Fname = s.Fname;

-- Practice Question 5.3: Find all pairs of employees (not supervisor-subordinate) who share last names
SELECT 
    CONCAT(e1.Fname, ' ', e1.Lname) AS Employee1_Name,
    CONCAT(e2.Fname, ' ', e2.Lname) AS Employee2_Name,
    e1.Lname AS Shared_LastName
FROM EMPLOYEE e1
JOIN EMPLOYEE e2 ON e1.Lname = e2.Lname
WHERE e1.Ssn < e2.Ssn  -- Avoid duplicates and self-references
AND e1.Super_ssn != e2.Ssn  -- Exclude supervisor relationships
AND e2.Super_ssn != e1.Ssn  -- Exclude reverse supervisor relationships
ORDER BY e1.Lname, e1.Fname;

-- ========================================
-- SECTION 6: EMPLOYEES WITH DEPENDENTS AND PROJECT ASSIGNMENTS
-- ========================================

-- Practice Question 6.1: Find employees who have both dependents AND are assigned to projects
SELECT DISTINCT CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name
FROM EMPLOYEE e
JOIN DEPENDENT d ON e.Ssn = d.Essn
JOIN WORKS_ON w ON e.Ssn = w.Essn
ORDER BY e.Lname;

-- Practice Question 6.2: Find employees who have dependents but are NOT assigned to any projects
SELECT CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name
FROM EMPLOYEE e
JOIN DEPENDENT d ON e.Ssn = d.Essn
LEFT JOIN WORKS_ON w ON e.Ssn = w.Essn
WHERE w.Essn IS NULL
GROUP BY e.Ssn, e.Fname, e.Lname;

-- Practice Question 6.3: Find employees who have more dependents than projects they work on
SELECT 
    CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name,
    dep_count.Dependent_Count,
    COALESCE(proj_count.Project_Count, 0) AS Project_Count
FROM EMPLOYEE e
JOIN (
    SELECT d.Essn, COUNT(d.Dependent_name) AS Dependent_Count
    FROM DEPENDENT d
    GROUP BY d.Essn
) dep_count ON e.Ssn = dep_count.Essn
LEFT JOIN (
    SELECT w.Essn, COUNT(w.Pno) AS Project_Count
    FROM WORKS_ON w
    GROUP BY w.Essn
) proj_count ON e.Ssn = proj_count.Essn
WHERE dep_count.Dependent_Count > COALESCE(proj_count.Project_Count, 0);

-- ========================================
-- SECTION 7: ADVANCED FILTERING SCENARIOS
-- ========================================

-- Practice Question 7.1: Find employees who work in Houston but live in Houston
SELECT CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name
FROM EMPLOYEE e
JOIN WORKS_ON w ON e.Ssn = w.Essn
JOIN PROJECT p ON w.Pno = p.Pnumber
WHERE p.Plocation = 'Houston'
AND e.Address LIKE '%Houston%'
GROUP BY e.Ssn, e.Fname, e.Lname;

-- Practice Question 7.2: Find the highest paid employee in each department
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

-- Practice Question 7.3: Find employees who work more total hours than the average
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

-- Practice Question 7.4: Find employees who supervise other employees but have no dependents
SELECT CONCAT(e.Fname, ' ', e.Lname) AS Supervisor_Name
FROM EMPLOYEE e
WHERE e.Ssn IN (
    SELECT DISTINCT Super_ssn
    FROM EMPLOYEE
    WHERE Super_ssn IS NOT NULL
)
AND e.Ssn NOT IN (
    SELECT DISTINCT Essn
    FROM DEPENDENT
)
ORDER BY e.Lname;

-- ========================================
-- SECTION 8: COMPLEX MULTI-TABLE JOINS
-- ========================================

-- Practice Question 8.1: Comprehensive employee report
SELECT 
    CONCAT(e.Fname, ' ', e.Lname) AS Employee_Name,
    d.Dname AS Department,
    COALESCE(CONCAT(s.Fname, ' ', s.Lname), 'No Supervisor') AS Supervisor,
    COUNT(DISTINCT w.Pno) AS Number_of_Projects,
    COALESCE(SUM(w.Hours), 0) AS Total_Hours_Worked,
    COUNT(DISTINCT dep.Dependent_name) AS Number_of_Dependents
FROM EMPLOYEE e
JOIN DEPARTMENT d ON e.Dno = d.Dnumber
LEFT JOIN EMPLOYEE s ON e.Super_ssn = s.Ssn
LEFT JOIN WORKS_ON w ON e.Ssn = w.Essn
LEFT JOIN DEPENDENT dep ON e.Ssn = dep.Essn
GROUP BY e.Ssn, e.Fname, e.Lname, d.Dname, s.Fname, s.Lname
ORDER BY d.Dname, e.Lname;

-- Practice Question 8.2: Find departments where all employees have at least one dependent
SELECT d.Dname AS Department_Name
FROM DEPARTMENT d
WHERE NOT EXISTS (
    SELECT e.Ssn
    FROM EMPLOYEE e
    WHERE e.Dno = d.Dnumber
    AND NOT EXISTS (
        SELECT dep.Essn
        FROM DEPENDENT dep
        WHERE dep.Essn = e.Ssn
    )
);

-- Practice Question 8.3: Find the employee who works the most hours across all projects in each department
SELECT 
    d.Dname AS Department,
    CONCAT(e.Fname, ' ', e.Lname) AS Hardest_Working_Employee,
    SUM(w.Hours) AS Total_Hours
FROM EMPLOYEE e
JOIN DEPARTMENT d ON e.Dno = d.Dnumber
JOIN WORKS_ON w ON e.Ssn = w.Essn
GROUP BY d.Dnumber, d.Dname, e.Ssn, e.Fname, e.Lname
HAVING SUM(w.Hours) = (
    SELECT MAX(total_by_emp.total_hours)
    FROM (
        SELECT SUM(w2.Hours) AS total_hours
        FROM EMPLOYEE e2
        JOIN WORKS_ON w2 ON e2.Ssn = w2.Essn
        WHERE e2.Dno = d.Dnumber
        GROUP BY e2.Ssn
    ) total_by_emp
)
ORDER BY d.Dname;

-- ========================================
-- VERIFICATION COMPLETE!
-- ========================================
