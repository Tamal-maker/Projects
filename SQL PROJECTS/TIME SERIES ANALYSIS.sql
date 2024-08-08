CREATE DATABASE TIME_SERIES_ANALYSIS;

SELECT * FROM new_superstore

/* 1) Use the LEAD window function to create a new column sales_next that displays the sales of the next row in the dataset. 
This function will help you quickly compare a given row�s values and values in the next row.*/

SELECT Product_ID, Category, Product_Name, Sales, LEAD(Sales) OVER(PARTITION BY CATEGORY ORDER BY SALES DESC)SALES_NEXT FROM new_superstore

/* 2) Create a new column sales_previous to display the values of the row above a given row.*/

SELECT Product_ID, Category, Product_Name, Sales, LAG(Sales) OVER(PARTITION BY CATEGORY ORDER BY SALES DESC)SALES_PREVIOUS FROM new_superstore

/* 3) Rank the data based on sales in descending order using the RANK function*/

SELECT *, RANK() OVER (ORDER BY sales DESC)[SALES RANK] FROM new_superstore 

/* 4) Use common SQL commands and aggregate functions to show the monthly and daily sales averages.*/
SELECT * FROM new_superstore

/*MONTHLY SALES AVERAGE*/
SELECT YEAR(Order_Date)Year, MONTH(Order_Date)Month, AVG(Sales) AS Monthly_Sales_Average FROM new_superstore GROUP BY YEAR(Order_Date), MONTH(Order_Date)

/*DAILY SALES AVERAGE*/
SELECT Order_Date, AVG(Sales) AS Daily_Sales_Average FROM new_superstore GROUP BY Order_Date ORDER BY Order_Date;

/* 5) Analyze discounts on two consecutive days.*/    

WITH CTE AS (

/* 6) Evaluate moving averages using the window functions.*/

/*Default Window Size*/