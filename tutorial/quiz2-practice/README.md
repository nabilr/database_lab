# Quiz 2 Practice - Advanced SQL Topics

## 🎯 Learning Objectives

This comprehensive practice section covers all advanced SQL topics for Quiz 2, including:

- **More Complex SQL Retrieval Queries** - Advanced filtering, joins, and query optimization
- **Constraints as Assertions and Actions as Triggers** - Data integrity and business rules
- **Views (Virtual Tables) in SQL** - Creating and managing database views
- **Schema Change Statements in SQL** - ALTER TABLE, constraints, and schema modifications
- **Comparisons Involving NULL and Three-Valued Logic** - NULL handling and logical operations
- **Nested Queries, Tuples, and Set/Multiset Comparisons** - Complex subqueries and set operations
- **Correlated Nested Queries** - Advanced subquery techniques
- **The EXISTS and UNIQUE Functions in SQL** - Existence testing and uniqueness validation
- **Explicit Sets and Renaming of Attributes in SQL** - Set operations and column aliasing
- **Grouping: The GROUP BY and HAVING Clauses** - Data aggregation and group filtering
- **Aggregate Functions in SQL** - Statistical and analytical functions
- **Discussion and Summary of SQL Queries** - Query optimization and performance analysis
- **Tutorial examples of SQL queries** - Real-world business scenarios

## 🗄️ Database Setup

### Prerequisites
- Docker installed on your system
- Basic understanding of SQL fundamentals
- Familiarity with database concepts

### Quick Start

1. **Navigate to the quiz2-practice directory:**
   ```bash
   cd tutorial/quiz2-practice
   ```

2. **Build the Docker image:**
   ```bash
   docker build -t quiz2-practice-db .
   ```

3. **Run the database container:**
   ```bash
   docker run --name quiz2-db -p 3311:3306 quiz2-practice-db
   ```

4. **Connect to the database:**
   ```bash
   # Using MySQL client
   mysql -h localhost -P 3311 -u root -pquiz2pass quiz2_practice
   
   # Or using Docker exec
   docker exec -it quiz2-db mysql -u root -pquiz2pass quiz2_practice
   ```

## 📚 Practice Structure

### Files Overview

| File | Description |
|------|-------------|
| `questions.sql` | 50+ practice questions organized by topic |
| `solutions.sql` | Complete solutions with detailed explanations |
| `schema.sql` | Database schema with tables, views, and procedures |
| `sample-data.sql` | Comprehensive test data for practice |
| `Dockerfile` | Docker configuration for easy setup |
| `README.md` | This documentation file |

### Question Categories

#### 1. **More Complex SQL Retrieval Queries** (3 questions)
- Complex WHERE conditions with multiple criteria
- Advanced JOINs across multiple tables
- Custom ORDER BY with CASE statements

#### 2. **Constraints as Assertions and Actions as Triggers** (3 questions)
- Creating assertions for business rules
- Triggers for automatic data updates
- Triggers for data validation and integrity

#### 3. **Views (Virtual Tables) in SQL** (3 questions)
- Simple views for data abstraction
- Complex views with aggregations
- Updatable views for data modification

#### 4. **Schema Change Statements in SQL** (4 questions)
- Adding and modifying columns
- Adding constraints and checks
- Table modifications and recreations

#### 5. **Comparisons Involving NULL and Three-Valued Logic** (3 questions)
- NULL value handling and comparisons
- Three-valued logic with AND/OR operations
- COALESCE and NULLIF functions

#### 6. **Nested Queries, Tuples, and Set/Multiset Comparisons** (4 questions)
- Scalar subqueries and IN/NOT IN operations
- Tuple comparisons and set operations
- UNION, INTERSECT, and EXCEPT operations

#### 7. **Correlated Nested Queries** (3 questions)
- Basic correlated subqueries
- EXISTS and NOT EXISTS with correlations
- Multiple correlated subqueries

#### 8. **The EXISTS and UNIQUE Functions in SQL** (4 questions)
- EXISTS and NOT EXISTS functions
- UNIQUE function for uniqueness testing
- Performance comparison of EXISTS vs IN

#### 9. **Explicit Sets and Renaming of Attributes in SQL** (3 questions)
- Explicit sets with IN operator
- Attribute renaming and aliasing
- Complex renaming with expressions

#### 10. **Grouping: The GROUP BY and HAVING Clauses** (4 questions)
- Basic GROUP BY operations
- Multiple column grouping
- HAVING clause for group filtering
- Complex GROUP BY with JOINs

#### 11. **Aggregate Functions in SQL** (4 questions)
- Basic aggregate functions (COUNT, SUM, AVG, MIN, MAX)
- Conditional aggregations
- Window functions with aggregates

#### 12. **Discussion and Summary of SQL Queries** (3 questions)
- Query optimization analysis
- Query equivalence demonstrations
- Performance comparison studies

#### 13. **Tutorial Examples of SQL Queries** (3 questions)
- Real-world business scenarios
- Data analysis and reporting queries
- Complex academic management queries

## 🔗 Database Connection Details

| Parameter | Value |
|-----------|-------|
| **Host** | localhost |
| **Port** | 3311 |
| **Database** | quiz2_practice |
| **Username** | root |
| **Password** | quiz2pass |

## 📊 Database Schema

### Core Tables
- **STUDENT** - Student information with academic data
- **DEPARTMENT** - Academic departments with budgets
- **INSTRUCTOR** - Faculty information and salaries
- **COURSE** - Course catalog with prerequisites
- **SECTION** - Course sections and scheduling
- **ENROLLMENT** - Student course enrollments and grades
- **QUIZ** - Quiz information and scheduling
- **QUIZ_SUBMISSION** - Student quiz submissions and scores
- **STUDENT_HISTORY** - Historical academic records

### Key Features
- **25+ students** across 10 departments
- **22 courses** with prerequisite relationships
- **24 sections** across multiple terms
- **50+ quiz submissions** with performance data
- **Comprehensive views** for common queries
- **Stored procedures** for business logic
- **Triggers** for data integrity
- **Indexes** for query optimization

## 🏃‍♂️ Quick Test

Once your database is running, try these test queries:

```sql
-- Test basic connectivity
SELECT COUNT(*) as total_students FROM student;

-- Test complex query with joins
SELECT s.name, d.name as department, AVG(e.grade) as avg_grade
FROM student s
INNER JOIN department d ON s.dept_id = d.dept_id
INNER JOIN enrollment e ON s.student_id = e.student_id
GROUP BY s.student_id, s.name, d.name
HAVING AVG(e.grade) > 85;

-- Test view functionality
SELECT * FROM student_performance LIMIT 5;

-- Test stored procedure
CALL GetStudentAcademicSummary(1);
```

## 📖 How to Use This Practice

### 1. **Systematic Approach**
- Work through each section in order
- Complete all questions in a section before moving to the next
- Test your queries with the provided sample data

### 2. **Practice Techniques**
- Write queries from scratch without looking at solutions
- Test your queries with different data scenarios
- Explain your query logic in plain English
- Consider performance implications

### 3. **Learning Objectives**
- Master complex SQL query construction
- Understand NULL handling and three-valued logic
- Learn to create and use views effectively
- Practice with triggers and constraints
- Develop query optimization skills

### 4. **Self-Assessment**
- Time yourself on complex queries
- Compare your solutions with provided answers
- Identify areas needing additional study
- Practice explaining queries to others

## 🛠️ Useful Commands

```bash
# View all tables
SHOW TABLES;

# Describe table structure
DESCRIBE student;
DESCRIBE enrollment;

# View sample data
SELECT * FROM student LIMIT 5;
SELECT * FROM department;

# Check database status
SELECT DATABASE();
SELECT VERSION();

# View table constraints
SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
WHERE TABLE_SCHEMA = 'quiz2_practice';

# View indexes
SHOW INDEX FROM student;
SHOW INDEX FROM enrollment;

# View stored procedures
SHOW PROCEDURE STATUS WHERE Db = 'quiz2_practice';

# View triggers
SHOW TRIGGERS FROM quiz2_practice;
```

## 🔍 Advanced Features

### Views Available
- `student_summary` - High-performing students
- `department_statistics` - Department metrics
- `instructor_workload` - Faculty teaching loads
- `student_performance` - Student academic analysis
- `course_enrollment_stats` - Course enrollment metrics
- `instructor_teaching_load` - Detailed instructor statistics

### Stored Procedures
- `CalculateStudentGPA(student_id)` - Recalculate student GPA
- `GetDepartmentStats(dept_id)` - Department statistics
- `GetStudentAcademicSummary(student_id)` - Student academic summary
- `GetDepartmentPerformanceReport(dept_id)` - Department performance report

### Triggers
- `update_student_gpa_after_grade_change` - Auto-update GPA on grade changes
- `check_prerequisites_before_enrollment` - Validate prerequisites

## 🎯 Practice Tips

### 1. **Query Construction**
- Start with simple queries and build complexity
- Use proper indentation and formatting
- Test each part of complex queries separately
- Use meaningful aliases for readability

### 2. **Performance Considerations**
- Understand when to use EXISTS vs IN
- Consider index usage in your queries
- Use appropriate JOIN types
- Avoid unnecessary subqueries

### 3. **NULL Handling**
- Always consider NULL values in your logic
- Use IS NULL and IS NOT NULL appropriately
- Understand three-valued logic implications
- Use COALESCE and NULLIF when needed

### 4. **Advanced Techniques**
- Practice with window functions
- Master correlated subqueries
- Understand set operations
- Learn to create effective views

## 🔧 Troubleshooting

### Common Issues

1. **Connection refused**: Make sure Docker container is running
   ```bash
   docker ps
   docker start quiz2-db
   ```

2. **Permission denied**: Check username and password
   ```bash
   mysql -h localhost -P 3311 -u root -pquiz2pass
   ```

3. **Table doesn't exist**: Verify you're in the correct database
   ```sql
   USE quiz2_practice;
   SHOW TABLES;
   ```

4. **Syntax errors**: Check MySQL documentation for proper syntax
   - Use backticks for reserved words
   - Check parentheses matching
   - Verify data types and constraints

### Container Management
```bash
# Stop the container
docker stop quiz2-db

# Remove the container
docker rm quiz2-db

# View container logs
docker logs quiz2-db

# Restart the container
docker start quiz2-db

# Rebuild the image
docker build -t quiz2-practice-db .
```

## 📚 Additional Resources

- [MySQL 8.0 Documentation](https://dev.mysql.com/doc/refman/8.0/en/)
- [SQL Window Functions Guide](https://dev.mysql.com/doc/refman/8.0/en/window-functions.html)
- [MySQL Triggers Documentation](https://dev.mysql.com/doc/refman/8.0/en/triggers.html)
- [MySQL Views Documentation](https://dev.mysql.com/doc/refman/8.0/en/views.html)
- [SQL Performance Tuning](https://dev.mysql.com/doc/refman/8.0/en/optimization.html)

## 🎓 Success Criteria

After completing this practice, you should be able to:

- ✅ Write complex multi-table queries with advanced JOINs
- ✅ Create and manage database views effectively
- ✅ Implement triggers and constraints for data integrity
- ✅ Handle NULL values and three-valued logic correctly
- ✅ Write correlated subqueries and use EXISTS/UNIQUE functions
- ✅ Perform complex aggregations with GROUP BY and HAVING
- ✅ Optimize queries for better performance
- ✅ Create stored procedures for business logic
- ✅ Modify database schemas safely
- ✅ Analyze and explain query performance

## 📝 Study Strategy

### Week 1: Foundation Topics
- Complex SQL retrieval queries
- NULL handling and three-valued logic
- Basic views and schema changes

### Week 2: Advanced Querying
- Nested and correlated subqueries
- EXISTS and UNIQUE functions
- Set operations and tuple comparisons

### Week 3: Aggregation and Optimization
- GROUP BY and HAVING clauses
- Aggregate functions and window functions
- Query optimization and performance analysis

### Week 4: Advanced Features
- Triggers and constraints
- Stored procedures and functions
- Real-world business scenarios

## 🚀 Next Steps

After mastering Quiz 2 topics, consider:

- **Database Design** - Normalization and schema design
- **Performance Tuning** - Indexing and query optimization
- **Advanced Analytics** - Data warehousing and business intelligence
- **Database Administration** - Backup, recovery, and maintenance
- **NoSQL Databases** - Document and graph databases

---

**Happy Learning! 🎓**

For questions or issues, refer to the solutions file and practice with the comprehensive sample data provided.
