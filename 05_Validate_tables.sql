--Checking if thr orders_full table returns the same row count and total sales and profit as superstore_clean.
SELECT COUNT(*) FROM orders_full;

SELECT SUM(sales), SUM(profit) FROM orders_full;

SELECT SUM(sales), SUM(profit) FROM superstore_clean;