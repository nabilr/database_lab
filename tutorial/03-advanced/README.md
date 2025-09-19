# Advanced SQL Tutorial

## 🎯 Learning Objectives
After completing this tutorial, you will be able to:
- Use window functions (ROW_NUMBER, RANK, LAG, LEAD, etc.)
- Write Common Table Expressions (CTEs)
- Create recursive queries
- Analyze query performance
- Optimize database queries with indexes
- Build complex analytics queries
- Use stored procedures and functions

## 🗄️ Database Setup
```bash
# From this directory
docker build -t university-mysql-advanced .
docker run --name uni-db-advanced -p 3308:3306 university-mysql-advanced
```

## 📚 Tutorial Sections

### 1. Window Functions
Master ranking, running totals, and analytical functions.

### 2. Common Table Expressions (CTEs)
Write readable, modular queries with CTEs.

### 3. Recursive CTEs
Handle hierarchical data and complex relationships.

### 4. Advanced Analytics
Build sophisticated reporting and analysis queries.

### 5. Performance Optimization
Learn indexing strategies and query optimization.

### 6. Complex Business Logic
Implement real-world business rules in SQL.

### 7. Advanced Practice Exercises
Enterprise-level scenarios and challenges.

## 🔗 Database Connection
- **Host:** localhost
- **Port:** 3308  
- **Database:** university_advanced
- **Username:** root
- **Password:** advancedpass

## 🔧 Advanced Features
This tutorial includes:
- Extended schema with 10+ additional tables
- Performance monitoring views
- Custom functions and procedures
- Comprehensive indexing examples
- Large dataset for performance testing
- Query optimization examples

## 📊 Performance Monitoring
Built-in tools for query analysis:
```sql
-- View query performance statistics
SELECT * FROM v_query_performance LIMIT 10;

-- Analyze index usage
CALL sp_analyze_index_usage();

-- Calculate student GPA
SELECT calculate_gpa(201) as student_gpa;
```

## 🏃‍♂️ Quick Test
Once your database is running, try this advanced query:
```sql
WITH student_rankings AS (
    SELECT 
        s.name,
        AVG(qs.score / q.max_score * 100) as avg_percentage,
        ROW_NUMBER() OVER (ORDER BY AVG(qs.score / q.max_score * 100) DESC) as rank
    FROM student s
    JOIN quiz_submission qs ON s.student_id = qs.student_id
    JOIN quiz q ON qs.quiz_id = q.quiz_id
    GROUP BY s.student_id, s.name
)
SELECT name, ROUND(avg_percentage, 2) as performance, rank
FROM student_rankings
WHERE rank <= 3;
```

## 🚀 Enterprise Concepts
This tutorial covers production-ready SQL techniques used in:
- Data warehousing
- Business intelligence
- Performance optimization
- Large-scale database management
