Create Database Sales_Analysis

SELECT * FROM [dbo].[SUPERSTORE]

--1) What are total sales and total profits of each year?

SELECT DATETRUNC(YEAR,Order_Date)YEAR, ROUND(SUM(SALES),2)TOTAL_SALES, ROUND(SUM(PROFIT),2)TOTAL_PROFIT FROM [dbo].[SUPERSTORE] 
GROUP BY DATETRUNC(YEAR,Order_Date) ORDER BY YEAR ASC

/*The data above shows how the profits over the years have steadily increased with each year being more profitable than the other despite having a fall 
in sales in 2015, our financial performance*/


--2) What are the total profits and total sales per quarter?
SELECT * FROM [SUPERSTORE]

SELECT DATEPART(YEAR,ORDER_DATE)YEAR,
CASE
WHEN DATEPART(MONTH,ORDER_DATE) IN (1,2,3) THEN 'Q1'
WHEN DATEPART(MONTH,ORDER_DATE) IN (4,5,6) THEN 'Q2'
WHEN DATEPART(MONTH,ORDER_DATE) IN (7,8,9) THEN 'Q3'
ELSE 'Q4'
END AS [QUARTER], SUM(SALES)TOTAL_SALES, SUM(PROFIT)TOTAL_PROFIT FROM [SUPERSTORE] GROUP BY DATEPART(YEAR,ORDER_DATE), Order_Date ORDER BY YEAR, QUARTER, TOTAL_PROFIT DESC

/* The most performing quarters from 2014 -2017 has been shown creating pivot table & chart by computing the above table in excel by importing the data 
via establishing connection*/


--3) What region generates the highest sales and profits ?
SELECT * FROM [SUPERSTORE]

SELECT Region, ROUND(SUM(Sales), 2)TOTAL_SALES, ROUND(SUM(Profit), 2)TOTAL_PROFIT FROM [SUPERSTORE] GROUP BY Region ORDER BY TOTAL_PROFIT DESC

/*It is the Central region that is quite alarming as we generate way more revenue than the South region but do not make at least the same profits over 
there. The Central region should be on our watchlist as we could start to think on how we could maybe put our resources in the other regions instead. 
Let’s observe each regions profit margins for further analysis with the following code:  */

SELECT Region, ROUND(SUM(Profit)/SUM(Sales)*100,2)PROFIT_MARGIN FROM [SUPERSTORE] GROUP BY Region ORDER BY PROFIT_MARGIN DESC


--4) What state and city brings in the highest sales and profits ?

/* Lets discover 10 highest & the lowest states then we will move on to cities.*/

--STATES
--Top 10 states 
SELECT TOP 10 State, SUM(Sales)TOTAL_SALES, SUM(Profit)TOTAL_PROFIT FROM [SUPERSTORE] GROUP BY State ORDER BY TOTAL_PROFIT DESC

--Bottom 10 states
SELECT TOP 10 State, SUM(Sales)TOTAL_SALES, SUM(Profit)TOTAL_PROFIT FROM [SUPERSTORE] GROUP BY State ORDER BY TOTAL_PROFIT ASC

--CITIES
--Top 10 Cities
SELECT TOP 10 City, SUM(Sales)TOTAL_SALES, SUM(Profit)TOTAL_PROFIT FROM [SUPERSTORE] GROUP BY City ORDER BY TOTAL_PROFIT DESC

--Bottom 10 Cities
SELECT TOP 10 City, SUM(Sales)TOTAL_SALES, SUM(Profit)TOTAL_PROFIT FROM [SUPERSTORE] GROUP BY City ORDER BY TOTAL_PROFIT ASC


--5) Find the relationship between discount and sales and the total discount per category?

SELECT Discount, AVG(Sales)AVG_SALES FROM [SUPERSTORE] GROUP BY Discount ORDER BY Discount desc

/*Seems that for each discount point, the average sales seem to vary a lot, hence we'll check the correlation with a graph in Excel*/

-- Total discount per product category:

SELECT Category, SUM(Discount)TOTAL_DISCOUNT FROM [SUPERSTORE] GROUP BY Category ORDER BY TOTAL_DISCOUNT DESC

/*So Office supplies are the most discounted items followed by Furniture and Technology. We will later dive in into how much profit and sales each generate. 
Before that, let’s zoom in the category section to see exactly what type of products are the most discounted.*/

SELECT Category, Sub_Category, ROUND(SUM(Discount),2)TOTAL_DISCOUNT FROM [SUPERSTORE] GROUP BY Category, Sub_Category ORDER BY TOTAL_DISCOUNT DESC

/*Binders, Phones and Furnishings are the most discounted items. But the gap between binders and the others are drastic. We should check the sales and 
profits for the binders and other items on the list.*/


--6) What category generates the highest sales and profits in each region and state ?

SELECT Category, SUM(Sales)TOTAL_SALES, SUM(Profit)TOTAL_PROFIT, ROUND(SUM(Profit)/SUM(Sales)*100,2)PROFIT_MARGIN FROM [SUPERSTORE] GROUP BY Category
ORDER BY TOTAL_PROFIT DESC

/*Out of the 3, it is clear that Technology and Office Supplies are the best in terms of profits. Plus they seem like a good investment because of their
profit margins. Furnitures are still making profits but do not convert well in overall. Let’s observe the highest total sales and total profits per 
Category in each region:*/

SELECT Region, Category, SUM(Sales)TOTAL_SALES, SUM(Profit)TOTAL_PROFIT FROM [SUPERSTORE] GROUP BY Region, Category ORDER BY TOTAL_PROFIT DESC

/*Among the total profits, the only one that fails to break even is the Central Region with Furniture where we operate at a loss when selling it there.*/

--let’s see the highest total sales and total profits per Category in each state:

SELECT State, Category, SUM(Sales)TOTAL_SALES, SUM(Profit)TOTAL_PROFIT FROM [SUPERSTORE] GROUP BY State, Category ORDER BY TOTAL_PROFIT DESC

--Let’s check the least profitable ones by just changing our ‘ORDER BY’ clause too ascending:

SELECT State, Category, SUM(Sales)TOTAL_SALES, SUM(Profit)TOTAL_PROFIT FROM [SUPERSTORE] GROUP BY State, Category ORDER BY TOTAL_PROFIT ASC

/*Office supplies in Texas, Technology in Ohio and Furniture in Texas and Illinois are our biggest losses.*/


--7) What subcategory generates the highest sales and profits in each region and state ?

SELECT Sub_Category, SUM(Sales)TOTAL_SALES, SUM(Profit)TOTAL_PROFIT, ROUND(SUM(Profit)/SUM(Sales)*100,2)PROFIT_MARGIN FROM [SUPERSTORE] GROUP BY Sub_Category
ORDER BY TOTAL_PROFIT DESC

/*Out of our 17 subcategories nationwide, our biggest profits comes from Copiers, Phones, Accessories and Paper. The profits and profit margins on 
Copiers and Papers especially are interesting for the long run. Our losses came from Tables, Bookcases and Supplies where we are uncapable of breaking 
even. Those 3 should be further reviewed as the sales are there, (except Supplies) but we cannot generate profits from them.*/

--Highest total sales and total profits per subcategory in each region:

SELECT Region, Sub_Category, SUM(Sales)TOTAL_SALES, SUM(Profit)TOTAL_PROFIT FROM [SUPERSTORE] GROUP BY Region, Sub_Category ORDER BY TOTAL_PROFIT DESC

--Least performing ones:

SELECT Region, Sub_Category, SUM(Sales)TOTAL_SALES, SUM(Profit)TOTAL_PROFIT FROM [SUPERSTORE] GROUP BY Region, Sub_Category ORDER BY TOTAL_PROFIT ASC

/*We are unable to break-even with 14 subcategories. Tables and Furnishings are our biggest losses in profits in the East, South and Central region.*/

--Highest total sales and total profits per subcategory in each state:

SELECT State, Sub_Category, SUM(Sales)TOTAL_SALES, SUM(Profit)TOTAL_PROFIT FROM [SUPERSTORE] GROUP BY State, Sub_Category ORDER BY TOTAL_PROFIT DESC

/*Machines, Phones and Binders perform very well in New York. Followed by Accessories and Binders in California and Michigan respectively.*/

--Lowest total sales and profits per subcategory in each state:

SELECT State, Sub_Category, SUM(Sales)TOTAL_SALES, SUM(Profit)TOTAL_PROFIT FROM [SUPERSTORE] GROUP BY State, Sub_Category ORDER BY TOTAL_PROFIT ASC

/*Binders are our biggest losses in Texas and Illnois. Machines are not profitable in Ohio at all. We should observe and rethink our strategies in those
areas.*/


--8) What are the names of the products that are the most and least profitable to us?

SELECT Product_Name, SUM(Sales)TOTAL_SALES, SUM(Profit)TOTAL_PROFIT FROM [SUPERSTORE] GROUP BY Product_Name ORDER BY TOTAL_PROFIT DESC

/*These Copiers, Machines and Printers are definetly the main foundations of our profits. The Canon imageClass 2200 Advanced Copier, Fellowes PB500 
Electric Punch Plastic Comb Binding Machine with Manual Bind and the Hewlett Packard LaserJet 3310 Copier are our top 3. We should keep up the stock 
with these. Let’s verify our less proftable ones:*/

SELECT Product_Name, SUM(Sales)TOTAL_SALES, SUM(Profit)TOTAL_PROFIT FROM [SUPERSTORE] GROUP BY Product_Name ORDER BY TOTAL_PROFIT ASC

/*The Cubify CubeX 3D Printer Double Head Print, Lexmark MX611dhe Monochrome Laser Printer and the Cubify CubeX 3D Printer Triple Head Print are the 
products that operate the most at a loss. We should take this into account if we are thinking about modifying our stock.*/

--9) What segment makes the most of our profits and sales ?

SELECT Segment, SUM(Sales)TOTAL_SALES, SUM(Profit)TOTAL_PROFIT FROM [SUPERSTORE] GROUP BY Segment ORDER BY TOTAL_PROFIT DESC

/*The consumer segment brings in the most profit followed by Corporate and then Home office.*/

--10) How many customers do we have (unique customer IDs) in total and how much per region and state?

--UNIQUE CUSTOMER IDs
SELECT COUNT(DISTINCT Customer_ID)TOTAL_CUSTOMERS FROM [SUPERSTORE] 

--UNIQUE ORDER IDs
SELECT COUNT(DISTINCT Order_ID)TOTAL_CUSTOMERS FROM [SUPERSTORE]

--We’ve had 793 customers between 2014 and 2017. Regionally, we had the following:

SELECT Region, COUNT(DISTINCT Customer_ID)TOTAL_CUSTOMERS FROM [SUPERSTORE] GROUP BY Region ORDER BY TOTAL_CUSTOMERS DESC

/*We surely had customers moving around regions which explains why they all do not add up to 793. Since there could be double counting. 
The West is the area where we have the biggest market of all. Statewise, here are the numbers: */

SELECT State, COUNT(DISTINCT Customer_ID)TOTAL_CUSTOMERS FROM [SUPERSTORE] GROUP BY State ORDER BY TOTAL_CUSTOMERS DESC

--We have the most customers in California, New York and Texas. The areas where we have the least that passed by there are:

SELECT State, COUNT(DISTINCT Customer_ID)TOTAL_CUSTOMERS FROM [SUPERSTORE] GROUP BY State ORDER BY TOTAL_CUSTOMERS ASC

--Wyoming, North Dakota and West Virginia are the places where we had the least customers carry on business with us there.


--11) Find out top 15 customers that generated the most sales compared to total profits?

SELECT TOP 15 Customer_ID, Customer_Name, SUM(Sales)TOTAL_SALES, SUM(Profit)TOTAL_PROFIT FROM [SUPERSTORE] GROUP BY Customer_ID, Customer_Name ORDER BY
TOTAL_SALES DESC

/*The display of the customer names are on file but showing the unique Customer id is a form of pseudonymization for security reasons. What is actually 
interesting to see is that customer ID ‘SM-20320’ is the customer who spent the most with us but is not bringing us profit. We still have to reward 
his/her loyalty. It is customer ID ‘TC-20980’ who is second in the list but brings us the most profit. So we really have to thank our top customers and 
keep them on deck.*/


--12) Find out Average shipping time per class and in total?
SELECT * FROM [SUPERSTORE]

--Finally, the average shipping time regardless of the shipping mode that is chosen is found with the following function:

SELECT ROUND(AVG(DATEDIFF(DAY, Order_Date, Ship_Date)), 1)AVG_SHIPPING_TIME FROM [SUPERSTORE] 

--The shipping time in each shipping mode is:

SELECT Ship_Mode, ROUND(AVG(DATEDIFF(DAY, Order_Date, Ship_Date)), 1)AVG_SHIPPING_TIME FROM [SUPERSTORE] GROUP BY Ship_Mode ORDER BY AVG_SHIPPING_TIME


/*The data visualization has been meticulously crafted and is now prominently displayed within Power BI, offering insightful perspectives and 
interactive analysis capabilities.*/