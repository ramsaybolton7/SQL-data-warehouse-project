# Naming Conventions in Data Warehouse

This document outlines the naming conventions I implemented in the **Data Warehouse project**.  
It ensures **consistency, scalability, and clarity** across all schemas, tables, views, columns, and stored procedures.

---

## General Principles
- Used **snake_case** with lowercase letters and underscores.
- All names are in **English**.
- Avoided **SQL reserved words** as object names.

---

## Table Naming Conventions

### Bronze Layer
- Names kept as in the source system.
- Format: `<sourcesystem>_<entity>`
- Example: `crm_customer_info` → Customer information from CRM system.

### Silver Layer
- Same pattern `<sourcesystem>_<entity>`.
- Ensures transparency and traceability with source.

### Gold Layer
- Business-aligned, meaningful names.
- Format: `<category>_<entity>`
- Examples:  
  - `dim_customers` → Customer dimension.  
  - `dim_products` → Product dimension.  
  - `fact_sales` → Fact table for sales transactions.  

---

## Glossary of Patterns
- `dim_` → Dimension table (e.g., `dim_customers`)  
- `fact_` → Fact table (e.g., `fact_sales`)  
- `report_` → Reporting table (e.g., `report_sales_monthly`)  

---

## Column Naming Conventions

### Surrogate Keys
- All surrogate keys end with `_key`.  
- Example: `customer_key` in `dim_customers`.

### Technical Columns
- Prefix: `dwh_` for metadata/system-generated fields.  
- Example: `dwh_load_date` → load timestamp.

---

## Stored Procedures
- Format: `load_<layer>`  
- Examples:  
  - `load_bronze` → loads data into Bronze.  
  - `load_silver` → loads data into Silver.  
  - `load_gold` → loads data into Gold.  

---
