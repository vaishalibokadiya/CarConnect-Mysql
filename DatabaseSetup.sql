CREATE DATABASE CarConnect;
USE CarConnect;

CREATE TABLE Customer (
    customerId INT AUTO_INCREMENT PRIMARY KEY,
    firstName VARCHAR(50),
    lastName VARCHAR(50),
    email VARCHAR(100),
    phoneNumber VARCHAR(15),
    address VARCHAR(200),
    username VARCHAR(50) UNIQUE,
    password VARCHAR(200), 
    registrationDate VARCHAR(15)
);
INSERT INTO Customer (firstName, lastName, email, phoneNumber, address, username, password, registrationDate)
VALUES
('John', 'Doe', 'john.doe@email.com', '123-456-7890', '123 Main St, Cityville, USA', 'john_doe123', 'hashed_password_123', '2023-01-01'),
('Alice', 'Smith', 'alice.smith@email.com', '987-654-3210', '456 Oak St, Townsville, USA', 'alice_smith456', 'hashed_password_456', '2023-02-15'),
('Bob', 'Johnson', 'bob.johnson@email.com', '555-123-7890', '789 Pine St, Villagetown, USA', 'bob_johnson789', 'hashed_password_789', '2023-03-20'),
('Emily', 'Davis', 'emily.davis@email.com', '222-333-4444', '101 Elm St, Hamletville, USA', 'emily_davis101', 'hashed_password_101', '2023-04-10'),
('Michael', 'Lee', 'michael.lee@email.com', '777-888-9999', '202 Cedar St, Hilltop, USA', 'michael_lee202', 'hashed_password_202', '2023-05-05');

CREATE TABLE Vehicle (
    vehicleId INT AUTO_INCREMENT PRIMARY KEY,
    model VARCHAR(50),
    make VARCHAR(50),
    year INT,
    color VARCHAR(20),
    registrationNumber VARCHAR(20) UNIQUE,
    availability BOOLEAN,
    dailyRate DECIMAL(10, 2)
);

INSERT INTO Vehicle (model, make, year, color, registrationNumber, availability, dailyRate)
VALUES
('Sedan', 'Toyota', 2020, 'Blue', 'ABC123', true, 50.00),
('SUV', 'Honda', 2019, 'Red', 'XYZ789', false, 65.50),
('Hatchback', 'Ford', 2022, 'Silver', 'JKL456', true, 40.75),
('Truck', 'Chevrolet', 2021, 'Black', 'MNO789', true, 75.25),
('Convertible', 'BMW', 2018, 'White', 'PQR321', false, 90.00);


CREATE TABLE Reservation (
    reservationId INT AUTO_INCREMENT PRIMARY KEY,
    customerId INT,
    vehicleId INT,
    startDate VARCHAR(20),
    endDate VARCHAR(20),
    totalCost DECIMAL(10, 2),
    status VARCHAR(20),
    FOREIGN KEY (customerId) REFERENCES Customer(customerId) ON DELETE CASCADE,
    FOREIGN KEY (vehicleId) REFERENCES Vehicle(vehicleId) ON DELETE CASCADE
);

INSERT INTO Reservation (customerId, vehicleId, startDate, endDate, totalCost, status)
VALUES
  (1, 1, '2023-01-10', '2023-01-15', 250.00, 'Confirmed'),
  (2, 2, '2023-02-05', '2023-02-10', 180.50, 'Pending'),
  (3, 3, '2023-03-20', '2023-03-25', 300.75, 'Completed'),
  (4, 4, '2023-04-15', '2023-04-20', 200.25, 'Confirmed'),
  (5, 5, '2023-05-08', '2023-05-13', 150.00, 'Pending');


CREATE TABLE Admin (
    adminId INT AUTO_INCREMENT PRIMARY KEY,
    firstName VARCHAR(50),
    lastName VARCHAR(50),
    email VARCHAR(100),
    phoneNumber VARCHAR(15),
    username VARCHAR(50) UNIQUE,
    password VARCHAR(200),
    role VARCHAR(20),
    joinDate VARCHAR(20)
);

INSERT INTO Admin (firstName, lastName, email, phoneNumber, username, password, role, joinDate)
VALUES
    ('John', 'Doe', 'john.doe@example.com', '123-456-7890', 'john_admin', 'hashed_password_1', 'Super Admin', '2023-01-01'),
    ('Jane', 'Smith', 'jane.smith@example.com', '987-654-3210', 'jane_admin', 'hashed_password_2', 'Fleet Manager', '2023-02-15'),
    ('David', 'Johnson', 'david.johnson@example.com', '555-123-4567', 'david_admin', 'hashed_password_3', 'System Analyst', '2023-03-20'),
    ('Emily', 'Clark', 'emily.clark@example.com', '777-888-9999', 'emily_admin', 'hashed_password_4', 'Admin Assistant', '2023-04-10'),
    ('Michael', 'Williams', 'michael.williams@example.com', '111-222-3333', 'michael_admin', 'hashed_password_5', 'Inventory Manager', '2023-05-05');
