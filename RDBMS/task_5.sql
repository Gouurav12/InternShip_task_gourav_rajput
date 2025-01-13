-- Step 1: Create the Database
CREATE DATABASE IF NOT EXISTS restaurant;
USE restaurant;

-- Step 2: Drop Existing Tables (To Avoid Duplication Issues)
DROP TABLE IF EXISTS Payments, Reviews, Orders, Customers, Restaurants;

-- Step 3: Create Tables

-- Restaurants Table
CREATE TABLE Restaurants (
    RestaurantID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    City VARCHAR(100) NOT NULL,
    Rating DECIMAL(3, 2),
    CuisineType VARCHAR(100)
);

-- Customers Table
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL
);

-- Orders Table
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    RestaurantID INT,
    OrderAmount DECIMAL(10, 2),
    OrderDate DATE,
    OrderStatus VARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);

-- Reviews Table
CREATE TABLE Reviews (
    ReviewID INT AUTO_INCREMENT PRIMARY KEY,
    RestaurantID INT,
    ReviewText TEXT,
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);

-- Payments Table
CREATE TABLE Payments (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    PaymentMethod VARCHAR(50),
    OrderID INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Step 4: Insert Sample Data

-- Insert Data into Restaurants
INSERT INTO Restaurants (Name, City, Rating, CuisineType)
VALUES
('The Gourmet Spot', 'Mumbai', 4.7, 'Italian'),
('Spicy Fusion', 'Delhi', 4.3, 'Indian'),
('Pasta Palace', 'Mumbai', 4.6, 'Italian');

-- Insert Data into Customers
INSERT INTO Customers (FirstName, LastName)
VALUES
('John', 'Doe'),
('Jane', 'Smith'),
('Aman', 'Khan');

-- Insert Data into Orders
INSERT INTO Orders (CustomerID, RestaurantID, OrderAmount, OrderDate, OrderStatus)
VALUES
(1, 1, 1200.50, '2025-01-01', 'Delivered'),
(2, 2, 850.00, '2025-01-02', 'Cancelled'),
(3, 1, 950.00, '2025-01-03', 'Delivered');

-- Insert Data into Reviews
INSERT INTO Reviews (RestaurantID, ReviewText)
VALUES
(1, 'Amazing food and great service!'),
(1, 'Best Italian restaurant in town!');

-- Insert Data into Payments
INSERT INTO Payments (PaymentMethod, OrderID)
VALUES
('Credit Card', 1),
('Cash', 2),
('Online Payment', 3);

-- Step 5: Queries

-- 1. Retrieve restaurants with a rating of 4.5 or higher
SELECT 
    R.Name, 
    R.City 
FROM 
    Restaurants R 
WHERE 
    R.Rating >= 4.5;

-- 2. Find the total number of orders placed by each customer
SELECT 
    C.FirstName, 
    C.LastName, 
    COUNT(O.OrderID) AS TotalOrders 
FROM 
    Customers C 
LEFT JOIN 
    Orders O 
ON 
    C.CustomerID = O.CustomerID 
GROUP BY 
    C.CustomerID;

-- 3. List restaurants offering "Italian" cuisine in "Mumbai"
SELECT 
    R.Name, 
    R.City 
FROM 
    Restaurants R 
WHERE 
    R.CuisineType = 'Italian' 
    AND R.City = 'Mumbai';

-- 4. Calculate the total revenue generated by each restaurant from completed orders
SELECT 
    R.Name, 
    SUM(O.OrderAmount) AS TotalRevenue 
FROM 
    Restaurants R 
JOIN 
    Orders O 
ON 
    R.RestaurantID = O.RestaurantID 
WHERE 
    O.OrderStatus = 'Delivered' 
GROUP BY 
    R.RestaurantID;

-- 5. Retrieve the most recent order placed by each customer
SELECT 
    C.FirstName, 
    C.LastName, 
    MAX(O.OrderDate) AS MostRecentOrderDate 
FROM 
    Customers C 
LEFT JOIN 
    Orders O 
ON 
    C.CustomerID = O.CustomerID 
GROUP BY 
    C.CustomerID;

-- 6. List customers who have not placed any orders yet
SELECT 
    C.FirstName, 
    C.LastName 
FROM 
    Customers C 
WHERE 
    C.CustomerID NOT IN (SELECT DISTINCT O.CustomerID FROM Orders O);

-- 7. Identify the most reviewed restaurants
SELECT 
    R.Name, 
    COUNT(Rev.ReviewID) AS NumberOfReviews 
FROM 
    Restaurants R 
LEFT JOIN 
    Reviews Rev 
ON 
    R.RestaurantID = Rev.RestaurantID 
GROUP BY 
    R.RestaurantID 
ORDER BY 
    NumberOfReviews DESC;

-- 8. Find the most preferred payment method
SELECT 
    P.PaymentMethod, 
    COUNT(P.PaymentID) AS PaymentCount 
FROM 
    Payments P 
GROUP BY 
    P.PaymentMethod 
ORDER BY 
    PaymentCount DESC 
LIMIT 1;

-- 9. List the top 5 restaurants by total revenue
SELECT 
    R.Name, 
    SUM(O.OrderAmount) AS TotalRevenue 
FROM 
    Restaurants R 
JOIN 
    Orders O 
ON 
    R.RestaurantID = O.RestaurantID 
WHERE 
    O.OrderStatus = 'Delivered' 
GROUP BY 
    R.RestaurantID 
ORDER BY 
    TotalRevenue DESC 
LIMIT 5;

-- 10. Show details of cancelled orders with customer and restaurant names
SELECT 
    O.OrderID, 
    O.OrderDate, 
    C.FirstName AS CustomerFirstName, 
    C.LastName AS CustomerLastName, 
    R.Name AS RestaurantName 
FROM 
    Orders O 
JOIN 
    Customers C 
ON 
    O.CustomerID = C.CustomerID 
JOIN 
    Restaurants R 
ON 
    O.RestaurantID = R.RestaurantID 
WHERE 
    O.OrderStatus = 'Cancelled';
