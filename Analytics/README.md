# 📊 Exploratory Data Analysis (EDA) Using SQL  

## **Introduction**  
This document contains a series of **SQL queries** designed to perform **Exploratory Data Analysis (EDA)** on the newly created database. 
The goal of this analysis is to extract key **metrics, KPIs, and general insights** about the dataset before diving into deeper analytics or dashboard creation.  

## **Objectives of EDA**  
- Understand the **structure and quality** of the data.    
- Compute **summary statistics** such as total records, unique values, and distributions.  
- Generate **key business KPIs** like total sales, average revenue, customer retention rate, etc.  
- Uncover **trends and patterns** in the dataset.  

## **Scope of Analysis**  
The SQL queries in this file will focus on:  
1. **General Dataset Overview** – Count of records, unique values, missing data.  
2. **Sales Metrics** – Total revenue, average order value, highest-selling products.  
3. **Customer Insights** – Customer demographics, high-value customers.  
4. **Product Performance** – Best-selling products, least-selling items, category performance.  

Let’s dive into the data 🚀
---
1- Explore all columns in the dim_customers table:
```sql
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';
```

2- Explore all countries our customers come from:
```sql
SELECT
  DISTINCT country
FROM gold.dim_customers;
```

3- Explore all categories in the product dimension:
```sql
SELECT
  DISTINCT category, subcategory, product_name 
FROM gold.dim_product
ORDER  BY 1, 2, 3;
```
4- Identify earliest and latest date of the order AND How many years of sales are available:
```sql
SELECT
  MIN(order_date) AS first_order_date, 
  MAX(order_date) AS last_order_date,
  DATEDIFF(YEAR, MIN(order_date), MAX(order_Date)) AS order_range
FROM gold.fact_sales;
```
5- Find the youngest and oldest customer:
```sql
SELECT
  MIN(birthdate) AS youngest_customer ,
  DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS age_oldest,
  MAX(birthdate) AS oldest_customer,
  DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS age_youngest
FROM gold.dim_customers;
```
```sql
=====================================================================================================================
--Explore Measures in the fact table
=====================================================================================================================
```
6- Find the total sales:
```sql
SELECT
  SUM(sales_amount) AS total_sales
FROM gold.fact_sales;
```
7- Find how many items are sold:
```sql
SELECT 
  SUM(quantity) AS total_items_Sold 
FROM gold.fact_sales;
```
8- Find the average selling price:
```sql
SELECT
  AVG(price) AS avg_Selling_price 
FROM gold.fact_sales;
```
9- Find the total number of orders:
```sql
SELECT
  COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales;
```
10- Find the total number of products:
```sql
SELECT
  COUNT(product_name) AS total_products 
FROM gold.dim_product;
```
11- Find the total number of customers:
```sql
SELECT
  COUNT(customer_key) AS total_customers
FROM gold.dim_customers;
```
12- find the total number of customers who placed an order:
```sql
SELECT
  COUNT(distinct customer_key) AS total_customers
FROM gold.fact_sales;
```
```sql
==================================================================================================================
-- Generate a report that shows all key metrices of the business
==================================================================================================================
```
```sql
SELECT 'Total Sales' AS measure_name, 
SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL 
SELECT 'Total Nr. Customers' , COUNT(customer_key) FROM gold.dim_customers
UNION ALL
SELECT 'Total Nr. Products', COUNT(product_name) FROM gold.dim_product
UNION ALL
SELECT 'Avg Selling Price' ,  AVG(price) FROM gold.fact_sales
UNION ALL 
SELECT 'Total Nr. Orders' , COUNT(DISTINCT order_number) FROM gold.fact_sales
```
```sql
==================================================================================================================
--Generate a magnitude analysis
==================================================================================================================
```

1- Find total customers by countries: 
```sql
SELECT
  country,
  COUNT(customer_key) AS total_Customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;
```
2- Find total customers by gender:
```sql
SELECT
  gender,
  COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;
```
3- Find total products by category: 
```sql
SELECT
  category,
  COUNT(product_name) AS total_products
FROM gold.dim_product
GROUP BY category
ORDER BY total_products DESC;
```
4- What is the average cost in each category?:
```sql
SELECT
  category,
  AVG(cost) AS avg_costs
FROM gold.dim_product
GROUP BY category
ORDER BY avg_costs DESC;
```
5- What is the total revenue generated for each category?:
```sql
SELECT
  p.category,
  SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_product p
  ON f.product_key = p.product_key
GROUP BY category
ORDER BY total_revenue DESC;
```
6- What is the total revenue generated by each customer?:
```sql
SELECT
  c.customer_key,
  c.firstname , 
  c.lastname ,
  SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
  ON f.customer_key = c.customer_key
GROUP BY c.customer_key,c.firstname, c.lastname
ORDER BY total_revenue DESC;
```
7- What is the distribution of sold items across countries?:
```sql
SELECT
  c.country,
  SUM(f.quantity) AS sold_items
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
  ON f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY sold_items DESC;
```
8- Which 5 products generate the highest revenue?:
```sql
SELECT TOP 5
	  p.product_name,
	  SUM(f.sales_amount) AS total_revenue
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_product p
	  ON f.product_key = p.product_key
	GROUP BY p.product_name
	ORDER BY total_revenue DESC;
```
9- What are the worst performing products in terms of sales?:
```sql
SELECT TOP 5
  p.product_name,
	SUM(f.sales_amount) as total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_product p
	ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC;
```
10- Find top 10 customers who generated the highest revenue?:
```sql
SELECT TOP 10
	c.customer_key,
	c.firstname,
	c.lastname,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
	ON f.customer_key = c.customer_key
GROUP BY c.customer_key,c.firstname, c.lastname
ORDER BY total_revenue DESC;
```

