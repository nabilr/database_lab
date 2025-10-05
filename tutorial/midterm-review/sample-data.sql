-- ========================================
-- SAMPLE DATA FOR MIDTERM REVIEW
-- ========================================
-- Comprehensive test data for both schemas

USE midterm_review;

-- ========================================
-- STUDENT-COURSE SAMPLE DATA
-- ========================================

-- Insert departments
INSERT INTO DEPARTMENT (dept_id, name, budget, building) VALUES
(1, 'Computer Science', 500000.00, 'Engineering Building'),
(2, 'Mathematics', 300000.00, 'Science Hall'),
(3, 'Physics', 400000.00, 'Physics Building'),
(4, 'Biology', 350000.00, 'Biology Lab'),
(5, 'Chemistry', 380000.00, 'Chemistry Lab'),
(6, 'Business', 450000.00, 'Business School'),
(7, 'English', 200000.00, 'Humanities Building');

-- Insert students
INSERT INTO STUDENT (student_id, name, dept_id, year_level, enrollment_date, gpa) VALUES
(1001, 'Alice Johnson', 1, 'Junior', '2022-09-01', 3.75),
(1002, 'Bob Smith', 2, 'Sophomore', '2023-09-01', 3.20),
(1003, 'Carol Davis', 1, 'Senior', '2021-09-01', 3.90),
(1004, 'David Wilson', 3, 'Freshman', '2024-09-01', 3.10),
(1005, 'Eva Brown', 4, 'Junior', '2022-09-01', 3.60),
(1006, 'Frank Miller', 5, 'Sophomore', '2023-09-01', 3.40),
(1007, 'Grace Lee', 1, 'Senior', '2021-09-01', 3.85),
(1008, 'Henry Taylor', 2, 'Junior', '2022-09-01', 3.30),
(1009, 'Ivy Chen', 6, 'Sophomore', '2023-09-01', 3.50),
(1010, 'Jack Anderson', 7, 'Freshman', '2024-09-01', 3.25),
(1011, 'Kate Martinez', 1, 'Junior', '2022-09-01', 3.70),
(1012, 'Liam Thompson', 3, 'Senior', '2021-09-01', 3.80),
(1013, 'Maya Rodriguez', 4, 'Sophomore', '2023-09-01', 3.45),
(1014, 'Noah Garcia', 5, 'Junior', '2022-09-01', 3.55),
(1015, 'Olivia White', 6, 'Senior', '2021-09-01', 3.65);

-- Insert courses
INSERT INTO COURSE (course_id, title, credits, dept_id, description) VALUES
(101, 'CS101: Introduction to Programming', 3, 1, 'Basic programming concepts using Python'),
(102, 'CS102: Data Structures', 4, 1, 'Arrays, linked lists, stacks, queues, trees'),
(103, 'CS201: Algorithms', 4, 1, 'Sorting, searching, graph algorithms'),
(104, 'CS301: Database Systems', 3, 1, 'SQL, relational model, normalization'),
(105, 'CS401: Software Engineering', 3, 1, 'Software development lifecycle'),
(201, 'MATH101: Calculus I', 4, 2, 'Limits, derivatives, integrals'),
(202, 'MATH102: Calculus II', 4, 2, 'Advanced integration techniques'),
(203, 'MATH201: Linear Algebra', 3, 2, 'Matrices, vector spaces, eigenvalues'),
(204, 'MATH301: Statistics', 3, 2, 'Probability, distributions, hypothesis testing'),
(301, 'PHYS101: General Physics I', 4, 3, 'Mechanics, thermodynamics'),
(302, 'PHYS102: General Physics II', 4, 3, 'Electricity, magnetism, waves'),
(303, 'PHYS201: Modern Physics', 3, 3, 'Quantum mechanics, relativity'),
(401, 'BIO101: General Biology', 4, 4, 'Cell biology, genetics, evolution'),
(402, 'BIO201: Molecular Biology', 3, 4, 'DNA, RNA, protein synthesis'),
(501, 'CHEM101: General Chemistry', 4, 5, 'Atomic structure, bonding, reactions'),
(502, 'CHEM201: Organic Chemistry', 4, 5, 'Carbon compounds, functional groups'),
(601, 'BUS101: Introduction to Business', 3, 6, 'Business fundamentals, management'),
(602, 'BUS201: Marketing', 3, 6, 'Marketing strategies, consumer behavior'),
(701, 'ENG101: English Composition', 3, 7, 'Writing skills, grammar, literature');

-- Insert prerequisites
INSERT INTO PREREQUISITE (course_id, prereq_id) VALUES
(102, 101),  -- Data Structures requires Intro to Programming
(103, 102),  -- Algorithms requires Data Structures
(104, 102),  -- Database Systems requires Data Structures
(105, 104),  -- Software Engineering requires Database Systems
(202, 201),  -- Calculus II requires Calculus I
(203, 202),  -- Linear Algebra requires Calculus II
(302, 301),  -- Physics II requires Physics I
(303, 302),  -- Modern Physics requires Physics II
(402, 401),  -- Molecular Biology requires General Biology
(502, 501);  -- Organic Chemistry requires General Chemistry

-- Insert sections
INSERT INTO SECTION (section_id, course_id, term, year_num, capacity, instructor_name) VALUES
(2001, 101, 'Fall', 2024, 30, 'Dr. Sarah Chen'),
(2002, 102, 'Fall', 2024, 25, 'Prof. Michael Rodriguez'),
(2003, 103, 'Fall', 2024, 20, 'Dr. Emma Thompson'),
(2004, 104, 'Fall', 2024, 25, 'Dr. David Kim'),
(2005, 105, 'Fall', 2024, 20, 'Prof. Lisa Johnson'),
(2006, 201, 'Fall', 2024, 35, 'Dr. Robert Brown'),
(2007, 202, 'Fall', 2024, 30, 'Prof. Maria Garcia'),
(2008, 203, 'Fall', 2024, 25, 'Dr. James Wilson'),
(2009, 204, 'Fall', 2024, 30, 'Prof. Jennifer Davis'),
(2010, 301, 'Fall', 2024, 30, 'Dr. Christopher Lee'),
(2011, 302, 'Fall', 2024, 25, 'Prof. Amanda Taylor'),
(2012, 303, 'Fall', 2024, 20, 'Dr. Kevin Martinez'),
(2013, 401, 'Fall', 2024, 30, 'Dr. Rachel Anderson'),
(2014, 402, 'Fall', 2024, 25, 'Prof. Daniel White'),
(2015, 501, 'Fall', 2024, 35, 'Dr. Michelle Clark'),
(2016, 502, 'Fall', 2024, 25, 'Prof. Steven Lewis'),
(2017, 601, 'Fall', 2024, 40, 'Dr. Nicole Walker'),
(2018, 602, 'Fall', 2024, 30, 'Prof. Brian Hall'),
(2019, 701, 'Fall', 2024, 35, 'Dr. Patricia Young');

-- Insert grade reports
INSERT INTO GRADE_REPORT (student_id, course_id, section_id, grade, semester, year_num) VALUES
-- Alice Johnson (1001) - CS major
(1001, 101, 2001, 92.5, 'Fall2024', 2024),
(1001, 102, 2002, 88.0, 'Fall2024', 2024),
(1001, 201, 2006, 85.5, 'Fall2024', 2024),
(1001, 301, 2010, 90.0, 'Fall2024', 2024),

-- Bob Smith (1002) - Math major
(1002, 201, 2006, 78.5, 'Fall2024', 2024),
(1002, 202, 2007, 82.0, 'Fall2024', 2024),
(1002, 204, 2009, 87.5, 'Fall2024', 2024),
(1002, 101, 2001, 75.0, 'Fall2024', 2024),

-- Carol Davis (1003) - CS major
(1003, 101, 2001, 95.0, 'Fall2024', 2024),
(1003, 102, 2002, 92.5, 'Fall2024', 2024),
(1003, 103, 2003, 89.0, 'Fall2024', 2024),
(1003, 104, 2004, 91.5, 'Fall2024', 2024),
(1003, 105, 2005, 88.0, 'Fall2024', 2024),

-- David Wilson (1004) - Physics major
(1004, 301, 2010, 80.0, 'Fall2024', 2024),
(1004, 201, 2006, 77.5, 'Fall2024', 2024),
(1004, 101, 2001, 72.0, 'Fall2024', 2024),

-- Eva Brown (1005) - Biology major
(1005, 401, 2013, 86.0, 'Fall2024', 2024),
(1005, 402, 2014, 84.5, 'Fall2024', 2024),
(1005, 501, 2015, 79.0, 'Fall2024', 2024),
(1005, 201, 2006, 81.5, 'Fall2024', 2024),

-- Frank Miller (1006) - Chemistry major
(1006, 501, 2015, 83.0, 'Fall2024', 2024),
(1006, 502, 2016, 80.5, 'Fall2024', 2024),
(1006, 201, 2006, 76.0, 'Fall2024', 2024),
(1006, 301, 2010, 78.5, 'Fall2024', 2024),

-- Grace Lee (1007) - CS major
(1007, 101, 2001, 94.5, 'Fall2024', 2024),
(1007, 102, 2002, 91.0, 'Fall2024', 2024),
(1007, 103, 2003, 87.5, 'Fall2024', 2024),
(1007, 104, 2004, 90.0, 'Fall2024', 2024),
(1007, 105, 2005, 85.5, 'Fall2024', 2024),

-- Henry Taylor (1008) - Math major
(1008, 201, 2006, 82.5, 'Fall2024', 2024),
(1008, 202, 2007, 85.0, 'Fall2024', 2024),
(1008, 203, 2008, 88.5, 'Fall2024', 2024),
(1008, 204, 2009, 86.0, 'Fall2024', 2024),

-- Ivy Chen (1009) - Business major
(1009, 601, 2017, 89.0, 'Fall2024', 2024),
(1009, 602, 2018, 87.5, 'Fall2024', 2024),
(1009, 101, 2001, 81.0, 'Fall2024', 2024),
(1009, 201, 2006, 79.5, 'Fall2024', 2024),

-- Jack Anderson (1010) - English major
(1010, 701, 2019, 92.0, 'Fall2024', 2024),
(1010, 101, 2001, 74.0, 'Fall2024', 2024),
(1010, 201, 2006, 77.0, 'Fall2024', 2024);

-- ========================================
-- COMPANY SAMPLE DATA
-- ========================================

-- Insert departments
INSERT INTO COMPANY_DEPARTMENT (Dname, Dnumber, Mgr_ssn, Mgr_start_date) VALUES
('Research', 5, NULL, '1988-05-22'),
('Administration', 4, NULL, '1995-01-01'),
('Headquarters', 1, NULL, '1981-06-19'),
('Software', 6, NULL, '1999-05-15'),
('Hardware', 7, NULL, '2000-03-01'),
('Marketing', 8, NULL, '2001-07-15'),
('Finance', 9, NULL, '2002-02-10');

-- Insert employees
INSERT INTO EMPLOYEE (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno) VALUES
('John', 'B', 'Smith', '123456789', '1965-01-09', '731 Fondren, Houston, TX', 'M', 30000, NULL, 5),
('Franklin', 'T', 'Wong', '333445555', '1955-12-08', '638 Voss, Houston, TX', 'M', 40000, NULL, 5),
('Alicia', 'J', 'Zelaya', '999887777', '1968-01-19', '3321 Castle, Spring, TX', 'F', 25000, '333445555', 4),
('Jennifer', 'S', 'Wallace', '987654321', '1941-06-20', '291 Berry, Bellaire, TX', 'F', 43000, NULL, 4),
('Ramesh', 'K', 'Narayan', '666884444', '1962-09-15', '975 Fire Oak, Humble, TX', 'M', 38000, '333445555', 5),
('Joyce', 'A', 'English', '453453453', '1972-07-31', '5631 Rice, Houston, TX', 'F', 25000, '333445555', 5),
('Ahmad', 'V', 'Jabbar', '987987987', '1969-03-29', '980 Dallas, Houston, TX', 'M', 25000, '987654321', 4),
('James', 'E', 'Borg', '888665555', '1937-11-10', '450 Stone, Houston, TX', 'M', 55000, NULL, 1),
('Robert', 'F', 'Scott', '444444400', '1942-06-15', '563 Rice, Houston, TX', 'M', 58000, '888665555', 1),
('Maria', 'D', 'Rodriguez', '444444401', '1959-04-15', '123 Main, Dallas, TX', 'F', 45000, '888665555', 6),
('David', 'S', 'Johnson', '444444402', '1963-08-22', '456 Oak, Austin, TX', 'M', 42000, '444444401', 6),
('Lisa', 'M', 'Anderson', '444444403', '1970-12-03', '789 Pine, Houston, TX', 'F', 35000, '444444401', 7),
('Michael', 'T', 'Brown', '444444404', '1967-05-18', '321 Elm, Dallas, TX', 'M', 48000, '888665555', 7),
('Sarah', 'L', 'Wilson', '444444405', '1975-03-22', '654 Maple, Austin, TX', 'F', 38000, '987654321', 8),
('Thomas', 'R', 'Davis', '444444406', '1980-08-14', '987 Cedar, Houston, TX', 'M', 32000, '444444405', 8),
('Emily', 'C', 'Garcia', '444444407', '1982-11-30', '147 Birch, Dallas, TX', 'F', 41000, '888665555', 9),
('Christopher', 'A', 'Martinez', '444444408', '1978-06-05', '258 Spruce, Austin, TX', 'M', 37000, '444444407', 9);

-- Update department managers
UPDATE COMPANY_DEPARTMENT SET Mgr_ssn = '333445555' WHERE Dnumber = 5;  -- Research
UPDATE COMPANY_DEPARTMENT SET Mgr_ssn = '987654321' WHERE Dnumber = 4;  -- Administration  
UPDATE COMPANY_DEPARTMENT SET Mgr_ssn = '888665555' WHERE Dnumber = 1;  -- Headquarters
UPDATE COMPANY_DEPARTMENT SET Mgr_ssn = '444444401' WHERE Dnumber = 6;  -- Software
UPDATE COMPANY_DEPARTMENT SET Mgr_ssn = '444444404' WHERE Dnumber = 7;  -- Hardware
UPDATE COMPANY_DEPARTMENT SET Mgr_ssn = '444444405' WHERE Dnumber = 8;  -- Marketing
UPDATE COMPANY_DEPARTMENT SET Mgr_ssn = '444444407' WHERE Dnumber = 9;  -- Finance

-- Update employee supervisors
UPDATE EMPLOYEE SET Super_ssn = '888665555' WHERE Ssn = '333445555';  -- Wong reports to Borg
UPDATE EMPLOYEE SET Super_ssn = '888665555' WHERE Ssn = '987654321';  -- Wallace reports to Borg
UPDATE EMPLOYEE SET Super_ssn = '333445555' WHERE Ssn = '123456789';  -- Smith reports to Wong

-- Insert projects
INSERT INTO PROJECT (Pname, Pnumber, Plocation, Dnum) VALUES
('ProductX', 1, 'Bellaire', 5),
('ProductY', 2, 'Sugarland', 5),
('ProductZ', 3, 'Houston', 5),
('Computerization', 10, 'Stafford', 4),
('Reorganization', 20, 'Houston', 1),
('Newbenefits', 30, 'Stafford', 4),
('Software Development', 40, 'Houston', 6),
('Hardware Testing', 50, 'Dallas', 7),
('Mobile App', 60, 'Austin', 6),
('Network Security', 70, 'Houston', 7),
('Market Research', 80, 'Dallas', 8),
('Brand Campaign', 90, 'Austin', 8),
('Financial Analysis', 100, 'Houston', 9),
('Budget Planning', 110, 'Dallas', 9);

-- Insert work assignments
INSERT INTO WORKS_ON (Essn, Pno, Hours) VALUES
('123456789', 1, 32.5),
('123456789', 2, 7.5),
('666884444', 3, 40.0),
('453453453', 1, 20.0),
('453453453', 2, 20.0),
('333445555', 2, 10.0),
('333445555', 3, 10.0),
('333445555', 10, 10.0),
('333445555', 20, 10.0),
('999887777', 30, 30.0),
('999887777', 10, 10.0),
('987987987', 10, 35.0),
('987987987', 30, 5.0),
('987654321', 30, 20.0),
('987654321', 20, 15.0),
('888665555', 20, 16.0),
('444444401', 40, 40.0),
('444444402', 40, 20.0),
('444444402', 60, 20.0),
('444444403', 50, 40.0),
('444444404', 50, 30.0),
('444444404', 70, 10.0),
('444444405', 80, 35.0),
('444444405', 90, 15.0),
('444444406', 80, 25.0),
('444444406', 90, 25.0),
('444444407', 100, 40.0),
('444444407', 110, 20.0),
('444444408', 100, 30.0),
('444444408', 110, 30.0);

-- Insert dependents
INSERT INTO DEPENDENT (Essn, Dependent_name, Sex, Bdate, Relationship) VALUES
('333445555', 'Alice', 'F', '1986-04-05', 'Daughter'),
('333445555', 'Theodore', 'M', '1983-10-25', 'Son'),
('333445555', 'Joy', 'F', '1958-05-03', 'Spouse'),
('987654321', 'Abner', 'M', '1942-02-28', 'Spouse'),
('123456789', 'Michael', 'M', '1988-01-04', 'Son'),
('123456789', 'Alice', 'F', '1988-12-30', 'Daughter'),
('123456789', 'Elizabeth', 'F', '1967-05-05', 'Spouse'),
('444444401', 'Carlos', 'M', '1985-03-15', 'Son'),
('444444401', 'Sofia', 'F', '1960-08-20', 'Spouse'),
('444444403', 'Emma', 'F', '1995-07-12', 'Daughter'),
('444444405', 'Lucas', 'M', '1998-09-18', 'Son'),
('444444407', 'Isabella', 'F', '1992-04-22', 'Daughter'),
('444444407', 'Gabriel', 'M', '1989-11-10', 'Son');

-- Insert department locations
INSERT INTO DEPT_LOCATIONS (Dnumber, Dlocation) VALUES
(1, 'Houston'),
(4, 'Stafford'),
(5, 'Bellaire'),
(5, 'Sugarland'),
(5, 'Houston'),
(6, 'Houston'),
(6, 'Austin'),
(7, 'Dallas'),
(7, 'Houston'),
(8, 'Dallas'),
(8, 'Austin'),
(9, 'Houston'),
(9, 'Dallas');

-- ========================================
-- VERIFICATION QUERIES
-- ========================================

-- Show record counts
SELECT 'STUDENT-COURSE TABLES' AS Schema_Section, 'Count' AS Info;
SELECT 'Departments' AS Table_Name, COUNT(*) AS Record_Count FROM DEPARTMENT
UNION ALL
SELECT 'Students', COUNT(*) FROM STUDENT
UNION ALL
SELECT 'Courses', COUNT(*) FROM COURSE
UNION ALL
SELECT 'Prerequisites', COUNT(*) FROM PREREQUISITE
UNION ALL
SELECT 'Sections', COUNT(*) FROM SECTION
UNION ALL
SELECT 'Grade Reports', COUNT(*) FROM GRADE_REPORT;

SELECT 'COMPANY TABLES' AS Schema_Section, 'Count' AS Info;
SELECT 'Departments' AS Table_Name, COUNT(*) AS Record_Count FROM COMPANY_DEPARTMENT
UNION ALL
SELECT 'Employees', COUNT(*) FROM EMPLOYEE
UNION ALL
SELECT 'Projects', COUNT(*) FROM PROJECT
UNION ALL
SELECT 'Work Assignments', COUNT(*) FROM WORKS_ON
UNION ALL
SELECT 'Dependents', COUNT(*) FROM DEPENDENT
UNION ALL
SELECT 'Department Locations', COUNT(*) FROM DEPT_LOCATIONS;
