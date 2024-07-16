CREATE DATABASE walmart_sales;

CREATE TABLE sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT (6, 4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10, 2) NOT NULL,
    gross_margin_pct FLOAT(11, 9),
    gross_income DECIMAL(12, 4) NOT NULL,
    rating FLOAT (2,1)
);
-- ----------------------------  Feature Engineering  -----------------------------------------
SELECT
    time,
    (CASE 
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END) AS time_of_date
FROM sales

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
    CASE 
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END
    );

-- time of day
SELECT
	date,
    DAYNAME(date) AS day_name
FROM 
	sales;
    
ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

-- month_name
SELECT date,
	MONTHNAME(date) as month_name
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);


-- -------------------------------------- Generic ---------------------------------------------

-- How many unique cities does the data have?
SELECT
	DISTINCT city
FROM sales;

SELECT
	DISTINCT city,
    branch
FROM sales;

-- In which city is each branch? 
SELECT
	DISTINCT branch
FROM sales;

-- ------------------------------------   Product  --------------------------------------------

-- How many unique product lines does that data have?
SELECT COUNT(DISTINCT product_line)
FROM sales;

-- What is the most common payment method?
SELECT 
	payment_method,
    COUNT(payment_method) AS cnt
FROM sales
	GROUP BY payment_method
    ORDER BY cnt desc;
    
-- What is the most selling product line?
SELECT 
	product_line,
    COUNT(product_line) AS cnt
FROM sales
	GROUP BY product_line
    ORDER BY cnt desc;
    
-- What is the total revenue by month?
SELECT
	month_name AS month,
	SUM(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue desc;

-- What month had the largest COGS?
SELECT
	month_name AS month,
	SUM(cogs) AS cogs
FROM sales
GROUP BY month_name
ORDER BY cogs desc;

-- What product line had the largest revenue?
SELECT product_line,
	SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

--  What is the city with the largest revenue?
SELECT city, branch,
	SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch
ORDER BY total_revenue DESC;

-- What product line had the largest VAT?
SELECT product_line,
SUM(VAT) as total_vat
FROM sales
GROUP BY product_line
ORDER by total_vat desc;

-- What product line had the largest VAT?
SELECT 
	product_line, 
    AVG(VAT) as avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- Fetch each product line and add a column to those product line showing 'Good','Bad'. Good if its greather than average sales


-- Which brnach sold more producdt than average product sold?
SELECT branch,
	SUM(quantity) AS qty
    FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- What is the most common product line by gender?
SELECT gender,
	product_line,
    COUNT(gender) as cnt
FROM sales
GROUP BY gender, product_line
ORDER BY cnt desc;

-- What is the average rating of each product?
SELECT 
	ROUND(AVG(rating), 2) AS avg_rating,
    product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating desc;

-- ------------------------------------- Sales ------------------------------------------------

-- Number of sales made in each time of the day per weekday
SELECT 
	time_of_day,
    COUNT(*) AS total_sales
FROM sales
GROUP BY time_of_day
ORDER by total_sales desc;

-- Which of the customer types bring the most revenue?
SELECT 
	SUM(customer_type) as cst,
    total
FROM sales
GROUP BY cst
ORDER BY total;

SELECT 
	customer_type,
    SUM(total) as total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue desc;

-- Which city has the largest percent/VAT?

SELECT 
	city,
	AVG(VAT) as vat_total
FROM
	sales
GROUP BY city
ORDER BY vat_total desc;

-- Which customer type pays the most in VAT?
SELECT
	customer_type,
    AVG(VAT) as vat
FROM sales
GROUP BY customer_type
ORDER BY vat desc;

-- ------------------------------------ Customers --------------------------------------------

-- How many unique customer types does the data have?
SELECT DISTINCT customer_type
FROM sales;

-- How many unique payments methods does the data have?
SELECT DISTINCT payment_method
FROM sales;

-- What is the most common customer type?
SELECT customer_type, COUNT(*) as count
FROM sales
GROUP BY customer_type
ORDER BY count desc;

-- Which customer type buys the most?
SELECT
	customer_type,
    COUNT(*) as customer_cnt
FROM sales
GROUP BY customer_type
ORDER BY customer_cnt;

-- What is the gender of the most of the customer?
SELECT
	gender, 
    COUNT(*) as gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt desc;

-- What is the gender distrubution per branch?
SELECT
	gender, 
    COUNT(*) as gender_cnt
FROM sales
WHERE branch = "A"
GROUP BY gender
ORDER BY gender_cnt desc;

-- What time of the day do customer give most ratings?
SELECT
	time_of_day,
    AVG(rating) as avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating desc;

-- Which time of the day do customers give most ratings per branch?
SELECT
	time_of_day,
    AVG(rating) as avg_rating
FROM sales
WHERE branch = "B"
GROUP BY time_of_day
ORDER BY avg_rating desc;

-- Which day of the week has the best avg rating?
SELECT 
	day_name,
    AVG(rating) as avg_rating
FROM sales
GROUP by day_name
ORDER by avg_rating desc;
    
-- Which day of the week has the best average rating per branch?
SELECT 
	day_name,
    AVG(rating) as avg_rating
FROM sales
WHERE branch = "A"
GROUP by day_name
ORDER by avg_rating desc;



