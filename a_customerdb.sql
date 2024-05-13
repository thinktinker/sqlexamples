CREATE DATABASE customerdb;

# Create customer table
CREATE TABLE customerdb.Customer(
	CustomerID INT NOT NULL,
    CustomerName VARCHAR(50) NOT NULL,
    City VARCHAR(50) NOT NULL,
    PRIMARY KEY(CustomerID)
);

# Create Order table that references Customer table (without a specific name to the constrain
/*
CREATE TABLE customerdb.Order(
	OrderID INT NOT NULL,
    CustomerID INT NOT NULL,
    ProductName VARCHAR(50) NOT NULL,
    PRIMARY KEY(OrderID),
    FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID)
);
*/

# Create Order table that refeences Customer table with a SPECIFIC constrain name
/*
CREATE TABLE customerdb.Order(
	OrderID INT NOT NULL,
    CustomerID INT NOT NULL,
    ProductName VARCHAR(50) NOT NULL,
    PRIMARY KEY(OrderID),
    CONSTRAINT FK_CustomerOrder FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) 
);
*/

# Drop customerdb.Order table
/* 
DROP TABLE customerdb.Order;
*/