{{ config(materialized = 'table') }}

WITH

orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
)

, promos AS (
    SELECT * FROM {{ ref('stg_promos') }}
)

, addresses AS (
    SELECT * FROM {{ ref('stg_addresses') }}
)

SELECT 
  orders.user_id
  , orders.order_id
  , orders.order_cost
  , orders.order_total
  , addresses.address_id
  , addresses.address AS address_shipped_to
  , addresses.zipcode AS zipcode_shipped_to
  , addresses.state AS state_shipped_to
  , addresses.country AS country_shipped_to
  , orders.tracking_id
  , orders.shipping_service
  , orders.created_at_utc
  , orders.estimated_delivery_at_utc
  , orders.delivered_at_utc
  , orders.status AS order_status
  , orders.shipping_cost
  , promos.promo_id
  , promos.discount AS promo_discount
  , case 
        when promos.promo_id is not null then true 
        else false 
    end as is_promo
  , age(delivered_at_utc, created_at_utc) as days_to_deliver

FROM orders
LEFT JOIN promos ON orders.promo_id = promos.promo_id
LEFT JOIN addresses ON orders.address_id = addresses.address_id

