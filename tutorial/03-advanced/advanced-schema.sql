-- Complete University Schema for Advanced Tutorial
CREATE DATABASE IF NOT EXISTS university_advanced;
USE university_advanced;

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
  CONSTRAINT fk_instr_dept
    FOREIGN KEY (dept_id) REFERENCES department(dept_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Students table
CREATE TABLE student (
  student_id INT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  dept_id INT,
  year_level ENUM('Freshman','Sophomore','Junior','Senior') DEFAULT 'Freshman',
  CONSTRAINT fk_student_dept
    FOREIGN KEY (dept_id) REFERENCES department(dept_id)
    ON DELETE SET NULL ON UPDATE CASCADE
);

-- Courses table
CREATE TABLE course (
  course_id INT PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  credits TINYINT NOT NULL CHECK (credits BETWEEN 1 AND 6),
  dept_id INT NOT NULL,
  CONSTRAINT fk_course_dept
    FOREIGN KEY (dept_id) REFERENCES department(dept_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Course prerequisites
CREATE TABLE prerequisite (
  course_id INT NOT NULL,
  prereq_id INT NOT NULL,
  PRIMARY KEY (course_id, prereq_id),
  CONSTRAINT fk_pr_course
    FOREIGN KEY (course_id) REFERENCES course(course_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_pr_req
    FOREIGN KEY (prereq_id) REFERENCES course(course_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Rooms table
CREATE TABLE room (
  room_id VARCHAR(20) PRIMARY KEY,
  building VARCHAR(100) NOT NULL
);

-- Sections table
CREATE TABLE section (
  section_id INT PRIMARY KEY,
  course_id INT NOT NULL,
  instructor_id INT,
  room_id VARCHAR(20),
  term ENUM('Spring','Summer','Fall') NOT NULL,
  year_num YEAR NOT NULL,
  CONSTRAINT fk_sec_course
    FOREIGN KEY (course_id) REFERENCES course(course_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_sec_instructor
    FOREIGN KEY (instructor_id) REFERENCES instructor(instructor_id)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_sec_room
    FOREIGN KEY (room_id) REFERENCES room(room_id)
    ON DELETE SET NULL ON UPDATE CASCADE
);

-- Enrollment table
CREATE TABLE enrollment (
  student_id INT NOT NULL,
  section_id INT NOT NULL,
  enrolled_on DATE NOT NULL DEFAULT (CURRENT_DATE),
  PRIMARY KEY (student_id, section_id),
  CONSTRAINT fk_enr_student
    FOREIGN KEY (student_id) REFERENCES student(student_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_enr_section
    FOREIGN KEY (section_id) REFERENCES section(section_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- Quiz table
CREATE TABLE quiz (
  quiz_id INT PRIMARY KEY,
  section_id INT NOT NULL,
  author_id INT NOT NULL,
  title VARCHAR(200) NOT NULL,
  max_score DECIMAL(5,2) NOT NULL CHECK (max_score > 0),
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_quiz_section
    FOREIGN KEY (section_id) REFERENCES section(section_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_quiz_author
    FOREIGN KEY (author_id) REFERENCES instructor(instructor_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  UNIQUE KEY uq_quiz_section (quiz_id, section_id)
);

-- Quiz submission table
CREATE TABLE quiz_submission (
  quiz_id INT NOT NULL,
  section_id INT NOT NULL,
  student_id INT NOT NULL,
  submitted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  score DECIMAL(5,2) NOT NULL CHECK (score >= 0),
  PRIMARY KEY (quiz_id, student_id),
  CONSTRAINT fk_qs_quiz
    FOREIGN KEY (quiz_id) REFERENCES quiz(quiz_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_qs_section
    FOREIGN KEY (section_id) REFERENCES section(section_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_qs_enrollment
    FOREIGN KEY (student_id, section_id) REFERENCES enrollment(student_id, section_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_qs_quiz_section_pair
    FOREIGN KEY (quiz_id, section_id) REFERENCES quiz(quiz_id, section_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- Sample data for advanced tutorial
INSERT INTO department (dept_id, name) VALUES
  (1,'Computer Science'),
  (2,'Mathematics'),
  (3,'Physics'),
  (4,'Biology');

INSERT INTO instructor (instructor_id, name, dept_id, email) VALUES
  (101,'Alice Karim',1,'alice@univ.example'),
  (102,'Bob Mathew',2,'bob@univ.example'),
  (103,'Carol Wilson',3,'carol@univ.example'),
  (104,'David Brown',4,'david@univ.example');

INSERT INTO student (student_id, name, dept_id, year_level) VALUES
  (201,'Omar N.',1,'Freshman'),
  (202,'Lina K.',2,'Sophomore'),
  (203,'Nabil F.',1,'Junior'),
  (204,'Sarah M.',3,'Senior'),
  (205,'Ahmed H.',4,'Freshman');

INSERT INTO course (course_id, title, credits, dept_id) VALUES
  (100,'CS101: Intro to Programming',3,1),
  (200,'CS201: Data Structures',4,1),
  (300,'MATH101: Calculus I',3,2),
  (400,'PHYS101: General Physics',4,3),
  (500,'BIO101: Biology Basics',3,4);

INSERT INTO room (room_id, building) VALUES
  ('R1','Main Hall'),
  ('R2','Science Block'),
  ('R3','Computer Lab'),
  ('R4','Physics Lab');

INSERT INTO section (section_id, course_id, instructor_id, room_id, term, year_num) VALUES
  (1001,100,101,'R1','Fall',2025),
  (1002,200,101,'R3','Fall',2025),
  (1003,300,102,'R2','Fall',2025),
  (1004,400,103,'R4','Fall',2025),
  (1005,500,104,'R2','Fall',2025);
