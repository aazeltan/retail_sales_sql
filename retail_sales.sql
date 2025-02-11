-- Create TABLE 
DROP TABLE IF EXISTS retail_sales; 
CREATE TABLE retail_sales(
	transactions_id INT PRIMARY KEY, 
	sale_date DATE, 
	sale_time TIME, 
	customer_id	INT, 
	gender VARCHAR(15),
	age	INT,
	category VARCHAR(15), 
	quantity INT, 
	price_per_unit FLOAT,	
	cogs FLOAT, 
	total_sale FLOAT
); 


SELECT * FROM retail_sales
LIMIT 10

--verify if the right data is uploaded --> check number of rows
SELECT 
	COUNT(*) 
FROM retail_sales

--DATA CLEARNING
--Deal with null values 
--Check for null values 
SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time IS NULL

SELECT * FROM retail_sales
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
	quantity IS NULL
	OR 
	price_per_unit IS NULL 
	OR 
	cogs IS NULL
	OR 
	total_sale IS NULL

--Deleting rows with null values from the table 
DELETE FROM retail_sales 
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
	quantity IS NULL
	OR 
	price_per_unit IS NULL 
	OR 
	cogs IS NULL
	OR 
	total_sale IS NULL
-- 

-- DATA EXPLORATION 

-- How many sales do we have? 1987
SELECT COUNT(*) as total_sales FROM retail_sales; 

-- How many unique customers do we have? 155
SELECT COUNT(DISTINCT customer_id) as total_sales FROM retail_sales; 

-- How many unique categories do we have? 3
SELECT COUNT(DISTINCT category) as total_sales FROM retail_sales; 
SELECT DISTINCT category FROM retail_sales; 
-- 

-- DATA ANALYSIS 
-- Qn 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:

SELECT * FROM retail_sales 
WHERE sale_date = '2022-11-05'

-- Qn 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022:

SELECT * FROM retail_sales 
WHERE category = 'Clothing' 
	AND 
	sale_date BETWEEN '2022-11-01' AND '2022-11-30'
	AND 
	quantity >= 4 

SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4

-- Qn 3. Write a SQL query to calculate the total sales (total_sale) for each category.: 
SELECT 
	category,
	SUM(total_sale) AS net_sales, 
	SUM(quantity) AS total_quantity, 
	COUNT(transactions_id) As total_transactions 
FROM retail_sales 
GROUP BY category 

-- Qn 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT 
	category, 
	ROUND(AVG(age),2) as avg_age
FROM retail_sales 
WHERE category = 'Beauty'
GROUP BY category 

-- Qn 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.: 

SELECT * FROM retail_sales 
WHERE total_sale> 1000;

-- Qn 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.: 

SELECT 
	COUNT(*) AS total_transactions, 
	category, 
	gender 
FROM retail_sales
GROUP BY category, gender; 

-- Qn 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year: 
WITH sales AS( 
	SELECT 
		AVG(total_sale) AS avg_sale, 
		EXTRACT(YEAR FROM sale_date) as year, 
		EXTRACT(MONTH FROM sale_date) as month, 
		RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC)
	FROM retail_sales 
	GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
)

SELECT
	year,
	month, 
	avg_sale
FROM sales 
WHERE rank = 1


-- Qn 8. Write a SQL query to find the top 5 customers based on the highest total sales: 

SELECT 
	customer_id, 
	SUM(total_sale) AS sale_per_person
FROM retail_sales 
GROUP BY customer_id ORDER BY SUM(total_sale) DESC 
LIMIT 5

-- Qn 9. Write a SQL query to find the number of unique customers who purchased items from each category.: 

SELECT 
	COUNT(DISTINCT(customer_id)) as unique_customers, 
	category
FROM retail_sales 
GROUP BY category 

-- Qn 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH schedule AS(
	SELECT *, 
		CASE 
			WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning' 
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END as shift 
	FROM retail_sales
) 

SELECT 
	shift, 
	COUNT(transactions_id) AS num_of_orders 
FROM schedule 
GROUP BY shift

--End of project