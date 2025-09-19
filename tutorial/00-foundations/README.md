# Database Foundations Tutorial

## 🎯 Learning Objectives
After completing this tutorial, you will understand:
- How to create databases and tables
- Basic data types (INT, VARCHAR, DATE, DECIMAL, BOOLEAN)
- Primary keys and auto-increment
- Simple constraints (NOT NULL, UNIQUE)
- Foreign key relationships
- Basic data insertion

## 📚 What's Included
- **`database-creation.sql`** - Step-by-step tutorial with simple examples
- **`practice-exercises.sql`** - 4 exercise sets to practice
- **`simple-solutions.sql`** - Complete solutions with explanations

## 🚀 Quick Start
```sql
-- Run the tutorial
mysql -u root -p < database-creation.sql

-- Try the exercises yourself
-- Then check your work against simple-solutions.sql
```

## 📖 Tutorial Sections

### 1. Database Creation
Learn to create and use databases

### 2. Basic Data Types  
Understand the most common MySQL data types with a simple example

### 3. Simple Constraints
Master NOT NULL, UNIQUE, and PRIMARY KEY

### 4. Foreign Key Relationships
Connect tables together with foreign keys

### 5. Testing and Queries
Verify everything works with simple SELECT statements

## 🏗️ Simple Example Schema
The tutorial uses a basic school database with just 4 tables:
- **students** (id, name, age, grade, birth_date)
- **courses** (course_id, course_name, credits, instructor)  
- **teachers** (teacher_id, name, email)
- **enrollments** (enrollment_id, student_id, course_id)

## 📝 Practice Exercises
The exercises use an even simpler pet store example:
- **pets** (pet_id, name, species, age, price)
- **customers** (customer_id, name, email, phone)
- **sales** (sale_id, customer_id, pet_id, sale_date)

## ✅ Key Concepts Covered
- CREATE DATABASE and USE
- Common data types for real-world scenarios
- PRIMARY KEY for unique identification
- NOT NULL for required fields  
- UNIQUE for preventing duplicates
- FOREIGN KEY for table relationships
- INSERT statements for adding data
- Basic JOIN queries

## 📈 Next Steps
Once you master these foundations, move on to:
- **01-beginner** - Basic SQL queries and filtering
- **02-intermediate** - Aggregation and advanced queries
- **03-advanced** - Window functions and analytics

## 💡 Tips for Success
1. Start with the main tutorial file
2. Try the exercises without looking at solutions
3. Always test your constraints work
4. Keep table designs simple at first
5. Use meaningful names for tables and columns
