-- ========================================
-- INTERMEDIATE SQL TUTORIAL
-- ========================================
-- This section covers aggregation, grouping, subqueries, and set operations
-- Topics: GROUP BY, HAVING, Subqueries, UNION, Date functions, CASE statements

-- Section 1: Aggregation Functions
-- ========================================

-- 1.1 Count total records
SELECT COUNT(*) as total_students FROM student;

-- 1.2 Count non-null values
SELECT COUNT(dept_id) as students_with_dept FROM student;

-- 1.3 Sum and average
SELECT AVG(credits) as avg_credits, SUM(credits) as total_credits 
FROM course;

-- 1.4 Min and max values
SELECT MIN(max_score) as min_quiz_score, MAX(max_score) as max_quiz_score 
FROM quiz;

-- Section 2: GROUP BY and HAVING
-- ========================================

-- 2.1 Group by single column
SELECT dept_id, COUNT(*) as student_count
FROM student
WHERE dept_id IS NOT NULL
GROUP BY dept_id;

-- 2.2 Group by multiple columns
SELECT dept_id, year_level, COUNT(*) as count
FROM student
WHERE dept_id IS NOT NULL
GROUP BY dept_id, year_level
ORDER BY dept_id, year_level;

-- 2.3 GROUP BY with JOIN
SELECT d.name as department, COUNT(s.student_id) as student_count
FROM department d
LEFT JOIN student s ON d.dept_id = s.dept_id
GROUP BY d.dept_id, d.name
ORDER BY student_count DESC;

-- 2.4 HAVING clause for filtering groups
SELECT d.name as department, COUNT(c.course_id) as course_count
FROM department d
LEFT JOIN course c ON d.dept_id = c.dept_id
GROUP BY d.dept_id, d.name
HAVING COUNT(c.course_id) >= 2;

-- Section 3: Subqueries
-- ========================================

-- 3.1 Scalar subquery in WHERE clause
SELECT name, year_level
FROM student
WHERE dept_id = (
    SELECT dept_id 
    FROM department 
    WHERE name = 'Computer Science'
);

-- 3.2 Subquery with IN operator
SELECT title
FROM course
WHERE course_id IN (
    SELECT course_id 
    FROM section 
    WHERE term = 'Fall' AND year_num = 2025
);

-- 3.3 Correlated subquery
SELECT s.name, s.year_level
FROM student s
WHERE EXISTS (
    SELECT 1 
    FROM enrollment e 
    WHERE e.student_id = s.student_id
);

-- 3.4 Subquery in SELECT clause
SELECT s.name,
       (SELECT COUNT(*) 
        FROM enrollment e 
        WHERE e.student_id = s.student_id) as enrollment_count
FROM student s;

-- Section 4: UNION Operations
-- ========================================

-- 4.1 UNION ALL - University directory
SELECT 
    name,
    'Instructor' as role,
    email
FROM instructor

UNION ALL

SELECT 
    name,
    CONCAT('Student (', year_level, ')') as role,
    NULL as email
FROM student
ORDER BY role, name;

-- 4.2 UNION - Remove duplicates (if any existed)
SELECT dept_id FROM instructor
UNION
SELECT dept_id FROM student
ORDER BY dept_id;

-- Section 5: Date Functions and CASE Statements
-- ========================================

-- 5.1 Date functions with enrollment data
SELECT 
    student_id,
    enrolled_on,
    DAYOFWEEK(enrolled_on) as day_of_week,
    MONTH(enrolled_on) as enrollment_month,
    DATEDIFF(CURDATE(), enrolled_on) as days_since_enrollment
FROM enrollment;

-- 5.2 CASE statements for categorization
SELECT 
    name,
    credits,
    CASE 
        WHEN credits <= 2 THEN 'Light Course'
        WHEN credits = 3 THEN 'Standard Course'
        WHEN credits >= 4 THEN 'Heavy Course'
    END as course_load
FROM course;

-- 5.3 Complex CASE with aggregation
SELECT 
    d.name as department,
    COUNT(CASE WHEN s.year_level = 'Freshman' THEN 1 END) as freshmen,
    COUNT(CASE WHEN s.year_level = 'Sophomore' THEN 1 END) as sophomores,
    COUNT(CASE WHEN s.year_level = 'Junior' THEN 1 END) as juniors,
    COUNT(CASE WHEN s.year_level = 'Senior' THEN 1 END) as seniors
FROM department d
LEFT JOIN student s ON d.dept_id = s.dept_id
GROUP BY d.dept_id, d.name;

-- Section 6: Advanced Joins and Set Operations
-- ========================================

-- 6.1 Self-join for prerequisites
SELECT 
    c1.title as course,
    c2.title as prerequisite
FROM course c1
INNER JOIN prerequisite p ON c1.course_id = p.course_id
INNER JOIN course c2 ON p.prereq_id = c2.course_id;

-- 6.2 Multiple aggregations with different groupings
SELECT 
    'Department' as metric_type,
    d.name as metric_name,
    COUNT(DISTINCT s.student_id) as count
FROM department d
LEFT JOIN student s ON d.dept_id = s.dept_id
GROUP BY d.dept_id, d.name

UNION ALL

SELECT 
    'Year Level' as metric_type,
    s.year_level as metric_name,
    COUNT(*) as count
FROM student s
GROUP BY s.year_level

ORDER BY metric_type, count DESC;

-- Section 7: Practice Exercises
-- ========================================

-- Exercise 1: Find departments with average course credits > 3
SELECT d.name, AVG(c.credits) as avg_credits
FROM department d
INNER JOIN course c ON d.dept_id = c.dept_id
GROUP BY d.dept_id, d.name
HAVING AVG(c.credits) > 3;

-- Exercise 2: Students who haven't taken any quizzes
SELECT s.name
FROM student s
WHERE s.student_id NOT IN (
    SELECT DISTINCT qs.student_id 
    FROM quiz_submission qs
);

-- Exercise 3: Quiz performance analysis
SELECT 
    q.title,
    COUNT(qs.student_id) as submissions,
    AVG(qs.score) as avg_score,
    AVG(qs.score / q.max_score * 100) as avg_percentage
FROM quiz q
LEFT JOIN quiz_submission qs ON q.quiz_id = qs.quiz_id
GROUP BY q.quiz_id, q.title, q.max_score;

-- Exercise 4: Course enrollment summary
SELECT 
    c.title,
    COUNT(e.student_id) as enrolled_students,
    CASE 
        WHEN COUNT(e.student_id) = 0 THEN 'No Enrollment'
        WHEN COUNT(e.student_id) < 2 THEN 'Low Enrollment'
        ELSE 'Good Enrollment'
    END as enrollment_status
FROM course c
LEFT JOIN section s ON c.course_id = s.course_id
LEFT JOIN enrollment e ON s.section_id = e.section_id
GROUP BY c.course_id, c.title;

-- Exercise 5: Find students enrolled in multiple courses
SELECT s.name, COUNT(e.section_id) as course_count
FROM student s
INNER JOIN enrollment e ON s.student_id = e.student_id
GROUP BY s.student_id, s.name
HAVING COUNT(e.section_id) > 1;
