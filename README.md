# SQL Database Tutorial Lab
A comprehensive SQL learning environment with beginner, intermediate, and advanced tutorials using a realistic university database schema.

## 📚 Tutorial Levels & Topics

| Level | Topics Covered | Directory | Database | Port |
|-------|---------------|-----------|----------|------|
| 🔵 **Foundations** | Database Creation, Data Types, Constraints, Foreign Keys | `tutorial/00-foundations/` | `simple_school` | 3305 |
| 🟢 **Beginner** | SELECT, WHERE, ORDER BY, Basic JOINs, LIMIT | `tutorial/01-beginner/` | `university_basic` | 3306 |
| 🟡 **Intermediate** | **Subqueries**, **UNION**, GROUP BY, HAVING, Date Functions | `tutorial/02-intermediate/` | `university_intermediate` | 3307 |
| 🔴 **Advanced** | Window Functions, CTEs, Recursive Queries, Analytics | `tutorial/03-advanced/` | `university_advanced` | 3308 |
| 🎯 **Quiz Practice** | **Nested Queries**, **Constraints**, **UNION**, Complex Joins | `tutorial/quiz1-practice/` | `quiz1_practice` | 3309 |

## 📋 Complete SQL Topics Coverage

### 🔵 [Foundations](tutorial/00-foundations/)
**🔗 [Practice Exercises](tutorial/00-foundations/practice-exercises.sql) | [Solutions](tutorial/00-foundations/solutions.sql)**

| Topic | Concepts Covered |
|-------|-----------------|
| **Database Creation** | CREATE DATABASE, USE, DROP |
| **Data Types** | VARCHAR, INT, DECIMAL, DATE, ENUM |
| **Constraints** | PRIMARY KEY, FOREIGN KEY, NOT NULL, UNIQUE |
| **Basic DML** | INSERT, UPDATE, DELETE |
| **Table Design** | Normalization basics, relationships |

### 🟢 [Beginner](tutorial/01-beginner/)
**🔗 [Query Examples](tutorial/01-beginner/queries.sql)**

| Topic | Concepts Covered |
|-------|-----------------|
| **SELECT Statements** | Basic SELECT, column aliases, DISTINCT |
| **Filtering (WHERE)** | Comparison operators, AND/OR, IN, LIKE, NULL |
| **Sorting & Limiting** | ORDER BY, LIMIT, OFFSET |
| **Basic JOINs** | INNER JOIN, LEFT JOIN, table aliases |
| **Pattern Matching** | LIKE with wildcards, regex basics |

### 🟡 [Intermediate](tutorial/02-intermediate/)
**🔗 [Query Examples](tutorial/02-intermediate/queries.sql)**

| Topic | Concepts Covered |
|-------|-----------------|
| **Aggregation Functions** | COUNT, SUM, AVG, MIN, MAX, GROUP BY |
| **Filtering Groups** | HAVING clause, GROUP BY with multiple columns |
| **Subqueries** | Scalar subqueries, IN subqueries, EXISTS/NOT EXISTS |
| **UNION Operations** | UNION, UNION ALL, combining result sets |
| **Date Functions** | DATE, YEAR, MONTH, DATEDIFF, DATE_ADD |
| **CASE Statements** | Simple CASE, searched CASE, conditional logic |

### 🔴 [Advanced](tutorial/03-advanced/)
**🔗 [Query Examples](tutorial/03-advanced/queries.sql)**

| Topic | Concepts Covered |
|-------|-----------------|
| **Window Functions** | ROW_NUMBER, RANK, DENSE_RANK, LAG, LEAD |
| **Analytical Functions** | Running totals, moving averages, NTILE |
| **Common Table Expressions** | WITH clauses, recursive CTEs |
| **Complex Analytics** | Cohort analysis, pivot tables, performance metrics |
| **Query Optimization** | EXISTS vs IN, efficient pagination, indexing |

### 🎯 [Quiz Practice](tutorial/quiz1-practice/)
**🔗 [Comprehensive Guide](tutorial/quiz1-practice/README.md)**

| Practice File | SQL Topics Covered |
|---------------|-------------------|
| **[01-joins-and-filtering-practice.sql](tutorial/quiz1-practice/01-joins-and-filtering-practice.sql)** | Complex JOINs, division operations, multi-table scenarios |
| **[02-integrity-constraints-practice.sql](tutorial/quiz1-practice/02-integrity-constraints-practice.sql)** | **Constraint violations**, primary keys, foreign keys, cascades |
| **[03-multiple-choice-practice.sql](tutorial/quiz1-practice/03-multiple-choice-practice.sql)** | Conceptual understanding, constraint behaviors |
| **[04-challenge-questions-practice.sql](tutorial/quiz1-practice/04-challenge-questions-practice.sql)** | Advanced scenarios, schema design, optimization |

#### 🎯 Quiz Practice Key Features
- ✅ **Nested Queries:** Scalar, correlated, EXISTS/NOT EXISTS patterns
- ✅ **Integrity Constraints:** Primary keys, foreign keys, cascades, violations
- ✅ **UNION Operations:** Set operations, duplicate handling
- ✅ **Advanced Scenarios:** Employee management, hierarchies, division operations

## 🚀 Quick Start

### Option 1: Individual Tutorial Setup
```bash
# Choose your level and run:
cd tutorial/{level-directory}
docker build -t {image-name} .
docker run --name {container-name} -p {port}:3306 {image-name}
```

### Option 2: Direct Commands by Level

<details>
<summary>🔵 Foundations (START HERE!)</summary>

```bash
cd tutorial/00-foundations
docker build -t university-mysql-foundations .
docker run --name uni-db-foundations -p 3305:3306 university-mysql-foundations
```
</details>

<details>
<summary>🟢 Beginner</summary>

```bash
cd tutorial/01-beginner
docker build -t university-mysql-beginner .
docker run --name uni-db-beginner -p 3306:3306 university-mysql-beginner
```
</details>

<details>
<summary>🟡 Intermediate</summary>

```bash
cd tutorial/02-intermediate
docker build -t university-mysql-intermediate .
docker run --name uni-db-intermediate -p 3307:3306 university-mysql-intermediate
```
</details>

<details>
<summary>🔴 Advanced</summary>

```bash
cd tutorial/03-advanced
docker build -t university-mysql-advanced .
docker run --name uni-db-advanced -p 3308:3306 university-mysql-advanced
```
</details>

<details>
<summary>🎯 Quiz Practice</summary>

```bash
cd tutorial/quiz1-practice
docker build -t quiz1-practice .
docker run --name quiz1-db -p 3309:3306 quiz1-practice

# Connect as student
docker exec -it quiz1-db mysql -u student -pstudent123 quiz1_practice

# Connect as admin
docker exec -it quiz1-db mysql -u root -pquiz1practice quiz1_practice
```
</details>

## 🔗 Connection Details

| Level | Port | Database | Username | Password |
|-------|------|----------|----------|----------|
| Foundations | 3305 | simple_school | root | foundationspass |
| Beginner | 3306 | university_basic | root | beginnerpass |
| Intermediate | 3307 | university_intermediate | root | intermediatepass |
| Advanced | 3308 | university_advanced | root | advancedpass |
| **Quiz Practice** | **3309** | **quiz1_practice** | **student/root** | **student123/quiz1practice** |

## 📖 Learning Path

1. **🔵 Foundations** → Database creation and basic concepts
2. **🟢 Beginner** → Fundamental SQL operations  
3. **🟡 Intermediate** → Aggregation, subqueries, and unions
4. **🔴 Advanced** → Performance optimization and analytics
5. **🎯 Quiz Practice** → Comprehensive assessment and real-world scenarios

Each tutorial includes:
- ✅ Step-by-step query examples with explanations
- ✅ Practical exercises with detailed solutions  
- ✅ Real-world scenarios and use cases
- ✅ Performance monitoring (advanced levels)

## 📊 Database Schemas

**University Database** (Levels 1-4): Departments, Instructors, Students, Courses, Sections, Enrollments, Quizzes, Prerequisites

**Employee Database** (Quiz Practice): Employee hierarchy, departments, projects, work assignments, dependents with comprehensive constraints

## 🛠 Useful Commands

```bash
# Connect to any database
mysql -h localhost -P {port} -u {username} -p

# View tutorial files
cat tutorial/{level}/queries.sql

# Container management
docker stop {container-name} && docker rm {container-name}
docker logs {container-name}

# Quick cleanup
docker stop $(docker ps -q) && docker rm $(docker ps -aq)
```

## 📁 File Structure
```
tutorial/
├── 00-foundations/     # Database basics
├── 01-beginner/        # SQL fundamentals  
├── 02-intermediate/    # Subqueries & unions
├── 03-advanced/        # Window functions & CTEs
└── quiz1-practice/     # Comprehensive assessment
    ├── README.md                           # Detailed guide
    ├── 01-joins-and-filtering-practice.sql
    ├── 02-integrity-constraints-practice.sql  
    ├── 03-multiple-choice-practice.sql
    └── 04-challenge-questions-practice.sql
```

Happy Learning! 🎓