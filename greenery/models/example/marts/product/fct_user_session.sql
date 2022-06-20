{{ config(materialized='table' ) }}

with 

users as (
    select * from {{ ref('dim_users')}}
),

event_activity as (
    select * from {{ ref('int_session_events_basic_agg')}}
)


select
    
    ea.user_id,
    ea.session_id,
    count(ea.event_id) as event_count,
    count(distinct ea.product_id) as distinct_product_viewed,
    sum(ea.page_view) as page_view_count,
    sum(ea.add_to_cart) as add_to_cart_count,
    sum(ea.checkout) as checkout_count,
    sum(ea.package_shipped) as package_shipped_count
from
    event_activity as ea
left join 
    users as u 
on u.user_id=ea.user_id
group by 1,2
