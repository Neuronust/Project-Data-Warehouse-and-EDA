/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Description:
    This script defines the table structure for the 'bronze' schema.
    Existing tables will be dropped if they already exist before being recreated.

    Use this script to initialize or reset the DDL structure of the Bronze layer.
===============================================================================
*/


DROP TABLE IF EXISTS bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info (
	"cst_id" int,
	"cst_key" VARCHAR,
	"cst_firstname" TEXT,
	"cst_lastname" TEXT,
	"cst_marital_status" TEXT,
	"cst_gndr" TEXT,
	"cst_create_date" date
);

DROP TABLE IF EXISTS bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info(
	"prd_id" INT,
	"prd_key" VARCHAR,
	"prd_nm" VARCHAR,
	"prd_cost" INT,
	"prd_line" TEXT,
	"prd_start_dt" date,
	"prd_end_dt" date
);

DROP TABLE IF EXISTS bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details(
	"sls_ord_num" varchar,
	"sls_prd_key" varchar,
	"sls_cust_id" int,
	"sls_order_dt" int,
	"sls_ship_dt" int,
	"sls_due_dt" int,
	"sls_sales" int,
	"sls_quantity" int,
	"sls_price" int
);

DROP TABLE IF EXISTS bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12(
	"cid" VARCHAR,
	"bdate" date,
	"gen" TEXT
);

DROP TABLE IF EXISTS bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101(
	"cid" VARCHAR,
	"cntry" TEXT
);

DROP TABLE IF EXISTS bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2(
	"id" VARCHAR,
	"cat" TEXT,
	"subcat" TEXT,
	"maintenance" TEXT
);