-- Create table: students
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(120),
    enrolled_at TIMESTAMP DEFAULT NOW()
);

-- Insert sample students
INSERT INTO students (name, email) VALUES
('Alice Johnson', 'alice@example.com'),
('Bruno Silva', 'bruno@example.com'),
('Carla Mendes', 'carla@example.com');

--------------------------------------------------------

-- Create table: courses
CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    title VARCHAR(120) NOT NULL,
    credits INT NOT NULL
);

-- Insert sample courses
INSERT INTO courses (title, credits) VALUES
('Data Engineering Fundamentals', 6),
('Database Systems', 5),
('Cloud Computing', 6);

--------------------------------------------------------

-- Create relationship table
CREATE TABLE enrollments (
    student_id INT REFERENCES students(id),
    course_id INT REFERENCES courses(id),
    PRIMARY KEY (student_id, course_id)
);

-- Insert sample enrollments
INSERT INTO enrollments VALUES
(1, 1),
(1, 2),
(2, 1),
(3, 3);

--1--
SELECT * 
FROM students;

--2--
SELECT s.full_name, d.name AS department
FROM students s
JOIN departments d ON s.department_id = d.id;

--3--
SELECT status, COUNT(*) AS total_students
FROM students
GROUP BY status;

--4--
SELECT c.title AS course, d.name AS department
FROM courses c
JOIN departments d ON c.department_id = d.id;

--5--
SELECT s.full_name, c.title AS course, e.final_status
FROM enrollments e
JOIN students s ON e.student_id = s.id
JOIN course_offerings co ON e.offering_id = co.id
JOIN courses c ON co.course_id = c.id;

--6--
SELECT co.id AS offering_id, AVG(g.grade) AS avg_grade
FROM grades g
JOIN assignments a ON g.assignment_id = a.id
JOIN course_offerings co ON a.offering_id = co.id
GROUP BY co.id;

--7--
SELECT s.full_name
FROM students s
LEFT JOIN grades g ON s.id = g.student_id
WHERE g.id IS NULL;

--8--
SELECT c.title AS course, COUNT(e.student_id) AS total_students
FROM enrollments e
JOIN course_offerings co ON e.offering_id = co.id
JOIN courses c ON co.course_id = c.id
GROUP BY c.title
HAVING COUNT(e.student_id) > 2;

