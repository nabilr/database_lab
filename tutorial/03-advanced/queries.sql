-- ========================================
-- ADVANCED SQL TUTORIAL
-- ========================================
-- This section covers window functions, CTEs, recursive queries, and complex analytics
-- Topics: Window functions, CTEs, Recursive CTEs, Advanced joins, Performance optimization

-- Section 1: Window Functions
-- ========================================

-- 1.1 ROW_NUMBER() - Ranking students by enrollment date
SELECT 
    s.name,
    e.enrolled_on,
    ROW_NUMBER() OVER (ORDER BY e.enrolled_on) as enrollment_order
FROM student s
INNER JOIN enrollment e ON s.student_id = e.student_id;

-- 1.2 RANK() and DENSE_RANK() - Quiz score rankings
SELECT 
    s.name,
    qs.score,
    q.max_score,
    RANK() OVER (PARTITION BY qs.quiz_id ORDER BY qs.score DESC) as score_rank,
    DENSE_RANK() OVER (PARTITION BY qs.quiz_id ORDER BY qs.score DESC) as dense_rank
FROM quiz_submission qs
INNER JOIN student s ON qs.student_id = s.student_id
INNER JOIN quiz q ON qs.quiz_id = q.quiz_id;

-- 1.3 LAG() and LEAD() - Compare consecutive enrollments
SELECT 
    s.name,
    e.enrolled_on,
    LAG(e.enrolled_on) OVER (ORDER BY e.enrolled_on) as previous_enrollment,
    LEAD(e.enrolled_on) OVER (ORDER BY e.enrolled_on) as next_enrollment,
    DATEDIFF(e.enrolled_on, LAG(e.enrolled_on) OVER (ORDER BY e.enrolled_on)) as days_since_previous
FROM student s
INNER JOIN enrollment e ON s.student_id = e.student_id;

-- 1.4 Running totals and moving averages
SELECT 
    s.name,
    qs.score,
    SUM(qs.score) OVER (ORDER BY qs.submitted_at ROWS UNBOUNDED PRECEDING) as running_total,
    AVG(qs.score) OVER (ORDER BY qs.submitted_at ROWS 2 PRECEDING) as moving_avg_3
FROM quiz_submission qs
INNER JOIN student s ON qs.student_id = s.student_id
ORDER BY qs.submitted_at;

-- 1.5 NTILE() - Dividing students into performance quartiles
SELECT 
    s.name,
    qs.score,
    q.max_score,
    (qs.score / q.max_score * 100) as percentage,
    NTILE(4) OVER (ORDER BY (qs.score / q.max_score)) as performance_quartile
FROM quiz_submission qs
INNER JOIN student s ON qs.student_id = s.student_id
INNER JOIN quiz q ON qs.quiz_id = q.quiz_id;

-- Section 2: Common Table Expressions (CTEs)
-- ========================================

-- 2.1 Simple CTE - Department statistics
WITH dept_stats AS (
    SELECT 
        d.dept_id,
        d.name as dept_name,
        COUNT(DISTINCT s.student_id) as student_count,
        COUNT(DISTINCT c.course_id) as course_count,
        COUNT(DISTINCT i.instructor_id) as instructor_count
    FROM department d
    LEFT JOIN student s ON d.dept_id = s.dept_id
    LEFT JOIN course c ON d.dept_id = c.dept_id
    LEFT JOIN instructor i ON d.dept_id = i.dept_id
    GROUP BY d.dept_id, d.name
)
SELECT 
    dept_name,
    student_count,
    course_count,
    instructor_count,
    ROUND(student_count / NULLIF(instructor_count, 0), 2) as student_to_instructor_ratio
FROM dept_stats;

-- 2.2 Multiple CTEs - Course difficulty analysis
WITH quiz_scores AS (
    SELECT 
        s.course_id,
        AVG(qs.score / q.max_score * 100) as avg_percentage
    FROM section s
    INNER JOIN quiz q ON s.section_id = q.section_id
    INNER JOIN quiz_submission qs ON q.quiz_id = qs.quiz_id
    GROUP BY s.course_id
),
enrollment_stats AS (
    SELECT 
        s.course_id,
        COUNT(DISTINCT e.student_id) as total_enrolled
    FROM section s
    INNER JOIN enrollment e ON s.section_id = e.section_id
    GROUP BY s.course_id
)
SELECT 
    c.title,
    c.credits,
    COALESCE(es.total_enrolled, 0) as enrolled_students,
    COALESCE(qs.avg_percentage, 0) as avg_quiz_percentage,
    CASE 
        WHEN qs.avg_percentage < 70 THEN 'Difficult'
        WHEN qs.avg_percentage < 85 THEN 'Moderate'
        ELSE 'Easy'
    END as difficulty_level
FROM course c
LEFT JOIN quiz_scores qs ON c.course_id = qs.course_id
LEFT JOIN enrollment_stats es ON c.course_id = es.course_id;

-- Section 3: Recursive CTEs
-- ========================================

-- 3.1 Recursive CTE - Course prerequisite chain
WITH RECURSIVE prerequisite_chain AS (
    -- Base case: courses with no prerequisites
    SELECT 
        course_id,
        title,
        0 as level,
        CAST(title AS CHAR(1000)) as path
    FROM course
    WHERE course_id NOT IN (SELECT course_id FROM prerequisite)
    
    UNION ALL
    
    -- Recursive case: courses that depend on previous level
    SELECT 
        c.course_id,
        c.title,
        pc.level + 1,
        CONCAT(pc.path, ' -> ', c.title)
    FROM course c
    INNER JOIN prerequisite p ON c.course_id = p.course_id
    INNER JOIN prerequisite_chain pc ON p.prereq_id = pc.course_id
    WHERE pc.level < 5  -- Prevent infinite recursion
)
SELECT 
    title,
    level as prerequisite_depth,
    path as learning_path
FROM prerequisite_chain
ORDER BY level, title;

-- Section 4: Advanced Analytics
-- ========================================

-- 4.1 Cohort analysis - Student performance over time
WITH student_cohorts AS (
    SELECT 
        s.student_id,
        s.name,
        s.year_level,
        MIN(e.enrolled_on) as first_enrollment_date,
        COUNT(DISTINCT e.section_id) as total_courses
    FROM student s
    INNER JOIN enrollment e ON s.student_id = e.student_id
    GROUP BY s.student_id, s.name, s.year_level
),
performance_metrics AS (
    SELECT 
        sc.student_id,
        sc.name,
        sc.year_level,
        sc.total_courses,
        AVG(qs.score / q.max_score * 100) as avg_performance,
        COUNT(qs.quiz_id) as quizzes_taken
    FROM student_cohorts sc
    LEFT JOIN quiz_submission qs ON sc.student_id = qs.student_id
    LEFT JOIN quiz q ON qs.quiz_id = q.quiz_id
    GROUP BY sc.student_id, sc.name, sc.year_level, sc.total_courses
)
SELECT 
    year_level as cohort,
    COUNT(*) as students_in_cohort,
    AVG(total_courses) as avg_courses_per_student,
    AVG(avg_performance) as cohort_avg_performance,
    AVG(quizzes_taken) as avg_quizzes_per_student
FROM performance_metrics
GROUP BY year_level
ORDER BY 
    CASE year_level
        WHEN 'Freshman' THEN 1
        WHEN 'Sophomore' THEN 2
        WHEN 'Junior' THEN 3
        WHEN 'Senior' THEN 4
    END;

-- 4.2 Advanced pivot table - Department performance matrix
SELECT 
    d.name as department,
    SUM(CASE WHEN s.year_level = 'Freshman' THEN 1 ELSE 0 END) as freshmen,
    SUM(CASE WHEN s.year_level = 'Sophomore' THEN 1 ELSE 0 END) as sophomores,
    SUM(CASE WHEN s.year_level = 'Junior' THEN 1 ELSE 0 END) as juniors,
    SUM(CASE WHEN s.year_level = 'Senior' THEN 1 ELSE 0 END) as seniors,
    COUNT(DISTINCT c.course_id) as courses_offered,
    COUNT(DISTINCT i.instructor_id) as faculty_count,
    ROUND(AVG(qs.score / q.max_score * 100), 2) as avg_quiz_performance
FROM department d
LEFT JOIN student s ON d.dept_id = s.dept_id
LEFT JOIN course c ON d.dept_id = c.dept_id
LEFT JOIN instructor i ON d.dept_id = i.dept_id
LEFT JOIN section sec ON c.course_id = sec.course_id
LEFT JOIN quiz q ON sec.section_id = q.section_id
LEFT JOIN quiz_submission qs ON q.quiz_id = qs.quiz_id AND s.student_id = qs.student_id
GROUP BY d.dept_id, d.name;

-- Section 5: Performance Optimization Patterns
-- ========================================

-- 5.1 Using EXISTS vs IN for better performance
-- Instead of: WHERE student_id IN (SELECT student_id FROM enrollment)
SELECT s.name
FROM student s
WHERE EXISTS (
    SELECT 1 
    FROM enrollment e 
    WHERE e.student_id = s.student_id
);

-- 5.2 Efficient pagination with window functions
WITH ranked_students AS (
    SELECT 
        student_id,
        name,
        year_level,
        ROW_NUMBER() OVER (ORDER BY name) as row_num
    FROM student
)
SELECT student_id, name, year_level
FROM ranked_students
WHERE row_num BETWEEN 2 AND 3;  -- Page 2, 2 records per page

-- Section 6: Complex Business Logic
-- ========================================

-- 6.1 Student academic standing calculator
WITH student_performance AS (
    SELECT 
        s.student_id,
        s.name,
        s.year_level,
        COUNT(DISTINCT e.section_id) as courses_enrolled,
        COUNT(DISTINCT qs.quiz_id) as quizzes_taken,
        AVG(qs.score / q.max_score * 100) as avg_quiz_percentage,
        SUM(c.credits) as total_credits_attempted
    FROM student s
    LEFT JOIN enrollment e ON s.student_id = e.student_id
    LEFT JOIN section sec ON e.section_id = sec.section_id
    LEFT JOIN course c ON sec.course_id = c.course_id
    LEFT JOIN quiz q ON sec.section_id = q.section_id
    LEFT JOIN quiz_submission qs ON q.quiz_id = qs.quiz_id AND s.student_id = qs.student_id
    GROUP BY s.student_id, s.name, s.year_level
)
SELECT 
    name,
    year_level,
    courses_enrolled,
    total_credits_attempted,
    COALESCE(avg_quiz_percentage, 0) as performance_percentage,
    CASE 
        WHEN COALESCE(avg_quiz_percentage, 0) >= 90 THEN 'Dean\'s List'
        WHEN COALESCE(avg_quiz_percentage, 0) >= 80 THEN 'Good Standing'
        WHEN COALESCE(avg_quiz_percentage, 0) >= 70 THEN 'Satisfactory'
        WHEN COALESCE(avg_quiz_percentage, 0) >= 60 THEN 'Probation'
        ELSE 'Academic Warning'
    END as academic_standing,
    CASE 
        WHEN courses_enrolled = 0 THEN 'Not Enrolled'
        WHEN total_credits_attempted < 12 THEN 'Part-time'
        ELSE 'Full-time'
    END as enrollment_status
FROM student_performance
ORDER BY avg_quiz_percentage DESC NULLS LAST;

-- Section 7: Advanced Practice Exercises
-- ========================================

-- Exercise 1: Find the top-performing student in each department
WITH dept_rankings AS (
    SELECT 
        s.student_id,
        s.name,
        d.name as department,
        AVG(qs.score / q.max_score * 100) as avg_percentage,
        ROW_NUMBER() OVER (PARTITION BY d.dept_id ORDER BY AVG(qs.score / q.max_score * 100) DESC) as dept_rank
    FROM student s
    INNER JOIN department d ON s.dept_id = d.dept_id
    LEFT JOIN quiz_submission qs ON s.student_id = qs.student_id
    LEFT JOIN quiz q ON qs.quiz_id = q.quiz_id
    GROUP BY s.student_id, s.name, d.dept_id, d.name
    HAVING COUNT(qs.quiz_id) > 0
)
SELECT name, department, ROUND(avg_percentage, 2) as performance
FROM dept_rankings
WHERE dept_rank = 1;

-- Exercise 2: Calculate semester workload distribution
WITH instructor_workload AS (
    SELECT 
        i.instructor_id,
        i.name,
        sec.term,
        sec.year_num,
        COUNT(sec.section_id) as sections_taught,
        SUM(c.credits) as total_credits,
        COUNT(DISTINCT e.student_id) as total_students
    FROM instructor i
    LEFT JOIN section sec ON i.instructor_id = sec.instructor_id
    LEFT JOIN course c ON sec.course_id = c.course_id
    LEFT JOIN enrollment e ON sec.section_id = e.section_id
    GROUP BY i.instructor_id, i.name, sec.term, sec.year_num
)
SELECT 
    name,
    term,
    year_num,
    sections_taught,
    total_credits,
    total_students,
    CASE 
        WHEN total_credits > 10 THEN 'Overloaded'
        WHEN total_credits >= 6 THEN 'Full Load'
        WHEN total_credits > 0 THEN 'Light Load'
        ELSE 'No Teaching'
    END as workload_status
FROM instructor_workload
WHERE term IS NOT NULL
ORDER BY name, year_num, term;
