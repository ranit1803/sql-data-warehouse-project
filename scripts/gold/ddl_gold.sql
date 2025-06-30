-- ============================================================================
-- File: gold_layer_views.sql
-- Description: This script creates business-friendly views in the Gold layer 
--              using data from the Silver layer. These views support analytics
--              and reporting use cases.
-- ============================================================================

-- Create View: gold.dim_customers
-- Purpose: Enriched customer dimension with demographic and location data
CREATE OR REPLACE VIEW gold.dim_customers AS
SELECT
  ROW_NUMBER() OVER(ORDER BY ci.cst_id) AS customer_key,
  ci.cst_id AS customer_id,
  ci.cst_key AS customer_number,
  ci.cst_firstname AS first_name,
  ci.cst_lastname AS last_name,
  la.CNTRY AS country,
  ci.cst_marital_status AS marital_status,
  CASE
    WHEN ci.cst_gndr != 'N/A' THEN ci.cst_gndr
    ELSE COALESCE(ca.GEN, 'N/A')
  END AS gender,
  ca.BDATE AS birthday,
  ci.cst_create_date AS creation_date
FROM silver.crm_cst_info ci
LEFT JOIN silver.erp_cust_az12 ca ON ci.cst_key = ca.CID
LEFT JOIN silver.erp_loc_a101 la ON ci.cst_key = la.CID;

-- Create View: gold.dim_products
-- Purpose: Product dimension enriched with category and maintenance details
CREATE OR REPLACE VIEW gold.dim_products AS
SELECT
  ROW_NUMBER() OVER(ORDER BY pn.prd_start_dt, pn.prd_id) AS product_key,
  pn.prd_id AS product_id,
  pn.prd_key AS product_number,
  pn.prd_nm AS product_name,
  pn.cat_id AS category_id,
  pc.CAT AS category,
  pc.SUBCAT AS sub_category,
  pc.MAINTENANCE AS maintenance_required,
  pn.prd_cost AS cost,
  pn.prd_line AS product_line,
  pn.prd_start_dt AS start_date,
  pn.prd_end_dt AS end_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc ON pn.cat_id = pc.ID
WHERE pn.prd_end_dt IS NULL;

-- Create View: gold.fact_sales
-- Purpose: Fact table with sales transactions linking customers and products
CREATE OR REPLACE VIEW gold.fact_sales AS
SELECT
  sd.sls_ord_num AS order_number,
  pr.product_key,
  cu.customer_key,
  sd.sls_order_dt AS order_date,
  sd.sls_ship_dt AS shipping_date,
  sd.sls_due_dt AS due_date,
  sd.sls_sales AS sales_amount,
  sd.sls_quantity AS quantity,
  sd.sls_price AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu ON sd.sls_cust_id = cu.customer_id;
