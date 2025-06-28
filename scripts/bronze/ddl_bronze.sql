/*
===============================================================================
Script: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This script loads data into the 'bronze' database from external CSV files.
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `LOAD DATA LOCAL INFILE` command to load data from CSV files 
      into the bronze tables.

Note:
    MySQL does not support schemas the same way as SQL Server, so we use 
    separate databases. This script assumes you're inside the MySQL CLI 
    with --local-infile=1 enabled.

Usage:
    Run in CLI: 
        mysql -u root -p --local-infile=1 < bronze_load.sql
    You can also use Table Import Wizard to insert the data into the table.

    Ensure all CSV files exist at the correct paths and match table structures.
===============================================================================
*/

USE bronze;

-- =============================================================================
-- Loading CRM Tables
-- =============================================================================

-- Load crm_cst_info
TRUNCATE TABLE crm_cst_info;
LOAD DATA LOCAL INFILE 'C:/sql/dwh_project/datasets/source_crm/cust_info.csv'
INTO TABLE crm_cst_info
FIELDS TERMINATED BY ',' 
IGNORE 1 LINES;

-- Load crm_prd_info
TRUNCATE TABLE crm_prd_info;
LOAD DATA LOCAL INFILE 'C:/sql/dwh_project/datasets/source_crm/prd_info.csv'
INTO TABLE crm_prd_info
FIELDS TERMINATED BY ',' 
IGNORE 1 LINES;

-- Load crm_sales_details
TRUNCATE TABLE crm_sales_details;
LOAD DATA LOCAL INFILE 'C:/sql/dwh_project/datasets/source_crm/sales_details.csv'
INTO TABLE crm_sales_details
FIELDS TERMINATED BY ',' 
IGNORE 1 LINES;

-- =============================================================================
-- Loading ERP Tables
-- =============================================================================

-- Load erp_CUST_AZ12
TRUNCATE TABLE erp_CUST_AZ12;
LOAD DATA LOCAL INFILE 'C:/sql/dwh_project/datasets/source_erp/cust_az12.csv'
INTO TABLE erp_CUST_AZ12
FIELDS TERMINATED BY ',' 
IGNORE 1 LINES;

-- Load erp_LOC_A101
TRUNCATE TABLE erp_LOC_A101;
LOAD DATA LOCAL INFILE 'C:/sql/dwh_project/datasets/source_erp/loc_a101.csv'
INTO TABLE erp_LOC_A101
FIELDS TERMINATED BY ',' 
IGNORE 1 LINES;

-- Load erp_PX_CAT_G1V2
TRUNCATE TABLE erp_PX_CAT_G1V2;
LOAD DATA LOCAL INFILE 'C:/sql/dwh_project/datasets/source_erp/px_cat_g1v2.csv'
INTO TABLE erp_PX_CAT_G1V2
FIELDS TERMINATED BY ',' 
IGNORE 1 LINES;

/*
===============================================================================
End of Bronze Layer Load Script
===============================================================================
*/
