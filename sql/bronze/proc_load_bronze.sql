/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Description:
    This stored procedure is responsible for loading data into the 'bronze'
    schema from external CSV files as part of the ETL pipeline.

    The process includes:
        - Clearing existing data in Bronze tables.
        - Importing data from CSV files into Bronze tables using BULK INSERT in Postgres SQL.

Parameters:
    No input or output parameters are required.

Execution:
    call bronze.load_bronze();
===============================================================================
*/

CREATE OR REPLACE PROCEDURE bronze.load_bronze()
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
	    RAISE NOTICE 'Loading Bronze layer';
	    RAISE NOTICE '===========================================';
	
	    RAISE NOTICE '-------------------------------------------';
	    RAISE NOTICE 'Loading CRM Tables';
	    RAISE NOTICE '-------------------------------------------';
		
		start_time := now();
	
	    RAISE NOTICE '>> Truncating Table : bronze.crm_cust_info';
	    TRUNCATE TABLE bronze.crm_cust_info;
	
	    RAISE NOTICE '>> Inserting Data Into Table : bronze.crm_cust_info';
	    COPY bronze.crm_cust_info 
	    FROM 'C:/Program Files/PostgreSQL/18/data/datasets/source_crm/cust_info.csv'
	    DELIMITER ','
	    CSV HEADER;
	
		end_time := now();
	
		RAISE NOTICE '>> Load time: % seconds',
	        EXTRACT(EPOCH FROM (end_time - start_time));
	
		raise notice '-------------------------------------------';
	
		start_time := now();
	    RAISE NOTICE '>> Truncating Table : bronze.crm_prd_info';
	    TRUNCATE TABLE bronze.crm_prd_info;
	
		
	    RAISE NOTICE '>> Inserting Data Into Table : bronze.crm_prd_info';
	    COPY bronze.crm_prd_info 
	    FROM 'C:/Program Files/PostgreSQL/18/data/datasets/source_crm/prd_info.csv'
	    DELIMITER ','
	    CSV HEADER;
		
		end_time := now();
		RAISE NOTICE '>> Load time: % seconds',
	        EXTRACT(EPOCH FROM (end_time - start_time));
		
		raise notice '-------------------------------------------';
	
		start_time := now();
	    RAISE NOTICE '>> Truncating Table : bronze.crm_sales_details';
	    TRUNCATE TABLE bronze.crm_sales_details;
	
	    RAISE NOTICE '>> Inserting Data Into Table : bronze.crm_sales_details';
	    COPY bronze.crm_sales_details 
	    FROM 'C:/Program Files/PostgreSQL/18/data/datasets/source_crm/sales_details.csv'
	    DELIMITER ','
	    CSV HEADER;
		end_time := now();
		
		RAISE NOTICE '>> Load time: % seconds',
	        EXTRACT(EPOCH FROM (end_time - start_time));
		
	    RAISE NOTICE '-------------------------------------------';
	    RAISE NOTICE 'Loading ERP Tables';
	    RAISE NOTICE '-------------------------------------------';
	
		start_time := now();
	    RAISE NOTICE '>> Truncating Table : bronze.erp_cust_az12';
	    TRUNCATE TABLE bronze.erp_cust_az12;
	
	    RAISE NOTICE '>> Inserting Data Into Table : bronze.erp_cust_az12';
	    COPY bronze.erp_cust_az12 
	    FROM 'C:/Program Files/PostgreSQL/18/data/datasets/source_erp/cust_az12.csv'
	    DELIMITER ','
	    CSV HEADER;
		end_time:= now();
		
		RAISE NOTICE '>> Load time: % seconds',
		        EXTRACT(EPOCH FROM (end_time - start_time));
	
		raise notice '-------------------------------------------';
		
		start_time := now();
	    RAISE NOTICE '>> Truncating Table : bronze.erp_loc_a101';
	    TRUNCATE TABLE bronze.erp_loc_a101;
	
	    RAISE NOTICE '>> Inserting Data Into Table : bronze.erp_loc_a101';
	    COPY bronze.erp_loc_a101 
	    FROM 'C:/Program Files/PostgreSQL/18/data/datasets/source_erp/loc_a101.csv'
	    DELIMITER ','
	    CSV HEADER;
		end_time := now();
	
		RAISE NOTICE '>> Load time: % seconds',
		        EXTRACT(EPOCH FROM (end_time - start_time));	
	
		raise notice '-------------------------------------------';
	
		start_time := now();
	    RAISE NOTICE '>> Truncating Table : bronze.erp_px_cat_g1v2';
	    TRUNCATE TABLE bronze.erp_px_cat_g1v2;
	
	    RAISE NOTICE '>> Inserting Data Into Table : bronze.erp_px_cat_g1v2';
	    COPY bronze.erp_px_cat_g1v2 
	    FROM 'C:/Program Files/PostgreSQL/18/data/datasets/source_erp/px_cat_g1v2.csv'
	    DELIMITER ','
	    CSV HEADER;
		end_time := now();
	
		RAISE NOTICE '>> Load time: % seconds',
		        EXTRACT(EPOCH FROM (end_time - start_time));
	
		EXCEPTION
		    WHEN OTHERS THEN
		        GET STACKED DIAGNOSTICS
		            v_message = MESSAGE_TEXT,
		            v_state   = RETURNED_SQLSTATE;
		
		        RAISE exception 'Error Message: %', v_message;
		        RAISE exception 'Error Code (SQLSTATE): %', v_state;
	end;
	batch_end_time := now();
	RAISE NOTICE '===========================================';
    RAISE NOTICE 'Total Load Duration : % seconds',
		EXTRACT(epoch from(batch_end_time-batch_start_time));
    RAISE NOTICE '===========================================';
END;
$$;