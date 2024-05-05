--Project – Querying a Large Relational Database

--a. Get all the details from the person table including email ID, phone number, and phone number type

SELECT * FROM [Person].[Person] A INNER JOIN [Person].[EmailAddress] B ON A.BusinessEntityID = B.BusinessEntityID 
INNER JOIN [Person].[PersonPhone] C ON B.BusinessEntityID = C.BusinessEntityID INNER JOIN [Person].[PhoneNumberType] D ON
C.PhoneNumberTypeID = D.PhoneNumberTypeID

--b. Get the details of the sales header order made in May 2011
SELECT * FROM [Sales].[SalesOrderHeader]

SELECT * FROM Sales.SalesOrderHeader WHERE MONTH(OrderDate) = 5 and YEAR(OrderDate) = 2011
--OR
SELECT * FROM [Sales].[SalesOrderHeader] WHERE DATENAME(MONTH,OrderDate) = 'MAY' AND DATENAME(YEAR,OrderDate)= 2011

--c. Get the details of the sales details order made in the month of May 2011
select * from [Sales].[SalesOrderDetail]
select * from [Sales].[SalesOrderHeader]

SELECT * FROM [Sales].[SalesOrderDetail] A INNER JOIN [Sales].[SalesOrderHeader] B ON A.SalesOrderID=B.SalesOrderID 
WHERE MONTH(OrderDate) = 5 AND YEAR(OrderDate)=2011

--d. Get the total sales made in May 2011
SELECT * from [Sales].[SalesOrderDetail]
SELECT * from [Sales].[SalesOrderHeader]

select sum(totaldue)Total_sales, orderdate from sales.SalesOrderHeader where month(OrderDate)=5 and year(orderdate)=2011
group by orderdate 
--OR
select B.OrderDate, sum(linetotal)TOTAL_SALES from sales.SalesOrderDetail A inner join sales.SalesOrderHeader B on A.SalesOrderID=B.SalesOrderID
where month(OrderDate)=5 and year(orderdate)=2011 GROUP BY B.OrderDate

--e. Get the total sales made in the year 2011 by month order by increasing sales
SELECT * from [Sales].[SalesOrderHeader]

SELECT MONTH(ORDERDATE)MONTH, SUM(TotalDue)SALES_VALUE FROM [Sales].[SalesOrderHeader] WHERE YEAR(ORDERDATE) = 2011 GROUP BY MONTH(ORDERDATE) 
ORDER BY SALES_VALUE ASC

--f. Get the total sales made to the customer with FirstName='Gustavo' and LastName ='Achong'
SELECT * FROM [Person].[Person]
SELECT * FROM [Sales].[Customer]
SELECT * FROM [Sales].[SalesOrderHeader]
SELECT * from [Sales].[SalesOrderDetail]


select firstname,lastname,sum(linetotal)TOTAL_SALES from person.person A join sales.Customer Bon A.BusinessEntityID = B.PersonID        --DUE TO PRIMARY KEY & FOREIGN KEY RELATION REFER DATABASE DIAGRAMjoin sales.SalesOrderHeader Con B.CustomerID = C.CustomerIDjoin sales.SalesOrderDetail Don D.SalesOrderID = D.SalesOrderIDwhere A.FirstName='gustavo' and A.LastName='achong'group by A.FirstName, A.LastNameselect  * from customer_detail c1  cross join orders