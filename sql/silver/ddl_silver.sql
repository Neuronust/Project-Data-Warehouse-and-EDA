/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Description:
    This script defines the table structure for the 'silver' schema.
    Existing tables will be dropped if they already exist before being recreated.

    Use this script to initialize or refresh the DDL structure of the Silver layer.
===============================================================================
*/

DROP TABLE IF EXISTS silver.crm_cust_info;
CREATE TABLE silver.crm_cust_info (
	"cst_id" int,
	"cst_key" VARCHAR,
	"cst_firstname" TEXT,
	"cst_lastname" TEXT,
	"cst_marital_status" TEXT,
	"cst_gndr" TEXT,
	"cst_create_date" date,
	"dwh_create_date" timestamp DEFAULT now()
);

DROP TABLE IF EXISTS silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info(
	"prd_id" INT,
	"prd_key" VARCHAR,
	"sls_prd_key" varchar,
	"cat_id" varchar,
	"prd_nm" VARCHAR,
	"prd_cost" INT,
	"prd_line" TEXT,
	"prd_start_dt" date,
	"prd_end_dt" date,
	"dwh_create_date" timestamp DEFAULT now()
);

DROP TABLE IF EXISTS silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details(
	"sls_ord_num" varchar,
	"sls_prd_key" varchar,
	"sls_cust_id" int,
	"sls_order_dt" date,
	"sls_ship_dt" date,
	"sls_due_dt" date,
	"sls_sales" int,
	"sls_quantity" int,
	"sls_price" int,
	"dwh_create_date" timestamp DEFAULT now()
);

DROP TABLE IF EXISTS silver.erp_cust_az12;
CREATE TABLE silver.erp_cust_az12(
	"cid" VARCHAR,
	"bdate" date,
	"gen" TEXT,
	"dwh_create_date" timestamp DEFAULT now()
);

DROP TABLE IF EXISTS silver.erp_loc_a101;
CREATE TABLE silver.erp_loc_a101(
	"cid" VARCHAR,
	"cntry" TEXT,
	"dwh_create_date" timestamp DEFAULT now()
);

DROP TABLE IF EXISTS silver.erp_px_cat_g1v2;
CREATE TABLE silver.erp_px_cat_g1v2(
	"id" VARCHAR,
	"cat" TEXT,
	"subcat" TEXT,
	"maintenance" TEXT,
	"dwh_create_date" timestamp DEFAULT now()
);