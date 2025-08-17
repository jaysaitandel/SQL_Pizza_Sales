🛍 Pizza Sales Analysis (Beginner SQL Project)
This project demonstrates SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data.
The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering business questions through SQL queries.

📌 Database Name: pizza DB
📌 Level: Beginner

🎯 Objectives
Database Setup: Create and populate a retail sales database with provided data.
Data Cleaning: Identify and remove records with missing/null values.
Exploratory Data Analysis (EDA): Perform basic exploration of the dataset.
Business Analysis: Write SQL queries to answer key business questions.
📂 Project Structure
1. Database Setup
CREATE DATABASE Pizza DB;

CREATE TABLE pizza_sales (
    pizza_id INT PRIMARY KEY,
    order_id INT,
    pizza_name_id VARCHAR(30),
    quantity INT,
    order_date DATE,
    order_time TIME,
    unit_price FLOAT,
    total_price FLOAT,
    pizza_size VARCHAR(10),
    pizza_category VARCHAR(20),
    pizza_ingredients VARCHAR(150),
    pizza_name VARCHAR(100)
);
2. Data Exploration & Cleaning
Record Count: Determine the total number of records in the dataset.
SELECT COUNT(*) AS total_sales FROM pizza_sales;
Customer Count: Find out how many unique customers are in the dataset.
SELECT COUNT(DISTINCT order_id) FROM pizza_sales;
Unique Categories: Identify all unique product categories in the dataset.
SELECT DISTINCT pizza_category from pizza_sales;
Check Null Values: Check for any null values in the dataset and delete records with missing data.
SELECT * FROM pizza_sales 
WHERE 
     pizza_id IS NULL
     OR
     order_id IS NULL
     OR
     pizza_name_id IS NULL
     OR
     quantity IS NULL
     OR 
     order_date IS NULL
     OR 
     order_time IS NULL
     OR
     unit_price IS NULL
     OR 
     total_price IS NULL
     OR
     pizza_size IS NULL
     OR
     pizza_ingredients IS NULL
     OR
     pizza_name IS  NULL;
3. Data Analysis & Business Queries
The following SQL queries were developed to answer specific business questions:

1️.Write a SQL query to retrieve all columns for sales made on '2015-10-03':
 SELECT * 
 FROM pizza_sales
 WHERE order_date = '2015-10-03';
2️.Write a SQL query to retrieve all transactions where the Pizza category is 'Classic' in the month of Nov-2015:
SELECT *
FROM pizza_sales
WHERE pizza_category = 'Classic'
      AND
      FORMAT(order_date, 'yyyy-MM') = '2015-11';
3️.Write a SQL query to calculate the total sales (total_sale) for each Pizza category.:
SELECT pizza_category,
      SUM(CAST(total_price AS DECIMAL(10,2))) AS net_sale,
      COUNT(*) AS total_orders
FROM pizza_sales
GROUP BY pizza_category; 
4️.Write a SQL query to find the average unit price of customers who purchased items from the 'Veggie' category.:
SELECT 
     ROUND(AVG(unit_price),2) AS avg_unit_price
FROM pizza_sales
WHERE pizza_category = 'Veggie';
5️.Write a SQL query to find all transactions where the total_price is greater than 15.:
SELECT * FROM pizza_sales
WHERE total_price > 15;
6️.Write a SQL query to find the total number of transactions (order_id) made by each category.:
SELECT pizza_category,
       count(*) AS total_transaction
FROM pizza_sales
GROUP BY pizza_category;
7️.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
WITH monthly_sales AS (
    SELECT 
        YEAR(order_date) AS year,
        MONTH(order_date) AS month,
        AVG(total_price) AS avg_sale
    FROM pizza_sales
    GROUP BY YEAR(order_date), MONTH(order_date)
)
SELECT year, month, avg_sale
FROM (
    SELECT 
        year,
        month,
        avg_sale,
        RANK() OVER (PARTITION BY year ORDER BY avg_sale DESC) AS rank
    FROM monthly_sales
) t1
WHERE rank = 1;
8️.Write a SQL query to find the top 5 pizza name based on the highest total sales :
SELECT TOP 5
    pizza_name,
    SUM(total_price) as total_sales
FROM pizza_sales
GROUP BY pizza_name
ORDER BY SUM(total_price) DESC;
9.Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category;
10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN DATEPART(HOUR, order_time) < 12 THEN 'Morning'
            WHEN DATEPART(HOUR, order_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM pizza_sales
)
SELECT 
    shift,
    SUM(total_price) AS total_sales  -- use SUM for sales value
FROM hourly_sale
GROUP BY shift;
