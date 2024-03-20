---II) Function
/* Scalar function

--Write a function named CountOfProducts (use scalar function) with parameters
--@MaNhom, the input value is taken from the CategoryID field, the function returns the product number
--total value of product group code. group products, information includes: CategoryID, CategoryName, CountOfProduct.*/

CREATE FUNCTION CountOfProducts(@MaNhom INT)
RETURNS INT --scalar
AS 
BEGIN
	DECLARE @soSP INT 
	SELECT @soSP=COUNT (P.ProductID)
	FROM Categories AS C INNER JOIN Products AS P 
	ON C.CategoryID = P.CategoryID
	WHERE C.CategoryID=@MaNhom
	RETURN @soSP
END 
GO
SELECT dbo.CountOfProducts(1) AS SoSanPham  ---so san pham ung vs nhomhang 1 =12
GO
--all data 
SELECT DISTINCT  C.CategoryID, C.CategoryName,dbo.CountOfProducts(C.CategoryID) AS 'Count of Producs'
FROM Categories AS C INNER JOIN Products P ON C.CategoryID = P.CategoryID


/*With a function named SalesOfEmp (using scalar function) returns total sales revenue
(SUM(UnitPrice*Quantity)) of an employee in an arbitrary month
and for an optional year, with parameters @EmployeeID, @MonthOrder,
@YearOrder*/
SELECT E.EmployeeID,MONTH(OrderDate) AS Thang,
		YEAR(OrderDate) AS Nam,
		SUM(UnitPrice*Quantity) AS [Tong Doanh Thu]
FROM Employees AS E JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
		JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
GROUP BY E.EmployeeID,MONTH(OrderDate), YEAR(OrderDate) 
--
CREATE FUNCTION SalesOfEmp (@EmployeeID INT, @MonthOrder INT, @YearOrder INT )
RETURNS DECIMAL
AS 
BEGIN 
	 DECLARE @TongDT DECIMAL 
	 SELECT @TongDT=SUM(UnitPrice*Quantity) 
     FROM Employees AS E JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
     JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
	 WHERE E.EmployeeID = @EmployeeID AND 
	 MONTH(OrderDate)= @MonthOrder AND  
	 YEAR (OrderDate) = @YearOrder 
	 RETURN @TongDT
END
GO
SELECT dbo.SalesOfEmp(1,1,1997) AS [Tong Doanh Thu]
--Total revenue of all employees
SELECT  E.EmployeeID ,MONTH(OrderDate) AS Thang,YEAR(OrderDate) AS Nam  ,
		dbo.SalesOfEmp (E.EmployeeID,MONTH(OrderDate), YEAR(OrderDate)) AS [Tong Doanh Thu]
FROM  Employees AS E INNER JOIN Orders AS O ON E.EmployeeID = O.EmployeeID 
INNER JOIN [Order Details] OD ON O.OrderID = OD.OrderID
GROUP BY E.EmployeeID,MONTH(OrderDate), YEAR(OrderDate) 
SELECT dbo.SalesOfEmp(1,1,1997) AS [Tong Doanh Thu]

