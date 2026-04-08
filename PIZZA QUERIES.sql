CREATE DATABASE PIZZA_SALES;
USE pizza_sales;

select*from orders;
select*from order_details;
select*from pizza_types;
select*from pizzas;
show tables;

select count(distinct order_id) as 'Total Orders' from orders;

select cast(sum(order_details.quantity * pizzas.price) as decimal(10,2)) as 'Total Revenue'
from order_details 
join pizzas on pizzas.pizza_id = order_details.pizza_id;

select pizza_id,price from pizzas 
order by price desc
limit 1;

select pizzas.size, count(*) as total_count
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size
order by total_count desc
limit 1;

select pizza_types.name as 'Pizza', sum(quantity) as 'Total Ordered'
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.name 
order by sum(quantity) desc
limit 5;

select pizza_types.category, sum(quantity) as 'Total Quantity Ordered'
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.category 
order by sum(quantity)  desc;

select hour(time) as 'Hour of the day', count(distinct order_id) as 'No of Orders'
from orders
group by hour(time) 
order by `No of Orders` desc;
desc orders;

select avg(daily_total) as avg_pizzas_per_day
from(
select orders.date, sum(order_details.quantity) as daily_total from orders
join order_details on orders.order_id =order_details.order_id
group by orders.date
) as daily_orders;

select pizza_types.category,count(*) as total_orders from order_details 
join pizzas on order_details.pizza_id =pizzas.pizza_id
join pizza_types on pizzas.pizza_type_id=pizza_types.pizza_type_id
group by pizza_types.category;

select date,  
         avg(total_quantity) as avg_pizzas_per_day
from (
select orders.date , sum(order_details.quantity) as 
total_quantity
     from orders
	 join order_details
     on orders.order_id = order_details.order_id
     group by orders.date
     )t
group by date;

select pizza_types.name, sum(order_details.quantity*pizzas.price) as 'Revenue from pizza'
from order_details 
join pizzas on pizzas.pizza_id = order_details.pizza_id
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.name
order by `Revenue from pizza` desc
limit 3;

select pizza_types.category, 
concat(cast((sum(order_details.quantity*pizzas.price) /
(select sum(order_details.quantity*pizzas.price) 
from order_details 
join pizzas on pizzas.pizza_id = order_details.pizza_id 
))*100 as decimal(10,2)), '%')
as 'Revenue contribution from pizza'
from order_details 
join pizzas on pizzas.pizza_id = order_details.pizza_id
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.category;

select pizza_types.name, 
concat(cast((sum(order_details.quantity*pizzas.price) /
(select sum(order_details.quantity*pizzas.price) 
from order_details 
join pizzas on pizzas.pizza_id = order_details.pizza_id 
))*100 as decimal(10,2)), '%')
as 'Revenue contribution from pizza'
from order_details 
join pizzas on pizzas.pizza_id = order_details.pizza_id
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.name
order by `Revenue contribution from pizza` desc;

select date as 'Date', cast(sum(quantity*price) as decimal(10,2)) as Revenue
from order_details 
join orders on order_details.order_id = orders.order_id
join pizzas on pizzas.pizza_id = order_details.pizza_id
group by date
order by date;

select category, name, total_revenue 
from (
      select
      pt.category,
      pt.name,
      sum(order_details.quantity*pizzas.price) as total_revenue,
      rank() over (partition by pt.category
order by sum(order_details.quantity*pizzas.price) desc) as rnk
   from order_details 
   join pizzas on order_details.pizza_id =pizzas.pizza_id
   join pizza_types pt on pizzas.pizza_type_id =pt.pizza_type_id
   group by pt.category , pt.name
)t
where rnk <=3;






