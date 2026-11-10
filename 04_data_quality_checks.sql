--Total row count on superstore_clean table
SELECT COUNT(*) FROM superstore_clean;

--Earliest and latest order_date on superstore_clean table
SELECT MIN(order_date), MAX(order_date) FROM superstore_clean;

--Number of distinct customers, products, orders, and regions in one query on superstore_clean table
SELECT COUNT(DISTINCT customer_id) AS customers,
       COUNT(DISTINCT product_id)  AS products,
       COUNT(DISTINCT order_id)    AS orders,
       COUNT(DISTINCT region)      AS regions
FROM superstore_clean;


--Count of loss-making rows (profit < 0) on superstore_clean table
SELECT COUNT(*) FROM superstore_clean WHERE profit < 0;


--Count of rows where sales <= 0 on superstore_clean table
SELECT COUNT(*) FROM superstore_clean WHERE sales <= 0;

--Count of rows where ship_date < order_date on superstore_clean table
SELECT COUNT(*) FROM superstore_clean WHERE ship_date < order_date;