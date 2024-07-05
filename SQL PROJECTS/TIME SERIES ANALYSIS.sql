CREATE DATABASE TIME_SERIES_ANALYSIS;

SELECT * FROM new_superstore

/* 1) Use the LEAD window function to create a new column sales_next that displays the sales of the next row in the dataset. 
This function will help you quickly compare a given row’s values and values in the next row.*/

SELECT Row_ID, order_id, order_date, Ship_Mode, segment, state, sales, LEAD(sales) OVER (PARTITION BY Ship_Mode ORDER BY Row_ID DESC)SALES_NEXT
FROM new_superstore

/* 2) Create a new column sales_previous to display the values of the row above a given row.*/

SELECT Row_ID ,order_id, order_date, Ship_Mode, segment, state, sales, LAG(sales) OVER (PARTITION BY Ship_Mode ORDER BY ROW_ID DESC)SALES_PREVIOUS 
FROM new_superstore

/* 3) Rank the data based on sales in descending order using the RANK function*/

SELECT order_date, Quantity, sales, RANK() OVER (ORDER BY sales DESC)[SALES RANK] FROM new_superstore 

/* 4) Use common SQL commands and aggregate functions to show the monthly and daily sales averages.*/
SELECT * FROM new_superstore

/*MONTHLY SALES AVERAGE*/
SELECT YEAR(Order_Date)Year, MONTH(Order_Date)Month, AVG(Sales) AS Monthly_Sales_Average FROM new_superstore GROUP BY YEAR(Order_Date), MONTH(Order_Date)ORDER BY Year, Month;

/*DAILY SALES AVERAGE*/
SELECT Order_Date, AVG(Sales) AS Daily_Sales_Average FROM new_superstore GROUP BY Order_Date ORDER BY Order_Date;


/* 5) Analyze discounts on two consecutive days.*/    

WITH CTE AS (SELECT Order_Date, Discount, LAG(Discount) OVER (ORDER BY Order_Date)Previous_Day_Discount FROM new_superstore) SELECT Order_Date, Discount AS Today_Discount, Previous_Day_Discount,    CASE        WHEN Discount > Previous_Day_Discount THEN 'Increase'        WHEN Discount < Previous_Day_Discount THEN 'Decrease'        ELSE 'No Discount'    END AS Discount_TrendFROM CTE;


/* 6) Evaluate moving averages using the window functions.*/

/*Default Window Size*/SELECT Order_Date, Sales, AVG(Sales) OVER (ORDER BY Order_Date) AS Moving_Average FROM new_superstore;     --windows analytical function/*Explicit Window Size*/SELECT Order_Date, Sales, AVG(Sales) OVER(ORDER BY ORDER_DATE ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)MOVING_AVG FROM new_superstore;   --windows frame/* 7) Calculate Running total using windows frame.*/SELECT Order_Date, Quantity, SUM(Sales) OVER(ORDER BY ORDER_DATE ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)RUNNING_TOTAL FROM new_superstore/* 8) Group the data based on the order of quantity & each group should have same number of rows.*/   SELECT Order_Date, Customer_ID, Sales, Quantity, NTILE(2000) OVER(ORDER BY QUANTITY)NTILE FROM new_superstore