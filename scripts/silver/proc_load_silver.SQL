/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/

DELIMITER $$

CREATE PROCEDURE silver_load_silver()
BEGIN
    -- Variables for logging
    DECLARE start_time DATETIME;
    DECLARE end_time   DATETIME;

    -- ===============================
    -- CRM CUSTOMER INFO
    -- ===============================
    SET start_time = NOW();
    TRUNCATE TABLE silver.crm_cust_info;

    INSERT INTO silver.crm_cust_info (
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
            WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
            WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
            ELSE 'n/a'
        END,
        CASE 
            WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
            WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
            ELSE 'n/a'
        END,
        cst_create_date
    FROM (
        SELECT *,
               ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
        FROM bronze.crm_cust_info
        WHERE cst_id IS NOT NULL
    ) t
    WHERE flag_last = 1;
    SET end_time = NOW();
    SELECT 'Loaded crm_cust_info in seconds:', TIMESTAMPDIFF(SECOND, start_time, end_time);

    -- ===============================
    -- CRM PRODUCT INFO
    -- ===============================
    SET start_time = NOW();
    TRUNCATE TABLE silver.crm_prd_info;

    INSERT INTO silver.crm_prd_info (
        prd_id, cat_id, prd_key, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt
    )
    SELECT
        prd_id,
        REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_'),
        SUBSTRING(prd_key, 7),
        prd_nm,
        IFNULL(prd_cost, 0),
        CASE 
            WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
            WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
            WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
            WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
            ELSE 'n/a'
        END,
        DATE(prd_start_dt),
        DATE_SUB(
            LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt),
            INTERVAL 1 DAY
        )
    FROM bronze.crm_prd_info;
    SET end_time = NOW();
    SELECT 'Loaded crm_prd_info in seconds:', TIMESTAMPDIFF(SECOND, start_time, end_time);

    -- ===============================
    -- CRM SALES DETAILS
    -- ===============================
    SET start_time = NOW();
    TRUNCATE TABLE silver.crm_sales_details;

    INSERT INTO silver.crm_sales_details (
        sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt, sls_due_dt, 
        sls_sales, sls_quantity, sls_price
    )
    SELECT 
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        CASE WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt) != 8 THEN NULL
             ELSE STR_TO_DATE(sls_order_dt, '%Y%m%d') END,
        CASE WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt) != 8 THEN NULL
             ELSE STR_TO_DATE(sls_ship_dt, '%Y%m%d') END,
        CASE WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt) != 8 THEN NULL
             ELSE STR_TO_DATE(sls_due_dt, '%Y%m%d') END,
        CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
             THEN sls_quantity * ABS(sls_price)
             ELSE sls_sales END,
        sls_quantity,
        CASE WHEN sls_price IS NULL OR sls_price <= 0
             THEN sls_sales / NULLIF(sls_quantity, 0)
             ELSE sls_price END
    FROM bronze.crm_sales_details;
    SET end_time = NOW();
    SELECT 'Loaded crm_sales_details in seconds:', TIMESTAMPDIFF(SECOND, start_time, end_time);

    -- ===============================
    -- ERP CUSTOMER AZ12
    -- ===============================
    SET start_time = NOW();
    TRUNCATE TABLE silver.erp_cust_az12;

    INSERT INTO silver.erp_cust_az12 (cid, bdate, gen)
    SELECT
        CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4) ELSE cid END,
        CASE WHEN bdate > CURDATE() THEN NULL ELSE bdate END,
        CASE 
            WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
            WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
            ELSE 'n/a'
        END
    FROM bronze.erp_cust_az12;
    SET end_time = NOW();
    SELECT 'Loaded erp_cust_az12 in seconds:', TIMESTAMPDIFF(SECOND, start_time, end_time);

    -- ===============================
    -- ERP LOC A101
    -- ===============================
    SET start_time = NOW();
    TRUNCATE TABLE silver.erp_loc_a101;

    INSERT INTO silver.erp_loc_a101 (cid, cntry)
    SELECT
        REPLACE(cid, '-', ''),
        CASE
            WHEN TRIM(cntry) = 'DE' THEN 'Germany'
            WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
            WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
            ELSE TRIM(cntry)
        END
    FROM bronze.erp_loc_a101;
    SET end_time = NOW();
    SELECT 'Loaded erp_loc_a101 in seconds:', TIMESTAMPDIFF(SECOND, start_time, end_time);

    -- ===============================
    -- ERP PX CAT G1V2
    -- ===============================
    SET start_time = NOW();
    TRUNCATE TABLE silver.erp_px_cat_g1v2;

    INSERT INTO silver.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
    SELECT id, cat, subcat, maintenance
    FROM bronze.erp_px_cat_g1v2;
    SET end_time = NOW();
    SELECT 'Loaded erp_px_cat_g1v2 in seconds:', TIMESTAMPDIFF(SECOND, start_time, end_time);

END$$

DELIMITER ;
