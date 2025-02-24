/*
===================================================================================
Create Database and Schemas
===================================================================================

Script Purpose:
This script creates a new database called 'DataWarehouse' after checking if it already exists
if the database exist, it dropped and recreated. Additionally, the script sets up three schemas within the database : 'bronze', 'silver', 'gold'
*/

USE Master;
GO

-- drop and recreate the 'DataWarehouse' database

IF EXISTS ( SELECT 1 FROM sys.databases WHERE name= 'DataWarehouse')
BEGIN
  ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE
END;
GO

-- create the 'DataWarehouse' database

CREATE DATABASE DataWarehouse
GO

USE DataWarehouse;
GO

  
-- create schemas

CREATE SCHEMA bronze;
GO
  
CREATE SCHEMA silver;
GO
  
CREATE SCHEMA gold;
GO

