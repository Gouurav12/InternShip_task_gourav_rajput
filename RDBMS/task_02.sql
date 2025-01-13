
CREATE DATABASE IF NOT EXISTS ride_hailing;
USE ride_hailing;

CREATE TABLE Drivers (
    DriverID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Phone VARCHAR(20),
    City VARCHAR(100),
    VehicleType VARCHAR(50),
    Rating DECIMAL(2, 1) -- Use DECIMAL for ratings
);

CREATE TABLE Riders (
    RiderID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Phone VARCHAR(20),
    City VARCHAR(100),
    JoinDate DATE
);

CREATE TABLE Rides (
    RideID INT PRIMARY KEY AUTO_INCREMENT,
    RiderID INT,
    DriverID INT,
    RideDate DATETIME,  -- Use DATETIME for more precision
    PickupLocation VARCHAR(255),
    DropLocation VARCHAR(255),
    Distance DECIMAL(5, 2), -- Use DECIMAL for distance
    Fare DECIMAL(7, 2),    -- Use DECIMAL for fare
    RideStatus VARCHAR(50),
    FOREIGN KEY (RiderID) REFERENCES Riders(RiderID),
    FOREIGN KEY (DriverID) REFERENCES Drivers(DriverID)
);

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    RideID INT,
    PaymentMethod VARCHAR(50),
    Amount DECIMAL(7, 2),
    PaymentDate DATETIME,
    FOREIGN KEY (RideID) REFERENCES Rides(RideID)
);
INSERT INTO Drivers (FirstName, LastName, Phone, City, VehicleType, Rating) VALUES
('Arjun', 'Reddy', '9876543210', 'Hyderabad', 'Sedan', 4.7),
('Vikram', 'Patel', '8765432109', 'Mumbai', 'Hatchback', 4.2),
('Simran', 'Kaur', '7654321098', 'Delhi', 'SUV', 4.9),
('Rahul', 'Sharma', '6543210987', 'Bangalore', 'Sedan', 4.5);

INSERT INTO Riders (FirstName, LastName, Phone, City, JoinDate) VALUES
('Priya', 'Desai', '9988776655', 'Mumbai', '2023-01-15'),
('Rohan', 'Singh', '8877665544', 'Delhi', '2022-11-20'),
('Anika', 'Khan', '7766554433', 'Bangalore', '2023-05-10'),
('Aryan', 'Verma', '6655443322', 'Hyderabad', '2023-08-01');

INSERT INTO Rides (RiderID, DriverID, RideDate, PickupLocation, DropLocation, Distance, Fare, RideStatus) VALUES
(1, 2, '2024-10-26 08:00:00', 'Andheri (Mumbai)', 'Bandra (Mumbai)', 15.5, 250.00, 'Completed'), -- Priya to Bandra
(2, 3, '2024-10-26 10:30:00', 'Connaught Place (Delhi)', 'Gurugram', 30.2, 500.00, 'Completed'), -- Rohan to Gurugram
(3, 4, '2024-10-26 12:45:00', 'MG Road (Bangalore)', 'Indiranagar (Bangalore)', 12.8, 180.00, 'Completed'), -- Anika within Bangalore
(4, 1, '2024-10-26 15:00:00', 'Charminar (Hyderabad)', 'Hitech City (Hyderabad)', 22.5, 350.00, 'Cancelled'),-- Aryan's ride cancelled
(1, 2, '2024-10-27 09:00:00', 'Bandra (Mumbai)', 'Chhatrapati Shivaji Maharaj International Airport (Mumbai)', 10, 150, 'Completed'), -- Priya to airport
(2, 3, '2024-10-27 11:30:00', 'Saket (Delhi)', 'Vasant Kunj (Delhi)', 8, 120, 'Completed'); -- Rohan within Delhi

INSERT INTO Payments (RideID, PaymentMethod, Amount, PaymentDate) VALUES
(1, 'Card', 250.00, '2024-10-26 08:05:00'),
(2, 'Wallet', 500.00, '2024-10-26 10:35:00'),
(3, 'Cash', 180.00, '2024-10-26 12:50:00'),
(5, 'Card', 150, '2024-10-27 09:05:00'),
(6, 'Wallet', 120, '2024-10-27 11:35:00');


-- 1. Who are our top-rated drivers (4.5 stars or higher)?
SELECT FirstName, LastName, Phone
FROM Drivers
WHERE Rating >= 4.5; 
-- 2. How many trips has each driver completed?
SELECT d.FirstName, d.LastName, COUNT(r.RideID) AS RidesCompleted
FROM Drivers d LEFT JOIN Rides r ON d.DriverID = r.DriverID
WHERE r.RideStatus = 'Completed' OR r.RideStatus IS NULL
GROUP BY d.DriverID, d.FirstName, d.LastName;
-- 3. Are there any riders who haven't taken a ride yet?
SELECT r.FirstName, r.LastName
FROM Riders r
LEFT JOIN Rides ri ON r.RiderID = ri.RiderID
WHERE ri.RideID IS NULL; 

-- 4. How much money has each driver earned from completed trips?
SELECT d.FirstName, d.LastName, SUM(r.Fare) AS TotalEarnings
FROM Drivers d JOIN Rides r ON d.DriverID = r.DriverID
WHERE r.RideStatus = 'Completed'
GROUP BY d.DriverID, d.FirstName, d.LastName;

-- 5. When was the last time each rider took a ride?
SELECT r.RiderID, MAX(r.RideDate) AS MostRecentRideDate
FROM Rides r
GROUP BY r.RiderID; 

-- 6. Where are our most popular pickup locations?
SELECT PickupLocation AS City, COUNT(RideID) AS RidesTaken
FROM Rides
GROUP BY PickupLocation; 

-- 7. Which rides were longer than 20 km?
SELECT RideID, PickupLocation, DropLocation, Distance
FROM Rides
WHERE Distance > 20; 
-- 8. What's the most common way people pay?
SELECT PaymentMethod, COUNT(PaymentID) AS PaymentCount
FROM Payments
GROUP BY PaymentMethod
ORDER BY PaymentCount DESC
LIMIT 1; 

-- 9. Who are our top 3 earners?
SELECT d.FirstName, d.LastName, SUM(r.Fare) AS TotalEarnings
FROM Drivers d JOIN Rides r ON d.DriverID = r.DriverID
WHERE r.RideStatus = 'Completed'
GROUP BY d.DriverID, d.FirstName, d.LastName
ORDER BY TotalEarnings DESC
LIMIT 3; 

-- 10. Can we get details about all the cancelled rides, including who cancelled them and who was supposed to drive?
SELECT r.RideID, r.RideDate, r.PickupLocation, r.DropLocation,
       ri.FirstName AS RiderFirstName, ri.LastName AS RiderLastName,
       d.FirstName AS DriverFirstName, d.LastName AS DriverLastName
FROM Rides r
JOIN Riders ri ON r.RiderID = ri.RiderID
JOIN Drivers d ON r.DriverID = d.DriverID
WHERE r.RideStatus = 'Cancelled';