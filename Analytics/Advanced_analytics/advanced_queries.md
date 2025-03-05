
## **Introduction**  
This document contains advanced **data analysis** of sales performance over time, cumulative analysis, product trends,customer segmentation.
The goal is to uncover **key patterns, trends, and insights** that can drive data-driven decision-making.  

By analyzing sales across **different time periods, product categories, and customer segments**, we aim to identify:  
- Seasonal trends and long-term growth patterns 📅  
- Top-performing products and underperforming items 🛍️  
- High-value customer groups and retention strategies 👥

```sql
--Analyze sales performance over time
--Changes over years or months
```
```sql
SELECT  
	YEAR(order_date) AS order_year,
	MONTH(order_date) AS order_month,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY order_year,order_month;
```
```sql
==================================================================================================================================
--CUMULATIVE ANALYSIS
==================================================================================================================================
```
```sql
--calculate the total sales per month
--the running total of sales over time
```
```sql 
SELECT  
	order_date,
	total_sales,
	SUM(total_sales) over (order by order_date) AS running_Total
FROM (
	SELECT 
		DATETRUNC(MONTH, order_date) AS order_date,
		SUM(sales_amount) AS total_sales
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY  DATETRUNC(MONTH, order_date)
	) t
```
```sql
=================================================================================================================================
-- Performance Analysis
=================================================================================================================================
```
```sql
/* Analyze the performance of products by comparing their sales to both the average sales
performance of the product and the previous year's sales
*/
```
```sql
SELECT * ,
	AVG(current_Sales) OVER (PARTITION BY  product_name) AS avg_sales,
	current_sales - AVG(current_Sales) OVER (PARTITION BY product_name) AS avg_diff,
	CASE WHEN current_sales - AVG(current_Sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
		 WHEN current_sales - AVG(current_Sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
		 ELSE 'AVG'
	END AS avg_change,
	LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS previous_sales,
	current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_py,
	CASE WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'decrease'
		 WHEN current_sales - LAG(current_sales) over (partition by product_name order by order_year) > 0 THEN 'increase'
		 ELSE 'no change'
	END AS 'py_change'
FROM (
	SELECT
		YEAR(f.order_date) AS order_year,
		p.product_name AS product_name,
		SUM(f.sales_amount) AS current_sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_product p
		ON f.product_key = p.product_key
	WHERE order_date IS NOT NULL
	GROUP BY p.product_name,YEAR(f.order_date)) t
```
```sql
==============================================================================================================================
-- proportional Analysis
==============================================================================================================================
```
```sql
-- which countries contribute the most to overall sales
```
```sql
WITH total_sales AS (
	SELECT 
		c.country,
		SUM(f.sales_amount) AS sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_customers c
           ON f.customer_key = c.customer_key
	GROUP BY c.country
	)
SELECT * , 
SUM(sales) OVER () AS overall_sales,
ROUND(CAST(sales AS float)/ SUM(sales) OVER () * 100, 2) AS prct_of_total
FROM total_sales
```
```sql
-- which categories contribute the most to overall sales?
```
```sql
WITH prd_sales AS (
	SELECT 
		p.category,
		SUM(f.sales_amount) AS sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_product p
	ON f.product_key = p.product_key
	GROUP BY p.category
	)
SELECT * , 
SUM(sales) OVER () AS overall_sales,
CONCAT(ROUND(CAST(sales AS float)/ SUM(sales) OVER () * 100, 2), '%') AS prct_of_total
FROM prd_sales
ORDER BY sales desc
```
```sql
-- segment products into cost ranges and count how many products in each segment 
```
```sql
WITH cost_dim AS(
	SELECT 
	product_key,
	product_name, 
	cost ,
	CASE WHEN cost < 100 THEN 'below 100'
	     WHEN cost BETWEEN 100 AND 500 THEN '100-500'
	     WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
	ELSE 'Above 1000'
        END AS  cost_range
FROM gold.dim_product
)
SELECT cost_range, COUNT(product_key) AS total_products
FROM cost_dim 
GROUP BY cost_range
ORDER BY total_products DESC;
```
```sql

/* group customers into segments based on their spending behavior
- VIP: customers with at least 12 months of history and spending more than $5000
- Regular: customers with at least 12 months of history but spending  $5000 or less
- New: customers with lifespan less than 12 month 
And find total number of customers by each group
*/
```
```sql
WITH spending_t AS (
	SELECT 
		c.customer_key,
		SUM(sales_amount) AS total_spending,
		MIN(order_date) AS first_order,
		MAX(order_date) AS last_order,
		DATEDIFF(MONTH, MIN(f.order_date), MAX(f.order_date)) AS lifespan
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_customers c
	ON f.customer_key = c.customer_key
	GROUP BY c.customer_key)

SELECT
	customer_Segment,
	COUNT(customer_key) AS total_customers 
FROM
(
    SELECT 
	customer_key,
	CASE WHEN total_spending > 5000 AND lifespan >= 12 THEN 'VIP'
	WHEN total_spending <= 5000 AND lifespan >= 12 THEN 'Regular'
	ELSE 'New'
	END AS customer_Segment
    FROM spending_t) t
GROUP BY customer_Segment
ORDDER BY total_customers;
```






	
