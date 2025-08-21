/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

-- ================================
-- Start Batch
-- ================================
SET @batch_start_time = NOW();

SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = '==================================';
SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = 'Loading Bronze Layer';
SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = '==================================';

-- ================================
-- CRM TABLES
-- ================================
SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = '**********************************';
SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = 'Loading CRM Tables';
SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = '**********************************';

-- crm_cust_info
SET @start_time = NOW();
SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = 'Truncating Table: crm_cust_info';
TRUNCATE TABLE crm_cust_info;

SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = 'Inserting Data Into: crm_cust_info';
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cust_info.csv'
INTO TABLE crm_cust_info
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@cst_id, @cst_key, @cst_firstname, @cst_lastname, @cst_marital_status, @cst_gndr, @cst_create_date)
SET 
    cst_id = NULLIF(@cst_id, ''),
    cst_key = NULLIF(@cst_key, ''),
    cst_firstname = NULLIF(@cst_firstname, ''),
    cst_lastname = NULLIF(@cst_lastname, ''),
    cst_marital_status = NULLIF(@cst_marital_status, ''),
    cst_gndr = NULLIF(@cst_gndr, ''),
    cst_create_date = STR_TO_DATE(NULLIF(@cst_create_date, ''), '%Y-%m-%d');
SET @end_time = NOW();
SET @duration = TIMESTAMPDIFF(SECOND, @start_time, @end_time);
SET @msg = CONCAT('>> Load Duration (crm_cust_info): ', @duration, ' seconds');
SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = @msg;

-- crm_prd_info
SET @start_time = NOW();
SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = 'Truncating Table: crm_prd_info';
TRUNCATE TABLE crm_prd_info;

SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = 'Inserting Data Into: crm_prd_info';
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/prd_info.csv'
INTO TABLE crm_prd_info
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@prd_id, @prd_key, @prd_nm, @prd_cost, @prd_line, @prd_start_dt, @prd_end_dt)
SET 
    prd_id = NULLIF(@prd_id, ''),
    prd_key = NULLIF(@prd_key, ''),
    prd_nm = NULLIF(@prd_nm, ''),
    prd_cost = NULLIF(@prd_cost, ''),
    prd_line = NULLIF(@prd_line, ''),
    prd_start_dt = STR_TO_DATE(NULLIF(@prd_start_dt, ''), '%Y-%m-%d %H:%i:%s'),
    prd_end_dt = STR_TO_DATE(NULLIF(@prd_end_dt, ''), '%Y-%m-%d %H:%i:%s');
SET @end_time = NOW();
SET @duration = TIMESTAMPDIFF(SECOND, @start_time, @end_time);
SET @msg = CONCAT('>> Load Duration (crm_prd_info): ', @duration, ' seconds');
SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = @msg;

-- crm_sales_details
SET @start_time = NOW();
SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = 'Truncating Table: crm_sales_details';
TRUNCATE TABLE crm_sales_details;

SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = 'Inserting Data Into: crm_sales_details';
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales_details.csv'
INTO TABLE crm_sales_details
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@sls_ord_num, @sls_prd_key, @sls_cust_id, @sls_order_dt, @sls_ship_dt, @sls_due_dt, @sls_sales, @sls_quantity, @sls_price)
SET 
    sls_ord_num = NULLIF(@sls_ord_num, ''),
    sls_prd_key = NULLIF(@sls_prd_key, ''),
    sls_cust_id = NULLIF(@sls_cust_id, ''),
    sls_order_dt = NULLIF(@sls_order_dt, ''),
    sls_ship_dt = NULLIF(@sls_ship_dt, ''),
    sls_due_dt = NULLIF(@sls_due_dt, ''),
    sls_sales = NULLIF(@sls_sales, ''),
    sls_quantity = NULLIF(@sls_quantity, ''),
    sls_price = NULLIF(@sls_price, '');
SET @end_time = NOW();
SET @duration = TIMESTAMPDIFF(SECOND, @start_time, @end_time);
SET @msg = CONCAT('>> Load Duration (crm_sales_details): ', @duration, ' seconds');
SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = @msg;

-- ================================
-- ERP TABLES
-- ================================
SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = '**********************************';
SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = 'Loading ERP Tables';
SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = '**********************************';

-- erp_loc_a101
SET @start_time = NOW();
SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = 'Truncating Table: erp_loc_a101';
TRUNCATE TABLE erp_loc_a101;

SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = 'Inserting Data Into: erp_loc_a101';
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/loc_a101.csv'
INTO TABLE erp_loc_a101
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@cid, @cntry)
SET 
    cid = NULLIF(@cid, ''),
    cntry = NULLIF(@cntry, '');
SET @end_time = NOW();
SET @duration = TIMESTAMPDIFF(SECOND, @start_time, @end_time);
SET @msg = CONCAT('>> Load Duration (erp_loc_a101): ', @duration, ' seconds');
SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = @msg;

-- erp_cust_az12
SET @start_time = NOW();
SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = 'Truncating Table: erp_cust_az12';
TRUNCATE TABLE erp_cust_az12;

SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = 'Inserting Data Into: erp_cust_az12';
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cust_az12.csv'
INTO TABLE erp_cust_az12
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@cid, @bdate, @gen)
SET 
    cid = NULLIF(@cid, ''),
    bdate = STR_TO_DATE(NULLIF(@bdate, ''), '%Y-%m-%d'),
    gen = NULLIF(@gen, '');
SET @end_time = NOW();
SET @duration = TIMESTAMPDIFF(SECOND, @start_time, @end_time);
SET @msg = CONCAT('>> Load Duration (erp_cust_az12): ', @duration, ' seconds');
SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = @msg;

-- erp_px_cat_g1v2
SET @start_time = NOW();
SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = 'Truncating Table: erp_px_cat_g1v2';
TRUNCATE TABLE erp_px_cat_g1v2;

SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = 'Inserting Data Into: erp_px_cat_g1v2';
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/px_cat_g1v2.csv'
INTO TABLE erp_px_cat_g1v2
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(@id, @cat, @subcat, @maintenance)
SET 
    id = NULLIF(@id, ''),
    cat = NULLIF(@cat, ''),
    subcat = NULLIF(@subcat, ''),
    maintenance = NULLIF(@maintenance, '');
SET @end_time = NOW();
SET @duration = TIMESTAMPDIFF(SECOND, @start_time, @end_time);
SET @msg = CONCAT('>> Load Duration (erp_px_cat_g1v2): ', @duration, ' seconds');
SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = @msg;

-- ================================
-- End Batch
-- ================================
SET @batch_end_time = NOW();
SET @batch_duration = TIMESTAMPDIFF(SECOND, @batch_start_time, @batch_end_time);
SET @final_msg = CONCAT('Bronze Layer Load Completed in ', @batch_duration, ' seconds');
SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = @final_msg;
