-- ========================================
-- FOUNDATIONS PRACTICE EXERCISES - SOLUTIONS
-- ========================================
-- Complete solutions to all practice exercises with explanations

-- SOLUTION SET 1: Database and Table Creation
-- ========================================

-- Solution 1.1: Create a Library Management Database
CREATE DATABASE IF NOT EXISTS library_system 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_0900_ai_ci;

USE library_system;

-- Solution 1.2: Create an Authors Table
CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE,
    nationality VARCHAR(50),
    biography LONGTEXT
) ENGINE=InnoDB;

-- Solution 1.3: Create a Books Table with Data Types
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    isbn CHAR(13) UNIQUE NOT NULL,                                    -- Exactly 13 characters
    title VARCHAR(200) NOT NULL,
    publication_date DATE,
    pages INT CHECK (pages > 0),                                      -- Must be positive
    price DECIMAL(8,2) CHECK (price > 0),                            -- Must be positive, up to 999,999.99
    language ENUM('English', 'Spanish', 'French', 'German') NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    rating DECIMAL(2,1) CHECK (rating BETWEEN 0.0 AND 5.0)          -- 0.0 to 5.0
) ENGINE=InnoDB;

-- SOLUTION SET 2: Constraints and Relationships
-- ========================================

-- Solution 2.1: Create Members Table with Constraints
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    membership_number VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE,                                         -- Unique if provided, can be NULL
    join_date DATE DEFAULT (CURRENT_DATE),
    membership_type ENUM('Student', 'Faculty', 'Public') NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB;

-- Solution 2.2: Create Book-Author Relationship Table
CREATE TABLE book_authors (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    
    PRIMARY KEY (book_id, author_id),                                 -- Composite primary key
    
    CONSTRAINT fk_book_authors_book 
        FOREIGN KEY (book_id) REFERENCES books(book_id)
        ON DELETE CASCADE ON UPDATE CASCADE,                          -- Remove relationship if book deleted
        
    CONSTRAINT fk_book_authors_author 
        FOREIGN KEY (author_id) REFERENCES authors(author_id)
        ON DELETE RESTRICT ON UPDATE CASCADE                          -- Prevent author deletion if they have books
) ENGINE=InnoDB;

-- Solution 2.3: Create Loans Table with Complex Relationships
CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date DATE DEFAULT (CURRENT_DATE),
    due_date DATE NOT NULL,                                           -- Must be provided (calculated as loan_date + 14)
    return_date DATE,
    fine_amount DECIMAL(6,2) DEFAULT 0.00,
    
    -- Composite unique constraint: same book can't be loaned to same member on same date
    UNIQUE KEY uk_loan_book_member_date (book_id, member_id, loan_date),
    
    CONSTRAINT fk_loans_book 
        FOREIGN KEY (book_id) REFERENCES books(book_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,                         -- Can't delete book if it has loan history
        
    CONSTRAINT fk_loans_member 
        FOREIGN KEY (member_id) REFERENCES members(member_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,                         -- Can't delete member if they have loan history
        
    CONSTRAINT chk_return_after_loan 
        CHECK (return_date IS NULL OR return_date >= loan_date),      -- Return date must be after loan date
        
    CONSTRAINT chk_due_after_loan 
        CHECK (due_date > loan_date)                                  -- Due date must be after loan date
) ENGINE=InnoDB;

-- SOLUTION SET 3: Advanced Constraints
-- ========================================

-- Solution 3.1: Create a Categories Table (with self-reference)
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) UNIQUE NOT NULL,
    parent_category_id INT,                                           -- Self-reference for hierarchical categories
    description TEXT,
    
    CONSTRAINT fk_category_parent 
        FOREIGN KEY (parent_category_id) REFERENCES categories(category_id)
        ON DELETE SET NULL ON UPDATE CASCADE                          -- If parent deleted, make this a root category
) ENGINE=InnoDB;

-- Solution 3.2: Create Book Categories Junction Table
CREATE TABLE book_categories (
    book_id INT NOT NULL,
    category_id INT NOT NULL,
    
    PRIMARY KEY (book_id, category_id),
    
    CONSTRAINT fk_book_cat_book 
        FOREIGN KEY (book_id) REFERENCES books(book_id)
        ON DELETE CASCADE ON UPDATE CASCADE,                          -- Remove categorization if book deleted
        
    CONSTRAINT fk_book_cat_category 
        FOREIGN KEY (category_id) REFERENCES categories(category_id)
        ON DELETE CASCADE ON UPDATE CASCADE                           -- Remove categorization if category deleted
) ENGINE=InnoDB;

-- Solution 3.3: Create a Reviews Table
CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),                       -- 1-5 star rating
    review_text LONGTEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_verified BOOLEAN DEFAULT FALSE,
    
    -- One review per member per book
    UNIQUE KEY uk_review_book_member (book_id, member_id),
    
    CONSTRAINT fk_reviews_book 
        FOREIGN KEY (book_id) REFERENCES books(book_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
        
    CONSTRAINT fk_reviews_member 
        FOREIGN KEY (member_id) REFERENCES members(member_id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- SOLUTION SET 4: Data Insertion Practice
-- ========================================

-- Solution 4.1: Insert Sample Authors
INSERT INTO authors (first_name, last_name, birth_date, nationality, biography) VALUES
    ('George', 'Orwell', '1903-06-25', 'British', 'Eric Arthur Blair, known by his pen name George Orwell, was an English novelist, essayist, journalist and critic.'),
    ('Jane', 'Austen', '1775-12-16', 'British', NULL),               -- Biography is NULL
    ('Harper', 'Lee', '1926-04-28', 'American', ''),                 -- Minimal required fields
    ('Gabriel', 'García Márquez', '1927-03-06', 'Colombian', 'Colombian novelist, short-story writer, screenwriter, and journalist.'),
    ('Toni', 'Morrison', '1931-02-18', 'American', 'American novelist, essayist, book editor, and college professor.');

-- Solution 4.2: Insert Sample Books
INSERT INTO books (isbn, title, publication_date, pages, price, language, rating) VALUES
    ('9780451524935', '1984', '1949-06-08', 328, 13.99, 'English', 4.5),
    ('9780141439518', 'Pride and Prejudice', '1813-01-28', 416, 12.50, 'English', 4.3),
    ('9780060935467', 'To Kill a Mockingbird', '1960-07-11', 281, 14.99, 'English', 4.8),
    ('9780307474728', 'One Hundred Years of Solitude', '1967-06-05', 417, 16.95, 'Spanish', 4.4),
    ('9781400033416', 'Beloved', '1987-09-02', 324, 15.99, 'English', 4.2);

-- Solution 4.3: Insert Sample Members
INSERT INTO members (membership_number, first_name, last_name, email, phone, membership_type) VALUES
    ('STU2025001', 'Alice', 'Johnson', 'alice.johnson@university.edu', '555-0101', 'Student'),
    ('FAC2025001', 'Dr. Robert', 'Smith', 'robert.smith@university.edu', '555-0102', 'Faculty'),
    ('PUB2025001', 'Emily', 'Davis', 'emily.davis@email.com', '555-0103', 'Public'),
    ('STU2025002', 'Michael', 'Brown', 'michael.brown@university.edu', NULL, 'Student'),    -- No phone
    ('PUB2025002', 'Sarah', 'Wilson', 'sarah.wilson@email.com', '555-0105', 'Public');

-- Solution 4.4: Create Book-Author Relationships
INSERT INTO book_authors (book_id, author_id) VALUES
    (1, 1),    -- 1984 by George Orwell
    (2, 2),    -- Pride and Prejudice by Jane Austen
    (3, 3),    -- To Kill a Mockingbird by Harper Lee
    (4, 4),    -- One Hundred Years of Solitude by Gabriel García Márquez
    (5, 5);    -- Beloved by Toni Morrison

-- SOLUTION SET 5: Sample Data for Categories and More Complex Relationships
-- ========================================

-- Insert Categories (demonstrating hierarchical structure)
INSERT INTO categories (category_name, parent_category_id, description) VALUES
    ('Fiction', NULL, 'Fictional works including novels and short stories'),
    ('Non-Fiction', NULL, 'Factual books including biographies, history, science'),
    ('Classic Literature', 1, 'Timeless works of fiction'),                        -- Child of Fiction
    ('Modern Fiction', 1, 'Contemporary fictional works'),                         -- Child of Fiction
    ('Dystopian', 3, 'Dark visions of future societies'),                         -- Child of Classic Literature
    ('Romance', 3, 'Love stories and romantic novels'),                           -- Child of Classic Literature
    ('American Literature', 3, 'Literature from American authors');               -- Child of Classic Literature

-- Link books to categories
INSERT INTO book_categories (book_id, category_id) VALUES
    (1, 5),    -- 1984 -> Dystopian
    (2, 6),    -- Pride and Prejudice -> Romance
    (3, 7),    -- To Kill a Mockingbird -> American Literature
    (4, 3),    -- One Hundred Years of Solitude -> Classic Literature
    (5, 7);    -- Beloved -> American Literature

-- Insert sample loans (with proper due dates)
INSERT INTO loans (book_id, member_id, loan_date, due_date) VALUES
    (1, 1, '2025-09-01', '2025-09-15'),    -- Alice borrows 1984
    (2, 2, '2025-09-05', '2025-09-19'),    -- Dr. Smith borrows Pride and Prejudice
    (3, 3, '2025-09-10', '2025-09-24');    -- Emily borrows To Kill a Mockingbird

-- Insert sample reviews
INSERT INTO reviews (book_id, member_id, rating, review_text) VALUES
    (1, 1, 5, 'Absolutely brilliant dystopian novel. Orwell\'s vision is both terrifying and prescient.'),
    (2, 2, 4, 'Witty and engaging romance. Austen\'s character development is masterful.'),
    (3, 3, 5, 'A powerful exploration of racial injustice. Essential reading for everyone.');

-- SOLUTION SET 6: Verification Queries
-- ========================================

-- Verify all tables were created successfully
SELECT TABLE_NAME, TABLE_ROWS, DATA_LENGTH, INDEX_LENGTH
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'library_system'
ORDER BY TABLE_NAME;

-- Verify foreign key relationships
SELECT 
    CONSTRAINT_NAME,
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME,
    DELETE_RULE,
    UPDATE_RULE
FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS rc
JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu 
    ON rc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
WHERE rc.CONSTRAINT_SCHEMA = 'library_system'
ORDER BY TABLE_NAME;

-- Test query: Books with their authors and categories
SELECT 
    b.title,
    CONCAT(a.first_name, ' ', a.last_name) as author_name,
    c.category_name,
    b.price,
    b.rating
FROM books b
LEFT JOIN book_authors ba ON b.book_id = ba.book_id
LEFT JOIN authors a ON ba.author_id = a.author_id
LEFT JOIN book_categories bc ON b.book_id = bc.book_id
LEFT JOIN categories c ON bc.category_id = c.category_id
ORDER BY b.title;

-- Test query: Active loans with member and book information
SELECT 
    l.loan_id,
    CONCAT(m.first_name, ' ', m.last_name) as member_name,
    b.title,
    l.loan_date,
    l.due_date,
    CASE 
        WHEN l.return_date IS NULL AND l.due_date < CURRENT_DATE THEN 'Overdue'
        WHEN l.return_date IS NULL THEN 'Active'
        ELSE 'Returned'
    END as loan_status
FROM loans l
JOIN members m ON l.member_id = m.member_id
JOIN books b ON l.book_id = b.book_id
ORDER BY l.loan_date DESC;

-- Test query: Category hierarchy
SELECT 
    c1.category_name as category,
    c2.category_name as parent_category,
    COUNT(bc.book_id) as book_count
FROM categories c1
LEFT JOIN categories c2 ON c1.parent_category_id = c2.category_id
LEFT JOIN book_categories bc ON c1.category_id = bc.category_id
GROUP BY c1.category_id, c1.category_name, c2.category_name
ORDER BY c2.category_name, c1.category_name;

-- DEMONSTRATION OF CONSTRAINT VIOLATIONS
-- ========================================

-- These INSERT statements will fail - demonstrating constraint enforcement:

-- 1. Duplicate ISBN (UNIQUE constraint violation)
-- INSERT INTO books (isbn, title, language) VALUES ('9780451524935', 'Duplicate Book', 'English');

-- 2. Invalid rating (CHECK constraint violation)  
-- INSERT INTO books (isbn, title, rating, language) VALUES ('9999999999999', 'Bad Rating', 6.0, 'English');

-- 3. Foreign key violation (non-existent author)
-- INSERT INTO book_authors (book_id, author_id) VALUES (1, 999);

-- 4. NULL in NOT NULL field
-- INSERT INTO members (first_name, email) VALUES ('John', 'john@email.com');  -- Missing last_name

-- 5. Invalid enum value
-- INSERT INTO members (membership_number, first_name, last_name, email, membership_type) 
-- VALUES ('TEST001', 'Test', 'User', 'test@email.com', 'InvalidType');

-- KEY LEARNING OUTCOMES FROM THESE SOLUTIONS:
-- ========================================
-- 1. Proper use of AUTO_INCREMENT for primary keys
-- 2. Appropriate data types for different kinds of data
-- 3. Strategic use of NOT NULL constraints
-- 4. UNIQUE constraints for business rules
-- 5. CHECK constraints for data validation
-- 6. Foreign key relationships with proper referential actions
-- 7. Composite keys for junction tables
-- 8. Self-referencing foreign keys for hierarchical data
-- 9. Default values for common scenarios
-- 10. Index implications of primary and foreign keys
