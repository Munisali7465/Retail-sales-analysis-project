-- create database retail sales analysis
CREATE DATABASE retail_sales_analysis;
--CREATE table 
drop table if exists retail_sales;

CREATE TABLE retail_sales(
transection_id INT PRIMARY KEY,
sales_date DATE,
sales_time TIME,
customer_id INT,
gender VARCHAR(15),
age INT,
category VARCHAR(20),
quantity INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sales FLOAT
);

SELECT*FROM retail_sales;
select count(*) from retail_sales;

select * from retail_sales
where transection_id is null;

select * from retail_sales
where sales_date is null;

select * from retail_sales
where sales_time is null;


select *from retail_sales
where transection_id  is null
	or
	sales_date is null
	or
	sales_time is null 
	or 
	gender is null
	or
	category is null
	or 
	quantity is null
	or 
	cogs is null
	or
	total_sales is null;

delete from retail_sales
where transection_id  is null
	or
	sales_date is null
	or
	sales_time is null 
	or 
	gender is null
	or
	category is null
	or 
	quantity is null
	or 
	cogs is null
	or
	total_sales is null;
-- data exploration
select count(distinct customer_id)as total_sales from retail_sales;

select distinct category from retail_sales;

--data analsis finding

--Q1-write a sql query to retrive all column for sales made on '2022-11-05'.
select*from retail_sales
where  sales_date ='2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
select*from retail_sales
where
	category='Clothing'
	and 
	to_char(sales_date,'YYYY-MM')='2022-11'
	and
	quantity>=4;


--- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category  ,
	sum(total_sales)as net_sales,
	count(*)as total_orders
from retail_sales
group by 1;


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select 
	round(avg(age),2)as avg_sales
from retail_sales
where category='Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select  *  from retail_sales
where total_sales>1000 ;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select
	category,
	gender,
	count(*) as total_trans
from retail_sales
group by category,gender
order by category desc;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select 
	year,
	month,
	avg_sales 
from(
select
		extract(year from sales_date)as year,
		extract(month from sales_date)as month,
		avg(total_sales)as avg_sales,
		rank()over(partition by extract (year from sales_date) order by avg(total_sales)desc) as rank
	from retail_sales
	group by year,month
)  as t1
where rank=1


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select  
	customer_id,
	sum(total_sales)as total_saels
from retail_sales
group by 1
order by 2 desc
limit 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select
	category,
	count(distinct customer_id)as cnt_unique_cs
from retail_sales
group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
with hourly_sales
as
(
select *,
	case
		when extract(hour from sales_time)<12 then 'morning'
		when extract(hour from sales_time) between 12 and 17 then 'afternoon'
		else'evening'
	end as shift
from retail_sales
)
select
	shift,
	count(*) as total_orders
from hourly_sales
group by shift;

--end of project


