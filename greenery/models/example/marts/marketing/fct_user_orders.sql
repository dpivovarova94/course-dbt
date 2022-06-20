{{ config(materialized = 'table') }}

select 
    uo.user_id,
    uo.state,
    min(uo.order_created_date) as first_order_date,
    max(uo.order_created_date) as last_order_date,
    count(uo.order_id) as order_count,
    count(distinct(oi.quantity)) as order_items_quantity,
    sum(uo.order_total) as order_amount
from
    {{ ref('int_user_orders') }} uo
join
    {{ ref('stg_order_items') }} as oi
on uo.order_id=oi.order_id
group by 1,2