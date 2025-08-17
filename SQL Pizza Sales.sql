--SQL Pizza sales analysis
CREATE DATABASE Pizza DB


-- create table
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

SELECT * FROM pizza_sales
WHERE pizza_id  BETWEEN 1 AND 10;

SELECT COUNT(*) 
FROM pizza_sales

-- Data Cleaning
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



-- Data Exploration

--Hoe many sales we have ?
SELECT COUNT(*) AS total_sales FROM pizza_sales

--How many uniuque orders we have ?
SELECT COUNT(DISTINCT order_id) FROM pizza_sales

SELECT DISTINCT pizza_category from pizza_sales

--Data Analysis & Business key problems and Answers

 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2015-10-03'
 SELECT * 
 FROM pizza_sales
 WHERE order_date = '2015-10-03';


-- Q.2 Write a SQL query to retrieve all transactions where the Pizza category is 'Classic' in the month of Nov-2015
SELECT *
FROM pizza_sales
WHERE pizza_category = 'Classic'
      AND
      FORMAT(order_date, 'yyyy-MM') = '2015-11'

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each  Pizza category.
SELECT pizza_category,
      SUM(CAST(total_price AS DECIMAL(10,2))) AS net_sale,
      COUNT(*) AS total_orders
FROM pizza_sales
GROUP BY pizza_category; 

-- Q.4 Write a SQL query to find the average unit price of customers who purchased items from the 'Veggie' category.
SELECT 
     ROUND(AVG(unit_price),2) AS avg_unit_price
FROM pizza_sales
WHERE pizza_category = 'Veggie'

-- Q.5 Write a SQL query to find all transactions where the total_price is greater than 15.
SELECT * FROM pizza_sales
WHERE total_price > 15

-- Q.6 Write a SQL query to find the total number of transactions (order_id) made by each category.
SELECT pizza_category,
       count(*) AS total_transaction
FROM pizza_sales
GROUP BY pizza_category

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

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

-- Q.8 Write a SQL query to find the top 5 pizza name based on the highest total sales 

SELECT TOP 5
    pizza_name,
    SUM(total_price) as total_sales
FROM pizza_sales
GROUP BY pizza_name
ORDER BY SUM(total_price) DESC

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.


SELECT 
    pizza_category,    
    COUNT(DISTINCT order_id) as cnt_unique_cs
FROM pizza_sales
GROUP BY pizza_category



-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

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


-- End of project



