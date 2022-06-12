#1.How many users do we have?

```
select count(distinct user_id)
from dbt_darima_p.stg_users

130
```

#2. On average, how many orders do we receive per hour?
```
with
order_per_hour as
(
select date_trunc('hour', created_at_utc), count(order_id) avg_orders
from dbt_darima_p.stg_orders
group by 1)
select avg(avg_orders)
from order_per_hour

7.5
```

#3. On average, how long does an order take from being placed to being delivered?
```
with date_difference as(
select order_id,
created_at_utc, 
delivered_at_utc,
age(delivered_at_utc, created_at_utc) delivery_time
from dbt_darima_p.stg_orders
where delivered_at_utc is not null)


3 days 21:24:11.803279
```
#4. How many users have only made one purchase? Two purchases? Three+ purchases?
```
with orders_per_user as(
select o.user_id, 
count(distinct order_id) order_count
from dbt_darima_p.stg_orders o 
left join dbt_darima_p.stg_users u on o.user_id=u.user_id
group by 1

)

select order_count,
count(distinct user_id) user_count
from orders_per_user
where order_count<=3
group by 1
order by 2 desc

25 users with 1 order
28 with 2 orders
34 with 3 orders
```

#5 On average, how many unique sessions do we have per hour?

```

with session_per_hour as
(
select date_trunc('hour', created_at_utc) as hour,
count(distinct session_id) unique_session_count
from dbt_darima_p.stg_events
group by 1
)
select round(avg(unique_session_count), 1)
from session_per_hour

16.3
```