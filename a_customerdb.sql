CREATE DATABASE customerdb;

USE customerdb;

CREATE TABLE Customers(
	CustomerID INT NOT NULL PRIMARY KEY,
    CustomerName VARCHAR(50) NOT NULL,
    City VARCHAR(50) NOT NULL
    -- PRIMARY KEY (CustomerID)
);

CREATE TABLE Orders(
	OrderID INT NOT NULL PRIMARY KEY,
    CustomerID INT NOT NULL,
    ProductName VARCHAR(50) NOT NULL,
    -- PRIMARY KEY (OrderID)
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) 
);

SHOW TABLES;
SELECT * FROM customers;

INSERT INTO Customers
VALUES(1, "John Doe", "Cardiff");

INSERT INTO Customers
VALUES(2, "Sam Smith", "Oxford"),
	  (3, "Jane Ayre", "Liverpool");

ALTER TABLE Orders
DROP FOREIGN KEY orders_ibfk_1;

ALTER TABLE Customers
MODIFY COLUMN CustomerID INT NOT NULL AUTO_INCREMENT;

INSERT INTO Customers(CustomerName, City)	# Insert values to specific fields to a table
VALUES("Mike Johnson", "Manchester");

ALTER TABLE Orders
MODIFY COLUMN OrderID INT AUTO_INCREMENT;

ALTER TABLE Orders											# Re-establish the referential intergrity btwn Customers and Orders
ADD CONSTRAINT fk_customer_id
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID);

SELECT * FROM Customers;

INSERT INTO Orders(CustomerID, ProductName)					# Insert orders for customers
VALUES(1, "iPhone 16"),										# CustomerID must exist (referential integrity)
	  (2, "iPad Air (Gen 4)");

SELECT * FROM Orders;
