CREATE TABLE superstore_clean AS
SELECT
    row_id::INT                              AS row_id,
    order_id,
    TO_DATE(order_date, 'MM/DD/YYYY')        AS order_date,
    TO_DATE(ship_date,  'MM/DD/YYYY')        AS ship_date,
    ship_mode,
	customer_id, 
	segment,
    country, 
	city, 
	state, 
	region,
    product_id, 
	category, 
	sub_category, 
    sales::NUMERIC(12,4)                     AS sales,
	product_name,
    quantity::INT                            AS quantity,
    discount::NUMERIC(5,2)                   AS discount,
    profit::NUMERIC(12,4)                    AS profit
FROM superstore_raw;