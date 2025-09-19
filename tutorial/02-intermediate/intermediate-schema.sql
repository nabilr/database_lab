-- Enhanced University Schema for Intermediate Tutorial
CREATE DATABASE IF NOT EXISTS university_intermediate;
USE university_intermediate;

-- Departments table
CREATE TABLE department (
  dept_id INT PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE
);

-- Instructors table
CREATE TABLE instructor (
  instructor_id INT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  dept_id INT NOT NULL,
  email VARCHAR(120) UNIQUE,
  FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);

-- Students table
CREATE TABLE student (
  student_id INT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  dept_id INT,
  year_level ENUM('Freshman','Sophomore','Junior','Senior') DEFAULT 'Freshman',
  FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);

-- Courses table
CREATE TABLE course (
  course_id INT PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  credits TINYINT NOT NULL,
  dept_id INT NOT NULL,
  FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);

-- Sections table
CREATE TABLE section (
  section_id INT PRIMARY KEY,
  course_id INT NOT NULL,
  instructor_id INT,
  term ENUM('Spring','Summer','Fall') NOT NULL,
  year_num YEAR NOT NULL,
  FOREIGN KEY (course_id) REFERENCES course(course_id),
  FOREIGN KEY (instructor_id) REFERENCES instructor(instructor_id)
);

-- Enrollment table
CREATE TABLE enrollment (
  student_id INT NOT NULL,
  section_id INT NOT NULL,
  enrolled_on DATE NOT NULL DEFAULT (CURRENT_DATE),
  PRIMARY KEY (student_id, section_id),
  FOREIGN KEY (student_id) REFERENCES student(student_id),
  FOREIGN KEY (section_id) REFERENCES section(section_id)
);

-- Quiz table
CREATE TABLE quiz (
  quiz_id INT PRIMARY KEY,
  section_id INT NOT NULL,
  author_id INT NOT NULL,
  title VARCHAR(200) NOT NULL,
  max_score DECIMAL(5,2) NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (section_id) REFERENCES section(section_id),
  FOREIGN KEY (author_id) REFERENCES instructor(instructor_id)
);

-- Quiz submission table
CREATE TABLE quiz_submission (
  quiz_id INT NOT NULL,
  student_id INT NOT NULL,
  submitted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  score DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (quiz_id, student_id),
  FOREIGN KEY (quiz_id) REFERENCES quiz(quiz_id),
  FOREIGN KEY (student_id) REFERENCES student(student_id)
);

-- Basic sample data (will be enhanced by intermediate-data.sql)
INSERT INTO department (dept_id, name) VALUES
  (1,'Computer Science'),
  (2,'Mathematics');

INSERT INTO instructor (instructor_id, name, dept_id, email) VALUES
  (101,'Alice Karim',1,'alice@univ.example'),
  (102,'Bob Mathew',2,'bob@univ.example');

INSERT INTO student (student_id, name, dept_id, year_level) VALUES
  (201,'Omar N.',1,'Freshman'),
  (202,'Lina K.',2,'Sophomore'),
  (203,'Nabil F.',1,'Junior');

INSERT INTO course (course_id, title, credits, dept_id) VALUES
  (100,'CS101: Intro to Programming',3,1),
  (200,'CS201: Data Structures',4,1),
  (300,'MATH101: Calculus I',3,2);
