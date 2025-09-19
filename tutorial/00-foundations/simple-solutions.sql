-- ========================================
-- SIMPLE FOUNDATIONS PRACTICE SOLUTIONS
-- ========================================
-- Complete solutions to the simple practice exercises

-- SOLUTION SET 1: Basic Database and Tables
-- ========================================

-- Solution 1.1: Create a Pet Store Database
CREATE DATABASE pet_store;
USE pet_store;

-- Solution 1.2: Create a Simple Pets Table
CREATE TABLE pets (
    pet_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    species VARCHAR(30) NOT NULL,
    age INT,
    price DECIMAL(6,2)
);

-- Solution 1.3: Create a Simple Customers Table
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15)
);

-- SOLUTION SET 2: Foreign Keys
-- ========================================

-- Solution 2.1: Create a Sales Table
CREATE TABLE sales (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    pet_id INT NOT NULL,
    sale_date DATE DEFAULT (CURRENT_DATE),
    
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (pet_id) REFERENCES pets(pet_id)
);

-- SOLUTION SET 3: Data Insertion
-- ========================================

-- Solution 3.1: Insert Sample Pets
INSERT INTO pets (name, species, age, price) VALUES
    ('Buddy', 'Dog', 3, 299.99),
    ('Whiskers', 'Cat', 2, 149.99),
    ('Tweety', 'Bird', 1, 89.99);

-- Solution 3.2: Insert Sample Customers
INSERT INTO customers (name, email, phone) VALUES
    ('John Smith', 'john@email.com', '555-0101'),
    ('Sarah Johnson', 'sarah@email.com', '555-0102');

-- Solution 3.3: Record Some Sales
INSERT INTO sales (customer_id, pet_id, sale_date) VALUES
    (1, 1, '2025-09-15'),    -- John bought Buddy
    (2, 2, '2025-09-16');    -- Sarah bought Whiskers

-- SOLUTION SET 4: Test Your Knowledge
-- ========================================

-- Solution 4.1: Write a query to show all pets and their details
SELECT * FROM pets;

-- Solution 4.2: Write a query to show sales with customer and pet names
SELECT 
    c.name as customer_name,
    p.name as pet_name,
    s.sale_date
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
JOIN pets p ON s.pet_id = p.pet_id;

-- VERIFICATION QUERIES:
-- ========================================

-- Show all tables created
SHOW TABLES;

-- Show structure of each table
DESCRIBE pets;
DESCRIBE customers; 
DESCRIBE sales;

-- Show sample data from all tables
SELECT 'PETS' as table_name; SELECT * FROM pets;
SELECT 'CUSTOMERS' as table_name; SELECT * FROM customers;
SELECT 'SALES' as table_name; SELECT * FROM sales;

-- Show the complete sales report
SELECT 
    s.sale_id,
    c.name as customer_name,
    c.email,
    p.name as pet_name,
    p.species,
    p.price,
    s.sale_date
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
JOIN pets p ON s.pet_id = p.pet_id
ORDER BY s.sale_date;
