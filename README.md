# SQL Database Tutorial Lab
A comprehensive SQL learning environment with beginner, intermediate, and advanced tutorials using a realistic university database schema.

## 📚 Tutorial Structure

### 🔵 Foundations (START HERE!)
**Topics Covered:** Database Creation, Data Types, Constraints, Foreign Keys
- **Directory:** `tutorial/00-foundations/`
- **Database:** `simple_school`
- **Docker Image:** `university-mysql-foundations`

### 🟢 Beginner Level
**Topics Covered:** Basic SELECT, WHERE, ORDER BY, JOINs, LIMIT
- **Directory:** `tutorial/01-beginner/`
- **Database:** `university_basic`
- **Docker Image:** `university-mysql-beginner`

### 🟡 Intermediate Level  
**Topics Covered:** GROUP BY, HAVING, Subqueries, UNION, Date Functions, CASE Statements
- **Directory:** `tutorial/02-intermediate/`
- **Database:** `university_intermediate` (with additional sample data)
- **Docker Image:** `university-mysql-intermediate`

### 🔴 Advanced Level
**Topics Covered:** Window Functions, CTEs, Recursive Queries, Performance Optimization, Analytics
- **Directory:** `tutorial/03-advanced/`
- **Database:** `university_advanced` (with extended schema and large dataset)
- **Docker Image:** `university-mysql-advanced`

## 🚀 Quick Start

Choose your tutorial level and follow the instructions:

#### Foundations Tutorial (START HERE!)
```bash
cd tutorial/00-foundations
docker build -t university-mysql-foundations .
docker run --name uni-db-foundations -p 3305:3306 university-mysql-foundations
```

#### Beginner Tutorial
```bash
cd tutorial/01-beginner
docker build -t university-mysql-beginner .
docker run --name uni-db-beginner -p 3306:3306 university-mysql-beginner
```

#### Intermediate Tutorial  
```bash
cd tutorial/02-intermediate
docker build -t university-mysql-intermediate .
docker run --name uni-db-intermediate -p 3307:3306 university-mysql-intermediate
```

#### Advanced Tutorial
```bash
cd tutorial/03-advanced
docker build -t university-mysql-advanced .
docker run --name uni-db-advanced -p 3308:3306 university-mysql-advanced
```

## 📊 Database Schema

The university database includes these main entities:
- **Departments** - Academic departments
- **Instructors** - Faculty members  
- **Students** - Enrolled students
- **Courses** - Available courses
- **Sections** - Course offerings per term
- **Enrollments** - Student-section relationships
- **Quizzes & Submissions** - Assessment data
- **Prerequisites** - Course dependencies

## 🔗 Connection Details

| Level | Port | Database | Username | Password |
|-------|------|----------|----------|----------|
| Foundations | 3305 | simple_school | root | foundationspass |
| Beginner | 3306 | university_basic | root | beginnerpass |
| Intermediate | 3307 | university_intermediate | root | intermediatepass |
| Advanced | 3308 | university_advanced | root | advancedpass |

## 📖 Learning Path

1. **Start with Foundations** - Learn database creation and basic concepts
2. **Move to Beginner** - Learn fundamental SQL operations
3. **Progress to Intermediate** - Master aggregation and complex queries  
4. **Advance to Expert Level** - Explore performance optimization and analytics

Each tutorial includes:
- ✅ Step-by-step query examples
- ✅ Practical exercises with solutions
- ✅ Real-world scenarios
- ✅ Performance monitoring tools (advanced level)

## 🛠 Useful Commands

```bash
# Connect to database (example for beginner level)
mysql -h localhost -P 3306 -u root -p

# View query examples
cat tutorial/01-beginner/queries.sql

# Stop and remove containers
docker stop uni-db-beginner && docker rm uni-db-beginner

# View logs
docker logs uni-db-beginner
```

Happy Learning! 🎓
