--select top 12 highest reveue generating products 
select  top 12 product_id,sum(selling_price) as sales from df_orders group by product_id order by sales desc ;




--select top 7 highest selling products in each region
with cte as (
select region,product_id,sum(selling_price) as sales
from df_orders
group by region,product_id)
select * from (
select *
, row_number() over(partition by region order by sales desc) as rn
from cte) A
where rn<=7;



--select bottom 7 lowest reveue generating products 
select  top 7 product_id from df_orders group by product_id order by sum(selling_price);



--find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023
with cte as(select year(order_date) as order_year,month(order_date) as order_month,sum(selling_price)
as sales from df_orders group by year(order_date),month(order_date))
select order_month,sum(case when order_year=2022 then sales else 0 end)as sales_2022
,sum(case when order_year=2023 then sales else 0 end)as sales_2023
from cte
group by order_month
order by order_month;



--for each category which month had highest sales 
with cte as (select category,month(order_date) as month,sum(selling_price) as sales
from df_orders group by category,month(order_date)
) 
select * from (select *,row_number() over(partition by category order by sales desc) as rn
from cte) a
where rn=1;


