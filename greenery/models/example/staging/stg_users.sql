{{config(materialized='view')}}

with source_data as (
    select *
from {{source('src_greenery', 'users')}}
),

renamed_recast as (

  select 
    -- ids
      user_id,
      address_id,

    -- strings
      first_name,
      last_name,
      email,
      phone_number,
    
      -- timestamps
      created_at as created_at_utc,
      updated_at as updated_at_utc

from source_data
)
select *
from renamed_recast