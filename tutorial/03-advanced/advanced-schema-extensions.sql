-- Advanced schema extensions for performance analysis and complex queries
-- This file adds tables and data structures for advanced SQL tutorials

-- Academic years table for temporal analysis
CREATE TABLE academic_year (
  year_id INT PRIMARY KEY,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  is_current BOOLEAN DEFAULT FALSE
) ENGINE=InnoDB;

-- Grade scale table
CREATE TABLE grade_scale (
  grade_id INT PRIMARY KEY AUTO_INCREMENT,
  letter_grade CHAR(2) NOT NULL,
  min_percentage DECIMAL(5,2) NOT NULL,
  max_percentage DECIMAL(5,2) NOT NULL,
  quality_points DECIMAL(3,2) NOT NULL
) ENGINE=InnoDB;

-- Student grades table (more comprehensive than quiz submissions)
CREATE TABLE student_grade (
  grade_id INT PRIMARY KEY AUTO_INCREMENT,
  student_id INT NOT NULL,
  section_id INT NOT NULL,
  assignment_type ENUM('Quiz', 'Exam', 'Project', 'Homework') NOT NULL,
  assignment_name VARCHAR(200) NOT NULL,
  points_earned DECIMAL(5,2) NOT NULL,
  points_possible DECIMAL(5,2) NOT NULL,
  graded_date DATE NOT NULL,
  CONSTRAINT fk_grade_student
    FOREIGN KEY (student_id) REFERENCES student(student_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_grade_section
    FOREIGN KEY (section_id) REFERENCES section(section_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_grade_enrollment
    FOREIGN KEY (student_id, section_id) REFERENCES enrollment(student_id, section_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX idx_student_section (student_id, section_id),
  INDEX idx_graded_date (graded_date),
  INDEX idx_assignment_type (assignment_type)
) ENGINE=InnoDB;

-- Course evaluation table
CREATE TABLE course_evaluation (
  evaluation_id INT PRIMARY KEY AUTO_INCREMENT,
  student_id INT NOT NULL,
  section_id INT NOT NULL,
  instructor_rating TINYINT CHECK (instructor_rating BETWEEN 1 AND 5),
  course_difficulty TINYINT CHECK (course_difficulty BETWEEN 1 AND 5),
  course_usefulness TINYINT CHECK (course_usefulness BETWEEN 1 AND 5),
  would_recommend BOOLEAN,
  comments TEXT,
  submitted_date DATE NOT NULL,
  CONSTRAINT fk_eval_student
    FOREIGN KEY (student_id) REFERENCES student(student_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_eval_section
    FOREIGN KEY (section_id) REFERENCES section(section_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX idx_submitted_date (submitted_date),
  INDEX idx_ratings (instructor_rating, course_difficulty, course_usefulness)
) ENGINE=InnoDB;

-- Attendance tracking table
CREATE TABLE attendance (
  attendance_id INT PRIMARY KEY AUTO_INCREMENT,
  student_id INT NOT NULL,
  section_id INT NOT NULL,
  class_date DATE NOT NULL,
  status ENUM('Present', 'Absent', 'Late', 'Excused') NOT NULL,
  recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_attendance_student
    FOREIGN KEY (student_id) REFERENCES student(student_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_attendance_section
    FOREIGN KEY (section_id) REFERENCES section(section_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_attendance_enrollment
    FOREIGN KEY (student_id, section_id) REFERENCES enrollment(student_id, section_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  UNIQUE KEY uk_student_section_date (student_id, section_id, class_date),
  INDEX idx_class_date (class_date),
  INDEX idx_status (status)
) ENGINE=InnoDB;

-- Financial aid table
CREATE TABLE financial_aid (
  aid_id INT PRIMARY KEY AUTO_INCREMENT,
  student_id INT NOT NULL,
  aid_type ENUM('Scholarship', 'Grant', 'Loan', 'Work Study') NOT NULL,
  aid_name VARCHAR(200) NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  academic_year YEAR NOT NULL,
  awarded_date DATE NOT NULL,
  requirements TEXT,
  CONSTRAINT fk_aid_student
    FOREIGN KEY (student_id) REFERENCES student(student_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX idx_academic_year (academic_year),
  INDEX idx_aid_type (aid_type),
  INDEX idx_amount (amount)
) ENGINE=InnoDB;

-- Research projects table (for advanced students and faculty)
CREATE TABLE research_project (
  project_id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(300) NOT NULL,
  description TEXT,
  principal_investigator_id INT NOT NULL,
  dept_id INT NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE,
  budget DECIMAL(12,2),
  status ENUM('Planning', 'Active', 'Completed', 'Suspended') NOT NULL,
  CONSTRAINT fk_research_pi
    FOREIGN KEY (principal_investigator_id) REFERENCES instructor(instructor_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_research_dept
    FOREIGN KEY (dept_id) REFERENCES department(dept_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  INDEX idx_status (status),
  INDEX idx_start_date (start_date),
  FULLTEXT idx_title_desc (title, description)
) ENGINE=InnoDB;

-- Student research participation
CREATE TABLE student_research (
  student_id INT NOT NULL,
  project_id INT NOT NULL,
  role ENUM('Undergraduate Researcher', 'Graduate Assistant', 'Volunteer') NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE,
  hours_per_week TINYINT,
  PRIMARY KEY (student_id, project_id),
  CONSTRAINT fk_student_research_student
    FOREIGN KEY (student_id) REFERENCES student(student_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_student_research_project
    FOREIGN KEY (project_id) REFERENCES research_project(project_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX idx_role (role),
  INDEX idx_dates (start_date, end_date)
) ENGINE=InnoDB;

-- Waitlist table for course registration
CREATE TABLE waitlist (
  waitlist_id INT PRIMARY KEY AUTO_INCREMENT,
  student_id INT NOT NULL,
  section_id INT NOT NULL,
  position INT NOT NULL,
  added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status ENUM('Active', 'Enrolled', 'Dropped') DEFAULT 'Active',
  CONSTRAINT fk_waitlist_student
    FOREIGN KEY (student_id) REFERENCES student(student_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_waitlist_section
    FOREIGN KEY (section_id) REFERENCES section(section_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  UNIQUE KEY uk_student_section_waitlist (student_id, section_id),
  INDEX idx_section_position (section_id, position),
  INDEX idx_added_date (added_date)
) ENGINE=InnoDB;

-- Insert sample data for advanced scenarios
INSERT INTO academic_year (year_id, start_date, end_date, is_current) VALUES
  (2024, '2024-08-15', '2025-05-15', FALSE),
  (2025, '2025-08-15', '2026-05-15', TRUE),
  (2026, '2026-08-15', '2027-05-15', FALSE);

INSERT INTO grade_scale (letter_grade, min_percentage, max_percentage, quality_points) VALUES
  ('A+', 97.00, 100.00, 4.00),
  ('A', 93.00, 96.99, 4.00),
  ('A-', 90.00, 92.99, 3.70),
  ('B+', 87.00, 89.99, 3.30),
  ('B', 83.00, 86.99, 3.00),
  ('B-', 80.00, 82.99, 2.70),
  ('C+', 77.00, 79.99, 2.30),
  ('C', 73.00, 76.99, 2.00),
  ('C-', 70.00, 72.99, 1.70),
  ('D', 60.00, 69.99, 1.00),
  ('F', 0.00, 59.99, 0.00);
