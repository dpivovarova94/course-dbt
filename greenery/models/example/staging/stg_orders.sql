{{config(materialized='view')}}

with source_data as (
    select *
from {{source('src_greenery', 'orders')}}
),

renamed_recast as (

  select 
    -- ids
      order_id,
      promo_id,
      user_id,
      address_id,


    -- costs
      order_cost,
      shipping_cost,
      order_total,
    
      -- timestamps
      created_at as created_at_utc,
      estimated_delivery_at as estimated_delivery_at_utc,
      delivered_at as delivered_at_utc,

      --shipping
      tracking_id,
      shipping_service,
      status

from source_data
)
select *
from renamed_recast