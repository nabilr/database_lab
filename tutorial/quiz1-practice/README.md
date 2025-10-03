# Quiz 1 Practice Tutorial

## 🎯 Learning Objectives
Master essential SQL concepts through comprehensive practice on:
- **Complex Joins and Filtering** - Find employees meeting multiple criteria, division operations
- **Integrity Constraints** - Understand and predict constraint violations
- **Multiple Choice Reasoning** - Deep understanding of database concepts
- **Challenge Variations** - Advanced scenarios and schema design

## 📚 What's Included

### Core Files
- **`employee-database-schema.sql`** - Complete employee database with proper constraints
- **`01-joins-and-filtering-practice.sql`** - 25+ join and filtering exercises
- **`02-integrity-constraints-practice.sql`** - Constraint violation scenarios and predictions
- **`03-multiple-choice-practice.sql`** - 25+ multiple choice questions with detailed explanations
- **`04-challenge-questions-practice.sql`** - Advanced variations and DDL exercises
- **`Dockerfile`** - Docker environment for easy setup

### Solution Files (Organized by Topic)
- **`01-joins-and-filtering-solutions.sql`** - Complete solutions for joins and filtering practice
- **`02-integrity-constraints-solutions.sql`** - Solutions and explanations for constraint scenarios
- **`03-multiple-choice-solutions.sql`** - Detailed answers and explanations for multiple choice questions
- **`04-challenge-questions-solutions.sql`** - Advanced solutions for challenge exercises
- **`solutions.sql`** - Legacy combined solutions file (kept for reference)

## 🚀 Quick Start

### Option 1: Docker (Recommended)
```bash
# Build and run the container
docker build -t quiz1-practice .
docker run -d --name quiz1-db -p 3306:3306 quiz1-practice

# Connect to the database
docker exec -it quiz1-db mysql -u student -pstudent123 quiz1_practice

# Or connect as root for admin tasks
docker exec -it quiz1-db mysql -u root -pquiz1practice quiz1_practice
```

### Option 2: Local MySQL
```bash
# Load the schema
mysql -u root -p < employee-database-schema.sql

# Connect to practice database
mysql -u root -p quiz1_practice
```

## 📖 Tutorial Structure

### Phase 1: Foundation (30 minutes)
**Start with:** `employee-database-schema.sql`
- Review the complete employee database schema
- Understand table relationships and constraints
- Verify data with sample queries

### Phase 2: Joins and Filtering (45 minutes)
**Practice with:** `01-joins-and-filtering-practice.sql`
- Basic joins with multiple tables
- Employees working on ALL projects in specific locations
- Multiple project assignments and complex filtering
- Employees with/without dependents
- Advanced multi-table scenarios

### Phase 3: Constraint Mastery (30 minutes)
**Work through:** `02-integrity-constraints-practice.sql`
- Predict constraint violation outcomes
- Understand primary key, foreign key, and unique constraints
- Practice DELETE cascade effects
- Handle circular reference scenarios

### Phase 4: Conceptual Understanding (45 minutes)
**Complete:** `03-multiple-choice-practice.sql`
- 25+ multiple choice questions
- Entity and referential integrity concepts
- Constraint types and behaviors
- Real-world scenario analysis

### Phase 5: Advanced Challenges (60 minutes)
**Tackle:** `04-challenge-questions-practice.sql`
- Schema modification and optimization
- Complex business rule implementation
- Performance optimization strategies
- Data validation and quality checks

### Phase 6: Solution Review (30 minutes)
**Study:** Individual solution files for each topic
- **`01-joins-and-filtering-solutions.sql`** - Review your join query solutions
- **`02-integrity-constraints-solutions.sql`** - Check your constraint predictions
- **`03-multiple-choice-solutions.sql`** - Verify your conceptual understanding
- **`04-challenge-questions-solutions.sql`** - Compare advanced challenge approaches
- Compare your solutions with provided answers
- Understand alternative approaches
- Learn optimization techniques

## 🏗️ Database Schema Overview

### Core Tables
- **EMPLOYEE** - Employee information with self-referencing supervisor relationship
- **DEPARTMENT** - Departments with manager relationships (circular reference with EMPLOYEE)
- **PROJECT** - Projects controlled by departments
- **WORKS_ON** - Many-to-many relationship between employees and projects
- **DEPENDENT** - Employee dependents

### Key Relationships
```
DEPARTMENT ←→ EMPLOYEE (circular: manager/employee)
EMPLOYEE → EMPLOYEE (supervisor hierarchy)
DEPARTMENT → PROJECT (department controls projects)
EMPLOYEE ←→ PROJECT (through WORKS_ON)
EMPLOYEE → DEPENDENT (one-to-many)
```

### Sample Data
- **13 employees** across 5 departments
- **10 projects** in various locations
- **22 work assignments** with hours
- **10 dependents** for 5 employees
- **Hierarchical supervision** structure

## 📝 Practice Question Categories

### 1. Joins and Filtering (25 questions)
- **Basic Joins** - Employee details with department/manager info
- **Division Operations** - Employees working on ALL projects meeting criteria
- **Multiple Assignments** - Employees with multiple projects
- **Dependent Relationships** - Using LEFT JOIN for optional relationships
- **Complex Filtering** - Multiple conditions and advanced scenarios

### 2. Integrity Constraints (15 scenarios)
- **Primary Key Violations** - Duplicate and NULL key attempts
- **Foreign Key Violations** - Non-existent reference attempts
- **DELETE Cascades** - Impact of deleting referenced records
- **UPDATE Violations** - Constraint violations during updates
- **Circular References** - Handling Department-Employee circularity

### 3. Multiple Choice (25 questions)
- **Entity Integrity** - Primary key constraint rules
- **Referential Integrity** - Foreign key behaviors
- **Constraint Types** - NOT NULL, UNIQUE, CHECK, DEFAULT
- **System Behaviors** - How databases handle violations
- **Performance Impact** - Constraint effects on operations

### 4. Challenge Questions (20+ exercises)
- **Schema Modifications** - Adding constraints to existing data
- **DDL Reconstruction** - Building schemas from requirements
- **Query Optimization** - Performance improvement techniques
- **Business Rules** - Complex constraint implementations
- **Data Validation** - Quality assurance queries

## ✅ Key Concepts Covered

### SQL Query Techniques
- Complex JOIN operations (INNER, LEFT, self-joins)
- Subquery strategies (correlated, EXISTS, NOT EXISTS)
- Aggregation with GROUP BY and HAVING
- Division operation implementation
- Set operations and comparisons

### Database Integrity
- Primary key constraints and entity integrity
- Foreign key constraints and referential integrity
- Unique constraints and duplicate prevention
- NOT NULL constraints and required fields
- CHECK constraints for business rules

### Advanced Topics
- Circular reference handling
- Constraint violation prediction
- Performance optimization with indexes
- Data quality validation
- Schema design best practices

## 💡 Study Strategy

### 1. Structured Approach (Recommended)
Follow the phases in order, spending adequate time on each section.

### 2. Focused Practice
If you're strong in one area, skip to your weak points:
- **Weak on Joins?** → Focus on Phase 2
- **Confused about Constraints?** → Focus on Phase 3
- **Need Conceptual Review?** → Focus on Phase 4

### 3. Exam Preparation
- Complete all multiple choice questions
- Practice predicting constraint violations
- Time yourself on complex queries
- Review solution explanations thoroughly

## 🔍 Verification Queries

Each practice file includes verification queries to check your work:

```sql
-- Check employee counts
SELECT COUNT(*) FROM EMPLOYEE;  -- Should be 13

-- Check constraint status
SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE 
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
WHERE TABLE_SCHEMA = 'quiz1_practice';

-- Verify relationships
SELECT 'Employees with Dependents' AS Category, COUNT(DISTINCT Essn) AS Count 
FROM DEPENDENT;  -- Should be 5
```

## 🚨 Common Pitfalls to Avoid

### 1. JOIN Mistakes
- **Forgetting LEFT JOIN** for optional relationships
- **Cartesian products** from missing join conditions
- **Wrong join order** in complex multi-table queries

### 2. Constraint Confusion
- **Assuming FK can be NULL** when NOT NULL is specified
- **Forgetting CASCADE effects** when deleting referenced rows
- **Misunderstanding circular references** in Department-Employee

### 3. Aggregation Errors
- **Missing GROUP BY** for non-aggregate columns
- **Wrong HAVING conditions** vs WHERE conditions
- **Incorrect COUNT usage** with NULL values

## 📈 Next Steps

After completing this tutorial:

1. **Test Your Understanding**
   - Create your own variations of the questions
   - Try to stump yourself with edge cases
   - Practice explaining concepts to others

2. **Apply to Real Projects**
   - Design schemas for actual applications
   - Consider constraint implications in your designs
   - Optimize queries for performance

3. **Advanced Topics**
   - Move to `02-intermediate` tutorial for advanced SQL
   - Explore database administration topics
   - Study database design normalization

## 🛠️ Troubleshooting

### Docker Issues
```bash
# Check container status
docker ps -a

# View logs
docker logs quiz1-db

# Restart container
docker restart quiz1-db

# Remove and rebuild
docker rm -f quiz1-db
docker build -t quiz1-practice .
```

### MySQL Connection Issues
```bash
# Check if MySQL is running
docker exec quiz1-db mysqladmin ping

# Reset password if needed
docker exec -it quiz1-db mysql -u root -p
```

### Permission Issues
```bash
# Grant permissions if needed
GRANT ALL PRIVILEGES ON quiz1_practice.* TO 'student'@'%';
FLUSH PRIVILEGES;
```

## 📚 Additional Resources

### Documentation
- [MySQL 8.0 Reference Manual](https://dev.mysql.com/doc/refman/8.0/en/)
- [SQL Constraints Documentation](https://dev.mysql.com/doc/refman/8.0/en/constraints.html)
- [JOIN Syntax Reference](https://dev.mysql.com/doc/refman/8.0/en/join.html)

### Practice Datasets
- [Classic Models Database](https://www.mysqltutorial.org/mysql-sample-database.aspx)
- [Sakila Sample Database](https://dev.mysql.com/doc/sakila/en/)
- [Employee Sample Database](https://github.com/datacharmer/test_db)

## 🎓 Assessment Checklist

Before moving on, ensure you can:

- [ ] Write complex multi-table JOIN queries
- [ ] Implement division operations (ALL/EVERY queries)
- [ ] Predict constraint violation outcomes
- [ ] Explain entity vs referential integrity
- [ ] Handle circular foreign key references
- [ ] Optimize queries for performance
- [ ] Design schemas with proper constraints
- [ ] Validate data integrity with queries

## 💪 Quiz Yourself

Try these quick challenges:
1. Find employees who work on more projects than they have dependents
2. Predict what happens when you delete a department manager
3. Write a CHECK constraint ensuring managers earn more than supervisees
4. Identify all constraint violations in a given INSERT statement

---

**Ready to master SQL? Start with `employee-database-schema.sql` and work through each practice file systematically. Good luck! 🚀**
