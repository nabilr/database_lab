# Beginner SQL Tutorial

## 🎯 Learning Objectives
After completing this tutorial, you will be able to:
- Write basic SELECT statements
- Filter data using WHERE clauses
- Sort results with ORDER BY
- Limit result sets
- Join tables using INNER JOIN and LEFT JOIN
- Use comparison and logical operators

## 🗄️ Database Setup
```bash
# From this directory
docker build -t university-mysql-beginner .
docker run --name uni-db-beginner -p 3306:3306 university-mysql-beginner
```

## 📚 Tutorial Sections

### 1. Basic SELECT Statements
Learn to retrieve data from single tables using SELECT.

### 2. Filtering with WHERE
Master the art of filtering data with conditions.

### 3. Sorting and Limiting
Organize your results and control output size.

### 4. Basic Joins
Connect related tables to get meaningful results.

### 5. Practice Exercises
Apply what you've learned with real-world scenarios.

## 🔗 Database Connection
- **Host:** localhost
- **Port:** 3306  
- **Database:** university_basic
- **Username:** root
- **Password:** beginnerpass

## 📖 Query Examples
All queries are in `queries.sql`. Run them step by step to understand each concept.

## 🏃‍♂️ Quick Test
Once your database is running, try this query:
```sql
SELECT name FROM department;
```
Expected result: Computer Science, Mathematics

## 📈 Next Steps
After mastering these basics, move on to the Intermediate tutorial to learn about:
- GROUP BY and aggregations
- Subqueries
- UNION operations
- Advanced filtering techniques
