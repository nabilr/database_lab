-- Additional data for intermediate tutorial
-- This adds more complexity to practice GROUP BY, subqueries, and UNION operations

-- Add more departments
INSERT INTO department (dept_id, name) VALUES
  (3, 'Physics'),
  (4, 'Biology'),
  (5, 'Chemistry');

-- Add more instructors
INSERT INTO instructor (instructor_id, name, dept_id, email) VALUES
  (103, 'Dr. Sarah Chen', 3, 'sarah.chen@univ.example'),
  (104, 'Prof. Michael Rodriguez', 4, 'michael.r@univ.example'),
  (105, 'Dr. Emma Thompson', 5, 'emma.t@univ.example'),
  (106, 'Prof. David Kim', 1, 'david.kim@univ.example'),
  (107, 'Dr. Lisa Johnson', 2, 'lisa.j@univ.example');

-- Add more students
INSERT INTO student (student_id, name, dept_id, year_level) VALUES
  (204, 'Ahmed Al-Mansouri', 3, 'Sophomore'),
  (205, 'Maria Santos', 4, 'Junior'),
  (206, 'James Wilson', 5, 'Senior'),
  (207, 'Priya Patel', 1, 'Freshman'),
  (208, 'Carlos Martinez', 2, 'Sophomore'),
  (209, 'Sophie Laurent', 3, 'Junior'),
  (210, 'Hassan Ibrahim', 4, 'Senior'),
  (211, 'Anna Kowalski', 5, 'Freshman'),
  (212, 'Raj Sharma', 1, 'Sophomore'),
  (213, 'Elena Popov', 2, 'Junior');

-- Add more courses
INSERT INTO course (course_id, title, credits, dept_id) VALUES
  (400, 'PHYS101: General Physics I', 4, 3),
  (401, 'PHYS201: General Physics II', 4, 3),
  (500, 'BIO101: Introduction to Biology', 3, 4),
  (501, 'BIO201: Molecular Biology', 4, 4),
  (600, 'CHEM101: General Chemistry I', 3, 5),
  (601, 'CHEM201: Organic Chemistry', 4, 5),
  (101, 'CS102: Programming Fundamentals', 3, 1),
  (301, 'MATH201: Calculus II', 4, 2),
  (302, 'MATH301: Linear Algebra', 3, 2);

-- Add prerequisites
INSERT INTO prerequisite (course_id, prereq_id) VALUES
  (401, 400),  -- Physics II requires Physics I
  (501, 500),  -- Molecular Biology requires Intro Biology
  (601, 600),  -- Organic Chemistry requires General Chemistry
  (101, 100),  -- Programming Fundamentals requires Intro to Programming
  (301, 300);  -- Calculus II requires Calculus I

-- Add more rooms
INSERT INTO room (room_id, building) VALUES
  ('R3', 'Physics Building'),
  ('R4', 'Biology Lab'),
  ('R5', 'Chemistry Lab'),
  ('R6', 'Computer Lab'),
  ('R7', 'Mathematics Building');

-- Add more sections for Spring 2025
INSERT INTO section (section_id, course_id, instructor_id, room_id, term, year_num) VALUES
  -- Spring 2025 sections
  (2001, 400, 103, 'R3', 'Spring', 2025),
  (2002, 500, 104, 'R4', 'Spring', 2025),
  (2003, 600, 105, 'R5', 'Spring', 2025),
  (2004, 101, 106, 'R6', 'Spring', 2025),
  (2005, 301, 107, 'R7', 'Spring', 2025),
  -- Fall 2025 additional sections
  (1004, 400, 103, 'R3', 'Fall', 2025),
  (1005, 500, 104, 'R4', 'Fall', 2025),
  (1006, 600, 105, 'R5', 'Fall', 2025);

-- Add more enrollments
INSERT INTO enrollment (student_id, section_id, enrolled_on) VALUES
  -- Spring 2025 enrollments
  (204, 2001, '2025-01-15'),
  (205, 2002, '2025-01-15'),
  (206, 2003, '2025-01-15'),
  (207, 2004, '2025-01-16'),
  (208, 2005, '2025-01-16'),
  (209, 2001, '2025-01-17'),
  (210, 2002, '2025-01-17'),
  (211, 2003, '2025-01-18'),
  (212, 2004, '2025-01-18'),
  (213, 2005, '2025-01-19'),
  -- Fall 2025 additional enrollments
  (204, 1004, '2025-09-05'),
  (205, 1005, '2025-09-05'),
  (206, 1006, '2025-09-06'),
  (208, 1001, '2025-09-06'),
  (209, 1004, '2025-09-07'),
  (210, 1005, '2025-09-07');

-- Add more quizzes
INSERT INTO quiz (quiz_id, section_id, author_id, title, max_score) VALUES
  (5003, 2001, 103, 'Mechanics Quiz', 15.0),
  (5004, 2002, 104, 'Cell Biology Quiz', 12.0),
  (5005, 2003, 105, 'Chemical Bonds Quiz', 18.0),
  (5006, 2004, 106, 'Basic Programming Quiz', 20.0),
  (5007, 2005, 107, 'Derivatives Quiz', 25.0),
  (5008, 1004, 103, 'Force and Motion', 15.0),
  (5009, 1005, 104, 'Genetics Basics', 10.0);

-- Add more quiz submissions
INSERT INTO quiz_submission (quiz_id, section_id, student_id, submitted_at, score) VALUES
  (5003, 2001, 204, '2025-02-15 10:00:00', 13.5),
  (5003, 2001, 209, '2025-02-15 10:05:00', 12.0),
  (5004, 2002, 205, '2025-02-16 11:00:00', 10.5),
  (5004, 2002, 210, '2025-02-16 11:10:00', 11.0),
  (5005, 2003, 206, '2025-02-17 14:00:00', 16.0),
  (5005, 2003, 211, '2025-02-17 14:15:00', 15.5),
  (5006, 2004, 207, '2025-02-18 09:00:00', 18.0),
  (5006, 2004, 212, '2025-02-18 09:20:00', 17.5),
  (5007, 2005, 208, '2025-02-19 13:00:00', 22.0),
  (5007, 2005, 213, '2025-02-19 13:30:00', 20.5),
  (5008, 1004, 204, '2025-10-15 10:00:00', 14.0),
  (5008, 1004, 209, '2025-10-15 10:30:00', 13.0),
  (5009, 1005, 205, '2025-10-16 11:00:00', 9.0),
  (5009, 1005, 210, '2025-10-16 11:45:00', 8.5);
