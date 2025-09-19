-- Basic University Schema for Beginner Tutorial
CREATE DATABASE IF NOT EXISTS university_basic;
USE university_basic;

-- Simple departments table
CREATE TABLE department (
  dept_id INT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

-- Simple students table
CREATE TABLE student (
  student_id INT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  dept_id INT,
  year_level VARCHAR(20),
  FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);

-- Simple courses table
CREATE TABLE course (
  course_id INT PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  credits INT NOT NULL,
  dept_id INT NOT NULL,
  FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);

-- Simple instructors table
CREATE TABLE instructor (
  instructor_id INT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  dept_id INT NOT NULL,
  FOREIGN KEY (dept_id) REFERENCES department(dept_id)
);

-- Sample data
INSERT INTO department (dept_id, name) VALUES
  (1, 'Computer Science'),
  (2, 'Mathematics');

INSERT INTO student (student_id, name, dept_id, year_level) VALUES
  (1, 'Alice Johnson', 1, 'Freshman'),
  (2, 'Bob Smith', 2, 'Sophomore'),
  (3, 'Carol Davis', 1, 'Junior');

INSERT INTO course (course_id, title, credits, dept_id) VALUES
  (101, 'Intro to Programming', 3, 1),
  (102, 'Calculus I', 4, 2),
  (201, 'Data Structures', 3, 1);

INSERT INTO instructor (instructor_id, name, dept_id) VALUES
  (1, 'Dr. Smith', 1),
  (2, 'Prof. Johnson', 2);
