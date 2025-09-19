-- Advanced indexing strategies for performance optimization
-- This file demonstrates various indexing techniques and their impact

-- Add composite indexes for common query patterns
CREATE INDEX idx_student_dept_year ON student(dept_id, year_level);
CREATE INDEX idx_section_term_year ON section(term, year_num, course_id);
CREATE INDEX idx_enrollment_date ON enrollment(enrolled_on);
CREATE INDEX idx_quiz_section_author ON quiz(section_id, author_id);

-- Covering indexes (includes additional columns in the index)
CREATE INDEX idx_student_cover ON student(dept_id, year_level) INCLUDE (name);
CREATE INDEX idx_course_cover ON course(dept_id) INCLUDE (title, credits);

-- Functional indexes for computed values
CREATE INDEX idx_quiz_percentage ON quiz_submission((score/10*100));

-- Partial indexes for common filtered queries
CREATE INDEX idx_active_sections ON section(course_id, instructor_id) 
  WHERE term = 'Fall' AND year_num = 2025;

-- Text search indexes
CREATE FULLTEXT INDEX idx_course_title_search ON course(title);
CREATE FULLTEXT INDEX idx_instructor_name_search ON instructor(name);

-- Analyze table statistics for query optimization
ANALYZE TABLE department, instructor, student, course, section, enrollment, quiz, quiz_submission;

-- Create a view for performance monitoring
CREATE VIEW v_query_performance AS
SELECT 
    SCHEMA_NAME as database_name,
    DIGEST_TEXT as normalized_query,
    COUNT_STAR as execution_count,
    AVG_TIMER_WAIT/1000000000 as avg_execution_time_sec,
    MAX_TIMER_WAIT/1000000000 as max_execution_time_sec,
    SUM_ROWS_EXAMINED as total_rows_examined,
    SUM_ROWS_SENT as total_rows_returned
FROM performance_schema.events_statements_summary_by_digest 
WHERE SCHEMA_NAME = 'university_advanced'
ORDER BY COUNT_STAR DESC;

-- Create stored procedure for index usage analysis
DELIMITER $$
CREATE PROCEDURE sp_analyze_index_usage()
BEGIN
    SELECT 
        OBJECT_SCHEMA as database_name,
        OBJECT_NAME as table_name,
        INDEX_NAME as index_name,
        COUNT_FETCH as index_fetches,
        COUNT_INSERT as index_inserts,
        COUNT_UPDATE as index_updates,
        COUNT_DELETE as index_deletes
    FROM performance_schema.table_io_waits_summary_by_index_usage 
    WHERE OBJECT_SCHEMA = 'university_advanced'
    ORDER BY COUNT_FETCH DESC;
END$$
DELIMITER ;

-- Create function for GPA calculation
DELIMITER $$
CREATE FUNCTION calculate_gpa(p_student_id INT) 
RETURNS DECIMAL(3,2)
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE gpa_result DECIMAL(3,2);
    
    SELECT AVG(gs.quality_points * c.credits) / AVG(c.credits)
    INTO gpa_result
    FROM student_grade sg
    JOIN section s ON sg.section_id = s.section_id
    JOIN course c ON s.course_id = c.course_id
    JOIN grade_scale gs ON (sg.points_earned / sg.points_possible * 100) 
        BETWEEN gs.min_percentage AND gs.max_percentage
    WHERE sg.student_id = p_student_id;
    
    RETURN COALESCE(gpa_result, 0.00);
END$$
DELIMITER ;
