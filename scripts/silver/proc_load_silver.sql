CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN 
	PRINT '============================================================'
	PRINT' Loading Silver Data '
	PRINT'============================================================='
	
	PRINT'-------------------------------------------------------------'
	PRINT'Loading CRM Data'
	PRINT'-------------------------------------------------------------'

	PRINT'Truncate Table: silver.crm_cust_info'
	TRUNCATE TABLE silver.crm_cust_info

	PRINT'Insert into table :silver.crm_cust_info'

	insert into silver.crm_cust_info (
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		cst_marital_status,
		cst_gndr,
		cst_create_date
		)

	select cst_id,
		cst_key, 
		TRIM(cst_firstname) as cst_firstname,
		TRIM(cst_lastname) as cst_lastname,
		CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single' 
			 WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
			 ELSE 'Unkown'
		END as cst_marital_status,  -- normalize marital status to be more readable
		CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'     
			 WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
			 ELSE 'Unkown'
		END as cst_gndr, --normalize gndr column to be more readable
		cst_create_date
	from(
		select *,
		row_number() over (partition by cst_id order by cst_create_date DESC) as flag_last
		from bronze.crm_cust_info
		where cst_id is not null) as t  --remove duplicates
	where flag_last = 1  -- select the most recent record per customer

	PRINT'Truncate Table: silver.crm_prd_info'
	TRUNCATE TABLE silver.crm_prd_info

	PRINT'Insert Data into Table: silver.crm_prd_info'
	insert into silver.crm_prd_info(
	prd_id,
	cat_id,
	prd_key,
	prd_nm ,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
	)
	select 
	prd_id,
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') as cat_id,    -- extract cat_id to connect it with the category table
	SUBSTRING(prd_key, 7, len(prd_key)) as prd_key,           -- extract prd_key to be connected with the sales table
	prd_nm,
	ISNULL(prd_cost,0) AS prd_cost,
	CASE WHEN UPPER(TRIM(prd_line)) ='M' THEN 'Mountain'
		 WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
		 WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'other Sales'
		 WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
		 ELSE 'n/a'
		 END AS prd_line,
	CAST(prd_start_dt AS DATE),
	CAST(LEAD(prd_Start_dt) over (PARTITION BY prd_key ORDER BY prd_start_dt) -1 AS DATE) 
	as prd_end_dt --calculate end date as 1 day before the next start date
	from bronze.crm_prd_info;

	PRINT'Truncate Table: silver.crm_sales_details'
	TRUNCATE TABLE silver.crm_sales_details

	PRINT'Insert Data into Table : silver.crm_sales_details'
	INSERT INTO silver.crm_sales_details (
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		sls_ord_dt, 
		sls_ship_dt,
		sls_due_dt,
		sls_sales, 
		sls_quantity,
		sls_price
	)
	select sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	CASE WHEN sls_ord_dt <= 0 or LEN(sls_ord_dt) != 8 THEN NULL
		 ELSE CAST(CAST(sls_ord_dt as VARCHAR) AS DATE)
	END AS sls_ord_dt,
	CASE WHEN sls_ship_dt <= 0 or LEN(sls_ship_dt) != 8 THEN NULL
		 ELSE CAST(CAST(sls_ship_dt as VARCHAR) AS DATE)
	END AS sls_ship_dt,
	CASE WHEN sls_due_dt <= 0 or LEN(sls_due_dt) != 8 THEN NULL
		 ELSE CAST(CAST(sls_due_dt as VARCHAR) AS DATE)
	END AS sls_due_dt,
	CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
		 THEN sls_quantity * ABS(sls_price)
		 ELSE sls_sales
	END AS sls_sales,
	sls_quantity,
	CASE WHEN sls_price IS NULL OR sls_price <= 0
		 THEN sls_sales / NULLIF(sls_quantity, 0)
		 ELSE sls_price
	END AS sls_price
	FROM bronze.crm_sales_details;

	PRINT'--------------------------------------------------------'
	PRINT'LOADING ERP DATA'
	PRINT'--------------------------------------------------------'

	PRINT'Truncate table :silver.erp_cust_az12'
	TRUNCATE TABLE silver.erp_cust_az12

	PRINT'Insert Data into Table: silver.erp_cust_az12'
	insert into silver.erp_cust_az12(cid, bdate, gen)
	select 
	CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
	ELSE cid
	END AS cid,
	CASE WHEN bdate > GETDATE() THEN NULL --set future bdate to null
		 ELSE bdate
	END AS bdate,
	CASE WHEN UPPER(TRIM(gen)) IN ('F', 'Female') THEN 'Female'
		 WHEN UPPER(TRIM(gen)) IN ('M', 'Male') THEN 'Male'
		 ELSE 'n/a' --handle different gender types
	END AS gen
	from bronze.erp_cust_az12;

	PRINT'Truncate Table :silver.erp_loc_a101'
	TRUNCATE TABLE silver.erp_loc_a101

	PRINT'Insert Data Into Table : silver.erp_loc_a101'
	insert into silver.erp_loc_a101(cid, cntry)
	select REPLACE(cid,'-','') as cid,
	CASE WHEN cntry = 'DE' THEN 'Germany'
	WHEN cntry in ('USA', 'US') THEN 'United States'
	WHEN cntry IS NULL OR TRIM(cntry) = '' THEN 'n/a'
	ELSE TRIM(cntry)
	END AS cntry
	from bronze.erp_loc_a101;

	PRINT'Truncate Table: silver.erp_px_cat_g1v2'

	TRUNCATE TABLE silver.erp_px_cat_g1v2;
	PRINT'Insert Data into Table: silver.erp_px_cat_g1v2'

	insert into silver.erp_px_cat_g1v2(id, cat, subcat, maintenance)
	select id, 
	cat,
	subcat,
	maintenance
	from bronze.erp_px_cat_g1v2;
END

exec silver.load_silver;

