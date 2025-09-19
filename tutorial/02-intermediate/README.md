# Intermediate SQL Tutorial

## 🎯 Learning Objectives
After completing this tutorial, you will be able to:
- Use aggregate functions (COUNT, SUM, AVG, MIN, MAX)
- Group data with GROUP BY
- Filter groups using HAVING
- Write subqueries and correlated subqueries
- Combine result sets with UNION
- Use CASE statements for conditional logic
- Work with date functions

## 🗄️ Database Setup
```bash
# From this directory
docker build -t university-mysql-intermediate .
docker run --name uni-db-intermediate -p 3307:3306 university-mysql-intermediate
```

## 📚 Tutorial Sections

### 1. Aggregation Functions
Learn to summarize data using COUNT, SUM, AVG, MIN, and MAX.

### 2. GROUP BY and HAVING
Master data grouping and filtering groups.

### 3. Subqueries
Write queries within queries for complex data retrieval.

### 4. UNION Operations
Combine results from multiple queries.

### 5. Date Functions and CASE Statements
Work with dates and conditional logic.

### 6. Advanced Joins and Set Operations
Explore self-joins and complex relationships.

### 7. Practice Exercises
Real-world scenarios with intermediate complexity.

## 🔗 Database Connection
- **Host:** localhost
- **Port:** 3307  
- **Database:** university_intermediate
- **Username:** root
- **Password:** intermediatepass

## 📊 Enhanced Dataset
This tutorial includes:
- 5 departments (instead of 2)
- 7 instructors (instead of 2) 
- 13 students (instead of 3)
- More courses, sections, and quiz data
- Spring and Fall semester data

## 🏃‍♂️ Quick Test
Once your database is running, try this query:
```sql
SELECT d.name, COUNT(s.student_id) as student_count
FROM department d
LEFT JOIN student s ON d.dept_id = s.dept_id
GROUP BY d.dept_id, d.name
ORDER BY student_count DESC;
```

## 📈 Next Steps
After mastering intermediate concepts, advance to the Advanced tutorial for:
- Window functions
- Common Table Expressions (CTEs)
- Recursive queries
- Performance optimization
