{{config(materialized='view')}}

with source_data as (
    select *
from {{source('src_greenery', 'promos')}}
),

renamed_recast as (

  select 
      promo_id,
      discount,
      status

from source_data
)
select *
from renamed_recast