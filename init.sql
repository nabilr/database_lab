-- Create DB explicitly (mysql:8 also creates from $MYSQL_DATABASE)
CREATE DATABASE IF NOT EXISTS university CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE university;

-- Departments
CREATE TABLE department (
  dept_id     INT PRIMARY KEY,
  name        VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- Instructors
CREATE TABLE instructor (
  instructor_id INT PRIMARY KEY,
  name          VARCHAR(100) NOT NULL,
  dept_id       INT NOT NULL,
  email         VARCHAR(120) UNIQUE,
  CONSTRAINT fk_instr_dept
    FOREIGN KEY (dept_id) REFERENCES department(dept_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Students
CREATE TABLE student (
  student_id INT PRIMARY KEY,
  name       VARCHAR(100) NOT NULL,
  dept_id    INT,
  year_level ENUM('Freshman','Sophomore','Junior','Senior') DEFAULT 'Freshman',
  CONSTRAINT fk_student_dept
    FOREIGN KEY (dept_id) REFERENCES department(dept_id)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Courses
CREATE TABLE course (
  course_id  INT PRIMARY KEY,
  title      VARCHAR(200) NOT NULL,
  credits    TINYINT NOT NULL CHECK (credits BETWEEN 1 AND 6),
  dept_id    INT NOT NULL,
  CONSTRAINT fk_course_dept
    FOREIGN KEY (dept_id) REFERENCES department(dept_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Course prerequisites (self-referencing & composite key)
CREATE TABLE prerequisite (
  course_id  INT NOT NULL,
  prereq_id  INT NOT NULL,
  PRIMARY KEY (course_id, prereq_id),
  CONSTRAINT fk_pr_course
    FOREIGN KEY (course_id) REFERENCES course(course_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_pr_req
    FOREIGN KEY (prereq_id) REFERENCES course(course_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Rooms
CREATE TABLE room (
  room_id   VARCHAR(20) PRIMARY KEY,
  building  VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

-- Sections (specific offerings of a course)
CREATE TABLE section (
  section_id    INT PRIMARY KEY,
  course_id     INT NOT NULL,
  instructor_id INT,
  room_id       VARCHAR(20),
  term          ENUM('Spring','Summer','Fall') NOT NULL,
  year_num      YEAR NOT NULL,
  CONSTRAINT fk_sec_course
    FOREIGN KEY (course_id) REFERENCES course(course_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_sec_instructor
    FOREIGN KEY (instructor_id) REFERENCES instructor(instructor_id)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_sec_room
    FOREIGN KEY (room_id) REFERENCES room(room_id)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Enrollment (composite PK + FKs)
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
) ENGINE=InnoDB;

-- Quizzes (authored by instructor, attached to a section)
CREATE TABLE quiz (
  quiz_id      INT PRIMARY KEY,
  section_id   INT NOT NULL,
  author_id    INT NOT NULL,
  title        VARCHAR(200) NOT NULL,
  max_score    DECIMAL(5,2) NOT NULL CHECK (max_score > 0),
  created_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_quiz_section
    FOREIGN KEY (section_id) REFERENCES section(section_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_quiz_author
    FOREIGN KEY (author_id) REFERENCES instructor(instructor_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  UNIQUE KEY uq_quiz_section (quiz_id, section_id) -- to demonstrate a composite ref later
) ENGINE=InnoDB;

-- Quiz submissions:
-- Showcase multiple FKs, including a composite FK back to ENROLLMENT
CREATE TABLE quiz_submission (
  quiz_id     INT NOT NULL,
  section_id  INT NOT NULL,
  student_id  INT NOT NULL,
  submitted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  score       DECIMAL(5,2) NOT NULL CHECK (score >= 0),
  PRIMARY KEY (quiz_id, student_id),                        -- each student submits once per quiz
  CONSTRAINT fk_qs_quiz
    FOREIGN KEY (quiz_id) REFERENCES quiz(quiz_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_qs_section
    FOREIGN KEY (section_id) REFERENCES section(section_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  -- Enforce that the submitting student is actually enrolled in the section:
  CONSTRAINT fk_qs_enrollment
    FOREIGN KEY (student_id, section_id) REFERENCES enrollment(student_id, section_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  -- Optional: couple (quiz_id, section_id) relationship
  CONSTRAINT fk_qs_quiz_section_pair
    FOREIGN KEY (quiz_id, section_id) REFERENCES quiz(quiz_id, section_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- Seed data (small but rich enough for join practice)
-- ---------------------------------------------------------
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

-- CS201 requires CS101
INSERT INTO prerequisite (course_id, prereq_id) VALUES
  (200,100);

INSERT INTO room (room_id, building) VALUES
  ('R1','Main Hall'),
  ('R2','Science Block');

-- Sections (Fall 2025)
INSERT INTO section (section_id, course_id, instructor_id, room_id, term, year_num) VALUES
  (1001,100,101,'R1','Fall',2025),
  (1002,200,101,'R1','Fall',2025),
  (1003,300,102,'R2','Fall',2025);

-- Enrollments
INSERT INTO enrollment (student_id, section_id, enrolled_on) VALUES
  (201,1001,'2025-09-01'),
  (203,1001,'2025-09-02'),
  (201,1002,'2025-09-03'),   -- Omar goes to Data Structures too
  (202,1003,'2025-09-01');   -- Lina in Calculus

-- Quizzes
INSERT INTO quiz (quiz_id, section_id, author_id, title, max_score) VALUES
  (5001,1001,101,'Intro Quiz',10.0),
  (5002,1003,102,'Limits & Derivatives',20.0);

-- Quiz submissions (notice composite FK to enrollment)
INSERT INTO quiz_submission (quiz_id, section_id, student_id, submitted_at, score) VALUES
  (5001,1001,201,'2025-09-10 09:00:00',8.0),
  (5001,1001,203,'2025-09-10 09:05:00',9.5),
  (5002,1003,202,'2025-09-11 10:00:00',18.0);