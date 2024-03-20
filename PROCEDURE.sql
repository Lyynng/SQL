--III)	Stored Procedure:

--Write a procedure to calculate the total inventory (UnitsInStock) of each supplier in a certain country, information includes:
--SupplierID, SumOf UnitsInStock
CREATE PROC TotalStock AS
BEGIN
SELECT [SupplierID],sumofTotal=SUM(SubTotal)
FROM Sales.SalesOrderHeader
WHERE MONTH(OrderDate)=@thang AND YEAR(OrderDate)=@nam
GROUP BY CustomerID
END

--Create a procedure named TongThu with the input parameter being the employee code and the output parameter being the total value of invoices sold by that employee.
--Use the RETURN command to return the success or failure status of the procedure.

CREATE PROC TongThu @manv INT,@tonghd MONEY OUPUT
AS
BEGIN
	SELECT @tonghd = SUM(SubTotal)
	FROM Sales.SalesOrderHeader
	WHERE SalesPersonID=@manv
	RETURN 1
	IF @tonghd>0 RETURN 1
	ELSE RETURN 0
END
DECLARE @tong MONEY
EXEC TongThu 282,@tong OUTPUT
PRINT CONVERT(CHART(10),@tong)

--Create a procedure that displays the name and purchase amount of the customer who made the most purchases in a given year.
CREATE PROC totalDue
AS
BEGIN
SELECT [dbo].[Suppliers].[SupplierID],tongstock=COUNT([dbo].[Products].[UnitsInStock])
FROM [dbo].[Products] join [dbo].[Suppliers] 
ON [dbo].[Products].[SupplierID] = [dbo].[Suppliers].[SupplierID]
GROUP BY [dbo].[Suppliers].[SupplierID]
END

--Write a procedure XoaHD, used to delete an invoice in the Orders table when the OrderID is known.
--Note that before deleting a record in the Orders table, you must delete the records of that invoice in the [Order Details] table.
--If you cannot delete rows in the Orders table, you cannot delete rows in the [Order Details] table corresponding to that invoice.
CREATE PROC XoaHD @mahd INT
AS
BEGIN
IF EXISTS(SELECT * FROM [dbo].[Order Details] WHERE [OrderID]=@mahd)
	BEGIN
		DELETE FROM [dbo].[Orders] WHERE [OrderID]=@mahd
		DELETE FROM [dbo].[Order Details] WHERE [OrderID]=@mahd
	END
	ELSE
	BEGIN
		DELETE FROM [dbo].[Order Details] WHERE [OrderID]=@mahd
	END
END
--Write the procedure Sp_Update_Product with ProductID as the input parameter, used to increase UnitInStock by 10% if this product exists,
--otherwise, this product is not available.
CREATE PROC SP_UP @masp INT
AS
BEGIN
	IF @masp IS NOT NULL
	BEGIN
		SELECT ProductID,UIT=[UnitsInStock]+0.1*[UnitsInStock]
		FROM [dbo].[Products]
		WHERE ProductID=@masp
	END
	ELSE PRINT'khong co san pham nay'
END