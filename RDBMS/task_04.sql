-- Create a database named 'employee_db'
CREATE DATABASE employee_db;

-- Use the created database
USE employee_db;

-- 1. Create departments table
CREATE TABLE Departments (
  DepartmentID INT PRIMARY KEY AUTO_INCREMENT,
  DepartmentName VARCHAR(100) NOT NULL,
  ManagerID INT
);

-- 2. Create employee table
CREATE TABLE Employees (
  EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) NOT NULL,
  Email VARCHAR(100) UNIQUE,
  Phone VARCHAR(15),
  HireDate DATE,
  DepartmentID INT,
  ManagerID INT,
  Salary DECIMAL(10, 2),  -- Salary in INR
  FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
  FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
);

-- 3. Create performanceReviews table
CREATE TABLE PerformanceReviews (
  ReviewID INT PRIMARY KEY AUTO_INCREMENT,
  EmployeeID INT NOT NULL,
  ReviewDate DATE NOT NULL,
  PerformanceScore VARCHAR(20),
  Comments VARCHAR(255),
  FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

-- 4. Create payroll table
CREATE TABLE Payroll (
  PayrollID INT PRIMARY KEY AUTO_INCREMENT,
  EmployeeID INT NOT NULL,
  PaymentDate DATE,
  Amount DECIMAL(10, 2),  -- Amount in INR
  PaymentMethod VARCHAR(50),
  FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

-- 5. Insert data into departments table
INSERT INTO Departments (DepartmentID, DepartmentName, ManagerID)
VALUES
  (1, 'Human Resources', NULL),
  (2, 'Finance', NULL),
  (3, 'IT', NULL);

-- 6. Insert data into employee table
INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, Phone, HireDate, DepartmentID, ManagerID, Salary)
VALUES
  (101, 'Amit', 'Sharma', 'amit.sharma@example.com', '9876543210', '2022-06-15', 1, NULL, 60000.00),  -- Salary in INR
  (102, 'Priya', 'Mehra', 'priya.mehra@example.com', '9876543211', '2023-02-20', 2, 101, 50000.00),  -- Salary in INR
  (103, 'Ravi', 'Kumar', 'ravi.kumar@example.com', '9876543212', '2021-08-01', 3, 101, 80000.00),  -- Salary in INR
  (104, 'Neha', 'Singh', 'neha.singh@example.com', '9876543213', '2023-07-10', 1, 101, 45000.00);  -- Salary in INR

-- 7. Insert data into performanceReviews table
INSERT INTO PerformanceReviews (ReviewID, EmployeeID, ReviewDate, PerformanceScore, Comments)
VALUES
  (1, 101, '2023-12-01', 'Excellent', 'Outstanding performance'),
  (2, 102, '2023-11-15', 'Good', 'Meeting expectations'),
  (3, 103, '2023-10-20', 'Excellent', 'Consistently exceeding goals'),
  (4, 104, '2023-09-30', 'Average', 'Needs improvement in some areas');

-- 8. Insert data into payroll table
INSERT INTO Payroll (PayrollID, EmployeeID, PaymentDate, Amount, PaymentMethod)
VALUES
  (1, 101, '2023-12-15', 60000.00, 'Bank Transfer'),  -- Amount in INR
  (2, 102, '2023-12-15', 50000.00, 'Check'),  -- Amount in INR
  (3, 103, '2023-12-15', 80000.00, 'Bank Transfer'),  -- Amount in INR
  (4, 104, '2023-12-15', 45000.00, 'Check');  -- Amount in INR

-- **Queries**

-- 1. Retrieve the names and contact details of employees hired after January 1, 2023.
SELECT FirstName, LastName, HireDate 
FROM Employees 
WHERE HireDate > '2023-01-01';

-- 2. Find the total payroll amount paid to each department.
SELECT d.DepartmentName, SUM(p.Amount) AS total_payroll 
FROM Departments d
JOIN Employees e ON d.DepartmentID = e.DepartmentID
JOIN Payroll p ON e.EmployeeID = p.EmployeeID
GROUP BY d.DepartmentName;

-- 3. List all employees who have not been assigned a manager.
SELECT e.FirstName, e.LastName 
FROM Employees e
WHERE e.ManagerID IS NULL;

-- 4. Retrieve the highest salary in each department along with the employee's name.
SELECT d.DepartmentName, MAX(e.Salary) AS Highest_Salary, e.FirstName, e.LastName 
FROM Departments d
JOIN Employees e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName;

-- 5. Find the most recent performance review for each employee.
SELECT e.FirstName, e.LastName, MAX(r.ReviewDate) AS Recent_Review 
FROM Employees e
JOIN PerformanceReviews r ON e.EmployeeID = r.EmployeeID
GROUP BY e.EmployeeID;

-- 6. Count the number of employees in each department.
SELECT d.DepartmentName, COUNT(e.EmployeeID) AS Employees_In_Department 
FROM Departments d
LEFT JOIN Employees e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName;

-- 7. List all employees who have received a performance score of "Excellent."
SELECT e.FirstName, e.LastName, e.Email, r.PerformanceScore
FROM Employees e
JOIN PerformanceReviews r ON e.EmployeeID = r.EmployeeID
WHERE r.PerformanceScore = 'Excellent';

-- 8. Identify the most frequently used payment method in payroll. 
SELECT PaymentMethod, COUNT(*) AS Frequency
FROM Payroll
GROUP BY PaymentMethod
ORDER BY Frequency DESC
LIMIT 1;

-- 9. Retrieve the top 5 highest-paid employees along with their departments.
SELECT e.FirstName, e.LastName, d.DepartmentName, e.Salary
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
ORDER BY e.Salary DESC
LIMIT 5;

-- 10. Show details of all employees who report directly to a specific manager (e.g., ManagerID = 101).
SELECT * 
FROM Employees 
WHERE ManagerID = 101;