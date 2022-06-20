{{ config(materialized = 'table') }}

WITH

users AS (
    SELECT * FROM {{ ref('stg_users') }}
)

, addresses AS (
    SELECT * FROM {{ ref('stg_addresses') }}
)

SELECT
  user_id
  , users.address_id
  , users.first_name
  , users.last_name
  , users.email
  , users.created_at_utc
  , date(users.created_at_utc) as created_date
  , users.phone_number
  , addresses.address
  , addresses.zipcode
  , addresses.state
  , addresses.country
FROM users
LEFT JOIN addresses ON users.address_id = addresses.address_id