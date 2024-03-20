/*Create view vw_Products_Info displaying a list of products from the Products table and Categories table.
Information includes CategoryName, Description, ProductName, QuantityPerUnit, UnitPrice, UnitsInStock*/

CREATE VIEW vw_Products_Info
SELECT [ProductID], CategoryName, [Description], ProductName, QuantityPerUnit, UnitPrice, UnitsInStock
FROM [dbo].[Products] INNER JOIN [dbo].[Categories]
ON [dbo].[Products].[CategoryID]=[dbo].[Categories].[CategoryID]

/*Create a List_Product_view view containing a list of box products with unit price > 16,
Information includes ProductID, ProductName, UnitPrice, QuantityPerUnit, COUNT of OrderID*/
SELECT * FROM [dbo].[Products]
CREATE VIEW List_Product_view AS 
SELECT ProductID, ProductName, UnitPrice, QuantityPerUnit
FROM Products AS P
WHERE QuantityPerUnit LIKE '%Box%' AND UnitPrice>16
GROUP BY [ProductID],[UnitPrice], [QuantityPerUnit]

/*Create a vw_CustomerTotals view that displays the total sales from each customer by month and year.
Information includes CustomerID, YEAR(OrderDate) AS OrderYear, MONTH(OrderDate) AS OrderMonth, SUM(UnitPrice*Quantity)*/
CREATE VIEW vw_CustomerTotal AS
SELECT CUSTOMERID, NAM =YEAR(ORDERDATE),
THANG=MONTH(ORDERDATE), TONGTIEN=SUM(UNITPRICE*QUANTITY)
FROM ORDERS AS O JOIN [ORDER DETAILS] AS OD
ON O.ORDERID = OD.ORDERID
GROUP BY CUSTOMERID, YEAR(ORDERDATE), MONTH(ORDERDATE)

/*Create a view that returns the total number of products sold by each employee (Employee) each year.
Information includes EmployeeID, OrderYear, sumOfOrderQuantity*/
CREATE VIEW vw_EmployeeTotal AS
SELECT EmployeeID,  Year(OrderDate) AS OrderYear, SUM(OD.Quantity) AS TongSPBan
FROM Orders AS O INNER JOIN [Order Details] AS OD  ON O.OrderID=OD.OrderID
GROUP BY EmployeeID, YEAR(OrderDate)

SELECT * FROM vw_EmployeeTotal

 /*Create a ListCustomer_view view containing a list of customers with more than 5 orders from 1997 to 1998,
 Information includes customer code (CustomerID), full name (CompanyName), Invoice number (CountOfOrders)*/
CREATE VIEW vw_ListCustomer AS 
SELECT C.CustomerID, C.CompanyName, COUNT(O.OrderID) AS TongHoaDon
FROM customers AS C JOIN Orders AS O on C.customerID=O.CustomerID
WHERE YEAR(O.OrderDate)=1997 OR YEAR(O.OrderDate)=1998
GROUP BY c.CustomerID, C.CompanyName
HAVING COUNT(O.OrderID)>5

SELECT * FROM vw_ListCustomer

/*Create view vw_OrderSummary with keyword WITH ENCRYPTION including OrderYear (year of invoice date),
OrderMonth (month of invoice date), OrderTotal (total amount, =UnitPrice*Quantity).
Then view information and help about this view's code*/
CREATE VIEW VW_ORDERSUMARY
WITH ENCRYPTION AS
	SELECT ORDERYEAR =YEAR(ORDERDATE), 
	ORDERMONTH=MONTH(ORDERDATE), 
	ORDERTOTAL =SUM(QUANTITY*UNITPRICE)
	FROM ORDERS AS O JOIN [ORDER DETAILS] AS OD
	ON O.ORDERID =OD.ORDERID
	GROUP BY YEAR(ORDERDATE), 
	MONTH(ORDERDATE)
SELECT * FROM VW_ORDERSUMARY
/*Create view vwProducts with the WITH SCHEMABINDING keyword including ProductID, ProductName, Discount.
View information of View. Delete the Discount column. Can it be deleted? Why?*/
SELECT * FROM [dbo].[Products]
CREATE VIEW vwProducts
WITH SCHEMABINDING AS
SELECT [dbo].[Products].ProductID,ProductName, Discount
FROM [dbo].[Products] INNER JOIN [dbo].[Order Details]
ON [dbo].[Products].[ProductID]=[dbo].[Order Details].[ProductID]
--Remove Discount column.
GO
ALTER TABLE [dbo].[Order Details]
DROP COLUMN Discount
--Be able to remove? Why?*/
/*Cannot be deleted because If the view is created from a join (in or
addition) on multiple tables (2 tables), we can perform addition operations
Add or update data if this operation only has an effect
to exactly one base table (DELETE statement cannot be executed
available in this case).*/

/*Create view vw_Customer with keyword WITH CHECK OPTION containing only customers in London and Madrid city,
Information includes: CustomerID, CompanyName, City*/
CREATE VIEW vw_Customer AS
 SELECT CustomerID, CompanyName, City
 FROM CUSTOMERS 
 WHERE CITY ='LONDON'
 WITH CHECK OPTION
 SELECT * FROM vw_Customer
 /*Insert a new customer who is not located in London and Madrid through the view just created.
 Can it be inserted? Explain.*/
  INSERT vw_Customer(CUSTOMERID, COMPANYNAME, CITY)
 VALUES (4444,'khangantony','LONDON')
 SELECT * FROM vw_Customer
 SELECT * FROM CUSTOMERS

 /*Insert a new customer who is not located in London and Madrid through the view just created.
 Can it be inserted? Explain*/
 INSERT vw_Customer(CUSTOMERID, COMPANYNAME, CITY)
 VALUES (3333,'YYUUJK','LONDON')
 SELECT * FROM vw_Customer
 SELECT * FROM CUSTOMERS
 