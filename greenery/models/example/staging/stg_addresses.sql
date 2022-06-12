{{config(materialized='view')}}

with source_data as (
    select *
from {{source('src_greenery', 'addresses')}}
),

renamed_recast as (

  select 

      address_id,
      address,
      zipcode,
      state,
      country

from source_data
)
select *
from renamed_recast