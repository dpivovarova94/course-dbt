{{config(materialized='view')}}

with source_data as (
    select *
from {{source('src_greenery', 'products')}}
),

renamed_recast as (

  select 

      product_id,
      name,
      price,
      inventory

from source_data
)
select *
from renamed_recast