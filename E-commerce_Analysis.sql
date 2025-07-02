create database uk ;
use uk ;
select * from ecomm_customers ;
select * from ecomm_order_items ;
select * from ecomm_orders ;
select * from ecomm_payments ;
select * from ecomm_products ;

 

SELECT   o.*,   c.*,   it.*,   pro.product_name,   pro.category, 
  pro.price AS unit_price,
  (it.quantity * it.price) AS total_price, py.payment_mode, 
  py.status AS payment_status, py.payment_date
FROM ecomm_orders o

JOIN ecomm_customers c ON o.customer_id = c.customer_id
JOIN ecomm_order_items it ON o.order_id = it.order_id
JOIN ecomm_products pro ON it.product_id = pro.product_id
JOIN ecomm_payments py ON o.order_id = py.order_id;

 -- Top 5 high-spending customers
select c.name , sum(it.quantity * it.price)AS total_spending  from ecomm_customers c 
join ecomm_orders o on o.customer_id = c.customer_id
JOIN ecomm_order_items it ON o.order_id = it.order_id
 JOIN ecomm_products pro ON it.product_id = pro.product_id 
 group by c.name order by total_spending desc  limit 5 ;
 
  -- How many unique customers placed orders each month?
 select month(order_date) as month , count(distinct customer_id ) from ecomm_orders group by month(order_date) order by month ;
 
 -- Which city has the highest number of customers?
 
 select c.city ,count(*) from  ecomm_customers c 
 group by c.city 
 order by count(*) desc
 limit 1;
 
 -- Which customers have placed more than 3 orders?
 select c.name , count(o.order_id) AS More_Order from ecomm_customers c
 join ecomm_orders o on c.customer_id= o.customer_id 
 group by  c.customer_id, c.name 
 having More_Order >3 
 order by More_Order desc;

-- What is the total revenue generated each month ?
select month(order_date) AS Month , sum(total_amount) as Total_Amount from ecomm_orders group by Month order by Total_Amount ;

-- What is the average order value (AOV) ?

select avg(total_amount)as Avg_Value from ecomm_orders ;

-- Which product category generated the highest revenue ?

select pro.category , sum(it.quantity * it.price) AS total_price from ecomm_orders o 
join ecomm_order_items it on  o.order_id=it.order_id 
join ecomm_products pro on it.product_id = pro.product_id
group by pro.category order by total_price 
 ;
 
 -- Which product was sold the most (by quantity)?

select pro.product_name , max(it.quantity) as most_sold from ecomm_order_items it
join ecomm_products pro on pro.product_id=it.product_id
group by pro.product_name order by most_sold ;
 
-- List all products that were ordered more than 10 times.
 
select pro.product_name , sum(it.quantity) as most_sold from ecomm_order_items it
join ecomm_products pro on pro.product_id=it.product_id
group by pro.product_name
having most_sold > 10 
order by most_sold   ;

-- Which products were never ordered?
select pro.product_name , sum(it.quantity) as most_sold from ecomm_order_items it
join ecomm_products pro on pro.product_id=it.product_id
group by pro.product_name
having most_sold < 1 
order by most_sold   ;

select pro.product_name from ecomm_products pro 
join ecomm_order_items it on pro.product_id= it.product_id 
where pro.product_id is null; 

-- Show the top 3 most ordered products in each category.

SELECT category, product_name, total_sold FROM (
    SELECT p.category, p.product_name, SUM(it.quantity) AS total_sold,
	RANK() OVER (PARTITION BY p.category ORDER BY SUM(it.quantity) DESC) AS rnk
    FROM ecomm_order_items it
    JOIN ecomm_products p ON it.product_id = p.product_id
    GROUP BY p.category, p.product_name
) AS ranked
WHERE rnk <= 3;


-- What is the total quantity of each product sold ?

select pro.product_name , count(it.quantity) as total_quantity from ecomm_order_items it
join ecomm_products pro on pro.product_id=it.product_id
group by pro.product_name
order by total_quantity desc ;

-- What is the success rate of payments (Success vs Failed)? 
select distinct status, count(status) from ecomm_payments 
group by status ;

-- Which payment mode is used most frequently?
select distinct status, count(status) from ecomm_payments 
group by status order by status desc ;

select max(status) from ecomm_payments ;

-- List all orders with pending or failed payments and their customers.
SELECT   o.*,   c.*,   it.*,   pro.product_name,   pro.category, 
  pro.price AS unit_price,
  (it.quantity * it.price) AS total_price, py.payment_mode, 
  py.status AS payment_status, py.payment_date
FROM ecomm_orders o

JOIN ecomm_customers c ON o.customer_id = c.customer_id
JOIN ecomm_order_items it ON o.order_id = it.order_id
JOIN ecomm_products pro ON it.product_id = pro.product_id
JOIN ecomm_payments py ON o.order_id = py.order_id 
where status = 'Failed' or status = 'Pending' ;




