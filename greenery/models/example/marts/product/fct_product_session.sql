{{ config(materialized='table' ) }}

with 

products as (
    select * from {{ ref('dim_products')}}
),

event_activity as (
    select * from {{ ref('int_session_events_basic_agg')}}
)


select
    
    ea.product_id,
    p.name as product_name,
    count(ea.event_id) as event_count,
    sum(ea.page_view) as page_view_count,
    sum(ea.add_to_cart) as add_to_cart_count,
    sum(ea.checkout) as checkout_count,
    sum(ea.package_shipped) as package_shipped_count
from
    event_activity as ea
left join 
    products as p
on p.product_id=ea.product_id
where ea.product_id is not NULL
group by 1,2 
