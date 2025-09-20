-- ========================================
-- QUIZ 1 PRACTICE: MULTIPLE CHOICE QUESTIONS
-- ========================================
-- Practice multiple choice questions with detailed explanations
-- Load the schema first: mysql < employee-database-schema.sql

USE quiz1_practice;

-- ========================================
-- SECTION 1: ENTITY INTEGRITY
-- ========================================

/*
Question 1.1: Entity Integrity Constraint
Which of the following statements about entity integrity is TRUE?

A) Primary key attributes can contain NULL values if explicitly allowed
B) Primary key attributes must always be NOT NULL and UNIQUE
C) Entity integrity only applies to foreign keys
D) Multiple NULL values are allowed in primary key columns

YOUR ANSWER: ___

EXPLANATION:




*/

/*
Question 1.2: Primary Key Violation
Given this INSERT statement:
INSERT INTO EMPLOYEE (Fname, Lname, Ssn, Dno) VALUES ('John', 'Smith', NULL, 5);

What will happen?

A) The insert will succeed and Ssn will be set to NULL
B) The insert will fail due to entity integrity violation
C) The insert will succeed and Ssn will be auto-generated
D) The insert will succeed but with a warning

YOUR ANSWER: ___

EXPLANATION:




*/

/*
Question 1.3: Composite Primary Key
In the WORKS_ON table, the primary key is (Essn, Pno). Which is TRUE?

A) Both Essn and Pno can be NULL individually
B) Either Essn or Pno can be NULL, but not both
C) Neither Essn nor Pno can be NULL
D) Only one of them needs to be unique

YOUR ANSWER: ___

EXPLANATION:




*/

-- ========================================
-- SECTION 2: REFERENTIAL INTEGRITY
-- ========================================

/*
Question 2.1: Foreign Key Constraint
Which statement about foreign keys is FALSE?

A) Foreign key values must match existing primary key values in the referenced table
B) Foreign key values can be NULL unless explicitly restricted
C) A foreign key must always reference the primary key of another table
D) Foreign keys can reference any unique attribute in another table

YOUR ANSWER: ___

EXPLANATION:




*/

/*
Question 2.2: Referential Integrity Violation
What happens when you try to execute:
INSERT INTO EMPLOYEE (Fname, Lname, Ssn, Dno) VALUES ('Jane', 'Doe', '111111111', 99);

A) The insert succeeds with Dno set to 99
B) The insert fails because department 99 doesn't exist
C) The insert succeeds but Dno is set to NULL
D) The insert succeeds with Dno set to the default department

YOUR ANSWER: ___

EXPLANATION:




*/

/*
Question 2.3: DELETE with Foreign Key References
What happens when you try to delete an employee who is referenced as a supervisor?

A) The delete succeeds and supervised employees become orphaned
B) The delete fails due to referential integrity constraint
C) The delete succeeds and supervised employees are also deleted
D) The delete succeeds and supervised employees' Super_ssn is set to NULL

YOUR ANSWER: ___

EXPLANATION:




*/

/*
Question 2.4: Self-Referencing Foreign Key
In the EMPLOYEE table, Super_ssn references Ssn in the same table. Which is TRUE?

A) This creates a circular reference that is not allowed
B) This is allowed and creates a hierarchical relationship
C) This violates referential integrity rules
D) This requires a separate junction table

YOUR ANSWER: ___

EXPLANATION:




*/

-- ========================================
-- SECTION 3: CONSTRAINT TYPES AND BEHAVIORS
-- ========================================

/*
Question 3.1: NOT NULL Constraint
Which statement about NOT NULL constraints is TRUE?

A) NOT NULL only applies to primary key columns
B) NOT NULL prevents empty strings from being inserted
C) NOT NULL prevents NULL values but allows empty strings
D) NOT NULL is automatically applied to all foreign keys

YOUR ANSWER: ___

EXPLANATION:




*/

/*
Question 3.2: UNIQUE Constraint
What happens when you try to insert a duplicate value in a UNIQUE column?

A) The insert succeeds with a warning
B) The insert fails with a constraint violation error
C) The insert succeeds and overwrites the existing value
D) The insert succeeds and both values are kept

YOUR ANSWER: ___

EXPLANATION:




*/

/*
Question 3.3: CHECK Constraint
Which CHECK constraint syntax is valid in MySQL 8.0+?

A) ALTER TABLE EMPLOYEE ADD CHECK Salary > 0;
B) ALTER TABLE EMPLOYEE ADD CONSTRAINT salary_check CHECK (Salary > 0);
C) ALTER TABLE EMPLOYEE ADD CONSTRAINT CHECK (Salary > 0);
D) ALTER TABLE EMPLOYEE MODIFY Salary CHECK (Salary > 0);

YOUR ANSWER: ___

EXPLANATION:




*/

/*
Question 3.4: DEFAULT Constraint
What happens when you insert a row without specifying a value for a column with DEFAULT?

A) The insert fails
B) The column is set to NULL
C) The column is set to the default value
D) The column is set to an empty string

YOUR ANSWER: ___

EXPLANATION:




*/

-- ========================================
-- SECTION 4: CONSTRAINT VIOLATION HANDLING
-- ========================================

/*
Question 4.1: System Response to Constraint Violations
When a constraint violation occurs, what does the database system typically do?

A) Log the error but allow the operation to proceed
B) Reject the operation and return an error message
C) Automatically fix the violation
D) Ask the user how to handle the violation

YOUR ANSWER: ___

EXPLANATION:




*/

/*
Question 4.2: Transaction and Constraint Violations
If a constraint violation occurs in the middle of a transaction, what happens?

A) Only the violating statement is rolled back
B) The entire transaction is automatically rolled back
C) The transaction continues with a warning
D) The behavior depends on the transaction isolation level

YOUR ANSWER: ___

EXPLANATION:




*/

/*
Question 4.3: CASCADE Options
What does ON DELETE CASCADE mean for a foreign key constraint?

A) The delete operation is rejected
B) The foreign key value is set to NULL
C) The dependent rows are automatically deleted
D) The delete operation requires explicit confirmation

YOUR ANSWER: ___

EXPLANATION:




*/

-- ========================================
-- SECTION 5: ADVANCED CONSTRAINT SCENARIOS
-- ========================================

/*
Question 5.1: Circular References
How can circular foreign key references be handled during data insertion?

A) They are not allowed in relational databases
B) Insert one record with NULL foreign key, then update it
C) Use CASCADE constraints to handle the circularity
D) Disable constraint checking permanently

YOUR ANSWER: ___

EXPLANATION:




*/

/*
Question 5.2: Constraint Checking Timing
When are integrity constraints typically checked?

A) Only when the database is shut down
B) At the end of each transaction
C) Immediately when each statement is executed
D) Only when explicitly requested by the user

YOUR ANSWER: ___

EXPLANATION:




*/

/*
Question 5.3: Deferred Constraint Checking
What is deferred constraint checking?

A) Constraints are never checked
B) Constraints are checked at the end of a transaction
C) Constraints are checked only on weekends
D) Constraints are checked by a background process

YOUR ANSWER: ___

EXPLANATION:




*/

-- ========================================
-- SECTION 6: DOMAIN CONSTRAINTS
-- ========================================

/*
Question 6.1: Data Type Constraints
Which is an example of a domain constraint?

A) PRIMARY KEY constraint
B) FOREIGN KEY constraint
C) VARCHAR(50) length restriction
D) UNIQUE constraint

YOUR ANSWER: ___

EXPLANATION:




*/

/*
Question 6.2: Range Constraints
How would you ensure that employee ages are between 18 and 65?

A) Use a CHECK constraint: CHECK (Age BETWEEN 18 AND 65)
B) Use a FOREIGN KEY to an age table
C) Use a UNIQUE constraint on the Age column
D) Use a DEFAULT value of 30

YOUR ANSWER: ___

EXPLANATION:




*/

-- ========================================
-- SECTION 7: CONSTRAINT MODIFICATION
-- ========================================

/*
Question 7.1: Adding Constraints to Existing Tables
What happens when you add a new constraint to a table with existing data that violates the constraint?

A) The constraint is added and violating data is automatically fixed
B) The constraint addition fails
C) The constraint is added with a warning
D) Only new data is checked against the constraint

YOUR ANSWER: ___

EXPLANATION:




*/

/*
Question 7.2: Dropping Constraints
What happens to data when you drop a constraint?

A) All data in the table is deleted
B) Violating data is automatically deleted
C) The data remains unchanged
D) The table structure is reset

YOUR ANSWER: ___

EXPLANATION:




*/

-- ========================================
-- SECTION 8: REAL-WORLD SCENARIOS
-- ========================================

/*
Question 8.1: Department Manager Constraint
In our schema, Mgr_ssn in DEPARTMENT references Ssn in EMPLOYEE. What happens if you try to insert a department with a manager who doesn't exist yet?

A) The insert succeeds with Mgr_ssn set to NULL
B) The insert fails due to referential integrity violation
C) The employee record is automatically created
D) The constraint is temporarily disabled

YOUR ANSWER: ___

EXPLANATION:




*/

/*
Question 8.2: Employee Deletion Impact
What must be considered before deleting an employee from the database?

A) Only their personal information
B) Whether they have dependents
C) Whether they supervise others and work on projects
D) Only their salary information

YOUR ANSWER: ___

EXPLANATION:




*/

/*
Question 8.3: Data Migration Constraints
When migrating data from an old system, what constraint-related issues might arise?

A) All constraints will be automatically satisfied
B) Data might violate new integrity constraints
C) Constraints are not needed during migration
D) Migration tools automatically fix constraint violations

YOUR ANSWER: ___

EXPLANATION:




*/

-- ========================================
-- SECTION 9: PERFORMANCE AND CONSTRAINTS
-- ========================================

/*
Question 9.1: Constraint Impact on Performance
How do constraints typically affect database performance?

A) They always improve performance
B) They have no impact on performance
C) They may slow down INSERT/UPDATE operations but help with data integrity
D) They only affect SELECT queries

YOUR ANSWER: ___

EXPLANATION:




*/

/*
Question 9.2: Index Creation for Constraints
What happens when you create a PRIMARY KEY or UNIQUE constraint?

A) No additional structures are created
B) An index is automatically created
C) A trigger is automatically created
D) A view is automatically created

YOUR ANSWER: ___

EXPLANATION:




*/

-- ========================================
-- ANSWER KEY AND EXPLANATIONS
-- ========================================

/*
ANSWER KEY:

1.1: B - Primary key attributes must always be NOT NULL and UNIQUE
Entity integrity requires that primary keys uniquely identify each row and cannot be NULL.

1.2: B - The insert will fail due to entity integrity violation
Primary key columns cannot contain NULL values.

1.3: C - Neither Essn nor Pno can be NULL
In a composite primary key, ALL components must be NOT NULL.

2.1: C - A foreign key must always reference the primary key of another table (FALSE)
Foreign keys can reference any UNIQUE attribute, not just primary keys.

2.2: B - The insert fails because department 99 doesn't exist
Referential integrity requires foreign key values to exist in the referenced table.

2.3: B - The delete fails due to referential integrity constraint
Cannot delete a row that is referenced by other rows unless CASCADE is specified.

2.4: B - This is allowed and creates a hierarchical relationship
Self-referencing foreign keys are valid and commonly used for hierarchies.

3.1: C - NOT NULL prevents NULL values but allows empty strings
NOT NULL only prevents NULL, not empty strings ('').

3.2: B - The insert fails with a constraint violation error
UNIQUE constraints prevent duplicate values.

3.3: B - ALTER TABLE EMPLOYEE ADD CONSTRAINT salary_check CHECK (Salary > 0)
Proper syntax includes CONSTRAINT name and parentheses around condition.

3.4: C - The column is set to the default value
DEFAULT constraints provide automatic values when none specified.

4.1: B - Reject the operation and return an error message
Database systems enforce integrity by rejecting violating operations.

4.2: A - Only the violating statement is rolled back (in most systems)
Transaction behavior depends on system settings and error handling.

4.3: C - The dependent rows are automatically deleted
CASCADE automatically deletes related rows.

5.1: B - Insert one record with NULL foreign key, then update it
Common technique for handling circular references.

5.2: C - Immediately when each statement is executed
Most systems check constraints immediately (immediate mode).

5.3: B - Constraints are checked at the end of a transaction
Deferred checking delays validation until transaction commit.

6.1: C - VARCHAR(50) length restriction
Domain constraints restrict the set of allowable values for attributes.

6.2: A - Use a CHECK constraint: CHECK (Age BETWEEN 18 AND 65)
CHECK constraints enforce value ranges.

7.1: B - The constraint addition fails
Cannot add constraints that existing data violates.

7.2: C - The data remains unchanged
Dropping constraints only removes the enforcement rules.

8.1: B - The insert fails due to referential integrity violation
Foreign key values must exist in the referenced table.

8.2: C - Whether they supervise others and work on projects
Must consider all referential integrity dependencies.

8.3: B - Data might violate new integrity constraints
Old data may not meet new constraint requirements.

9.1: C - They may slow down INSERT/UPDATE operations but help with data integrity
Constraints require validation which takes time but ensures data quality.

9.2: B - An index is automatically created
Database systems create indexes to efficiently enforce uniqueness constraints.
*/

-- ========================================
-- PRACTICE COMPLETE!
-- ========================================
-- Review your answers against the answer key
-- Understanding the reasoning behind each answer is crucial
-- Next: 04-challenge-questions-practice.sql
