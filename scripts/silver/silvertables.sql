/*
===============================================================================
Silver Layer - Table Creation Script
===============================================================================
Script Purpose:
    This script creates the Silver layer tables in the `silver` database.
    These tables store cleaned and transformed data coming from the Bronze layer.
    Each table includes a `dwh_create_date` column to track the date of insertion
    into the data warehouse.

    If any table already exists, it will be dropped and recreated.

WARNING:
    Running this script will permanently delete existing Silver layer tables.
===============================================================================
*/

-- Use the Silver database
CREATE DATABASE IF NOT EXISTS silver;
USE silver;

-- ============================================================================
-- Step 1: Create CRM Tables
-- ============================================================================

DROP TABLE IF EXISTS crm_cst_info;
CREATE TABLE crm_cst_info (
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(10),
    cst_gndr VARCHAR(10),
    cst_create_date DATE,
    dwh_create_date DATE DEFAULT (CURRENT_DATE())
);

DROP TABLE IF EXISTS crm_prd_info;
CREATE TABLE crm_prd_info (
    prd_id INT,
    cat_id VARCHAR(50),
    prd_key VARCHAR(50),
    prd_nm VARCHAR(50),
    prd_cost VARCHAR(50),
    prd_line VARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE,
    dwh_create_date DATE DEFAULT (CURRENT_DATE())
);

DROP TABLE IF EXISTS crm_sales_details;
CREATE TABLE crm_sales_details (
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_order_dt DATE,
    sls_ship_dt DATE,
    sls_due_dt  DATE,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT,
    dwh_create_date DATE DEFAULT (CURRENT_DATE())
);

-- ============================================================================
-- Step 2: Create ERP Tables
-- ============================================================================

DROP TABLE IF EXISTS erp_CUST_AZ12;
CREATE TABLE erp_CUST_AZ12 (
    CID VARCHAR(50),
    BDATE DATE,
    GEN VARCHAR(50),
    dwh_create_date DATE DEFAULT (CURRENT_DATE())
);

DROP TABLE IF EXISTS erp_LOC_A101;
CREATE TABLE erp_LOC_A101 (
    CID VARCHAR(50),
    CNTRY VARCHAR(50),
    dwh_create_date DATE DEFAULT (CURRENT_DATE())
);

DROP TABLE IF EXISTS erp_PX_CAT_G1V2;
CREATE TABLE erp_PX_CAT_G1V2 (
    ID VARCHAR(50),
    CAT VARCHAR(50),
    SUBCAT VARCHAR(50),
    MAINTENANCE VARCHAR(50),
    dwh_create_date DATE DEFAULT (CURRENT_DATE())
);

-- ============================================================================
-- End of Script
-- ============================================================================
