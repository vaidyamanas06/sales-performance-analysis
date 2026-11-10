--Creating table Customers


CREATE TABLE customers AS
SELECT DISTINCT customer_id, segment
FROM superstore_clean;

ALTER TABLE customers ADD PRIMARY KEY (customer_id);


--Creating table Products


CREATE TABLE products AS
SELECT DISTINCT ON (product_id)
       product_id, product_name, category, sub_category
FROM superstore_clean
ORDER BY product_id, product_name;

ALTER TABLE products ADD PRIMARY KEY (product_id);


--Creating table Orders


CREATE TABLE orders AS
SELECT DISTINCT order_id, order_date, ship_date, ship_mode,
       customer_id, country, city, state, postal_code, region
FROM superstore_clean;

ALTER TABLE orders ADD PRIMARY KEY (order_id);


--Creating table Order items


CREATE TABLE order_items AS
SELECT row_id, order_id, product_id, sales, quantity, discount, profit
FROM superstore_clean;

ALTER TABLE order_items ADD PRIMARY KEY (row_id);
ALTER TABLE order_items ADD FOREIGN KEY (order_id)    REFERENCES orders(order_id);
ALTER TABLE order_items ADD FOREIGN KEY (product_id)  REFERENCES products(product_id);
ALTER TABLE orders      ADD FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

