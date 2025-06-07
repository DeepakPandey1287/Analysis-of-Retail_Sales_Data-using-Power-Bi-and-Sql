Create database sales_db;
use sales_db;
-- Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    Email VARCHAR(50),
    Phone VARCHAR(15),
    City VARCHAR(30)
);

-- Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Category VARCHAR(30),
    Price DECIMAL(10, 2),
    StockQuantity INT
);

-- SalesOrders Table
CREATE TABLE SalesOrders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- SalesOrderDetails Table
CREATE TABLE SalesOrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES SalesOrders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Customers.csv'
INTO TABLE Customers
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(CustomerID, CustomerName, Email, Phone, City);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Products.csv'
INTO TABLE Products
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ProductID, ProductName, Category, Price, StockQuantity);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/SalesOrders.csv'
INTO TABLE SalesOrders
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(OrderID, CustomerID, OrderDate, TotalAmount);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/SalesOrderDetails.csv'
INTO TABLE SalesOrderDetails
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(OrderDetailID, OrderID, ProductID, Quantity, Price);

select *from customers;

Select CustomerName,email,phone,city from customers;

select*from products;

select productname,price AS Product_Price from products where price>200;

select*from salesorders;

select customerid,orderdate from salesorders where orderdate>2025-01-01;

select customername,count(city) as cityname from customers group by customername;

select city,count(customername) as cityname from customers Group by city;

Select*from salesorderdetails;

Select sum(StockQuantity) As Total_Stock from Products;

Select sum(TotalAmount)  AS Total_Sales from salesorders;

Select Category,avg(Price) AS Averge_Price_Category from Products Group by Category;

Select CustomerID, max(TotalAmount) As highest_Total_Order_Amount 
from salesorders group by CustomerID 
Order by highest_Total_Order_Amount Desc Limit 1;

Select CustomerID, count(OrderID) As Orders_Placed_Per_Customer 
from salesorders group by CustomerID 
Order by CustomerID;

Select*from customers;

Select*from salesorders;

Select city,sum(TotalAmount) As City_With_Highest_Revenue 
from Customers left join salesorders on Customers.customerID= Salesorders.customerID 
group by city order by City_With_Highest_Revenue desc limit 1;

Select CustomerName, OrderID ,TotalAmount from customers inner join salesorders on customers.CustomerID= salesorders.CustomerID;

Select* From products;

Select ProductName,OrderID,Products.Price,Quantity 
from Products inner join 
salesorderdetails on Products.ProductID=salesorderdetails.ProductID;

Select ProductName,category,orderID ,count(category) As  times_product_appeared
from Products inner join 
salesorderdetails on Products.ProductID=salesorderdetails.ProductID 
where category="Electronics" Group by ProductName,category,orderID;

Select CustomerName,OrderID,Sum(TotalAmount) As Total_Amount_Spent from Customers 
Left Join Salesorders on Customers.CustomerID= Salesorders.customerID 
group by CustomerName,OrderID;

Select CustomerName,Sum(TotalAmount) As Total_Amount_Spent from Customers 
Left Join Salesorders on Customers.CustomerID= Salesorders.customerID 
group by CustomerName,OrderID;

Select ProductName from Products Left join salesorderdetails on Products.productID= salesorderdetails.ProductID where OrderID  IS Null;

SELECT Customers.CustomerID, CustomerName, SUM(TotalAmount) AS Total_Spent
FROM Customers
JOIN SalesOrders ON Customers.CustomerID = SalesOrders.CustomerID
GROUP BY Customers.CustomerID, CustomerName
HAVING SUM(TotalAmount) > (SELECT AVG(TotalAmount) FROM SalesOrders);

Select * from products;

SELECT ProductName, Category, Price
FROM Products
WHERE (Category, Price) IN (
    SELECT Category, MAX(Price)
    FROM Products
    GROUP BY Category
);

SELECT CustomerID
FROM SalesOrders
WHERE CustomerID IN (
    SELECT CustomerID
    FROM SalesOrders
    GROUP BY CustomerID
    HAVING COUNT(OrderID) > 3
);

SELECT *
FROM salesorderdetails
WHERE Quantity > 2
  AND OrderID IN (
      SELECT OrderID
      FROM salesorderdetails
      WHERE Quantity > 2
      GROUP BY OrderID
      HAVING COUNT(DISTINCT ProductID) > 2
  );

SELECT salesorders.CustomerID, CustomerName, SUM(TotalAmount) AS Total_Purchase_Amount
FROM SalesOrders Inner join Customers on customers.customerid= salesorders.customerid
GROUP BY salesorders.CustomerID, CustomerName
ORDER BY Total_Purchase_Amount DESC
LIMIT 5;

SELECT SalesOrderDetails.ProductID, ProductName, SUM(Quantity) AS Total_Quantity_Sold
FROM SalesOrderDetails inner join products on products.ProductID= SalesOrderDetails.ProductID
GROUP BY SalesOrderDetails.ProductID, ProductName
ORDER BY Total_Quantity_Sold DESC
LIMIT 3;

SELECT YEAR(OrderDate) AS Year, MONTH(OrderDate) AS Month, SUM(TotalAmount) AS Monthly_Sales_Revenue
FROM SalesOrders
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Year, Month;

SELECT OrderDate, COUNT(OrderID) AS Number_Of_Orders
FROM SalesOrders
GROUP BY OrderDate
ORDER BY Number_Of_Orders DESC
LIMIT 1;

SELECT Category, COUNT(DISTINCT OrderID) AS Number_Of_Orders
FROM Products
JOIN SalesOrderDetails ON Products.ProductID = SalesOrderDetails.ProductID
GROUP BY Category
ORDER BY Number_Of_Orders DESC
LIMIT 1;

SELECT 
  ProductID,OrderID,
  SUM(Price) AS Total_Spent,
  RANK() OVER (ORDER BY SUM(Price) DESC) AS Spending_Rank
FROM SalesOrderdetails
GROUP BY ProductID, OrderID;

SELECT 
  CustomerID,
  OrderID,
  OrderDate,
  ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS Order_Number_For_Customer
FROM SalesOrders;

SELECT 
  CASE 
    WHEN TotalAmount >= 1000 THEN 'High'
    WHEN TotalAmount BETWEEN 500 AND 999 THEN 'Medium'
    ELSE 'Low'
  END AS Order_Category,
  COUNT(*) AS Total_Orders,
  SUM(TotalAmount) AS Revenue
FROM SalesOrders
GROUP BY Order_Category;





