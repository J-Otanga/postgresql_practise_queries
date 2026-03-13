PART 2
-- =====================================================
-- =====================================================
-- SUBQUERY QUESTIONS
-- =====================================================

-- 51. Which customers have spent more than the average spending of all customers?
select c.customer_id, c.first_name, c.last_name,s.total_amount 
from customers c
join sales s using(customer_id)
where s.total_amount > (
    select avg(total_amount) 
    from sales
);

--select avg(total_amount) from sales;

-- 52. Which products are priced higher than the average price of all products?
select product_id,product_name,price from products p
where price > (select avg(price) from products);
--select avg(price) from products;

-- 53. Which customers have never made a purchase?
select customer_id,first_name, last_name from customers 
where customer_id in( select customer_id from customers 
except select customer_id from sales);
-- 54. Which products have never been sold?
select product_id,product_name from products
where product_id not in(select product_id from sales);

-- 55. Which customer made the single most expensive purchase?
select customer_id,total_amount from sales
where total_amount = (select max(total_amount) from sales);
-- 56. Which products have total sales greater than the average total sales across all products?
select product_id,total_amount from sales
where total_amount > (select avg(total_amount) from sales );
-- 57. Which customers registered earlier than the average registration date?
---****
select customer_id,first_name,last_name,registration_date from customers
where registration_date < (select avg(registration_date ) from customers);
-- 58. Which products have a price higher than the average price within their own category?
---*****
select product_id,product_name,category,price from products p 
where price>(select avg(price) from products where category = p.category);
-- 59. Which customers have spent more than the customer with ID = 10?
select customer_id from sales 
group by customer_id 
having sum(total_amount) > (select sum(total_amount) from sales where customer_id = 10);

-- 60. Which products have total quantity sold greater than the overall average quantity sold?
select product_id,quantity_sold  from sales 
where quantity_sold > (select avg(quantity_sold) from sales);

-- =====================================================
-- COMMON TABLE EXPRESSIONS (CTEs)
-- =====================================================

-- 61. Create an intermediate result that calculates the total amount spent by each customer,
--     then determine which customers are the top 5 highest spenders.
with total_amount_per_spender as (
select customer_id,sum(total_amount) as total_spent from sales group by customer_id)
select * from total_amount_per_spender 
order by total_spent desc limit 5;

-- 62. Create an intermediate result that calculates total quantity sold per product,
--     then determine which products are the top 3 most sold.
with quantity_per_product as(select product_id,sum(quantity_sold) as total_quantity from sales group by product_id)
select * from quantity_per_product 
order by total_quantity desc limit 3;
-- 63. Create an intermediate result showing total sales per product category,
--     then determine which category generates the highest revenue.
with sales_per_productCategory as (select p.category,sum(s.total_amount)as total_sales
from products p
join sales s using(product_id)
group by p.category)
select * from sales_per_productCategory order by total_sales desc limit 1;
-- 64. Create an intermediate result that calculates the number of purchases per customer,
--     then identify customers who purchased more than twice.
with purchase_per_customer as (select customer_id,count(sale_id) as total_purchases from sales group by customer_id)
select * from purchase_per_customer where total_purchases > 2;
-- 65. Create an intermediate result that calculates the total quantity sold per product,
--     then determine which products sold more than the average quantity sold.
with quantity_per_product as ( select product_id, sum(quantity_sold) as total_quantity from sales group by product_id)
select product_id, total_quantity from quantity_per_product 
where total_quantity >(
select avg(total_quantity ) from quantity_per_product);
-- 66. Create an intermediate result that calculates total spending per customer,
--     then determine which customers spent more than the average spending.
with spending_per_customer as(select customer_id,sum(total_amount) as  total_spending from sales group by customer_id)
select * from spending_per_customer
where total_spending > (
select avg(total_spending) from spending_per_customer);
-- 67. Create an intermediate result that calculates total revenue per product,
--     then list the products ordered from highest revenue to lowest.
with revenue_per_product as(
select product_id,sum(total_amount) as total_revenue from sales group by product_id)
select * from revenue_per_product 
order by total_revenue desc;
-- 68. Create an intermediate result showing monthly sales totals,
--     then determine which month had the highest revenue.
with sales_per_month as (
select extract(year from sale_date) as year,extract(month from sale_date)as month,sum(total_amount) as total_sales from sales 
group by month,year)
select * from sales_per_month order by total_sales desc limit 1;
-- 69. Create an intermediate result that calculates the number of sales per product,
--     then determine which products were purchased by more than three customers.

with sales_per_product as (select product_id, count(sale_id) as total_sales from sales group by product_id)
select * from sales_per_product where total_sales > 3;
-- 70. Create an intermediate result showing total quantity sold per product,
--     then identify products that sold less than the average quantity sold.
with total_quantity_per_product as( select product_id,sum(quantity_sold) as total_quantity from sales group by product_id)
select * from total_quantity_per_product 
where total_quantity < (select avg(total_quantity) from total_quantity_per_product );

-- =====================================================
-- WINDOW FUNCTION QUESTIONS
-- =====================================================

-- 71. Rank customers based on the total amount they have spent.
select customer_id, sum(total_amount) as total_amount,rank() over(order by sum(total_amount) desc) from sales group by customer_id;
-- 72. Rank products based on total quantity sold.
select product_id,sum(quantity_sold) as total_quantity, rank() over(order by sum(quantity_sold) desc) from sales group by product_id;
-- 73. Identify the 3rd highest spending customer.
with ranked_customers as(
select customer_id,sum(total_amount ), dense_rank() over(order by sum(total_amount)) as rank from sales group by customer_id )
select * from ranked_customers where rank = 3;

-- 74. Identify the 2nd most expensive product.
with ranked_products as (select product_name,price,dense_rank() over(order by price desc)as rank from products)
select * from ranked_products where rank = 2;
-- 75. Show the ranking of products within each category based on price.
select product_name,category,rank() over(partition by category order by price desc) as rank from products;

-- 76. Show the ranking of customers based on the number of purchases they made.
select customer_id,count(sale_id) as total_purchases, rank() over(order by count(sale_id)) as rank from sales group by customer_id ;
-- 77. Show the running total of sales amounts ordered by sale_date.
select sale_id, sale_date,total_amount, sum(total_amount) OVER (ORDER BY sale_date) AS running_total from  sales;

-- 78. Show the previous sale amount for each sale ordered by sale_date.
select sale_id,customer_id,lag(total_amount) over(order by sale_date)as previous_sale_amount from sales;
-- 79. Show the next sale amount for each sale ordered by sale_date.
select sale_id,customer_id,lead(total_amount) over(order by sale_date) as next_sale_amount from sales;
-- 80. Divide customers into 4 groups based on total spending.
select customer_id,sum(total_amount) as sum, ntile(4) over(order by sum(total_amount)) as q_grouping from sales group by customer_id;

-- =====================================================
-- ADVANCED ANALYTICAL QUESTIONS
-- =====================================================

-- 81. Which customers bought products in more than one category?
select s.customer_id,count(distinct p.category) from sales s 
join products p using(product_id)
group by s.customer_id
having count(distinct p.category)>1;

-- 82. Which customers purchased products within 7 days of registering?
select customer_id,product_id,sale_date from sales
where sale_date between 0 and 7;
-- 83. Which products have lower stock remaining than the average stock quantity?
select product_id,product_name,stock_quantity from products
where stock_quantity < (select avg(stock_quantity) from products);
-- 84. Which customers purchased the same product more than once?
select customer_id,product_id from sales
group by customer_id,product_id 
having count(*) > 1;
-- 85. Which product categories generated the highest total revenue?
select p.category,sum(s.total_amount) as total_revenue from sales s 
inner join products p using(product_id)
group by p.category
order by total_revenue desc limit 1; 

-- 86. Which products are among the top 3 most sold products?

select product_id, count(*) AS total_sales from sales group by product_id
order by total_sales desc limit 3;
-- 87. Which customers purchased the most expensive product?
select distinct s.customer_id from sales s inner join products p using (product_id)
where p.price = (select max(price) from products);
-- 88. Which products were purchased by the highest number of unique customers?
select distinct customer_id, count(product_id) from sales group by customer_id;
-- 89. Which customers made purchases above the average sale amount?
select customer_id,avg(total_amount) as average_amount from sales group by customer_id having avg(total_amount)>(select avg(total_amount) from sales);
-- 90. Which customers purchased more products than the average quantity purchased per customer?
select customer_id,quantity_sold from sales where quantity_sold > (select avg(quantity_sold) from sales);

-- =====================================================
-- ADVANCED WINDOW + ANALYTICAL PROBLEMS
-- =====================================================

-- 91. Which customers rank in the top 10% of spending?
with total_spending as(select customer_id,sum(total_amount) as total_amount from sales group by customer_id)
select * from(select * ,ntile(10) over(order by total_amount desc) as rank from total_spending) 
where rank = 1;
-- 92. Which products contribute to the top 50% of total revenue?
with product_revenue as (select product_id,sum(total_amount) as total_revenue from sales group by product_id)
select * from (select *,ntile(2) over(order by total_revenue desc) as rank from product_revenue)
where rank = 1;
-- 93. Which customers made purchases in consecutive months?
select customer_id,count(sale_id) from sales group by customer_id
-- 94. Which products experienced the largest difference between stock quantity and total quantity sold?

-- 95. Which customers have spending above the average spending of their membership tier?

-- 96. Which products have higher sales than the average sales within their category?

-- 97. Which customer made the largest single purchase relative to their total spending?

-- 98. Which products rank among the top 3 most sold products within each category?

-- 99. Which customers are tied for the highest total spending?

-- 100. Which products generated sales every year present in the dataset?
