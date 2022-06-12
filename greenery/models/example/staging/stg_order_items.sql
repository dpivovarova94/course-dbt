{{config(materialized='view')}}

with source_data as (
    select *
from {{source('src_greenery', 'order_items')}}
),

renamed_recast as (

  select 
      order_id,
      product_id,
      quantity

from source_data
)
select *
from renamed_recast