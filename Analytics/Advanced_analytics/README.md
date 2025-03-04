--Analyze sales performance over time
--Changes over years
select 
YEAR(order_date) AS order_year,
SUM(sales_amount) as total_sales,
COUNT(distinct customer_key) as total_customers
from gold.fact_sales
where order_date is not null
group by YEAR(order_date)
order by order_year;

--changes over months

select 
YEAR(order_date) AS order_year,
MONTH(order_date) AS order_month,
SUM(sales_amount) as total_sales,
COUNT(distinct customer_key) as total_customers,
SUM(quantity) as total_quantity
from gold.fact_sales
where order_date is not null
group by YEAR(order_date), MONTH(order_date)
order by order_year, order_month;

---

select 
DATETRUNC(MONTH, order_date) AS order_month,
SUM(sales_amount) as total_sales,
COUNT(distinct customer_key) as total_customers,
SUM(quantity) as total_quantity
from gold.fact_sales
where order_date is not null
group by DATETRUNC(MONTH,(order_date))
order by order_month;

--CUMULATIVE ANALYSIS

--calculate the total sales per month
--th running total of sales over time


select 
order_date,
total_sales,
SUM(total_sales) over (order by order_date) as running_Total
from (
	select 
		DATETRUNC(month, order_date) as order_date,
		SUM(sales_amount) as total_sales
	from gold.fact_sales
	where order_date is not null
	group by DATETRUNC(month, order_date)
	) t

-- Performance Analysis

/* Analyze the performance of products by comparing their sales to both the average sales
performance of the product and the previous year's sales
*/

SELECT * ,
AVG(current_Sales) over (partition by product_name) as avg_sales,
current_sales - AVG(current_Sales) over (partition by product_name) as avg_diff,
CASE WHEN current_sales - AVG(current_Sales) over (partition by product_name) < 0 then 'Below Avg'
	 WHEN current_sales - AVG(current_Sales) over (partition by product_name) > 0 then 'Above Avg'
	 ELSE 'AVG'
END AS avg_change,
LAG(current_sales) over (partition by product_name order by order_year) as previous_sales,
current_sales - LAG(current_sales) over (partition by product_name order by order_year) as diff_py,
CASE WHEN current_sales - LAG(current_sales) over (partition by product_name order by order_year) < 0 then 'decrease'
	 WHEN current_sales - LAG(current_sales) over (partition by product_name order by order_year) > 0 then 'increase'
	 ELSE 'no change'
END AS 'py_change'
FROM (
	SELECT
	YEAR(f.order_date) as order_year,
		p.product_name as product_name,
		SUM(f.sales_amount) as current_sales
	FROM gold.fact_sales f
	left join gold.dim_product p
	on f.product_key = p.product_key
	where order_date is not null
	group by p.product_name,YEAR(f.order_date)) t

-- proportional Analysis

-- which countries contribute the most to overall sales

with total_sales as (
	select 
		c.country,
		sum(f.sales_amount) as sales
	from gold.fact_sales f
	left join gold.dim_customers c
	on f.customer_key = c.customer_key
	group by c.country
	)
select * , 
sum(sales) over () as overall_sales,
round(cast(sales as float)/ sum(sales) over () * 100, 2) as prct_of_total
from total_sales

-- which categories contribute the most to overall sales

with prd_sales as (
	select 
		p.category,
		sum(f.sales_amount) as sales
	from gold.fact_sales f
	left join gold.dim_product p
	on f.product_key = p.product_key
	group by p.category
	)
select * , 
sum(sales) over () as overall_sales,
concat(round(cast(sales as float)/ sum(sales) over () * 100, 2), '%') as prct_of_total
from prd_sales
order by sales desc

-- Data Segment
/* segment products into cost ranges and count how many products in each segment */

with cost_dim as(
	select 
	product_key,
	product_name, 
	cost ,
	case when cost < 100 then 'below 100'
	when cost between 100 and 500 then '100-500'
	when cost between 500 and 1000 then '500-1000'
	else 'Above 1000'
    end as cost_range
from gold.dim_product
)
select cost_range, count(product_key) as total_products
from cost_dim 
group by cost_range
order by total_products desc;

/* group customers into segments based on their spending behavior
- VIP: customers with at least 12 months of history and spending more than $5000
- Regular: customers with at least 12 months of history but spending  $5000 or less
- New: customers with lifespan less than 12 month 
And find total number of customers by each group
*/

with spending_t as (
	select 
	c.customer_key,
	SUM(sales_amount) as total_spending,
	MIN(order_date) as first_order,
	MAX(order_date) as last_order,
	DATEDIFF(month, min(f.order_date), max(f.order_date)) as lifespan
	from gold.fact_sales f
	left join gold.dim_customers c
	on f.customer_key = c.customer_key
	group by c.customer_key)


select customer_Segment,
count(customer_key) as total_customers 
from
(
	select 
	customer_key,
	case when total_spending > 5000 and lifespan >= 12 then 'VIP'
	when total_spending <= 5000 and lifespan >= 12 then 'Regular'
	else 'New'
	end as customer_Segment
	from spending_t) t
group by customer_Segment
order by total_customers;







	
