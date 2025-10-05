# Midterm Review - SQL Database Practice

A comprehensive SQL midterm review environment with Docker setup, focusing on basic SQL operations, CROSS JOIN, and simple filtering without aggregate functions.

## 📚 Overview

This midterm review contains:
- **30 SQL questions** (15 from STUDENT-COURSE schema, 15 from COMPANY schema)
- **Complete sample data** for testing queries
- **Docker-based setup** for easy database management
- **Separate question and answer files**
- **Focus on basic SQL concepts** - no complex JOINs or aggregates

## 🎯 Learning Objectives

### Concepts Covered:
- **DDL (Data Definition Language)**: CREATE TABLE, constraints, data types
- **Basic DML (Data Manipulation Language)**: INSERT, UPDATE, DELETE
- **SELECT queries**: WHERE, LIKE, IN, NOT IN, BETWEEN
- **CROSS JOIN**: Practical scenarios using CROSS JOIN with WHERE filtering
- **Simple filtering**: Comparison operators, NULL handling
- **Data types**: VARCHAR, INT, DECIMAL, DATE, ENUM, CHAR
- **Constraints**: Primary keys, foreign keys, check constraints
- **Basic subqueries**: Simple IN subqueries
- **ORDER BY**: Sorting results
- **DISTINCT**: Removing duplicates

### What's NOT Covered:
- ❌ Complex JOINs (INNER, LEFT, RIGHT, OUTER)
- ❌ Aggregate functions (COUNT, SUM, AVG, MIN, MAX)
- ❌ GROUP BY and HAVING
- ❌ Window functions
- ❌ Recursive queries
- ❌ Complex subqueries (correlated, EXISTS)

## 🗄️ Database Schemas

### 1️⃣ STUDENT-COURSE Database
- **DEPARTMENT**: Departments with budgets and buildings
- **STUDENT**: Students with GPA, year level, enrollment dates
- **COURSE**: Courses with credits and descriptions
- **SECTION**: Course sections with terms and years
- **GRADE_REPORT**: Student grades and course enrollments
- **PREREQUISITE**: Course prerequisite relationships

### 2️⃣ COMPANY Database
- **COMPANY_DEPARTMENT**: Company departments with managers
- **EMPLOYEE**: Employees with salaries and supervisors
- **PROJECT**: Projects with locations and departments
- **WORKS_ON**: Employee-project assignments with hours
- **DEPENDENT**: Employee dependents with relationships
- **DEPT_LOCATIONS**: Department locations

## 🚀 Quick Start

### Prerequisites
- Docker installed on your system
- Basic understanding of SQL syntax

### Setup Instructions

1. **Navigate to the midterm review directory:**
   ```bash
   cd tutorial/midterm-review
   ```

2. **Build the Docker image:**
   ```bash
   docker build -t midterm-review-db .
   ```

3. **Run the database container:**
   ```bash
   docker run --name midterm-db -p 3310:3306 midterm-review-db
   ```

4. **Connect to the database:**
   ```bash
   # Using MySQL client
   mysql -h localhost -P 3310 -u root -pmidtermpass midterm_review
   
   # Or using Docker exec
   docker exec -it midterm-db mysql -u root -pmidtermpass midterm_review
   ```

## 📋 File Structure

```
tutorial/midterm-review/
├── Dockerfile              # Docker configuration
├── schema.sql              # Database schema creation
├── sample-data.sql         # Sample data for testing
├── questions.sql           # 30 practice questions
├── answers.sql             # Complete solutions
└── README.md               # This file
```

## 📖 How to Use

### 1. Study the Questions
- Open `questions.sql` to see all 30 questions
- Each question includes:
  - Difficulty level (all Easy)
  - Concept being tested
  - Clear problem statement

### 2. Practice with Sample Data
- The database comes pre-loaded with sample data
- Test your queries against real data
- Verify your results match expected outcomes

### 3. Check Your Answers
- Open `answers.sql` to see complete solutions
- Each answer includes:
  - Full SQL query
  - Expected result description
  - Concept explanation

### 4. Focus Areas for Practice

#### DDL Questions (1, 16):
- Table creation with proper data types
- Primary and foreign key constraints
- Check constraints and defaults

#### Basic SELECT Questions (2, 4, 17, 19):
- WHERE clauses with comparison operators
- LIKE patterns for string matching
- Simple filtering conditions

#### CROSS JOIN Questions (3, 11, 18, 26):
- Practical scenarios using CROSS JOIN with WHERE filtering
- Finding potential relationships between tables
- Understanding when CROSS JOIN is appropriate

#### Data Manipulation Questions (13-15, 28-30):
- INSERT statements with proper syntax
- UPDATE statements with WHERE clauses
- DELETE statements with conditions

#### Advanced Filtering Questions (5-7, 20-22):
- IN and NOT IN operators
- BETWEEN for date ranges
- NULL handling with IS NULL/IS NOT NULL

## 🔧 Connection Details

| Parameter | Value |
|-----------|-------|
| **Host** | localhost |
| **Port** | 3310 |
| **Database** | midterm_review |
| **Username** | root |
| **Password** | midtermpass |

## 📊 Sample Data Overview

### Student-Course Data:
- **15 students** across 7 departments
- **19 courses** with various credits
- **19 sections** for Fall 2024
- **Grade reports** for multiple students
- **Prerequisites** for advanced courses

### Company Data:
- **18 employees** across 7 departments
- **14 projects** in various locations
- **Work assignments** with hours
- **Dependents** for employees
- **Department locations** in multiple cities

## 🎯 Practice Tips

1. **Start with DDL**: Practice table creation and constraints
2. **Master basic SELECT**: Focus on WHERE clauses and filtering
3. **Understand CROSS JOIN**: Learn practical scenarios where CROSS JOIN with WHERE filtering is appropriate
4. **Practice data types**: Know when to use VARCHAR vs CHAR, INT vs DECIMAL
5. **Test your queries**: Always run queries against the sample data
6. **Read error messages**: MySQL provides helpful error descriptions

## 🛠️ Useful Commands

```bash
# View all tables
SHOW TABLES;

# Describe table structure
DESCRIBE STUDENT;
DESCRIBE EMPLOYEE;

# View sample data
SELECT * FROM STUDENT LIMIT 5;
SELECT * FROM EMPLOYEE LIMIT 5;

# Check database status
SELECT DATABASE();

# View table constraints
SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
WHERE TABLE_SCHEMA = 'midterm_review';
```

## 🔍 Troubleshooting

### Common Issues:

1. **Connection refused**: Make sure Docker container is running
   ```bash
   docker ps
   docker start midterm-db
   ```

2. **Permission denied**: Check username and password
   ```bash
   mysql -h localhost -P 3310 -u root -pmidtermpass
   ```

3. **Table doesn't exist**: Verify you're in the correct database
   ```sql
   USE midterm_review;
   SHOW TABLES;
   ```

4. **Syntax errors**: Check MySQL documentation for proper syntax

### Container Management:
```bash
# Stop the container
docker stop midterm-db

# Remove the container
docker rm midterm-db

# View container logs
docker logs midterm-db

# Restart the container
docker start midterm-db
```

## 📚 Additional Resources

- [MySQL Documentation](https://dev.mysql.com/doc/)
- [SQL Tutorial - W3Schools](https://www.w3schools.com/sql/)
- [MySQL Data Types](https://dev.mysql.com/doc/refman/8.0/en/data-types.html)
- [MySQL Constraints](https://dev.mysql.com/doc/refman/8.0/en/constraints.html)

## 🎓 Success Criteria

After completing this midterm review, you should be able to:

- ✅ Create tables with proper data types and constraints
- ✅ Write basic SELECT queries with WHERE clauses
- ✅ Use CROSS JOIN to create Cartesian products
- ✅ Handle NULL values appropriately
- ✅ Perform basic data manipulation (INSERT, UPDATE, DELETE)
- ✅ Choose appropriate data types for different scenarios
- ✅ Understand primary and foreign key relationships

## 📝 Notes

- All questions are designed to be **Easy** level
- Focus is on **fundamental SQL concepts**
- **No aggregate functions** or complex operations
- **CROSS JOIN** is the only join type covered
- Practice with the provided sample data for best results

---

**Happy Learning! 🎓**

For questions or issues, refer to the sample data and expected results in the answer file.
