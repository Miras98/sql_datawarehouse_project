/*
===================================================================================================
Stored Procedure : Load Bronze Layer(source >> Bronze)
===================================================================================================
Script Purpose:
This stored procedure loads data into 'bronze' schema from external CSV files using Bulk insert
It Truncates the bronze tables before loading the data
Parameters:
None
This stored procedure does not accept any parameters or return any values

Usage Example:
EXEC bronze.load_bronze;
====================================================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME;
	BEGIN TRY
		PRINT '==========================================================================';
		PRINT 'LOADING BRONZE LAYER';
		PRINT '==========================================================================';

		PRINT'---------------------------------------------------------------------------';
		PRINT' LOADING CRM TABLES';
		PRINT '--------------------------------------------------------------------------';
		SET @start_time = GETDATE();
		PRINT'>> Truncating Table bronze.crm_cust_info'
		Truncate table bronze.crm_cust_info;
		print'>> Inserting Data Into: bronze.crm_cust_info'
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\DELL\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR= ',',
			TABLOCK
			);
			SET @end_time = GETDATE();
			PRINT'>> LOAD DURATION :' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
			print'>>..........................';

		SET @start_time = GETDATE();
		PRINT'>> Truncating Table bronze.crm_prd_info'
		Truncate table bronze.crm_prd_info;
		print'>> Inserting Data Into: bronze.crm_prd_info'
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\DELL\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR= ',',
			TABLOCK
			);
			SET @end_time = GETDATE();
			PRINT'>> LOAD DURATION :' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
			print'>>..........................';

		SET @start_time = GETDATE();
		PRINT'>> Truncating Table bronze.crm_sales_details'
		Truncate table bronze.crm_sales_details;
		print'>> Inserting Data Into: bronze.crm_sales_details'
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\DELL\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR= ',',
			TABLOCK
			);
			SET @end_time= GETDATE();
			PRINT'>> LOAD DURATION :' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
			print'>>..........................';


		PRINT'---------------------------------------------------------------------------'
		PRINT' LOADING ERP TABLES'
		PRINT'---------------------------------------------------------------------------'
		SET @start_time= GETDATE();

		PRINT'>> Truncating Table bronze.erp_cust_az12'
		Truncate table bronze.erp_cust_az12;
		print'>> Inserting Data Into: bronze.erp_cust_az12'
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\DELL\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR= ',',
			TABLOCK
			);
			SET @end_time= GETDATE();
			PRINT'>> LOAD DURATION :' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
			print'>>..........................';

		SET @start_time= GETDATE();
		PRINT'>> Truncating Table bronze.erp_loc_a101'
		Truncate table bronze.erp_loc_a101;
		print'>> Inserting Data Into: bronze.erp_loc_a101'
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\DELL\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR= ',',
			TABLOCK
			);
			SET @end_time = GETDATE();
			PRINT'>> LOAD DURATION :' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
			print'>>..........................';

		SET @start_time = GETDATE();
		PRINT'>> Truncating Table bronze.erp_px_cat_g1v2'
		Truncate table bronze.erp_px_cat_g1v2;
		print'>> Inserting Data Into: bronze.erp_px_cat_g1v2'
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\DELL\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR= ',',
			TABLOCK
			);
			SET @end_time = GETDATE()
			PRINT'>> LOAD DURATION :' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
			print'>>..........................';

		END TRY
		BEGIN CATCH
			PRINT'==========================================='
			PRINT' ERROR OCCURED DURING LOADING BRONZE LAYER'
			PRINT'Error Message' + ERROR_MESSAGE();
			PRINT'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
			PRINT'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
			PRINT'==========================================='
		END CATCH
END
