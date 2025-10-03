-- ========================================
-- SOLUTIONS: 03-multiple-choice-practice.sql
-- ========================================
-- Complete solutions and explanations for multiple choice practice questions
-- Load the schema first: mysql < employee-database-schema.sql

USE quiz1_practice;

-- ========================================
-- SECTION 1: ENTITY INTEGRITY
-- ========================================

/*
Question 1.1: Entity Integrity Constraint
Which of the following statements about entity integrity is TRUE?

A) Primary key attributes can contain NULL values if explicitly allowed
B) Primary key attributes must always be NOT NULL and UNIQUE ✓
C) Entity integrity only applies to foreign keys
D) Multiple NULL values are allowed in primary key columns

ANSWER: B

EXPLANATION:
Entity integrity is a fundamental constraint that requires primary key attributes to be:
1. NOT NULL - Primary keys cannot contain NULL values
2. UNIQUE - Primary keys must uniquely identify each row
This ensures each entity can be uniquely identified in the database.
*/

/*
Question 1.2: Primary Key Violation
Given this INSERT statement:
INSERT INTO EMPLOYEE (Fname, Lname, Ssn, Dno) VALUES ('John', 'Smith', NULL, 5);

What will happen?

A) The insert will succeed and Ssn will be set to NULL
B) The insert will fail due to entity integrity violation ✓
C) The insert will succeed and Ssn will be auto-generated
D) The insert will succeed but with a warning

ANSWER: B

EXPLANATION:
Since Ssn is the primary key of the EMPLOYEE table, it cannot be NULL.
The database will reject this INSERT with an error like "Column 'Ssn' cannot be null"
because it violates the entity integrity constraint.
*/

/*
Question 1.3: Composite Primary Key
In the WORKS_ON table, the primary key is (Essn, Pno). Which is TRUE?

A) Both Essn and Pno can be NULL individually
B) Either Essn or Pno can be NULL, but not both
C) Neither Essn nor Pno can be NULL ✓
D) Only one of them needs to be unique

ANSWER: C

EXPLANATION:
In a composite primary key, ALL components must be NOT NULL.
Even though the uniqueness constraint applies to the combination,
each individual component must still satisfy the NOT NULL requirement.
*/

-- ========================================
-- SECTION 2: REFERENTIAL INTEGRITY
-- ========================================

/*
Question 2.1: Foreign Key Constraint
Which statement about foreign keys is FALSE?

A) Foreign key values must match existing primary key values in the referenced table
B) Foreign key values can be NULL unless explicitly restricted
C) A foreign key must always reference the primary key of another table ✓
D) Foreign keys can reference any unique attribute in another table

ANSWER: C (This statement is FALSE)

EXPLANATION:
Foreign keys can reference any UNIQUE attribute in another table, not just primary keys.
While primary keys are the most common target, any column with a UNIQUE constraint
can be referenced by a foreign key. The other statements are all true.
*/

/*
Question 2.2: Referential Integrity Violation
What happens when you try to execute:
INSERT INTO EMPLOYEE (Fname, Lname, Ssn, Dno) VALUES ('Jane', 'Doe', '111111111', 99);

A) The insert succeeds with Dno set to 99
B) The insert fails because department 99 doesn't exist ✓
C) The insert succeeds but Dno is set to NULL
D) The insert succeeds with Dno set to the default department

ANSWER: B

EXPLANATION:
The Dno column is a foreign key referencing DEPARTMENT.Dnumber.
Since department 99 doesn't exist in the DEPARTMENT table, this violates
referential integrity and the database will reject the INSERT with an error.
*/

/*
Question 2.3: DELETE with Foreign Key References
What happens when you try to delete an employee who is referenced as a supervisor?

A) The delete succeeds and supervised employees become orphaned
B) The delete fails due to referential integrity constraint ✓
C) The delete succeeds and supervised employees are also deleted
D) The delete succeeds and supervised employees' Super_ssn is set to NULL

ANSWER: B

EXPLANATION:
By default, you cannot delete a row that is referenced by other rows.
The Super_ssn foreign key constraint prevents deletion of an employee
who supervises others, unless CASCADE options are specifically configured.
*/

/*
Question 2.4: Self-Referencing Foreign Key
In the EMPLOYEE table, Super_ssn references Ssn in the same table. Which is TRUE?

A) This creates a circular reference that is not allowed
B) This is allowed and creates a hierarchical relationship ✓
C) This violates referential integrity rules
D) This requires a separate junction table

ANSWER: B

EXPLANATION:
Self-referencing foreign keys are perfectly valid and commonly used
to represent hierarchical relationships like supervisor-subordinate,
parent-child, or manager-employee structures within the same table.
*/

-- ========================================
-- SECTION 3: CONSTRAINT TYPES AND BEHAVIORS
-- ========================================

/*
Question 3.1: NOT NULL Constraint
Which statement about NOT NULL constraints is TRUE?

A) NOT NULL only applies to primary key columns
B) NOT NULL prevents empty strings from being inserted
C) NOT NULL prevents NULL values but allows empty strings ✓
D) NOT NULL is automatically applied to all foreign keys

ANSWER: C

EXPLANATION:
NOT NULL only prevents NULL values. Empty strings ('') are valid values
that are different from NULL. NOT NULL can be applied to any column,
not just primary keys, and foreign keys can be NULL unless explicitly restricted.
*/

/*
Question 3.2: UNIQUE Constraint
What happens when you try to insert a duplicate value in a UNIQUE column?

A) The insert succeeds with a warning
B) The insert fails with a constraint violation error ✓
C) The insert succeeds and overwrites the existing value
D) The insert succeeds and both values are kept

ANSWER: B

EXPLANATION:
UNIQUE constraints enforce uniqueness by rejecting any attempt to insert
or update a column with a value that already exists. This results in
a constraint violation error, not a warning.
*/

/*
Question 3.3: CHECK Constraint
Which CHECK constraint syntax is valid in MySQL 8.0+?

A) ALTER TABLE EMPLOYEE ADD CHECK Salary > 0;
B) ALTER TABLE EMPLOYEE ADD CONSTRAINT salary_check CHECK (Salary > 0); ✓
C) ALTER TABLE EMPLOYEE ADD CONSTRAINT CHECK (Salary > 0);
D) ALTER TABLE EMPLOYEE MODIFY Salary CHECK (Salary > 0);

ANSWER: B

EXPLANATION:
The correct syntax includes:
- CONSTRAINT keyword with a constraint name
- CHECK keyword
- Condition in parentheses
This allows for proper constraint naming and management.
*/

/*
Question 3.4: DEFAULT Constraint
What happens when you insert a row without specifying a value for a column with DEFAULT?

A) The insert fails
B) The column is set to NULL
C) The column is set to the default value ✓
D) The column is set to an empty string

ANSWER: C

EXPLANATION:
DEFAULT constraints provide automatic values when no value is specified
in an INSERT statement. The column receives the predefined default value,
not NULL or an empty string.
*/

-- ========================================
-- SECTION 4: CONSTRAINT VIOLATION HANDLING
-- ========================================

/*
Question 4.1: System Response to Constraint Violations
When a constraint violation occurs, what does the database system typically do?

A) Log the error but allow the operation to proceed
B) Reject the operation and return an error message ✓
C) Automatically fix the violation
D) Ask the user how to handle the violation

ANSWER: B

EXPLANATION:
Database systems enforce integrity by immediately rejecting any operation
that would violate constraints. This preserves data integrity and ensures
the database remains in a consistent state.
*/

/*
Question 4.2: Transaction and Constraint Violations
If a constraint violation occurs in the middle of a transaction, what happens?

A) Only the violating statement is rolled back ✓
B) The entire transaction is automatically rolled back
C) The transaction continues with a warning
D) The behavior depends on the transaction isolation level

ANSWER: A

EXPLANATION:
Most database systems roll back only the specific statement that caused
the violation, not the entire transaction. The transaction can continue
after handling the error, unless explicitly rolled back by the application.
*/

/*
Question 4.3: CASCADE Options
What does ON DELETE CASCADE mean for a foreign key constraint?

A) The delete operation is rejected
B) The foreign key value is set to NULL
C) The dependent rows are automatically deleted ✓
D) The delete operation requires explicit confirmation

ANSWER: C

EXPLANATION:
ON DELETE CASCADE automatically deletes all rows that reference
the deleted row through the foreign key. This maintains referential
integrity by removing dependent records when the parent is deleted.
*/

-- ========================================
-- SECTION 5: ADVANCED CONSTRAINT SCENARIOS
-- ========================================

/*
Question 5.1: Circular References
How can circular foreign key references be handled during data insertion?

A) They are not allowed in relational databases
B) Insert one record with NULL foreign key, then update it ✓
C) Use CASCADE constraints to handle the circularity
D) Disable constraint checking permanently

ANSWER: B

EXPLANATION:
The standard approach is to temporarily use NULL for the foreign key,
insert both records, then update one to establish the reference.
This avoids the chicken-and-egg problem of circular dependencies.
*/

/*
Question 5.2: Constraint Checking Timing
When are integrity constraints typically checked?

A) Only when the database is shut down
B) At the end of each transaction
C) Immediately when each statement is executed ✓
D) Only when explicitly requested by the user

ANSWER: C

EXPLANATION:
Most database systems check constraints immediately when each statement
is executed (immediate mode). This provides immediate feedback and
prevents constraint violations from accumulating.
*/

/*
Question 5.3: Deferred Constraint Checking
What is deferred constraint checking?

A) Constraints are never checked
B) Constraints are checked at the end of a transaction ✓
C) Constraints are checked only on weekends
D) Constraints are checked by a background process

ANSWER: B

EXPLANATION:
Deferred constraint checking delays validation until transaction commit.
This allows temporary constraint violations within a transaction,
useful for complex operations that need multiple steps to satisfy constraints.
*/

-- ========================================
-- SECTION 6: DOMAIN CONSTRAINTS
-- ========================================

/*
Question 6.1: Data Type Constraints
Which is an example of a domain constraint?

A) PRIMARY KEY constraint
B) FOREIGN KEY constraint
C) VARCHAR(50) length restriction ✓
D) UNIQUE constraint

ANSWER: C

EXPLANATION:
Domain constraints restrict the set of allowable values for an attribute.
Data type specifications like VARCHAR(50) limit the length and type
of values that can be stored, defining the domain of valid values.
*/

/*
Question 6.2: Range Constraints
How would you ensure that employee ages are between 18 and 65?

A) Use a CHECK constraint: CHECK (Age BETWEEN 18 AND 65) ✓
B) Use a FOREIGN KEY to an age table
C) Use a UNIQUE constraint on the Age column
D) Use a DEFAULT value of 30

ANSWER: A

EXPLANATION:
CHECK constraints are specifically designed to enforce value ranges
and business rules. The BETWEEN operator provides a clean way
to specify minimum and maximum values for an attribute.
*/

-- ========================================
-- SECTION 7: CONSTRAINT MODIFICATION
-- ========================================

/*
Question 7.1: Adding Constraints to Existing Tables
What happens when you add a new constraint to a table with existing data that violates the constraint?

A) The constraint is added and violating data is automatically fixed
B) The constraint addition fails ✓
C) The constraint is added with a warning
D) Only new data is checked against the constraint

ANSWER: B

EXPLANATION:
You cannot add a constraint if existing data violates it.
The database will reject the ALTER TABLE statement with an error.
Data must be cleaned up first before the constraint can be added.
*/

/*
Question 7.2: Dropping Constraints
What happens to data when you drop a constraint?

A) All data in the table is deleted
B) Violating data is automatically deleted
C) The data remains unchanged ✓
D) The table structure is reset

ANSWER: C

EXPLANATION:
Dropping a constraint only removes the enforcement rule.
All existing data remains in the table unchanged.
This can potentially leave data that violates the removed constraint.
*/

-- ========================================
-- SECTION 8: REAL-WORLD SCENARIOS
-- ========================================

/*
Question 8.1: Department Manager Constraint
In our schema, Mgr_ssn in DEPARTMENT references Ssn in EMPLOYEE. What happens if you try to insert a department with a manager who doesn't exist yet?

A) The insert succeeds with Mgr_ssn set to NULL
B) The insert fails due to referential integrity violation ✓
C) The employee record is automatically created
D) The constraint is temporarily disabled

ANSWER: B

EXPLANATION:
Foreign key constraints are enforced immediately. You cannot reference
an employee who doesn't exist. Must insert the employee first,
or insert the department with NULL manager and update later.
*/

/*
Question 8.2: Employee Deletion Impact
What must be considered before deleting an employee from the database?

A) Only their personal information
B) Whether they have dependents
C) Whether they supervise others and work on projects ✓
D) Only their salary information

ANSWER: C

EXPLANATION:
Employee deletion affects multiple relationships: dependents, supervision
of other employees, project assignments, and potentially department
management. All foreign key references must be handled properly.
*/

/*
Question 8.3: Data Migration Constraints
When migrating data from an old system, what constraint-related issues might arise?

A) All constraints will be automatically satisfied
B) Data might violate new integrity constraints ✓
C) Constraints are not needed during migration
D) Migration tools automatically fix constraint violations

ANSWER: B

EXPLANATION:
Legacy data often doesn't meet the strict integrity requirements
of modern database designs. Common issues include orphaned records,
missing required values, and data format inconsistencies.
*/

-- ========================================
-- SECTION 9: PERFORMANCE AND CONSTRAINTS
-- ========================================

/*
Question 9.1: Constraint Impact on Performance
How do constraints typically affect database performance?

A) They always improve performance
B) They have no impact on performance
C) They may slow down INSERT/UPDATE operations but help with data integrity ✓
D) They only affect SELECT queries

ANSWER: C

EXPLANATION:
Constraints require validation during data modification operations,
which adds overhead. However, this cost is usually justified by
the data integrity benefits and can actually help query performance
through automatic index creation.
*/

/*
Question 9.2: Index Creation for Constraints
What happens when you create a PRIMARY KEY or UNIQUE constraint?

A) No additional structures are created
B) An index is automatically created ✓
C) A trigger is automatically created
D) A view is automatically created

ANSWER: B

EXPLANATION:
Database systems automatically create indexes for PRIMARY KEY and UNIQUE
constraints to efficiently enforce uniqueness. These indexes also
improve query performance for searches on these columns.
*/

-- ========================================
-- DETAILED ANSWER EXPLANATIONS
-- ========================================

/*
COMPREHENSIVE ANSWER KEY WITH EXPLANATIONS:

ENTITY INTEGRITY (Section 1):
- Primary keys must be NOT NULL and UNIQUE (entity integrity principle)
- NULL values violate entity integrity for primary keys
- All components of composite primary keys must be NOT NULL

REFERENTIAL INTEGRITY (Section 2):
- Foreign keys can reference any UNIQUE attribute, not just primary keys
- Foreign key values must exist in referenced table (no orphans)
- Deleting referenced rows requires handling dependent rows
- Self-referencing foreign keys create valid hierarchical relationships

CONSTRAINT TYPES (Section 3):
- NOT NULL prevents NULL but allows empty strings
- UNIQUE constraints cause immediate failure on duplicates
- CHECK constraints need proper syntax with constraint names
- DEFAULT values are automatically used when no value specified

VIOLATION HANDLING (Section 4):
- Constraint violations cause immediate rejection with error
- Usually only violating statement is rolled back, not entire transaction
- CASCADE options automatically handle dependent row operations

ADVANCED SCENARIOS (Section 5):
- Circular references handled by temporary NULL values
- Constraints typically checked immediately per statement
- Deferred checking delays validation until transaction end

DOMAIN CONSTRAINTS (Section 6):
- Data type specifications define value domains
- CHECK constraints enforce value ranges and business rules

CONSTRAINT MODIFICATION (Section 7):
- Cannot add constraints that existing data violates
- Dropping constraints leaves data unchanged

REAL-WORLD CONSIDERATIONS (Section 8):
- Foreign key references must exist before insertion
- Employee deletion affects multiple dependent relationships
- Data migration often reveals constraint violations

PERFORMANCE IMPACT (Section 9):
- Constraints add validation overhead but ensure data quality
- Indexes automatically created for PRIMARY KEY and UNIQUE constraints
*/

-- ========================================
-- PRACTICE TEST VALIDATION
-- ========================================

-- Query to verify constraint understanding
SELECT 
    'Constraint Type' AS Category,
    'PRIMARY KEY' AS Type,
    'Must be NOT NULL and UNIQUE' AS Rule
UNION ALL
SELECT 'Constraint Type', 'FOREIGN KEY', 'Must reference existing value or be NULL'
UNION ALL
SELECT 'Constraint Type', 'UNIQUE', 'No duplicate values allowed'
UNION ALL
SELECT 'Constraint Type', 'NOT NULL', 'No NULL values, empty strings OK'
UNION ALL
SELECT 'Constraint Type', 'CHECK', 'Must satisfy specified condition'
UNION ALL
SELECT 'Constraint Type', 'DEFAULT', 'Provides value when none specified';

-- ========================================
-- MULTIPLE CHOICE SOLUTIONS COMPLETE!
-- ========================================
-- These solutions cover all aspects of database constraints:
-- - Entity and referential integrity principles
-- - Constraint types and their behaviors
-- - Violation handling and system responses
-- - Real-world application scenarios
-- - Performance considerations
-- ========================================
