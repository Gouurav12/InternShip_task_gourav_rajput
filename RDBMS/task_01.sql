-- Database and Table Creation (as provided before)
CREATE DATABASE IF NOT EXISTS university;
USE university;

CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE Professors (
    professor_id INT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20)
);

CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    department_id INT,
    professor_id INT,
    credits INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id),
    FOREIGN KEY (professor_id) REFERENCES Professors(professor_id)
);

CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    date_of_birth DATE,
    enrollment_date DATE,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    enrollment_date DATE,  -- Include enrollment_date in Enrollments
    grade VARCHAR(5),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- Insert Data (with Indian Male Names)
INSERT INTO Departments (department_id, department_name) VALUES
(1, 'Computer Science'), (2, 'Mathematics'), (3, 'Mechanical Engineering');

INSERT INTO Professors (professor_id, first_name, last_name, email, phone) VALUES
(101, 'Dr. Sharma', 'Ravi', 'ravi.sharma@uni.edu', '555-1234'),
(102, 'Dr. Patel', 'Vijay', 'vijay.patel@uni.edu', '555-5678');

INSERT INTO Courses (course_id, course_name, department_id, professor_id, credits) VALUES
(201, 'Data Structures', 1, 101, 3),
(202, 'Calculus II', 2, 102, 4),
(203, 'Thermodynamics', 3, 101, 4),
(204, 'Database Systems', 1, 101, 3),
(205, 'Operating Systems', 1, 101, 3);

INSERT INTO Students (first_name, last_name, email, phone, date_of_birth, enrollment_date, department_id) VALUES
('Aryan', 'Verma', 'aryan.verma@example.com', '555-1111', '2000-03-10', '2023-09-01', 1),
('Kunal', 'Gupta', 'kunal.gupta@example.com', '555-2222', '2001-07-15', '2022-09-01', 2),
('Veer', 'Chowdhury', 'veer.chowdhury@example.com', '555-3333', '2002-11-20', '2024-01-15', 3),
('Aditya', 'Kumar', 'aditya.kumar@example.com', '555-4444', '2000-09-02', '2023-09-01', 1);

INSERT INTO Enrollments (student_id, course_id, enrollment_date, grade) VALUES
(1, 201, '2023-09-05', 'A'),
(1, 204, '2023-09-05', 'B'),
(2, 202, '2022-09-05', 'C'),
(3, 203, '2024-01-20', 'B+'),
(4, 204, '2023-09-05', 'A-'),
(4, 205, '2023-09-05', 'B');



-- Modified Queries (with sample data and Indian names)

-- 1. Total Number of Students in Each Department
SELECT d.department_name, COUNT(s.student_id) AS total_students
FROM Students s JOIN Departments d ON s.department_id = d.department_id
GROUP BY d.department_name;

-- 2. Courses Taught by a Specific Professor (Dr. Sharma)
SELECT c.course_name
FROM Courses c JOIN Professors p ON c.professor_id = p.professor_id
WHERE p.last_name = 'Sharma';

-- 3. Average Grade of Students in Each Course
SELECT c.course_name, AVG(CASE WHEN e.grade = 'A' THEN 4 WHEN e.grade = 'A-' THEN 3.7 WHEN e.grade = 'B+' THEN 3.3 WHEN e.grade = 'B' THEN 3 WHEN e.grade = 'C' THEN 2 ELSE 0 END) AS average_grade
FROM Enrollments e JOIN Courses c ON e.course_id = c.course_id
GROUP BY c.course_name;

-- 4. Students Who Have Not Enrolled in Any Courses
SELECT s.first_name, s.last_name
FROM Students s
WHERE NOT EXISTS (SELECT 1 FROM Enrollments e WHERE s.student_id = e.student_id);

-- 5. Number of Courses Offered by Each Department
SELECT d.department_name, COUNT(c.course_id) AS num_courses
FROM Departments d LEFT JOIN Courses c ON d.department_id = c.department_id
GROUP BY d.department_name;

-- 6. Students Who Have Taken a Specific Course ('Database Systems')
SELECT s.first_name, s.last_name
FROM Students s JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Database Systems';

-- 7. Most Popular Course Based on Enrollment
SELECT c.course_name, COUNT(e.student_id) AS enrollment_count
FROM Courses c JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_name
ORDER BY enrollment_count DESC
LIMIT 1;

-- 8. Average Number of Credits Per Student in a Department (Computer Science)
SELECT AVG(credits_per_student) AS average_credits
FROM (SELECT s.student_id, SUM(c.credits) AS credits_per_student
FROM Students s JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
WHERE s.department_id = 1
GROUP BY s.student_id) AS student_credits;

-- 9. Professors Who Teach in More Than One Department
SELECT p.first_name, p.last_name
FROM Professors p
WHERE (SELECT COUNT(DISTINCT c.department_id) FROM Courses c WHERE c.professor_id = p.professor_id) > 1;

-- 10. Highest and Lowest Grade in a Specific Course ('Operating Systems')
SELECT MAX(CASE WHEN e.grade = 'A' THEN 4 WHEN e.grade = 'A-' THEN 3.7 WHEN e.grade = 'B+' THEN 3.3 WHEN e.grade = 'B' THEN 3 WHEN e.grade = 'C' THEN 2 ELSE 0 END) AS highest_grade,
       MIN(CASE WHEN e.grade = 'A' THEN 4 WHEN e.grade = 'A-' THEN 3.7 WHEN e.grade = 'B+' THEN 3.3 WHEN e.grade = 'B' THEN 3 WHEN e.grade = 'C' THEN 2 ELSE 0 END) AS lowest_grade
FROM Enrollments e
JOIN Courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Operating Systems';