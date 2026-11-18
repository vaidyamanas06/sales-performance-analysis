

--The headline numbers

Select Sum(sales) as revenue, 
sum(profit) as total_profit, 
(100 * sum(profit)/(sum(sales))) as margin_percent,
count (distinct(order_id)) as number_of_orders
from orders_full;

--Top 10 products by profit

select product_id, product_name , sum(profit) as total_profit
from orders_full
group by product_id, product_name 
order by total_profit desc
limit 10;

--Regional revenue, profit, and profit margin (%) analysis.

select region, Sum(sales) as revenue, sum(profit) as total_profit, (100*(sum(profit)/(sum(sales)))) as margin
from orders_full
group by region
order by margin desc;

--Identification of loss-making sub-categories.

select sub_category, sum(profit) as total_profit
from orders_full
group by sub_category
having sum(profit) <0
order by total_profit desc;

--Monthly revenue trend

SELECT DATE_TRUNC('month', order_date)::DATE AS month,
       SUM(sales) AS revenue
FROM orders_full
GROUP BY DATE_TRUNC('month', order_date)::DATE
ORDER BY month;

--Month-over-month growth

WITH monthly AS (
  SELECT DATE_TRUNC('month', order_date)::DATE AS month,
         SUM(sales) AS revenue
  FROM orders_full
  GROUP BY 1
)
SELECT month,
       ROUND(revenue, 2) AS revenue,
       ROUND(LAG(revenue) OVER (ORDER BY month), 2) AS prev_revenue,
       ROUND(100.0 * (revenue - LAG(revenue) OVER (ORDER BY month))
             / LAG(revenue) OVER (ORDER BY month), 1) AS mom_growth_pct
FROM monthly
ORDER BY month;

--Rank products within each category

SELECT *
FROM (
  SELECT category, product_name,
         ROUND(SUM(profit), 2) AS profit,
         RANK() OVER (PARTITION BY category ORDER BY SUM(profit) DESC) AS rnk
  FROM orders_full
  GROUP BY category, product_id, product_name
) t
WHERE rnk <= 3
ORDER BY category, rnk;

-- List the top 10 customers by revenue.

SELECT customer_id, ROUND(SUM(sales), 2) AS revenue
FROM orders_full
GROUP BY customer_id
ORDER BY revenue DESC
LIMIT 10;

-- How many customers make up the first 80% of total revenue?

WITH cust AS (
  SELECT customer_id, SUM(sales) AS revenue
  FROM orders_full
  GROUP BY customer_id
),
ranked AS (
  SELECT customer_id, revenue,
         SUM(revenue) OVER (ORDER BY revenue DESC
                            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running,
         SUM(revenue) OVER () AS total
  FROM cust
)
SELECT COUNT(*) AS customers_for_80pct
FROM ranked
WHERE running - revenue < 0.8 * total;

--Do discounts cause losses?

SELECT CASE WHEN discount = 0    THEN '0%'
            WHEN discount <= 0.2 THEN '1-20%'
            WHEN discount <= 0.4 THEN '21-40%'
            ELSE '40%+' END      AS discount_band,
       COUNT(*)                  AS line_items,
       ROUND(AVG(profit), 2)     AS avg_profit,
       ROUND(SUM(profit), 2)     AS total_profit
FROM orders_full
GROUP BY 1
ORDER BY MIN(discount);
