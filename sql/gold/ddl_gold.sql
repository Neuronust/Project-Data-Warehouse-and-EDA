/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Description:
    This script is responsible for creating views in the Gold layer of the
    data warehouse. The Gold layer contains the final structure of fact and
    dimension tables following a star schema design.

    Each view applies transformations and integrates data from the Silver layer
    to generate a refined, well-structured, and analysis-ready dataset.

Usage:
    - These views are intended for direct use in reporting and analytical queries.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================
DROP VIEW IF EXISTS gold.dim_customers;
CREATE view gold.dim_customers AS
SELECT 
	row_number()over(ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	ci.cst_marital_status AS marital_status,
	CASE
		WHEN ci.cst_gndr != 'unknown' THEN ci.cst_gndr 
		ELSE COALESCE(eca.gen,'unknown')
	END AS customer_gender,
	eca.bdate AS birth_date,
	ela.cntry AS country,
	ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 eca 
	ON  ci.cst_key = eca.cid
LEFT JOIN silver.erp_loc_a101 ela
	ON ci.cst_key=ela.cid;

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
DROP VIEW IF EXISTS gold.dim_products;
CREATE VIEW gold.dim_products as
SELECT
	row_number()over(ORDER BY prd_id) AS product_key,
	pi.prd_id AS product_id,
	pi.sls_prd_key AS sales_product_key,
	pi.cat_id AS id,
	pi.prd_nm AS product_name,
	CASE
		WHEN epcgv.cat IS NULL THEN 'Others'
		ELSE epcgv.cat
	END AS category,
	CASE
		WHEN epcgv.subcat IS NULL THEN 'Others'
		ELSE epcgv.subcat
	END AS subcategory,
	pi.prd_cost AS cost,
	pi.prd_line AS product_line,
	epcgv.maintenance,
	pi.prd_start_dt AS start_date
FROM 
silver.crm_prd_info pi
LEFT JOIN silver.erp_px_cat_g1v2 epcgv ON 
	pi.cat_id = epcgv.id 
WHERE pi.prd_end_dt IS NULL;

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
DROP VIEW IF EXISTS gold.fact_sales;
CREATE VIEW gold.fact_sales as
SELECT
	sd.sls_ord_num AS order_number,
	ds.customer_key,
	dp.product_key,
	sd.sls_order_dt AS order_date,
	sd.sls_ship_dt AS ship_date,
	sd.sls_due_dt AS due_date,
	sd.sls_sales AS sales,
	sd.sls_quantity AS quantity,
	sd.sls_price AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_customers ds
	ON sd.sls_cust_id = ds.customer_id 
LEFT JOIN gold.dim_products dp 
	ON sd.sls_prd_key = dp.sales_product_key;

SELECT 
	* 
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_customers ds
	ON sd.sls_cust_id = ds.customer_id;