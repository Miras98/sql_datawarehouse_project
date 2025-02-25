/*
===================================================================================
Quality Checks
===================================================================================
Script Purpose:
This script performs several quality checks foe data consistency, accuracy
and standardization across the 'Silver' schema. it includes checks for:
-Nulls or duplicate values
-Unwanted spaces in string fields
- Data standardization and Consistency
-Invalid date ranges or orders
- Data consistency between related fields

Usage notes:
-Run these checks after loading data in the Silver schema
===================================================================================
*/
-- Check 'crm_cust_info'
-- ===========================================================

-- check for duplicates or null values in primary key
-- EXpectations : no results

SELECT cst_id , COUNT(*) 
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

--check for unwanted spaces

SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

SELECT cst_firstname 
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)

-- Data Consistency and Standardization

SELECT DISTINCT cst_key 
FROM silver.crm_cust_info

SELECT DISTINCT cst_gndr  
FROM silver.crm_cust_info

SELECT DISTINCT cst_marital_status  
FROM silver.crm_cust_info

--===========================================================
-- Check 'crm_prd_info'
--===========================================================
--check for duplicates or null values in primary key
--EXpectations : no results

SELECT prd_id , COUNT(*) 
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

--check for unwanted spaces

SELECT prd_nm 
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

--check for nulls or negative numbers

SELECT prd_cost 
FROM silver.crm_prd_info
WHERE  prd_cost < 0 OR prd_cost IS NULL

-- Data Standardization and consistency
SELECT distinct prd_line 
FROM silver.crm_prd_info

-- check for invalid dates

SELECT * 
FROM silver.crm_prd_info
WHERE prd_start_dt > prd_end_dt

--===========================================================
-- Check 'crm_sales_details'
--===========================================================
--check unwanted spaces
SELECT sls_ord_num 
FROM silver.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num)

--check for invalid date order
SELECT * 
FROM silver.crm_sales_details
WHERE sls_ord_dt > sls_ship_dt
OR sls_ord_dt > sls_due_dt

-- check data consistency bet. sales, quantity and price
--> sales= quantity * price
-- values must not be zero, negative or null

SELECT sls_sales,
sls_quantity,
sls_price
FROM silver.crm_sales_details
WHERE sls_Sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0


--===========================================================
-- Check 'erp_cust_az12'
--===========================================================

--check out-of-range dates
SELECT bdate 
FROM silver.erp_cust_az12
WHERE bdate > getdate()

--data consistency & standardization
SELECT DISTINCT gen 
FROM silver.erp_cust_az12

--===========================================================
-- Check 'erp_loc_a101'
--===========================================================

--data consistency & standardization
SELECT DISTINCT cntry 
FROM silver.erp_loc_a101

--===========================================================
-- Check 'erp_px_cat_g1v2'
--===========================================================

--check for unwanted spaces

SELECT * FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) 
OR subcat != TRIM(subcat)
OR maintenance != TRIM(maintenance)

-- check Data consistency & standardization

SELECT DISTINCT cat 
FROM silver.erp_px_cat_g1v2




