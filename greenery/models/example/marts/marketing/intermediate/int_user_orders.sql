{{ config(materialized = 'table') }}

with users as (
    select * 
    from {{ ref('dim_users') }}
), 

orders as (
    select *
    from {{ ref('fct_orders') }}
)

select
  users.*
  , orders.order_id
  , orders.order_cost
  , orders.order_total
  , orders.shipping_service
  , orders.order_status
  , orders.shipping_cost
  , orders.is_promo
  , orders.days_to_deliver
  , date(orders.created_at_utc) as order_created_date
  , orders.state_shipped_to
from 
    users
join 
    orders 
on users.user_id=orders.user_id