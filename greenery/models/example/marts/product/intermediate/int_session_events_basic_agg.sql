{{ config(materialized = 'table') }}
{% set event_types = ['package_shipped', 'page_view', 'add_to_cart', 'checkout'] %}

with source_data as (
    select *
from {{ref('stg_events')}}
),

renamed_recast as (

  select 

  event_id,
      session_id,
      user_id,
      product_id
      {% for event_type in event_types %}
      ,sum(case when event_type= '{{event_type}}' then 1 else 0 end) as {{event_type}}
      {% endfor %}
      --sum(case when event_type='package_shipped' then 1 end) as package_shipped,
      --sum(case when event_type='page_view' then 1 end) as page_view,
      --sum(case when event_type='checkout' then 1 end) as checkout,
      --sum(case when event_type='add_to_cart' then 1 end) as add_to_cart
      

from source_data
group by 1,2,3,4
)
select *
from renamed_recast