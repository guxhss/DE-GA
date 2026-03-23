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