--I)Batch
--Write a batch declaring the variable @tongsoHD containing the total number of invoices for products with ProductID='31',
--if @tongsoHD>50 then prints the string "Product 31 has over 50 orders", 
--otherwise it prints the string "Product 31 has few orders"

DECLARE @tongsoHD INT
SELECT @tongsoHD=COUNT(SalesOrderID)
FROM Sales.SalesOrderDetail
WHERE ProductID= 31
IF @tongsoHD>50 PRINT 'Sản phẩm 31 có trên 50 đơn hàng'
ELSE PRINT 'Sản phẩm 31 có ít đơn đặt  hàng'
GO

--Write a Batch with parameters @makh and @n, containing invoice number @n of customer @makh,
--parameter @nam contains the year of invoice (for example @nam=1996), if @n>0 then print
--string: "Customers have @n invoices in 1996", otherwise if @n=0 then print the string "Customers have no invoices in 1996"

DECLARE @makh INT, @n INT,@nam INT
SET @makh= 9696
SET @nam= 1996
SELECT @n=COUNT(SalesOrderID)
FROM Sales.SalesOrderHeader
WHERE CustomerID=@makh and YEAR(OrderDate)=@nam
IF @n>0 PRINT N'Khách hàng có ' + CONVERT(CHART(5),@n)+N'trong năm 2008'
ELSE PRINT N'Ko có'
GO

--Write a batch to calculate the discount amount for invoices (OrderID) with a total amount > 500,
--information includes OrderID, TotalTien=sum(UnitPrice*Quantity), Discount, with Discount calculated as follows:
--Invoices with TongTien <500 will not be reduced,
--TongTien from 500 to <5000 will reduce 5% of TongTien
--TongTien from 5000 to <10000, 10% discount of TongTien
--TongTien from 10,000 or more will reduce TongTien by 15%.
--(Hint: Use the structure Case… when …then …)

SELECT SalesOrderID,Subtotal=SUM(LineTotal),DISCOUNT = CASE
WHEN SUM(LineTotal)<500 THEN 0
WHEN SUM(LineTotal)<5000 THEN 0.5*SUM(LineTotal)
WHEN SUM(LineTotal)<10000 THEN 0.1*SUM(LineTotal)
ELSE 0.15*SUM(LineTotal)
END
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID

--Write a Batch with 3 parameters: @MaNCC, @MaSP, @SoLuongCC, containing the values ​​of the fields SupplierID, ProductID, Quantity,
--with the value passed to the variables @MaNCC, @MaSP (eg: @MaNCC =5, @MaSP =11, the program will assign the corresponding value of
--field Quantity for the variable @SoLuongCC, if @SoLuongCC returns null, print the string
--"Supplier 5 does not supply product 11", otherwise (eg: @SoLuongCC =12), print the string "Supplier 5 offers product 11 with quantity 12"

DECLARE @mancc INT, @masp INT, @soluongcc INT
SET @mancc=5
SET @masp=11
SELECT @soluongcc=OnOrderQty
FROM Purchasing.ProductVendor
WHERE ProductID=@masp and BusinessEntityID=@mancc
IF @soluongcc IS NULL PRINT 'Nha cung cap '+CONVERT(CHAR(5),@mancc)+'khong cung cap san pham '+CONVERT(CHART(5),@masp)
ELSE PRINT 'Nha cung cap '+CONVERT(CHAR(5),@mancc) +'cung cap san pham'+CONVERT(CHAR(5),@masp) +' với số lượng là'+CONVERT(CHAR(5),@soluongcc)

--Write a batch to increase the average UnitPrice of orders according to the following conditions:
--When the average unit price in an order is < 50, update to increase the unit price of the order by 10%, if after updating
--The largest unit price of the order is > 300, then stop.

WHILE (SELECT AVG([UnitPrice]) FROM [Sales].[SalesOrderDetail])<50
BEGIN
UPDATE [Sales].[SalesOrderDetail]
SET UnitPrice=UnitPrice+UnitPrice*0.1
IF(SELECT MAX(UnitPrice) FROM [Sales].[SalesOrderDetail])>300
BREAK
ELSE
CONTINUE
END

