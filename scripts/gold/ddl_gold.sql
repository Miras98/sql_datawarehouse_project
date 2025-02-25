/*
============================================================================================
DDL Script: Create Gold Views
============================================================================================
Sript Purpose:
This script create views for the Gold Layer in the data warehouse.
This gold layer represents the final dimension and fact tables (Start Schema).

Each view performs transformations and combine data from the silver layer 
to produce clean, enriched and business-ready dataset.

Usage:
These views can be queried directly for reporting and analysis puproses.
===========================================================================================
*/

-- ========================================================================================
-- Create Dimension Table: gold.dim_Customers
-- =========================================================================================

IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
	DROP VIEW gold.dim_customers;
GO
  
CREATE VIEW gold.dim_customers AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY cst_id ) as customer_key,      --surrogate key
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS firstname,
	ci.cst_lastname AS lastname,
	la.cntry as country,
	ci.cst_marital_status AS marital_status,
	CASE WHEN ci.cst_gndr != 'Unkown' THEN ci.cst_gndr        --crm is the master for gender info
		   ELSE COALESCE(ca.gen, 'n/a')
	END AS  gender,
	ca.bdate AS birthdate,
	ci.cst_create_date AS create_date
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca
	ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 AS la
	ON ci.cst_key = la.cid
GO

-- ========================================================================================
-- Create Dimension Table: gold.dim_products
-- =========================================================================================

IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
	DROP VIEW gold.dim_products;
GO
CREATE VIEW gold.dim_products AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) as product_key,
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,
	px.cat AS category,
	px.subcat AS subcategory,
	px.maintenance,
	pn.prd_cost AS cost,
	pn.prd_line AS product_line,
	pn.prd_start_dt AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 px
  ON pn.cat_id = px.id
WHERE  pn.prd_end_dt IS NULL  -- filter out all historical data
GO

-- ========================================================================================
-- Create Fact Table: gold.fact_sales
-- =========================================================================================
  
IF OBJECT_ID('gold.fact_Sales', 'V') IS NOT NULL
	DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT 
	si.sls_ord_num as order_number,
	pr.product_key,
	cu.customer_key,
	si.sls_ord_dt as order_date,
	si.sls_ship_dt as shipping_date,
	si.sls_due_dt as due_date,
	si.sls_sales as sales_Amount,
	si.sls_quantity as quantity,
	si.sls_price as price
FROM silver.crm_sales_Details si
LEFT JOIN gold.dim_product pr
  ON si.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
  ON si.sls_cust_id = cu.customer_id;
GO
