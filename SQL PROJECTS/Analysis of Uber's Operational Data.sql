Create database Uber_Operational_Data

--Capstone Project Questions:

/* City-Level Performance Optimization:
Which are the top 3 cities where Uber should focus more on driver recruitment based on key
metrics such as demand high cancellation rates and driver ratings? */
select * from rides

SELECT TOP 3 start_city, COUNT(*)total_rides, SUM(CASE WHEN ride_status = 'Canceled' THEN 1 ELSE 0 END)canceled_rides,
AVG(rating)avg_driver_rating FROM rides GROUP BY start_city ORDER BY total_rides DESC, canceled_rides DESC, avg_driver_rating ASC
 
/*Revenue leakage analysis: 
How can you detect rides with fare discrepancies or those marked as "completed" without any corresponding payment ? */

/* To detect revenue leakage, we need to identify:
 1. Rides with fare discrepancies (e.g., missing or abnormally low fares).
 2. Completed rides with no corresponding payment (possible data issues or revenue loss). */

 --1. Detect Fare Discrepancies: Find completed rides with missing or unusually low fare values.

 SELECT ride_id, start_city, end_city, distance_km, fare, payment_method FROM rides WHERE ride_status = 'Completed' AND (fare IS NULL OR fare < 10)
ORDER BY fare ASC;

--2. Detect Completed Rides Without Payment: Find completed rides where no valid payment method was recorded.

SELECT ride_id, start_city, end_city, fare, payment_method FROM rides WHERE ride_status = 'Completed' AND (payment_method IS NULL OR payment_method = '')
ORDER BY fare DESC;

/*Cancellation Analysis
 What are the cancellation patterns across cities and ride categories? How do these patterns
 correlate with revenue from completed rides?*/

--1. Cancellation Rate by City

 SELECT start_city, COUNT(*)total_rides, SUM(CASE WHEN ride_status = 'Canceled' THEN 1 ELSE 0 END)canceled_rides,
(SUM(CASE WHEN ride_status = 'Canceled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*))cancel_rate FROM rides GROUP BY start_city ORDER BY cancel_rate DESC

--2. Cancellation Rate by Ride Category

SELECT dynamic_pricing, COUNT(*) AS total_rides, SUM(CASE WHEN ride_status = 'Canceled' THEN 1 ELSE 0 END)canceled_rides, 
(SUM(CASE WHEN ride_status = 'Canceled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*))cancel_rate
FROM rides GROUP BY dynamic_pricing ORDER BY cancel_rate DESC;

--3. Correlation Between Cancellations & Revenue:

SELECT start_city, COUNT(*) AS total_rides, SUM(CASE WHEN ride_status = 'Canceled' THEN 1 ELSE 0 END)canceled_rides, 
(SUM(CASE WHEN ride_status = 'Canceled' THEN 1 ELSE 0 END) * 100 / COUNT(*))cancel_rate, 
SUM(CASE WHEN ride_status = 'Completed' THEN fare ELSE 0 END)total_revenue FROM rides GROUP BY start_city ORDER BY cancel_rate DESC;

/* Cancellation Patterns by Time of Day:
   Analyze the cancellation patterns based on different times of day. Which hours have the highest
   cancellation rates, and what is their impact on revenue? */

--1. Cancellation Rate by Hour
SELECT * FROM rides

SELECT DATEPART(HOUR, START_TIME)RIDE_HOUR, COUNT(*)TOTAL_RIDES, SUM(CASE WHEN RIDE_STATUS = 'CANCELED' THEN 1 ELSE 0 END)CANCELED_RIDES,
(SUM(CASE WHEN RIDE_STATUS = 'CANCELED' THEN 1 ELSE 0 END) * 100 / COUNT(*))CANCELED_RATE FROM rides GROUP BY DATEPART(HOUR, START_TIME) 
ORDER BY CANCELED_RATE DESC

--2. Revenue by Hour

SELECT DATEPART(HOUR, START_TIME)RIDE_HOUR, SUM(CASE WHEN RIDE_STATUS = 'COMPLETED' THEN FARE ELSE 0 END)TOTAL_REVENUE FROM rides 
GROUP BY DATEPART(HOUR, START_TIME) ORDER BY TOTAL_REVENUE DESC

/*Seasonal Fare Variations: 
How do fare amounts vary across different seasons? Identify any significant trends or anomalies in fare distributions.*/

select DATEPART(MONTH,ride_date)Month, AVG(fare)Avg_fare from rides where ride_status = 'Completed' group by DATEPART(MONTH,ride_date) order by Month

/*Average Ride Duration by City:
 What is the average ride duration for each city? How does this relate to customer satisfaction?*/
 select * from rides

 select start_city, AVG(DATEDIFF(MINUTE, start_time, end_time))Avg_Ride_Duration from rides where ride_status = 'Completed' group by start_city 
 order by Avg_Ride_Duration desc

 /* How this Relates to Customer Satisfaction:
- Long durations may indicate traffic issues or driver inefficiency, impacting customer ratings negatively.
- Short durations often correlate with higher satisfaction but could indicate shorter trips or better operational efficiency. */


 /* Index for Ride Date Performance Improvement:
 How can query performance be improved when filtering rides by date? */

CREATE INDEX IDX_RIDE_DATE ON RIDES(RIDE_DATE)

--Calling the above index 
SELECT * FROM rides WHERE ride_date = '2024-03-01'
--OR
SELECT * FROM rides WHERE ride_date BETWEEN '2024-01-01' AND '2024-03-31';

/* View for Average Fare by City
 How can you quickly access information on average fares for each city? */
 
CREATE VIEW AVG_FARE_BY_CITY 
AS
SELECT start_city, AVG(fare)AVG_FARE FROM rides WHERE ride_status = 'Completed' group by start_city

--Calling View
 select * from AVG_FARE_BY_CITY

/* Trigger for Ride Status Change Logging:
 How can you track changes in ride statuses for auditing purposes? */

 CREATE TABLE ride_status_log (log_id INT IDENTITY PRIMARY KEY, ride_id UNIQUEIDENTIFIER, old_status NVARCHAR(50), new_status NVARCHAR(50), 
 change_time DATETIME)

CREATE TRIGGER track_ride_status ON rides
AFTER UPDATE
AS
BEGIN
    IF UPDATE(ride_status)
    BEGIN
        INSERT INTO ride_status_log (ride_id, old_status, new_status, change_time)
        SELECT 
            d.ride_id, 
            d.ride_status AS old_status, 
            i.ride_status AS new_status, 
            GETDATE()change_time
        FROM deleted d JOIN inserted i ON d.ride_id = i.ride_id;
    END
END;

/* View for Driver Performance Metrics
 What performance metrics can be summarized to assess driver efficiency? */

Create View DriverPerformance 
as 
select driver_id, COUNT(*)Total_Rides, SUM(case when ride_status = 'Completed' then 1 else 0 end)Completed_Rides,
SUM(case when ride_status = 'Canceled' then 1 else 0 end)Canceled_Rides,
(SUM(case when ride_status = 'Completed' then 1 else 0 end)*100/COUNT(*))Completion_Rate, AVG(rating)Avg_Rating, SUM(fare)Total_Earnings
from rides group by driver_id 

--Calling View
select * from DriverPerformance

/* Index on Payment Method for Faster Querying
 How can you optimize query performance for payment-related queries? */
 SELECT * FROM rides

Create Index IDX_PAYMENT_METHOD ON RIDES(PAYMENT_METHOD)
