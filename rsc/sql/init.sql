-- =========================================================
-- UNIVERSITY DATABASE - FULL INIT.SQL
-- PostgreSQL practice dataset
-- =========================================================

-- =========================================================
-- RESET
-- =========================================================
DROP TABLE IF EXISTS grades CASCADE;
DROP TABLE IF EXISTS assignments CASCADE;
DROP TABLE IF EXISTS enrollments CASCADE;
DROP TABLE IF EXISTS course_offerings CASCADE;
DROP TABLE IF EXISTS courses CASCADE;
DROP TABLE IF EXISTS instructors CASCADE;
DROP TABLE IF EXISTS students CASCADE;
DROP TABLE IF EXISTS departments CASCADE;

-- =========================================================
-- TABLES
-- =========================================================

CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    building VARCHAR(100),
    budget NUMERIC(12,2) NOT NULL CHECK (budget >= 0)
);

CREATE TABLE instructors (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(120) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    hire_date DATE NOT NULL,
    department_id INT NOT NULL REFERENCES departments(id),
    salary NUMERIC(10,2) NOT NULL CHECK (salary > 0)
);

CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    student_number VARCHAR(20) NOT NULL UNIQUE,
    full_name VARCHAR(120) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    birth_date DATE,
    enrolled_at DATE NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('active', 'inactive', 'graduated', 'suspended')),
    department_id INT REFERENCES departments(id)
);

CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE,
    title VARCHAR(120) NOT NULL,
    credits INT NOT NULL CHECK (credits BETWEEN 1 AND 30),
    department_id INT NOT NULL REFERENCES departments(id)
);

CREATE TABLE course_offerings (
    id SERIAL PRIMARY KEY,
    course_id INT NOT NULL REFERENCES courses(id),
    instructor_id INT NOT NULL REFERENCES instructors(id),
    semester VARCHAR(20) NOT NULL,
    year INT NOT NULL CHECK (year BETWEEN 2020 AND 2035),
    room VARCHAR(30),
    capacity INT NOT NULL CHECK (capacity > 0),
    schedule VARCHAR(100),
    UNIQUE (course_id, instructor_id, semester, year)
);

CREATE TABLE enrollments (
    id SERIAL PRIMARY KEY,
    student_id INT NOT NULL REFERENCES students(id),
    offering_id INT NOT NULL REFERENCES course_offerings(id),
    enrolled_on DATE NOT NULL,
    final_status VARCHAR(20) NOT NULL CHECK (final_status IN ('enrolled', 'passed', 'failed', 'withdrawn')),
    UNIQUE (student_id, offering_id)
);

CREATE TABLE assignments (
    id SERIAL PRIMARY KEY,
    offering_id INT NOT NULL REFERENCES course_offerings(id),
    title VARCHAR(120) NOT NULL,
    weight NUMERIC(5,2) NOT NULL CHECK (weight > 0 AND weight <= 100),
    due_date DATE NOT NULL
);

CREATE TABLE grades (
    id SERIAL PRIMARY KEY,
    assignment_id INT NOT NULL REFERENCES assignments(id),
    student_id INT NOT NULL REFERENCES students(id),
    grade NUMERIC(5,2) NOT NULL CHECK (grade BETWEEN 0 AND 20),
    submitted_at TIMESTAMP,
    UNIQUE (assignment_id, student_id)
);

-- =========================================================
-- DATA: departments
-- =========================================================

INSERT INTO departments (name, building, budget) VALUES
('Computer Science', 'Engineering Building', 250000.00),
('Data Science', 'Innovation Center', 180000.00),
('Mathematics', 'Science Hall', 150000.00),
('Business', 'Main Building', 220000.00),
('Digital Media', 'Arts Block', 130000.00);

-- =========================================================
-- DATA: instructors
-- =========================================================

INSERT INTO instructors (full_name, email, hire_date, department_id, salary) VALUES
('Dr. Ana Martins', 'ana.martins@university.edu', '2018-09-01', 1, 3200.00),
('Dr. Pedro Almeida', 'pedro.almeida@university.edu', '2017-02-15', 1, 3500.00),
('Dr. Sofia Carvalho', 'sofia.carvalho@university.edu', '2019-01-10', 2, 3100.00),
('Dr. Miguel Santos', 'miguel.santos@university.edu', '2016-06-20', 3, 3400.00),
('Dr. Rita Fernandes', 'rita.fernandes@university.edu', '2020-03-12', 4, 3000.00),
('Dr. Tiago Lopes', 'tiago.lopes@university.edu', '2021-09-01', 5, 2900.00),
('Dr. Beatriz Costa', 'beatriz.costa@university.edu', '2015-11-05', 2, 3600.00),
('Dr. João Ribeiro', 'joao.ribeiro@university.edu', '2014-04-18', 3, 3700.00);

-- =========================================================
-- DATA: students
-- =========================================================

INSERT INTO students (student_number, full_name, email, birth_date, enrolled_at, status, department_id) VALUES
('S2024001', 'Alice Johnson', 'alice.johnson@student.edu', '2002-05-14', '2024-09-10', 'active', 1),
('S2024002', 'Bruno Silva', 'bruno.silva@student.edu', '2001-11-03', '2024-09-10', 'active', 2),
('S2024003', 'Carla Mendes', 'carla.mendes@student.edu', '2003-01-22', '2024-09-10', 'active', 2),
('S2024004', 'David Pereira', 'david.pereira@student.edu', '2000-08-17', '2023-09-12', 'active', 1),
('S2024005', 'Eva Costa', 'eva.costa@student.edu', '2002-04-29', '2023-09-12', 'active', 3),
('S2024006', 'Filipe Rocha', 'filipe.rocha@student.edu', '2001-06-10', '2022-09-15', 'graduated', 4),
('S2024007', 'Gabriela Sousa', 'gabriela.sousa@student.edu', '2003-03-19', '2024-09-10', 'active', 5),
('S2024008', 'Hugo Ferreira', 'hugo.ferreira@student.edu', '2002-12-07', '2023-09-12', 'inactive', 1),
('S2024009', 'Ines Oliveira', 'ines.oliveira@student.edu', '2001-10-11', '2022-09-15', 'active', 3),
('S2024010', 'Joao Cardoso', 'joao.cardoso@student.edu', '2000-02-25', '2021-09-20', 'suspended', 4),
('S2024011', 'Larissa Gomes', 'larissa.gomes@student.edu', '2002-07-30', '2024-09-10', 'active', 2),
('S2024012', 'Marco Teixeira', 'marco.teixeira@student.edu', '2001-09-01', '2023-09-12', 'active', 1);

-- =========================================================
-- DATA: courses
-- =========================================================

INSERT INTO courses (code, title, credits, department_id) VALUES
('CS101', 'Programming Fundamentals', 6, 1),
('CS102', 'Database Systems', 6, 1),
('CS201', 'Data Structures and Algorithms', 6, 1),
('DS101', 'Introduction to Data Science', 6, 2),
('DS202', 'Machine Learning Basics', 6, 2),
('MA101', 'Calculus I', 5, 3),
('MA201', 'Statistics', 5, 3),
('BU101', 'Principles of Management', 5, 4),
('BU202', 'Business Analytics', 6, 4),
('DM101', 'Digital Design', 5, 5);

-- =========================================================
-- DATA: course_offerings
-- =========================================================

INSERT INTO course_offerings (course_id, instructor_id, semester, year, room, capacity, schedule) VALUES
(1, 1, 'Fall',   2025, 'E201', 40, 'Mon/Wed 10:00-11:30'),
(2, 2, 'Fall',   2025, 'E305', 35, 'Tue/Thu 14:00-15:30'),
(3, 1, 'Spring', 2026, 'E210', 30, 'Mon/Wed 08:30-10:00'),
(4, 3, 'Fall',   2025, 'I110', 45, 'Tue/Thu 09:00-10:30'),
(5, 7, 'Spring', 2026, 'I205', 30, 'Fri 10:00-13:00'),
(6, 4, 'Fall',   2025, 'S101', 50, 'Mon/Wed/Fri 09:00-10:00'),
(7, 8, 'Fall',   2025, 'S202', 40, 'Tue/Thu 11:00-12:30'),
(8, 5, 'Fall',   2025, 'M104', 60, 'Wed 18:00-21:00'),
(9, 5, 'Spring', 2026, 'M204', 35, 'Tue 18:00-21:00'),
(10, 6, 'Fall',  2025, 'A010', 25, 'Fri 14:00-17:00');

-- =========================================================
-- DATA: enrollments
-- =========================================================

INSERT INTO enrollments (student_id, offering_id, enrolled_on, final_status) VALUES
(1, 1, '2025-09-15', 'enrolled'),
(1, 2, '2025-09-15', 'enrolled'),
(1, 4, '2025-09-16', 'enrolled'),

(2, 4, '2025-09-15', 'enrolled'),
(2, 7, '2025-09-17', 'enrolled'),
(2, 8, '2025-09-18', 'enrolled'),

(3, 4, '2025-09-15', 'enrolled'),
(3, 6, '2025-09-17', 'enrolled'),
(3, 10, '2025-09-18', 'enrolled'),

(4, 1, '2025-09-15', 'enrolled'),
(4, 2, '2025-09-16', 'enrolled'),
(4, 6, '2025-09-16', 'enrolled'),

(5, 6, '2025-09-15', 'enrolled'),
(5, 7, '2025-09-16', 'enrolled'),

(6, 8, '2025-09-15', 'passed'),
(6, 9, '2026-02-10', 'passed'),

(7, 10, '2025-09-15', 'enrolled'),
(7, 8, '2025-09-16', 'withdrawn'),

(8, 1, '2025-09-15', 'failed'),
(8, 2, '2025-09-16', 'withdrawn'),

(9, 6, '2025-09-15', 'passed'),
(9, 7, '2025-09-16', 'enrolled'),

(10, 8, '2025-09-15', 'withdrawn'),

(11, 4, '2025-09-15', 'enrolled'),
(11, 7, '2025-09-16', 'enrolled'),
(11, 2, '2025-09-17', 'enrolled'),

(12, 1, '2025-09-15', 'enrolled'),
(12, 3, '2026-02-10', 'enrolled');

-- =========================================================
-- DATA: assignments
-- =========================================================

INSERT INTO assignments (offering_id, title, weight, due_date) VALUES
-- offering 1 / CS101
(1, 'Quiz 1', 10, '2025-10-01'),
(1, 'Project', 40, '2025-11-15'),
(1, 'Final Exam', 50, '2025-12-10'),

-- offering 2 / CS102
(2, 'Lab 1', 15, '2025-10-05'),
(2, 'SQL Project', 35, '2025-11-20'),
(2, 'Final Exam', 50, '2025-12-12'),

-- offering 3 / CS201
(3, 'Algorithm Worksheet', 20, '2026-03-05'),
(3, 'Implementation Project', 30, '2026-04-10'),
(3, 'Final Exam', 50, '2026-05-20'),

-- offering 4 / DS101
(4, 'Notebook Assignment', 20, '2025-10-10'),
(4, 'Data Analysis Report', 30, '2025-11-18'),
(4, 'Final Exam', 50, '2025-12-11'),

-- offering 5 / DS202
(5, 'Modeling Exercise', 20, '2026-03-08'),
(5, 'ML Mini Project', 30, '2026-04-18'),
(5, 'Final Exam', 50, '2026-05-25'),

-- offering 6 / MA101
(6, 'Problem Set 1', 20, '2025-10-03'),
(6, 'Problem Set 2', 20, '2025-11-01'),
(6, 'Final Exam', 60, '2025-12-15'),

-- offering 7 / MA201
(7, 'Statistics Quiz', 25, '2025-10-15'),
(7, 'Mini Project', 25, '2025-11-10'),
(7, 'Final Exam', 50, '2025-12-16'),

-- offering 8 / BU101
(8, 'Case Study', 40, '2025-11-05'),
(8, 'Presentation', 20, '2025-11-19'),
(8, 'Final Exam', 40, '2025-12-18'),

-- offering 9 / BU202
(9, 'Dashboard Project', 40, '2026-03-25'),
(9, 'Business Report', 20, '2026-04-20'),
(9, 'Final Exam', 40, '2026-05-28'),

-- offering 10 / DM101
(10, 'Portfolio', 50, '2025-11-25'),
(10, 'Final Project', 50, '2025-12-20');

-- =========================================================
-- DATA: grades
-- =========================================================

INSERT INTO grades (assignment_id, student_id, grade, submitted_at) VALUES
-- offering 1 / CS101 / assignments 1,2,3
(1, 1, 17.5, '2025-10-01 10:15:00'),
(2, 1, 18.0, '2025-11-15 23:10:00'),
(3, 1, 16.0, '2025-12-10 12:00:00'),

(1, 4, 14.0, '2025-10-01 10:20:00'),
(2, 4, 15.5, '2025-11-15 21:30:00'),
(3, 4, 13.0, '2025-12-10 12:00:00'),

(1, 8, 8.0, '2025-10-01 10:22:00'),
(2, 8, 7.5, '2025-11-15 20:10:00'),
(3, 8, 6.0, '2025-12-10 12:00:00'),

(1, 12, 16.5, '2025-10-01 10:40:00'),
(2, 12, 17.0, '2025-11-15 22:00:00'),
(3, 12, 15.5, '2025-12-10 12:00:00'),

-- offering 2 / CS102 / assignments 4,5,6
(4, 1, 18.0, '2025-10-05 16:10:00'),
(5, 1, 19.0, '2025-11-20 23:00:00'),
(6, 1, 17.5, '2025-12-12 14:00:00'),

(4, 4, 13.0, '2025-10-05 16:20:00'),
(5, 4, 14.5, '2025-11-20 22:40:00'),
(6, 4, 12.0, '2025-12-12 14:00:00'),

(4, 11, 16.0, '2025-10-05 16:05:00'),
(5, 11, 17.0, '2025-11-20 22:55:00'),
(6, 11, 15.0, '2025-12-12 14:00:00'),

-- offering 3 / CS201 / assignments 7,8,9
(7, 12, 15.0, '2026-03-05 11:00:00'),
(8, 12, 16.5, '2026-04-10 23:10:00'),
(9, 12, 14.0, '2026-05-20 10:00:00'),

-- offering 4 / DS101 / assignments 10,11,12
(10, 1, 17.0, '2025-10-10 20:00:00'),
(11, 1, 18.0, '2025-11-18 22:00:00'),
(12, 1, 16.0, '2025-12-11 11:30:00'),

(10, 2, 15.0, '2025-10-10 19:00:00'),
(11, 2, 14.0, '2025-11-18 21:45:00'),
(12, 2, 13.5, '2025-12-11 11:30:00'),

(10, 3, 16.5, '2025-10-10 18:50:00'),
(11, 3, 17.5, '2025-11-18 21:20:00'),
(12, 3, 16.0, '2025-12-11 11:30:00'),

(10, 11, 19.0, '2025-10-10 19:10:00'),
(11, 11, 18.5, '2025-11-18 20:50:00'),
(12, 11, 18.0, '2025-12-11 11:30:00'),

-- offering 5 / DS202
-- no grades because there are no enrollments in offering 5

-- offering 6 / MA101 / assignments 16,17,18
(16, 3, 13.0, '2025-10-03 12:00:00'),
(17, 3, 14.0, '2025-11-01 12:00:00'),
(18, 3, 12.0, '2025-12-15 09:00:00'),

(16, 4, 15.0, '2025-10-03 12:00:00'),
(17, 4, 14.5, '2025-11-01 12:00:00'),
(18, 4, 13.0, '2025-12-15 09:00:00'),

(16, 5, 16.0, '2025-10-03 12:00:00'),
(17, 5, 17.0, '2025-11-01 12:00:00'),
(18, 5, 15.5, '2025-12-15 09:00:00'),

(16, 9, 18.0, '2025-10-03 12:00:00'),
(17, 9, 17.5, '2025-11-01 12:00:00'),
(18, 9, 18.5, '2025-12-15 09:00:00'),

-- offering 7 / MA201 / assignments 19,20,21
(19, 2, 14.5, '2025-10-15 10:10:00'),
(20, 2, 15.0, '2025-11-10 18:00:00'),
(21, 2, 13.0, '2025-12-16 09:00:00'),

(19, 5, 16.0, '2025-10-15 10:12:00'),
(20, 5, 17.0, '2025-11-10 18:10:00'),
(21, 5, 15.5, '2025-12-16 09:00:00'),

(19, 9, 17.5, '2025-10-15 10:13:00'),
(20, 9, 18.0, '2025-11-10 18:20:00'),
(21, 9, 18.0, '2025-12-16 09:00:00'),

(19, 11, 16.5, '2025-10-15 10:14:00'),
(20, 11, 17.5, '2025-11-10 18:30:00'),
(21, 11, 16.0, '2025-12-16 09:00:00'),

-- offering 8 / BU101 / assignments 22,23,24
(22, 2, 15.0, '2025-11-05 17:00:00'),
(23, 2, 16.0, '2025-11-19 20:00:00'),
(24, 2, 14.0, '2025-12-18 19:00:00'),

(22, 6, 17.0, '2025-11-05 16:30:00'),
(23, 6, 18.0, '2025-11-19 20:15:00'),
(24, 6, 17.5, '2025-12-18 19:00:00'),

-- offering 9 / BU202 / assignments 25,26,27
(25, 6, 16.5, '2026-03-25 17:30:00'),
(26, 6, 17.0, '2026-04-20 18:00:00'),
(27, 6, 16.0, '2026-05-28 19:00:00'),

-- offering 10 / DM101 / assignments 28,29
(28, 3, 18.0, '2025-11-25 23:00:00'),
(29, 3, 17.5, '2025-12-20 23:30:00'),

(28, 7, 16.0, '2025-11-25 22:00:00'),
(29, 7, 18.0, '2025-12-20 22:45:00');