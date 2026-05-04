/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Description:
    This stored procedure handles the ETL (Extract, Transform, Load) process
    by transferring data from the 'bronze' schema to the 'silver' schema.

    Key steps include:
        - Clearing existing data in the Silver tables.
        - Loading data from Bronze after applying necessary cleaning
          and transformation processes.

Parameters:
    This procedure does not take any input parameters or return any output.

Execution:
    call silver.load_silver();
===============================================================================
*/

CREATE OR REPLACE PROCEDURE silver.load_silver()
LANGUAGE plpgsql
AS $$
DECLARE
    v_message TEXT;
    v_state TEXT;
	start_time timestamp;
	end_time timestamp;
	batch_start_time timestamp;
	batch_end_time timestamp;
BEGIN
	begin
	
		batch_start_time := now();
	    RAISE NOTICE '===========================================';
	    RAISE NOTICE 'Loading silver layer';
	    RAISE NOTICE '===========================================';
	
	    RAISE NOTICE '-------------------------------------------';
	    RAISE NOTICE 'Loading CRM Tables';
	    RAISE NOTICE '-------------------------------------------';
		
		start_time := now();
	
	    RAISE NOTICE '>> Truncating Table : silver.crm_cust_info';
	    TRUNCATE TABLE silver.crm_cust_info;
	
	    RAISE NOTICE '>> Inserting Data Into Table : silver.crm_cust_info';
		INSERT INTO silver.crm_cust_info(
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
			trim(cst_firstname) AS cst_firstname,
			trim(cst_lastname) AS cst_lastname,
			CASE
				WHEN trim(UPPER(cst_marital_status))='M' THEN 'Married'
				WHEN trim(UPPER(cst_marital_status))='S' THEN 'Single'
				ELSE 'Unknown'
			END AS cst_marital_status, -- Normalize marital status,
			CASE
				WHEN trim(UPPER(cst_gndr))='F' THEN 'Female'
				WHEN trim(UPPER(cst_gndr))='M' THEN 'Male'
				ELSE 'Unknown'
			END AS cst_gndr, -- Normalize gender information,
			(cst_create_date)
		FROM (
			SELECT 
				*,
				row_number()over (PARTITION BY cst_id ORDER BY cci.cst_create_date deSC) AS rn
			FROM bronze.crm_cust_info cci
			WHERE cst_id IS NOT null
			)
		WHERE rn =1 -- Select the most recent record customers
		;
		
		end_time := now();
	
		RAISE NOTICE '>> Load time: % seconds',
	        EXTRACT(EPOCH FROM (end_time - start_time));
	
		raise notice '-------------------------------------------';
	
		start_time := now();
	    RAISE NOTICE '>> Truncating Table : silver.crm_prd_info';
		TRUNCATE TABLE silver.crm_prd_info;
				
		RAISE NOTICE '>> Inserting Data Into Table : silver.crm_prd_info';
		INSERT INTO silver.crm_prd_info(
			prd_id,
			prd_key,
			cat_id,
			sls_prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)
		SELECT 
			prd_id,
			prd_key,
			REPLACE(substring(prd_key FROM '^([^-]+-[^-]+)'),'-','_') AS cat_id, --Extract category key
			regexp_replace(prd_key,'^[^-]+-[^-]+-','') AS sls_prd_key, -- Extract sales details key
			prd_nm,
			CASE 
				WHEN prd_cost IS NULL THEN 0
				ELSE prd_cost
			END AS prd_cost
			,
			CASE
				WHEN upper(trim(prd_line)) = 'M' THEN 'Mountain'
				WHEN upper(trim(prd_line)) = 'R' THEN 'Road'
				WHEN upper(trim(prd_line)) = 'S' THEN 'Other Sales'
				WHEN upper(trim(prd_line)) = 'T' THEN 'Touring'
				ELSE 'unknown'
			END AS prd_line, -- Normalize lines code to readable format
			prd_start_dt::date AS prd_start_dt,
			(LEAD (prd_start_dt)OVER(PARTITION BY prd_key ORDER BY prd_start_dt) -1) ::date
			AS  prd_end_dt -- Calculate end date as one day before the next start date
		FROM bronze.crm_prd_info;

		end_time := now();
		RAISE NOTICE '>> Load time: % seconds',
	        EXTRACT(EPOCH FROM (end_time - start_time));
		
		raise notice '-------------------------------------------';
	
		start_time := now();
	    RAISE NOTICE '>> Truncating Table : silver.crm_sales_details';
	    TRUNCATE TABLE silver.crm_sales_details;
	
	    RAISE NOTICE '>> Inserting Data Into Table : silver.crm_sales_details';
		
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
				WHEN length(sls_order_dt::text) != 8 OR sls_order_dt=0 THEN NULL
				ELSE sls_order_dt::varchar::date
			END AS sls_order_dt, -- normalize order date to date format
			CASE 
				WHEN length(sls_ship_dt::text) != 8 OR sls_ship_dt=0 THEN NULL
				ELSE sls_ship_dt::varchar::date
			END AS sls_ship_dt, -- normalize ship date to date format
			CASE 
				WHEN length(sls_due_dt::text) != 8 OR sls_due_dt=0 THEN NULL
				ELSE sls_due_dt::varchar::date
			END AS sls_due_dt, -- normalize due date to date format
			CASE 
				WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales != sls_quantity * abs(sls_price) THEN sls_quantity * abs(sls_price) 
				ELSE sls_sales
			END AS sls_sales, --Recalculate sales value if original value is missing or incorrect
			sls_quantity, 
			CASE
				WHEN sls_price IS NULL OR sls_price<=0 THEN  sls_sales / NULLIF(sls_quantity,0)
				ELSE sls_price
			END AS sls_price -- Recalculate price value if original valie is missing or incorrect
		FROM bronze.crm_sales_details csd;

		end_time := now();
		
		RAISE NOTICE '>> Load time: % seconds',
	        EXTRACT(EPOCH FROM (end_time - start_time));
		
	    RAISE NOTICE '-------------------------------------------';
	    RAISE NOTICE 'Loading ERP Tables';
	    RAISE NOTICE '-------------------------------------------';
	
		start_time := now();
	    RAISE NOTICE '>> Truncating Table : silver.erp_cust_az12';
	    TRUNCATE TABLE silver.erp_cust_az12;
	
	    RAISE NOTICE '>> Inserting Data Into Table : silver.erp_cust_az12';
		INSERT INTO silver.erp_cust_az12(
			cid,
			bdate,
			gen
		)
		SELECT 
			CASE
				WHEN cid LIKE 'NAS%' THEN substr(cid,4)
				ELSE cid
			END AS cid, -- Normalize cid to standard format
			bdate,
			CASE 
				WHEN upper(trim(gen)) = 'M' THEN 'Male'
				WHEN upper(trim(gen)) = 'F' THEN 'Female'
				WHEN gen IS NULL OR trim(gen) ='' THEN 'Unknown'
				ELSE trim(gen)
			END AS gen--Normalize gender to descriptive and readable format
		FROM bronze.erp_cust_az12
		WHERE bdate < now() and bdate >'1924-01-01'; -- Delete Unormal birth date;
		
		end_time:= now();
		
		RAISE NOTICE '>> Load time: % seconds',
		        EXTRACT(EPOCH FROM (end_time - start_time));
	
		raise notice '-------------------------------------------';
		
		start_time := now();
	    RAISE NOTICE '>> Truncating Table : silver.erp_loc_a101';
	    TRUNCATE TABLE silver.erp_loc_a101;
	
	    RAISE NOTICE '>> Inserting Data Into Table : silver.erp_loc_a101';		

		INSERT INTO silver.erp_loc_a101 (
			cid,
			cntry
		)
		SELECT
			regexp_replace(cid,'-','') AS cid,
			CASE
				WHEN upper(trim(cntry)) IN ('US','USA') THEN 'United States of America'
				WHEN upper(trim(cntry)) IN  ('DE','DEU','GERMANY') THEN 'Germany'
				WHEN cntry IS NULL OR trim(cntry) = '' THEN 'Unknown'
				ELSE trim(cntry)
			END AS cntry-- normalize and handle blank or null country code
		FROM bronze.erp_loc_a101;
		
		end_time := now();
	
		RAISE NOTICE '>> Load time: % seconds',
		        EXTRACT(EPOCH FROM (end_time - start_time));	
	
		raise notice '-------------------------------------------';
	
		start_time := now();
	    RAISE NOTICE '>> Truncating Table : silver.erp_px_cat_g1v2';
	    TRUNCATE TABLE silver.erp_px_cat_g1v2;
	
	    RAISE NOTICE '>> Inserting Data Into Table : silver.erp_px_cat_g1v2';
		INSERT INTO silver.erp_px_cat_g1v2 (
			id,
			cat,
			subcat,
			maintenance
		)
		SELECT 
			id,
			cat,
			subcat,
			maintenance
		FROM bronze.erp_px_cat_g1v2;
		
		end_time := now();
	
		RAISE NOTICE '>> Load time: % seconds',
		        EXTRACT(EPOCH FROM (end_time - start_time));
	
		EXCEPTION
		    WHEN OTHERS THEN
		        GET STACKED DIAGNOSTICS
		            v_message = MESSAGE_TEXT,
		            v_state   = RETURNED_SQLSTATE;
		
		        RAISE EXCEPTION 'Error (%): %', v_state, v_message;
	end;
	batch_end_time := now();
	RAISE NOTICE '===========================================';
    RAISE NOTICE 'Total Load Duration : % seconds',
		EXTRACT(epoch from(batch_end_time-batch_start_time));
    RAISE NOTICE '===========================================';
END;
$$;