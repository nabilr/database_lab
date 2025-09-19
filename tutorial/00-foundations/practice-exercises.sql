-- ========================================
-- SIMPLE FOUNDATIONS PRACTICE EXERCISES
-- ========================================
-- Basic exercises for database creation and table design

-- EXERCISE SET 1: Basic Database and Tables
-- ========================================

-- Exercise 1.1: Create a Pet Store Database
-- Create a database called 'pet_store'
-- Solution template:
/*
CREATE DATABASE pet_store;
USE pet_store;
*/

-- Exercise 1.2: Create a Simple Pets Table
-- Requirements:
-- - pet_id: auto-incrementing primary key
-- - name: required, up to 50 characters
-- - species: required (like 'Dog', 'Cat', 'Bird')
-- - age: whole number
-- - price: decimal with 2 decimal places
-- Solution template:
/*
CREATE TABLE pets (
    -- Your solution here
);
*/

-- Exercise 1.3: Create a Simple Customers Table
-- Requirements:
-- - customer_id: auto-incrementing primary key
-- - name: required, up to 100 characters
-- - email: unique, up to 100 characters
-- - phone: optional, up to 15 characters
-- Solution template:
/*
CREATE TABLE customers (
    -- Your solution here
);
*/

-- EXERCISE SET 2: Foreign Keys
-- ========================================

-- Exercise 2.1: Create a Sales Table
-- Requirements:
-- - sale_id: auto-incrementing primary key
-- - customer_id: foreign key to customers table
-- - pet_id: foreign key to pets table
-- - sale_date: date, defaults to current date
-- Solution template:
/*
CREATE TABLE sales (
    -- Your solution here
);
*/

-- EXERCISE SET 3: Data Insertion
-- ========================================

-- Exercise 3.1: Insert Sample Pets
-- Insert 3 pets: a dog named "Buddy", a cat named "Whiskers", and a bird named "Tweety"
-- Solution template:
/*
INSERT INTO pets (name, species, age, price) VALUES
    -- Your solution here
*/

-- Exercise 3.2: Insert Sample Customers
-- Insert 2 customers with different emails
-- Solution template:
/*
INSERT INTO customers (name, email, phone) VALUES
    -- Your solution here
*/

-- Exercise 3.3: Record Some Sales
-- Create sales records linking customers to pets they bought
-- Solution template:
/*
INSERT INTO sales (customer_id, pet_id, sale_date) VALUES
    -- Your solution here
*/

-- EXERCISE SET 4: Test Your Knowledge
-- ========================================

-- Exercise 4.1: Write a query to show all pets and their details
-- Solution template:
/*
SELECT * FROM pets;
*/

-- Exercise 4.2: Write a query to show sales with customer and pet names
-- Solution template:
/*
SELECT 
    c.name as customer_name,
    p.name as pet_name,
    s.sale_date
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
JOIN pets p ON s.pet_id = p.pet_id;
*/

-- WHAT YOU'VE LEARNED:
-- ========================================
-- 1. CREATE DATABASE and USE commands
-- 2. Basic data types: INT, VARCHAR, DECIMAL, DATE
-- 3. PRIMARY KEY for unique identification  
-- 4. NOT NULL for required fields
-- 5. UNIQUE for no duplicates
-- 6. FOREIGN KEY to link tables
-- 7. INSERT to add data
-- 8. Simple JOIN queries

-- COMMON MISTAKES TO AVOID:
-- ========================================
-- 1. Forgetting PRIMARY KEY
-- 2. Wrong data types (using INT for names)
-- 3. Missing NOT NULL on required fields
-- 4. Creating foreign keys before parent tables exist
-- 5. Forgetting to specify field lengths for VARCHAR