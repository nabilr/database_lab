-- ========================================
-- QUIZ 2 PRACTICE QUESTIONS
-- Advanced SQL Topics for Database Lab
-- ========================================
-- Topics Covered:
-- 1. More Complex SQL Retrieval Queries
-- 2. Specifying Constraints as Assertions and Actions as Triggers
-- 3. Views (Virtual Tables) in SQL
-- 4. Schema Change Statements in SQL
-- 5. Comparisons Involving NULL and Three-Valued Logic
-- 6. Nested Queries, Tuples, and Set/Multiset Comparisons
-- 7. Correlated Nested Queries
-- 8. The EXISTS and UNIQUE Functions in SQL
-- 9. Explicit Sets and Renaming of Attributes in SQL
-- 10. Grouping: The GROUP BY and HAVING Clauses
-- 11. Aggregate Functions in SQL
-- 12. Discussion and Summary of SQL Queries
-- 13. Tutorial examples of SQL queries

-- ========================================
-- SAMPLE DATABASE SCHEMA
-- ========================================
-- This practice uses a University Management System with the following tables:
-- 
-- STUDENT (student_id, name, dept_id, year_level, gpa, enrollment_date)
-- DEPARTMENT (dept_id, name, budget, building)
-- COURSE (course_id, title, credits, dept_id, description)
-- SECTION (section_id, course_id, term, year_num, instructor_id, capacity)
-- ENROLLMENT (enrollment_id, student_id, section_id, enrolled_on, grade)
-- INSTRUCTOR (instructor_id, name, dept_id, salary, hire_date)
-- QUIZ (quiz_id, section_id, title, max_score, due_date)
-- QUIZ_SUBMISSION (submission_id, student_id, quiz_id, score, submitted_at)

-- ========================================
-- SECTION 1: MORE COMPLEX SQL RETRIEVAL QUERIES
-- ========================================

-- Question 1.1: Complex WHERE with Multiple Conditions
-- Difficulty: Intermediate
-- Write a query to find all students who:
-- - Are in Computer Science or Mathematics departments
-- - Have GPA between 3.0 and 3.8
-- - Enrolled after 2020
-- - Are not Freshmen

-- Question 1.2: Advanced JOIN with Multiple Tables
-- Difficulty: Advanced
-- Write a query to find all students who:
-- - Are enrolled in courses taught by instructors earning more than $60,000
-- - Show student name, course title, instructor name, and instructor salary
-- - Include only courses with more than 2 credits

-- Question 1.3: Complex ORDER BY with CASE
-- Difficulty: Intermediate
-- Write a query to list all students ordered by:
-- - First: Department (Computer Science, then Mathematics, then others)
-- - Second: GPA (descending)
-- - Third: Name (ascending)
-- Use CASE statements for custom ordering

-- ========================================
-- SECTION 2: SPECIFYING CONSTRAINTS AS ASSERTIONS AND ACTIONS AS TRIGGERS
-- ========================================

-- Question 2.1: Creating Assertions
-- Difficulty: Advanced
-- Create an assertion to ensure that no instructor can teach more than 4 sections in a single semester.

-- Question 2.2: Creating Triggers for Data Integrity
-- Difficulty: Advanced
-- Create a trigger that automatically updates a student's GPA whenever a new grade is inserted into the ENROLLMENT table.

-- Question 2.3: Trigger for Business Rules
-- Difficulty: Advanced
-- Create a trigger that prevents enrollment in a course if the student hasn't completed the prerequisites.

-- ========================================
-- SECTION 3: VIEWS (VIRTUAL TABLES) IN SQL
-- ========================================

-- Question 3.1: Simple View Creation
-- Difficulty: Easy
-- Create a view called "student_summary" that shows:
-- - Student ID, name, department name, and GPA
-- - Only for students with GPA > 3.0

-- Question 3.2: Complex View with Aggregations
-- Difficulty: Intermediate
-- Create a view called "department_statistics" that shows:
-- - Department name
-- - Number of students
-- - Average GPA
-- - Number of courses offered
-- - Total budget

-- Question 3.3: Updatable View
-- Difficulty: Advanced
-- Create an updatable view called "student_contacts" that allows updating student names and department assignments.

-- ========================================
-- SECTION 4: SCHEMA CHANGE STATEMENTS IN SQL
-- ========================================

-- Question 4.1: Adding Columns
-- Difficulty: Easy
-- Add a new column "phone_number" to the STUDENT table with VARCHAR(15) data type.

-- Question 4.2: Modifying Column Properties
-- Difficulty: Intermediate
-- Modify the GPA column in the STUDENT table to allow NULL values and change the precision to DECIMAL(4,2).

-- Question 4.3: Adding Constraints
-- Difficulty: Intermediate
-- Add a CHECK constraint to ensure that student GPA is between 0.0 and 4.0.

-- Question 4.4: Dropping and Recreating Tables
-- Difficulty: Advanced
-- Create a new table "STUDENT_HISTORY" to track student academic history, then modify the existing STUDENT table to reference it.

-- ========================================
-- SECTION 5: COMPARISONS INVOLVING NULL AND THREE-VALUED LOGIC
-- ========================================

-- Question 5.1: NULL Comparisons
-- Difficulty: Easy
-- Write a query to find all students who have NULL GPA values and all students who have non-NULL GPA values.

-- Question 5.2: Three-Valued Logic with AND/OR
-- Difficulty: Intermediate
-- Write a query that demonstrates three-valued logic by finding students where:
-- - GPA > 3.5 OR dept_id = 1
-- - Show how NULL values affect the result

-- Question 5.3: COALESCE and NULLIF Functions
-- Difficulty: Intermediate
-- Write a query that uses COALESCE to replace NULL GPA values with 0.0 and NULLIF to handle division by zero in GPA calculations.

-- ========================================
-- SECTION 6: NESTED QUERIES, TUPLES, AND SET/MULTISET COMPARISONS
-- ========================================

-- Question 6.1: Scalar Subqueries
-- Difficulty: Easy
-- Write a query to find all students whose GPA is higher than the average GPA of all students.

-- Question 6.2: Subqueries with IN and NOT IN
-- Difficulty: Intermediate
-- Write a query to find all students who are enrolled in courses taught by instructors from the Computer Science department.

-- Question 6.3: Tuple Comparisons
-- Difficulty: Advanced
-- Write a query to find all students who have the same GPA and are in the same department as at least one other student.

-- Question 6.4: Set Operations (UNION, INTERSECT, EXCEPT)
-- Difficulty: Intermediate
-- Write queries using UNION, INTERSECT, and EXCEPT to:
-- - Find students in CS or Math departments (UNION)
-- - Find students who are both CS majors and have GPA > 3.5 (INTERSECT)
-- - Find CS students who don't have GPA > 3.5 (EXCEPT)

-- ========================================
-- SECTION 7: CORRELATED NESTED QUERIES
-- ========================================

-- Question 7.1: Basic Correlated Subquery
-- Difficulty: Intermediate
-- Write a query to find all students who have a GPA higher than the average GPA of students in their own department.

-- Question 7.2: Correlated Subquery with EXISTS
-- Difficulty: Advanced
-- Write a query to find all departments that have at least one student with GPA > 3.5.

-- Question 7.3: Multiple Correlated Subqueries
-- Difficulty: Advanced
-- Write a query to find all students who:
-- - Have GPA higher than the department average
-- - Are enrolled in more courses than the student average
-- - Have taken at least one quiz

-- ========================================
-- SECTION 8: THE EXISTS AND UNIQUE FUNCTIONS IN SQL
-- ========================================

-- Question 8.1: EXISTS Function
-- Difficulty: Intermediate
-- Write a query using EXISTS to find all students who have submitted at least one quiz.

-- Question 8.2: NOT EXISTS Function
-- Difficulty: Intermediate
-- Write a query using NOT EXISTS to find all students who have never submitted any quiz.

-- Question 8.3: UNIQUE Function
-- Difficulty: Advanced
-- Write a query using UNIQUE to find all departments where all students have unique GPAs (no duplicate GPAs within the department).

-- Question 8.4: EXISTS vs IN Performance
-- Difficulty: Advanced
-- Write equivalent queries using both EXISTS and IN, then explain the performance differences.

-- ========================================
-- SECTION 9: EXPLICIT SETS AND RENAMING OF ATTRIBUTES IN SQL
-- ========================================

-- Question 9.1: Explicit Sets with IN
-- Difficulty: Easy
-- Write a query to find all students whose year_level is in the explicit set ('Sophomore', 'Junior', 'Senior').

-- Question 9.2: Attribute Renaming
-- Difficulty: Easy
-- Write a query that renames columns to be more descriptive:
-- - student_id → Student_ID
-- - name → Full_Name
-- - gpa → Grade_Point_Average

-- Question 9.3: Complex Renaming with Expressions
-- Difficulty: Intermediate
-- Write a query that creates calculated columns with descriptive names:
-- - "Academic_Standing" based on GPA ranges
-- - "Years_Enrolled" calculated from enrollment date
-- - "Department_Rank" based on GPA within department

-- ========================================
-- SECTION 10: GROUPING - THE GROUP BY AND HAVING CLAUSES
-- ========================================

-- Question 10.1: Basic GROUP BY
-- Difficulty: Easy
-- Write a query to count the number of students in each department.

-- Question 10.2: GROUP BY with Multiple Columns
-- Difficulty: Intermediate
-- Write a query to find the average GPA for each combination of department and year level.

-- Question 10.3: HAVING Clause
-- Difficulty: Intermediate
-- Write a query to find departments that have more than 5 students and average GPA > 3.0.

-- Question 10.4: Complex GROUP BY with JOINs
-- Difficulty: Advanced
-- Write a query to find the average quiz score for each student, grouped by department and year level, showing only groups with more than 2 students.

-- ========================================
-- SECTION 11: AGGREGATE FUNCTIONS IN SQL
-- ========================================

-- Question 11.1: Basic Aggregate Functions
-- Difficulty: Easy
-- Write a query to find the minimum, maximum, average, and count of student GPAs.

-- Question 11.2: Aggregate Functions with GROUP BY
-- Difficulty: Intermediate
-- Write a query to find the total budget, average salary, and number of instructors for each department.

-- Question 11.3: Conditional Aggregates
-- Difficulty: Advanced
-- Write a query to find:
-- - Total number of students
-- - Number of students with GPA > 3.0
-- - Number of students with GPA <= 3.0
-- - Average GPA for each category

-- Question 11.4: Window Functions with Aggregates
-- Difficulty: Advanced
-- Write a query to show each student's GPA along with:
-- - Department average GPA
-- - Overall average GPA
-- - Student's rank within department
-- - Student's percentile within department

-- ========================================
-- SECTION 12: DISCUSSION AND SUMMARY OF SQL QUERIES
-- ========================================

-- Question 12.1: Query Optimization
-- Difficulty: Advanced
-- Analyze the following query and suggest optimizations:
-- SELECT s.name, d.name, c.title
-- FROM student s, department d, course c, enrollment e
-- WHERE s.dept_id = d.dept_id 
--   AND e.student_id = s.student_id 
--   AND c.course_id = e.course_id
--   AND s.gpa > 3.0;

-- Question 12.2: Query Equivalence
-- Difficulty: Advanced
-- Write three different queries that produce the same result:
-- "Find all students who are enrolled in Computer Science courses"

-- Question 12.3: Performance Analysis
-- Difficulty: Advanced
-- Compare the performance of these equivalent queries and explain the differences:
-- 1. Using IN with subquery
-- 2. Using EXISTS with subquery
-- 3. Using JOIN

-- ========================================
-- SECTION 13: TUTORIAL EXAMPLES OF SQL QUERIES
-- ========================================

-- Question 13.1: Real-World Business Query
-- Difficulty: Intermediate
-- Write a query to generate a student academic report showing:
-- - Student information
-- - Courses enrolled
-- - Quiz performance
-- - Academic standing
-- - Department ranking

-- Question 13.2: Data Analysis Query
-- Difficulty: Advanced
-- Write a query to analyze instructor workload:
-- - Instructor name and department
-- - Number of sections taught
-- - Total students taught
-- - Average quiz scores for their sections
-- - Workload classification (Light/Medium/Heavy)

-- Question 13.3: Reporting Query
-- Difficulty: Advanced
-- Write a query to generate a department performance report:
-- - Department name and budget
-- - Student enrollment by year level
-- - Average GPA by year level
-- - Course offerings and enrollment
-- - Faculty-to-student ratio
-- - Performance metrics and recommendations

-- ========================================
-- SAMPLE DATA FOR TESTING
-- ========================================

-- Use the following sample data to test your queries:

-- INSERT INTO DEPARTMENT VALUES 
-- (1, 'Computer Science', 500000.00, 'Engineering Building'),
-- (2, 'Mathematics', 300000.00, 'Science Building'),
-- (3, 'Physics', 250000.00, 'Science Building');

-- INSERT INTO STUDENT VALUES
-- (101, 'Alice Johnson', 1, 'Sophomore', 3.5, '2022-09-01'),
-- (102, 'Bob Smith', 1, 'Junior', 3.8, '2021-09-01'),
-- (103, 'Carol Davis', 2, 'Senior', 3.2, '2020-09-01'),
-- (104, 'David Wilson', 1, 'Freshman', 2.8, '2023-09-01'),
-- (105, 'Eve Brown', 2, 'Sophomore', 3.6, '2022-09-01');

-- INSERT INTO INSTRUCTOR VALUES
-- (201, 'Dr. Smith', 1, 75000.00, '2020-01-15'),
-- (202, 'Dr. Johnson', 1, 80000.00, '2019-08-20'),
-- (203, 'Dr. Davis', 2, 70000.00, '2021-01-10');

-- INSERT INTO COURSE VALUES
-- (301, 'Database Systems', 3, 1, 'Introduction to database concepts'),
-- (302, 'Data Structures', 3, 1, 'Fundamental data structures'),
-- (303, 'Calculus I', 4, 2, 'Differential calculus'),
-- (304, 'Linear Algebra', 3, 2, 'Vector spaces and linear transformations');

-- INSERT INTO SECTION VALUES
-- (401, 301, 'Fall', 2024, 201, 30),
-- (402, 302, 'Fall', 2024, 202, 25),
-- (403, 303, 'Fall', 2024, 203, 35),
-- (404, 304, 'Spring', 2025, 203, 30);

-- INSERT INTO ENROLLMENT VALUES
-- (501, 101, 401, '2024-08-15', 85.5),
-- (502, 102, 401, '2024-08-15', 92.0),
-- (503, 101, 402, '2024-08-15', 88.0),
-- (504, 103, 403, '2024-08-15', 78.5),
-- (505, 105, 403, '2024-08-15', 91.0);

-- INSERT INTO QUIZ VALUES
-- (601, 401, 'Quiz 1', 100, '2024-09-15'),
-- (602, 401, 'Quiz 2', 100, '2024-10-15'),
-- (603, 402, 'Quiz 1', 100, '2024-09-20');

-- INSERT INTO QUIZ_SUBMISSION VALUES
-- (701, 101, 601, 85, '2024-09-15 10:00:00'),
-- (702, 102, 601, 95, '2024-09-15 10:30:00'),
-- (703, 101, 602, 90, '2024-10-15 09:00:00'),
-- (704, 102, 602, 88, '2024-10-15 09:15:00'),
-- (705, 101, 603, 82, '2024-09-20 11:00:00');

-- ========================================
-- END OF PRACTICE QUESTIONS
-- ========================================
-- 
-- Instructions for Practice:
-- 1. Work through each section systematically
-- 2. Test your queries with the provided sample data
-- 3. Compare your results with expected outputs
-- 4. Focus on understanding the concepts, not just memorizing syntax
-- 5. Practice explaining your queries in plain English
-- 6. Consider performance implications of different approaches
-- 7. Total: 50+ practice questions covering all Quiz 2 topics
-- ========================================
