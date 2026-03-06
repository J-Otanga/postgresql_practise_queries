-- 1. Write a query to select all data from the `Customers` table.
select * from customers;

-- 2. Write a query to select the total number of products from the `Products` table.
select count(product_id) from products;
-- 3. Write a query to select the product name and its price from the `Products` table where the price is greater than 500.
select product_name,price from products where price > 500 order by price desc;
-- 4. Write a query to find the average price of all products from the `Products` table.
select avg(price) as Average_price from products;
-- 5. Write a query to find the total sales amount from the `Sales` table.
select sum(total_amount) as total_sales from sales;
-- 6. Write a query to select distinct membership statuses from the `Customers` table.
select distinct(membership_status) from customers;
-- 7. Write a query to concatenate first and last names of all customers and show the result as `full_name`.
select concat(first_name,' ',last_name) as full_name from customers;
-- 8. Write a query to find all products in the `Products` table where the category is 'Electronics'.
select product_name from products where category = 'Electronics';
-- 9. Write a query to find the highest price from the `Products` table.
select max(price) from products;
select product_name, price from products order by price desc limit 1;
-- 10. Write a query to count the number of sales for each product from the `Sales` table.
select count(sale_id) from sales;
-- 11. Write a query to find the total quantity sold for each product from the `Sales` table.
select product_id, sum(quantity_sold) from sales group by product_id order by product_id asc;
-- 12. Write a query to find the lowest price of products in the `Products` table.
select min(price) from products;
select product_name, price from products order by price asc limit 1;
-- 13. Write a query to find customers who have purchased products with a price greater than 1000.
select customer_id from sales where total_amount > 1000;
-- 14. Write a query to join the `Sales` and `Products` tables on product_id, and select the product name and total sales amount.
select p.product_name, s.total_amount from products p inner join sales s on p.product_id = s.product_id order by s.total_amount desc;
-- 15. Write a query to join the `Customers` and `Sales` tables and find the total amount spent by each customer.
select c.customer_id, c.last_name, s.total_amount from customers c left join sales s on c.customer_id = s.customer_id;
-- 16. Write a query to join the `Customers`, `Sales`, and `Products` tables, and show each customer's first and last name, product name, and quantity sold.
select c.first_name,c.last_name, p.product_name ,s.quantity_sold from customers c
inner join sales s on s.customer_id = c.customer_id 
inner join products p on s.product_id = p.product_id;
-- 17. Write a query to perform a self-join on the `Customers` table and find all pairs of customers who have the same membership status.
select c.customer_id, concat(c.first_name,' ',c.last_name),
c2.customer_id ,concat(c2.first_name ,' ',c2.last_name ),c2.membership_status from customers c
left join customers c2
on c.membership_status = c2.membership_status
and c.customer_id < c2.customer_id;
-- 18. Write a query to join the `Sales` and `Products` tables, and calculate the total number of sales for each product.
select p.product_name, sum(s.total_amount) as total_sales from products p
inner join sales s 
on p.product_id = s.product_id
group by p.product_name
order by total_sales desc;
-- 19. Write a query to find the products in the `Products` table where the stock quantity is less than 10.
select product_id,product_name from products 
where stock_quantity < 10;
-- 20. Write a query to join the `Sales` table and the `Products` table, and find products with sales greater than 5.
select p.product_id,s.sale_id,p.product_name from products p 
inner join sales s 
on p.product_id =s.product_id 
where s.total_amount > 5;
-- 21. Write a query to select customers who have purchased products that are either in the 'Electronics' or 'Appliances' category.
select c.customer_id ,s.product_id,p.product_name, c.first_name,c.last_name from customers c 
inner join sales s 
using(customer_id)
inner join products p 
using(product_id)
where category in('Electronics','Appliances');
-- 22. Write a query to calculate the total sales amount per product and group the result by product name.
select p.product_name, sum(s.total_amount) from products p
inner join sales s 
using(product_id)
group by product_name;

-- 23. Write a query to join the `Sales` table with the `Customers` table and select customers who made a purchase in the year 2023.
select c.first_name,c.last_name,extract(year from sale_date) as sale_year from customers c
inner join sales s
using(customer_id)
where extract(year from sale_date) = 2023;
-- 24. Write a query to find the customers with the highest total sales in 2023.
select c.customer_id ,c.first_name,c.last_name,s.total_amount from customers c
inner join sales s
using(customer_id)
where extract(year from s.sale_date) = 2023
order by s.total_amount desc limit 1;
-- 25. Write a query to join the `Products` and `Sales` tables and select the most expensive product sold.
select p.product_id, p.product_name,p.price from products p
inner join sales s
using(product_id)
order by p.price desc limit 1;

-- 26. Write a query to find the total number of customers who have purchased products worth more than 500.
select count(*) from customers c 
inner join sales s
using(customer_id)
where total_amount > 500;
-- 27. Write a query to join the `Products`, `Sales`, and `Customers` tables and find the total number of sales made by customers who are in the 'Gold' membership tier.
select count(s.sale_id ) from sales s 
inner join customers c
using(customer_id)
inner join products p 
using(product_id)
where c.membership_status = 'Gold';
-- 28. Write a query to join the `Products` and `Inventory` tables and find all products that have low stock (less than 10).
select p.product_id,p.product_name,i.stock_quantity from products p 
inner join inventory i 
using(product_id)
where i.stock_quantity <10;
-- 29. Write a query to find customers who have purchased more than 5 products and show the total quantity of products they have bought.
select c.customer_id,c.first_name,c.last_name,
sum(s.quantity_sold ) as total_quantity_bought
from customers c 
inner join sales s
using(customer_id)
group by c.customer_id, c.first_name, c.last_name
having sum(s.quantity_sold) > 5 ;

-- 30. Write a query to find the average quantity sold per product.
select p.product_id ,avg(s.quantity_sold) as average_quantity_sold from products p 
left join sales s
using(product_id)
group by product_id;
-- 31. Write a query to find the number of sales made in the month of December 2023.
select count(sale_id),extract(year from sale_date) as year from sales 
group by extract(year from sale_date)
having extract(year from sale_date) = 2023;
-- 32. Write a query to find the total amount spent by each customer in 2023 and list the customers in descending order.
select c.customer_id,c.first_name,c.last_name,s.total_amount from customers c 
left join sales s using(customer_id)
order by c.first_name desc;

-- 33. Write a query to find all products that have been sold but have less than 5 units left in stock.
select s.product_id,p.product_name,i.stock_quantity from products p 
inner join sales s on p.product_id = s.product_id
inner join inventory i on s.product_id = i.product_id
where i.stock_quantity < 5;



-- 34. Write a query to find the total sales for each product and order the result by the highest sales.
select s.product_id,p.product_name, sum(s.total_amount) as total_sales from products p
inner join sales s
using(product_id)
group by s.product_id,p.product_name,s.total_amount 
order by s.total_amount desc;
-- 35. Write a query to find all customers who bought products within 7 days of their registration date.
select * from(
select c.first_name,
    c.last_name,
    c.registration_date,
    s.sale_date,
   (s.sale_date - c.registration_date ) as days_difference
    from customers c
    join sales s using(customer_id)) as date_difference
    where days_difference between 0 and 7;
-- 36. Write a query to join the `Sales` table with the `Products` table and filter the results by products priced between 100 and 500.
select s.sale_id,p.product_id,p.product_name,p.price
from products p 
inner join sales s
using(product_id)
where p.price between 100 and 500;
-- 37. Write a query to find the most frequent customer who made purchases from the `Sales` table.
select c.customer_id,c.first_name,c.last_name,count(*) as total_purchases from sales s
inner join customers c
using(customer_id)
group by c.customer_id,c.first_name,c.last_name
order by total_purchases desc limit 1;

-- 38. Write a query to find the total quantity of products sold per customer.
select c.customer_id,c.first_name,c.last_name,sum(s.quantity_sold)as quantity_sold from customers c
inner join sales s using(customer_id)
group by c.customer_id,c.first_name,c.last_name ;


-- 39. Write a query to find the products with the highest stock and lowest stock, and display them together in a single result set.

select product_id,product_name,stock_quantity from products
where stock_quantity = (select max(stock_quantity) from products)
union
select product_id,product_name,stock_quantity from products
where stock_quantity = (select min(stock_quantity) from products);

-- 40. Write a query to find products whose names contain the word 'Phone' and their total sales.
select p.product_id, p.product_name,sum(s.total_amount) as total_sales from products p 
inner join sales s using(product_id)
where p.product_name like '%phone%'
group by p.product_id,p.product_name;
-- 41. Write a query to perform an `INNER JOIN` between `Customers` and `Sales`, then display the total sales amount and the product names for customers in the 'Gold' membership status.
select c.customer_id,c.membership_status
-- 42. Write a query to find the total sales of products by category.
select p.category,sum(s.total_amount) as total_sales from products p
inner join sales s using(product_id)
group by p.category
order by total_sales desc;
-- 43. Write a query to join the `Products` table with the `Sales` table, and calculate the total sales for each product, grouped by month and year.
select p.product_id,sum(s.total_amount) ,
extract(year from s.sale_date) as year,
extract(month from s.sale_date) as month from products p
inner join sales s using(product_id)
group by p.product_id ,extract(month from s.sale_date),
extract(year from s.sale_date)
order by year desc,month asc;
-- 44. Write a query to join the `Sales` and `Inventory` tables and find products that have been sold but still have stock remaining.
select distinct s.product_id,p.product_name ,i.stock_quantity from products p
inner join sales s using(product_id)
inner join inventory i using(product_id)
where i.stock_quantity >=1;
-- 45. Write a query to find the top 5 customers who have made the highest purchases.
select c.customer_id,sum(s.total_amount) from customers c
inner join sales s using(customer_id)
group by c.customer_id 
order by sum(s.total_amount) desc limit 5;
-- 46. Write a query to calculate the total number of unique products sold in 2023.
select count(distinct product_id) from sales
where extract(year from sale_date) = 2023;

-- 47. Write a query to find the products that have not been sold in the last 6 months.
select p.product_id,p.product_name from products p 
except
select p.product_id,p.product_name from products p 
inner join sales s using(product_id)
where s.sale_date >= current_date - interval '6 months';

SELECT p.product_id, p.product_name
FROM products p
WHERE NOT EXISTS (
    SELECT 1
    FROM sales s
    WHERE s.product_id = p.product_id
    AND s.sale_date >= CURRENT_DATE - INTERVAL '6 months'
);


-- 48. Write a query to select the products with a price range between $200 and $800, and find the total quantity sold for each.
select p.product_id,p.product_name,p.price,sum(s.quantity_sold) as quantity_sold from products p
inner join sales s using(product_id)
where p.price between 200 and 400
group by p.product_id,p.product_name; 
-- 49. Write a query to find the customers who spent the most money in the year 2023.
select c.customer_id,c.first_name,c.last_name,sum(s.total_amount) as money_spent from customers c
inner join sales s using(customer_id)
where extract(year from s.sale_date) = 2023
group by  c.customer_id,c.first_name,c.last_name
order by money_spent desc limit 1;

-- 50. Write a query to select the products that have been sold more than 100 times and have a price greater than 200.
select p.product_id,p.product_name,count(s.sale_id) from products p
inner join sales s using(product_id)
group by p.product_id,p.product_name
having count(s.sale_id) > 100 and p.price > 200 ;