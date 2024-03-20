/*Table Valued Functions*/

--Write a function sumofOrder with two parameters @thang and @nam that returns a list of invoices (SalesOrderID) 
--created in the month and year passed in the two parameters @thang and @nam, total amount >50000, 
--information includes SalesOrderID, OrderDate, SubTotal, in which SubTotal =sum(OrderQty*UnitPrice)

SELECT O.OrderID ,O.OrderDate,SUM(OD.UnitPrice*OD.Quantity) AS TongTien
FROM [Order Details] AS OD INNER JOIN Orders AS O ON OD.Discount=O.OrderID
WHERE MONTH(O.OrderDate)=11 AND YEAR(O.OrderDate)=1996
GROUP BY O.OrderID,O.OrderDate
HAVING SUM(OD.UnitPrice*OD.Quantity)>5000
GO
--
CREATE FUNCTION Sum_ofOrder (@thang int , @nam int)
RETURNS TABLE
AS 
RETURN (SELECT O.OrderID,O.OrderDate,SUM(OD.UnitPrice*OD.Quantity) AS TongTien
		FROM [Order Details] AS OD INNER JOIN Orders AS O ON OD.Discount=O.OrderID
		WHERE MONTH(O.OrderDate)=11 AND YEAR(O.OrderDate)=1996
		GROUP BY O.OrderID,O.OrderDate
		HAVING SUM(OD.UnitPrice*OD.Quantity)>5000)
GO

--Create a function named SumOfProduct with input parameter @MaNCC (SupplierID),
--used to calculate total quantity (SumOfQuantity) and highest discount(MaxOfDiscount) of products provided by supplier @MaNCC,
--Information includes ProductID, SumOfQuantity, MaxOfDiscount

CREATE FUNCTION  Sum_Of_Product (@MaNCC INT)
RETURNS TABLE
AS
     RETURN (SELECT OD.ProductID, SumOfQuantity = SUM(Quantity), MaxOfDiscount = MAX(Discount)
	 FROM dbo.[Order Details] AS OD INNER JOIN Products AS P ON OD.ProductID = P.ProductID
	 WHERE SupplierID = @MaNCC
	 GROUP BY OD.ProductID)
----EXECUTE
DECLARE @MaNCC int
SET @MaNCC = 1
SELECT * FROM Sum_Of_Product(@MaNCC)

--Write a function named Discount_Func to calculate the discount amount on invoices (OrderID),
--Information includes OrderID, Quantity, Discount, in which Discount is calculated as follows:
--If Quantity< 10 then Discount=0,
--If 10<= Quantity <30 then Discount = 5% [UnitPrice*Quantity]
--If 30<= Quantity <50 then Discount = 10%[UnitPrice*Quantity]
--If Quantity >=50 then Discount = 15% [UnitPrice*Quantity]

CREATE FUNCTION Discount_Func ()
RETURNS TABLE
AS
    RETURN (SELECT OrderID, Quantity, 
	   Discount = CASE
	      WHEN Quantity < 10 THEN 0
		  WHEN Quantity BETWEEN 10 AND 30 THEN 0.05*(UnitPrice*Quantity)
		  WHEN Quantity BETWEEN 30 AND 50 THEN 0.1* (UnitPrice*Quantity)
		  ELSE 0.15* (UnitPrice*Quantity)
		  END
      FROM [Order Details])
	
--Write the function TotalOfEmp with parameters @MonthOrder, @YearOrder to calculate the total
--Revenue of employees in month and year by passing in 2 parameters,
--Information includes EmployeeID, Total, and Total=Sum(UnitPrice*Quantity).

CREATE FUNCTION TotalOfEmp (@MonthOrder DATETIME, @YearOrder DATETIME)
RETURNS TABLE
AS 
     RETURN (SELECT E.EmployeeID, SUM(OD.UnitPrice*Quantity) AS Total
	 FROM Employees AS E INNER JOIN Orders AS O ON E.EmployeeID = O.EmployeeID  
	 INNER JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
	 WHERE MONTH(OrderDate) = @MonthOrder AND YEAR(OrderDate) = @YearOrder
	 GROUP BY E.EmployeeID )
-----CHECK
SELECT * FROM TotalOFEmp (7,2005)

