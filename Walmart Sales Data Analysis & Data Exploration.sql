/*  Walmart Sales Data Analysis and Data Exploration.
    SQL Skills used;
 - Use of CTE's
 - Sub-Queries
 - Case Statement
 */
 
 
 -- SQL Queries to create the Data Base and Table for the import of the raw data

CREATE DATABASE IF NOT EXISTS WalmartSales;

CREATE TABLE IF NOT EXISTS Sales (
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
branch VARCHAR(5) NOT NULL,
city VARCHAR(30) NOT NULL,
customer VARCHAR(30) NOT NULL,
gender VARCHAR(10) NOT NULL,
product_line VARCHAR(30) NOT NULL,
unit_price DECIMAL(10,2) NOT NULL,
quantity INT NOT NULL,
tax_pct FLOAT(6,4) NOT NULL,
total DECIMAL(12, 4) NOT NULL,
date DATETIME NOT NULL,
time TIME NOT NULL,
payment VARCHAR(15) NOT NULL,
cogs DECIMAL(10,2) NOT NULL,
gross_margin_pct FLOAT(11,9),
gross_income DECIMAL(12, 4),
rating FLOAT(2, 1)

);
 
-- ---------------------------------------- Data Cleaning -----------------------------------------


 -- Changing the gross_income column name to net_income
 
 ALTER TABLE sales RENAME COLUMN gross_income TO net_income;
 
 -- Checking for duplicates   
SELECT *
FROM sales;

SELECT COUNT(*)
FROM sales;

SELECT COUNT(DISTINCT(invoice_id))
FROM sales;

-- Add the time_of_day column
SELECT time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "11:59:00" THEN "Morning"
        WHEN `time` BETWEEN "12:00:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_date
FROM sales;


ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);


-- Add day_name column
SELECT date,
	DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);


-- Add month_name column
SELECT date, MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

-- ----------------------------------------Analysis on Business Product-----------------------------------------


-- What is the most common payment method?

SELECT payment, COUNT(payment) AS Payment_Count
FROM sales
GROUP BY payment
ORDER BY Payment_Count DESC
LIMIT 1;

-- What is the most selling product?
SELECT product_line, COUNT(product_line) AS P_Line_Count
FROM sales
GROUP BY product_line
ORDER BY P_Line_Count DESC
LIMIT 1;

-- How many unique product does the datat have?

SELECT COUNT(DISTINCT(product_line))
FROM sales;

-- What is the total revenue by month?

SELECT  month_name, SUM(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC
LIMIT 1;

 -- Which product has the highest total cost of goods sold?
 SELECT product_line, SUM(cogs) AS total_cogs
 FROM sales
 GROUP BY product_line
 ORDER BY total_cogs DESC;
 
 -- Which city has the largest revenue?
 SELECT city, SUM(total) AS Total_Revenue
 FROM sales
 GROUP BY city
 ORDER BY Total_Revenue DESC;
 
 -- Which product generate the largest revenue ?
 SELECT product_line, SUM(total) AS total_revenue
 FROM sales
 GROUP BY product_line
 ORDER BY total_revenue DESC;
 
 -- What product has the highest Value Added Tax
 SELECT product_line, SUM(tax_pct) AS Total_Tax
 FROM sales
 GROUP BY product_line;
 
 
 -- Which products sold more than the average product sold?
 
 WITH Total_Product AS ( SELECT product_line, COUNT(product_line) AS Product_Count
        FROM sales
        GROUP BY product_line)
        
 SELECT product_line, Product_Count
 FROM Total_Product
 WHERE Product_Count > ( SELECT AVG(Product_Count) 
                        FROM Total_Product);
                        
-- What is the most common product sold by gender?

SELECT  product_line, gender, COUNT(product_line) AS Product_Count
FROM sales
GROUP BY product_line, gender
ORDER BY Product_Count DESC;

 
-- ----------------------------------------Sales Analysis-----------------------------------------

-- Which type of customer brings the most revenue?

SELECT customer, SUM(total) AS Total_Revenue
FROM sales
GROUP BY customer
ORDER BY Total_Revenue DESC;

-- Which type of customer pays the most Tax?
 
SELECT customer, SUM(tax_pct) AS Total_Tax
FROM sales
GROUP BY customer
ORDER BY Total_Tax DESC;

-- Which day do customer's buy more product?

WITH Product_Info AS (SELECT product_line, day_name, COUNT(day_name) AS Prod_Day_Cnt
					  FROM sales
                      GROUP BY product_line, day_name)
SELECT day_name, AVG(Prod_Day_Cnt) AS Avg_Prod_Day_Cnt
FROM Product_Info
GROUP BY day_name
ORDER BY Avg_Prod_Day_Cnt desc;
 
 
 
 
 -- ----------------------------------------Customer Analysis-----------------------------------------
 
-- How many unique payment methods does the data have?
SELECT COUNT(DISTINCT payment)
FROM sales;

-- How many unique customer types does the data have?
SELECT COUNT(DISTINCT customer)
FROM sales;


-- Which time of the day do customers give most ratings?
SELECT time_of_day,	AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;


-- Which day of the week has the best avg ratings?
SELECT day_name, AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name 
ORDER BY avg_rating DESC;






