{{config(materialized='view')}}

with source_data as (
    select *
from {{source('src_greenery', 'events')}}
),

renamed_recast as (

  select 

      event_id,
      session_id,
      user_id,
      event_type,
      page_url,
      created_at as created_at_utc,
      order_id,
      product_id

from source_data
)
select *
from renamed_recast