-- SQL Retail Sales Analysis - p1
-- CREATE TABLE
CREATE TABLE retail_sales
(
	transactions_id INT,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR,
	age INT,
	category VARCHAR,
	quantiy INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT	
);
SELECT * FROM retail_sales
LIMIT 10;


SELECT 
	COUNT(*) 
FROM retail_sales;

-- Data Cleaning
SELECT * FROM retail_sales
WHERE transactions_id is null

SELECT * FROM retail_sales
WHERE sale_time is null

SELECT * FROM retail_sales
WHERE transactions_id is null
	OR
	sale_date IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL

--
DELETE FROM retail_sales
WHERE transactions_id is null
	OR
	sale_date IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL

-- Data Exploration

--- how much sales we have?
SELECT count(*) as total_sale FROM retail_sales

-- how many customers we have
SELECT COUNT(DISTINCT customer_id) as total_customer From retail_sales

SELECT DISTINCT category FROM retail_sales

-- Data Analysis & Business key problems & Answers
-- Q.1 write a sql query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05'

--Q.2 write a sql query to retrieve all transactions where the category is 'clothing' and the quantity sold is greater than or qual 4in the month of nov 2022
SELECT * FROM retail_sales
WHERE 
	category = 'Clothing' 
	AND 
	TO_CHAR(sale_date,'YYYY-MM')='2022-11'
	AND
	quantiy>=4

--Q.3 write a sql query to calculate the total sales(total_sale) for waach category
SELECT 
	category,
	SUM(total_sale) as net_sale,
	COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1
ORDER BY net_sale desc

--Q.4 write a sql query to find the average age of customers who purchases items from the 'beuty' category
SELECT 
	ROUND(AVG(age),2)as avg_age
FROM retail_sales
WHERE category ='Beauty'

--Q.5 Write a sql query to find all transaction where the total_sale is grater than 1000
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Q.6 Write sql query to find the total number of transactions (transaction_id) made by each gender in each category
SELECT category,gender,count(transactions_id) as total_transaction
FROM retail_sales
GROUP BY category,gender
ORDER BY 1

--Q.7 write a sql query to calculate the average sale for each month, find out the best selling month in each year
SELECT year,month,ave_sale
FROM
(
	SELECT 
		EXTRACT(YEAR FROM sale_date) as year,
		EXTRACT(month FROM sale_date) as month,
		AVG(total_sale) as ave_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR from sale_date) ORDER BY AVG(total_sale)DESC) as rank
	FROM retail_sales
	GROUP BY 1,2
) as t1
WHERE rank = 1;

--Q.8 write a sql query to find the top 5 customers on the highest toal sales

SELECT 
	customer_id,
	sum(total_sale) as total_sale
From retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--Q.9 write a query to find the number of unique customers who puchased items from each category.
SELECT COUNT(DISTINCT customer_id),category
FROM retail_sales
GROUP BY 2

--Q.10 write a sql query to create eaach shift number of orders
WITH hourly_sale
as
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
SELECT 
	shift, count(*) as total_orders
FROM hourly_sale
GROUP BY shift

--End






