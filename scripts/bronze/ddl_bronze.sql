/*
===============================================================================
Script: Bronze Layer Setup and Load (Source -> Bronze)
===============================================================================
Script Purpose:
    This script creates the 'bronze' database and all necessary tables,
    then loads data from external CSV files using `LOAD DATA LOCAL INFILE`.
    It performs the following:
    - Creates the 'bronze' database if it doesn't exist
    - Creates CRM and ERP tables
    - Truncates each table before loading (if it already exists)
    - Loads data from CSV files

Requirements:
    - MySQL server must be run with --local-infile=1
    - Run this script from CLI using:
        mysql -u root -p --local-infile=1 < bronze_setup_and_load.sql

Directory Structure Expected:
    datasets/
      └── source_crm/
          ├── cust_info.csv
          ├── prd_info.csv
          └── sales_details.csv
      └── source_erp/
          ├── cust_az12.csv
          ├── loc_a101.csv
          └── px_cat_g1v2.csv
===============================================================================
*/

-- ============================================================================
-- Step 1: Create Bronze Database and Use It
-- ============================================================================
CREATE DATABASE IF NOT EXISTS bronze;
USE bronze;

-- ============================================================================
-- Step 2: Create CRM Tables
-- ============================================================================

DROP TABLE IF EXISTS crm_cst_info;
CREATE TABLE crm_cst_info (
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(10),
    cst_gndr VARCHAR(10),
    cst_create_date DATE
);

DROP TABLE IF EXISTS crm_prd_info;
CREATE TABLE crm_prd_info (
    prd_id INT,
    prd_key VARCHAR(50),
    prd_nm VARCHAR(50),
    prd_cost VARCHAR(50),
    prd_line VARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE
);

DROP TABLE IF EXISTS crm_sales_details;
CREATE TABLE crm_sales_details (
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt  INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);

-- ============================================================================
-- Step 3: Create ERP Tables
-- ============================================================================

DROP TABLE IF EXISTS erp_CUST_AZ12;
CREATE TABLE erp_CUST_AZ12 (
    CID VARCHAR(50),
    BDATE DATE,
    GEN VARCHAR(50)
);

DROP TABLE IF EXISTS erp_LOC_A101;
CREATE TABLE erp_LOC_A101 (
    CID VARCHAR(50),
    CNTRY VARCHAR(50)
);

DROP TABLE IF EXISTS erp_PX_CAT_G1V2;
CREATE TABLE erp_PX_CAT_G1V2 (
    ID VARCHAR(50),
    CAT VARCHAR(50),
    SUBCAT VARCHAR(50),
    MAINTENANCE VARCHAR(50)
);

-- ============================================================================
-- Step 4: Load Data into CRM Tables
-- ============================================================================

TRUNCATE TABLE crm_cst_info;
LOAD DATA LOCAL INFILE 'C:/sql/dwh_project/datasets/source_crm/cust_info.csv'
INTO TABLE crm_cst_info
FIELDS TERMINATED BY ',' 
IGNORE 1 LINES;

TRUNCATE TABLE crm_prd_info;
LOAD DATA LOCAL INFILE 'C:/sql/dwh_project/datasets/source_crm/prd_info.csv'
INTO TABLE crm_prd_info
FIELDS TERMINATED BY ',' 
IGNORE 1 LINES;

TRUNCATE TABLE crm_sales_details;
LOAD DATA LOCAL INFILE 'C:/sql/dwh_project/datasets/source_crm/sales_details.csv'
INTO TABLE crm_sales_details
FIELDS TERMINATED BY ',' 
IGNORE 1 LINES;

-- ============================================================================
-- Step 5: Load Data into ERP Tables
-- ============================================================================

TRUNCATE TABLE erp_CUST_AZ12;
LOAD DATA LOCAL INFILE 'C:/sql/dwh_project/datasets/source_erp/cust_az12.csv'
INTO TABLE erp_CUST_AZ12
FIELDS TERMINATED BY ',' 
IGNORE 1 LINES;

TRUNCATE TABLE erp_LOC_A101;
LOAD DATA LOCAL INFILE 'C:/sql/dwh_project/datasets/source_erp/loc_a101.csv'
INTO TABLE erp_LOC_A101
FIELDS TERMINATED BY ',' 
IGNORE 1 LINES;

TRUNCATE TABLE erp_PX_CAT_G1V2;
LOAD DATA LOCAL INFILE 'C:/sql/dwh_project/datasets/source_erp/px_cat_g1v2.csv'
INTO TABLE erp_PX_CAT_G1V2
FIELDS TERMINATED BY ',' 
IGNORE 1 LINES;

/*
===============================================================================
End of Bronze Layer Setup and Load Script
===============================================================================
*/
