/*
===============================================================================
Silver Layer Insert Script: Transform & Load from Bronze
===============================================================================
Script Purpose:
    This script loads cleaned and transformed data from the Bronze layer 
    into the Silver layer tables in the `silver` database. The transformations
    include:
        - Cleaning string fields (trimming, casing)
        - Handling invalid/null dates
        - Conditional logic via CASE expressions
        - Deriving new columns like cat_id, prd_line descriptions, etc.

WARNING:
    This script assumes that the Bronze layer is already populated.
    Ensure tables in the Silver layer are empty or prepared for new inserts.
===============================================================================
*/

USE silver;

-- ============================================================================
-- CRM Tables
-- ============================================================================

-- Insert into crm_cst_info
INSERT INTO silver.crm_cst_info (
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)
SELECT
    cst_id,
    cst_key,
    TRIM(cst_firstname),
    TRIM(cst_lastname),
    CASE
        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
        ELSE 'N/A'
    END,
    CASE
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
        ELSE 'N/A'
    END,
    cst_create_date
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag
    FROM bronze.crm_cst_info
) t
WHERE flag = 1;

-- Insert into crm_prd_info
INSERT INTO silver.crm_prd_info (
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
SELECT 
    prd_id,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
    SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,
    prd_nm,
    COALESCE(prd_cost, 0),
    CASE
        WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
        WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
        WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
        WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
        ELSE 'N/A'
    END,
    prd_start_dt,
    STR_TO_DATE(
        DATE_FORMAT(
            LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt),
            '%Y-%m-%d'
        ) - INTERVAL 1 DAY,
        '%Y-%m-%d'
    ) AS prd_end_dt
FROM bronze.crm_prd_info;

-- Insert into crm_sales_details
INSERT INTO silver.crm_sales_details (
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
)
SELECT 
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    CASE 
        WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt) != 8 THEN NULL
        ELSE STR_TO_DATE(sls_order_dt, '%Y%m%d')
    END,
    CASE 
        WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt) != 8 THEN NULL
        ELSE STR_TO_DATE(sls_ship_dt, '%Y%m%d')
    END,
    CASE 
        WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt) != 8 THEN NULL
        ELSE STR_TO_DATE(sls_due_dt, '%Y%m%d')
    END,
    CASE
        WHEN sls_sales != sls_quantity * ABS(sls_price) OR sls_sales <= 0 OR sls_sales IS NULL
        THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END,
    sls_quantity,
    CASE
        WHEN sls_price <= 0 OR sls_price IS NULL
        THEN sls_sales / NULLIF(sls_quantity, 0)
        ELSE sls_price
    END
FROM bronze.crm_sales_details;

-- ============================================================================
-- ERP Tables
-- ============================================================================

-- Insert into erp_CUST_AZ12
INSERT INTO silver.erp_cust_az12 (
    CID,
    BDATE,
    GEN
)
SELECT 
    CASE
        WHEN cid LIKE 'NAS%' THEN SUBSTR(cid, 4, LENGTH(cid))
        ELSE cid
    END,
    CASE 
        WHEN bdate > CURDATE() THEN NULL
        ELSE bdate
    END,
    CASE
        WHEN LOWER(TRIM(GEN)) LIKE 'f%' THEN 'Female'
        WHEN LOWER(TRIM(GEN)) LIKE 'm%' THEN 'Male'
        ELSE 'N/A'
    END
FROM bronze.erp_cust_az12;

-- Insert into erp_LOC_A101
INSERT INTO silver.erp_loc_a101 (
    CID,
    CNTRY
)
SELECT
    REPLACE(cid, '-', ''),
    CASE 
        WHEN UPPER(TRIM(cntry)) = 'DE' THEN 'Germany'
        WHEN UPPER(TRIM(cntry)) IN ('US', 'USA') THEN 'United States'
        WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'N/A'
        ELSE TRIM(cntry)
    END
FROM bronze.erp_loc_a101;

-- Insert into erp_PX_CAT_G1V2
INSERT INTO silver.erp_px_cat_g1v2 (
    ID,
    CAT,
    SUBCAT,
    MAINTENANCE
)
SELECT 
    TRIM(ID),
    TRIM(CAT),
    TRIM(SUBCAT),
    TRIM(MAINTENANCE)
FROM bronze.erp_px_cat_g1v2;

-- ============================================================================
-- End of Script
-- ============================================================================
