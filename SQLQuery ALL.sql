--- SQL Retail sales analysis  p1
-- CREATED NEW DATABSE 

CREATE DATABASE sql_project_p1;

-- CREATE TABLE

DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales(
				transactions_id	INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id	INT,
				gender	VARCHAR(20),
				age	INT,
				category VARCHAR(20),	
				quantiy	INT,
				price_per_unit	FLOAT,
				cogs FLOAT,
				total_sales FLOAT
) 
-- INSERTED ALL VALUES IN TABLE FROM CSV FILE BY IMPORT FLAT FILE.

-- TO CHECK TOP 100 VALUES.

SELECT TOP 100 *
FROM retail_sales1;

-- TO CHECK TOTAL ROWS IN A TABLE 

SELECT COUNT(total_sale),total_sale
FROM retail_sales1
group by total_sale;

-- DATA CLEANING

SELECT * FROM retail_sales1
WHERE transactions_id IS NULL;

-- CHECKING NULL VALUES ONE BY ONE BECOMES TIME CONSUMING, HENCE CHECKING ALL NULL USING BELOW QUERY.

SELECT * FROM retail_sales1
WHERE 
transactions_id IS NULL
OR 
sale_date IS NULL
OR
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
age IS NULL
OR
category IS NULL
OR
quantiy IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;


-- There ware multiple null values available in age column, updating by taking AVG(age) in all NULL VAULES of age column.
-- Check AVG(age) column 

SELECT AVg(age) as age_avg
FROM retail_sales1
WHERE age IS NOT NULL;

-- Updated AVG(age) in age column.

UPDATE retail_sales1
SET age = (SELECT AVg(age) as age_avg
FROM retail_sales1
WHERE age IS NOT NULL)
WHERE age IS NULL;

SELECT * FROM retail_sales1;

-- Deleted Remaining NULL

DELETE FROM retail_sales1
WHERE 
transactions_id IS NULL
OR 
sale_date IS NULL
OR 
customer_id IS NULL
OR 
gender IS NULL
OR 
age IS NULL
OR 
category IS NULL
OR 
quantiy IS NULL
OR 
Price_per_unit IS NULL
OR 
cogs IS NULL
OR 
total_sale IS NULL;


-- To check how many values remined after deleting NULL values.
SELECT COUNT(*) 
FROM retail_sales1;

-- DATA Exploration

-- Q1 - How many sales we have have

SELECT COUNT(*) as Total_Sales 
FROM retail_sales1;

-- Q2- How many total customers we have
SELECT COUNT(DISTINCT(customer_id)) AS Total_customer
FROM retail_sales1;

-- Q3 -- what are unique catergories we have
SELECT DISTINCT(category) FROM retail_sales1;

-- DATA ANALYSIS OR KEY BUISNESS PROBLEMS 

-- Q1 --Write SQL query to retrieve all columns for sales made on '2022/11/05'

SELECT * FROM retail_sales1;

SELECT * 
FROM retail_sales1
WHERE sale_date = '2022/11/05';

-- Q2 - Write a squel query to retrieve all transactions where the category is clothing and the quantitiy sold is more  than 
-- 10 in the month of Nov 2022

SELECT 
*
FROM retail_sales1
WHERE category = 'Clothing' AND quantiy >= 4 AND sale_date >= '2022/11/01' AND sale_date < '2022/12/01';


-- Q3 - Write a sql to calculate total sales for each cateory

SELECT category, SUM(total_sale) AS total_sales, COUNT(*) AS total_orders
FROM retail_sales1
GROUP BY category;

-- USING WINDOW FUNCTION


WITH sub_query AS (SELECT category,
  SUM(total_sale) OVER(PARTITION BY category) AS total_sales,
  COUNT(*) OVER(PARTITION BY category) AS total_orders
  FROM retail_sales1) 
SELECT DISTINCT(category), total_sales,total_orders
FROM sub_query;


-- Q4 - Write a sql query to find the average age of customers who purchased items from the 'Beauty' Category

SELECT AVG(age) AS Avg_age 
FROM retail_sales1
WHERE category = 'Beauty';


-- Q5 -- Write a sql query to find all transaction where the total sale is greter than 1000
SELECT * 
FROM retail_sales1
WHERE total_sale > 1000
ORDER BY total_sale;

-- Q6 - Write a sql query to find total number of transactions (transaction_id) made by each gender in each category

SELECT gender,category,COUNT(*) AS total_transaction
FROM retail_sales1
GROUP BY gender, category
ORDER BY category;


-- Q7- Write a sql query to calculate the average sale for each month.Find out best seeling month in each year
SELECT * FROM retail_sales1;
SELECT * FROM (
SELECT MONTH(sale_date) AS monthn,YEAR(sale_date) AS year,AVG(total_sale) AS Avgsale,
RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS Rankn
FROM retail_sales1
GROUP BY MONTH(sale_date),YEAR(sale_date)
) AS t1
WHERE Rankn = 1;

-- Q8 - Find the top 5 customers based on the highest total sales.
SELECT * FROM retail_sales1;


WITH  mytable
AS 
(SELECT customer_id, SUM(total_Sale) AS total_sales
FROM retail_sales1
GROUP BY customer_id) 
SELECT TOP  5 * 
FROM mytable
ORDER BY total_sales DESC;


-- Q9-- Write a sql query to find the number of uniqure customers who purchased items from each category.

SELECT COUNT(DISTINCT(customer_id)) AS customer_count, category
FROM retail_sales1
GROUP BY category;

-- Q10-- Write a sql query to create eachshift and number of orders (ex:Morning <=12,Afternoon Between 12 and 17, EVening >17)

WITH tably AS 
(SELECT *,
CASE
WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening'
END AS shift
FROM retail_sales1)

SELECT shift, COUNT(transactions_id) AS order_count
FROM tably
GROUP BY shift;

-- END OF PROJECT ---