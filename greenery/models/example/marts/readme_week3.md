# Part 1
## 1 What is our overall conversion rate?
select count (distinct case when checkout=1 then session_id end)::float/count(distinct session_id)::float
from dbt.dbt_darima_p.int_session_events_basic_agg

0.62

## What is our conversion rate by product?
since there is a fct_product_session table, it's easy to calculate:
```
select 
product_id,
product_name,
page_view_count,
add_to_cart_count,
add_to_cart_count/page_view_count as converstion_rate
--count (distinct case when checkout=1 then session_id end)::float/count(distinct session_id)::float
from dbt.dbt_darima_p.fct_product_session
order by 5 desc
```
the Top converted product is String of Perls
Some products might convert better than the others depending on where are they positioned (which page), if they are featured in marketing campaigns, if they are recommended more often or more precisely 

# Part 2
## Create a macro to simplify part of a model(s)

added a macro to marts/product/intermediate/int_session_events_basic_agg.sql
```
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

from source_data
group by 1,2,3,4
)
select *
from renamed_recast
```
# Part 3
## Add a post hook to your project to apply grants to the role “reporting”. Create reporting role first by running CREATE ROLE reporting in your database instance.
```
on-run-end:
  - "grant usage on schema {{dbt_darima_p}} to role reporting"
```

# Part 4
## Install a package (i.e. dbt-utils, dbt-expectations) and apply one or more of the macros to your project
Added package dbt_utils: /greenery/packages.yml
```
packages:
  - package: dbt-labs/dbt_utils
    version: 0.8.6
```
adding datediff macro to fct_orders.sql:

```
,{{ dbt_utils.datediff("date(orders.created_at_utc)", "date(orders.delivered_at_utc)", 'day') }} as days_to_order_delivery
```

adding get_query_results_as_dict to fct_users_summary.sql:

```
{{ config(materialized = 'table') }}

{% set sql_statement %}
    select distinct order_status from {{ ref('int_user_orders') }}
{% endset %}

{% set order_statuses = dbt_utils.get_query_results_as_dict(sql_statement) %}

select 
    uo.user_id,
    uo.state,
    min(uo.order_created_date) as first_order_date,
    max(uo.order_created_date) as last_order_date,
    count(uo.order_id) as order_count,
    count(distinct(oi.quantity)) as order_items_quantity,
    sum(uo.order_total) as order_amount
    {% for order_status in order_statuses['order_status'] %}
      ,sum(case when order_status= '{{order_status}}' then 1 else 0 end) as {{order_status}}_orders_count
      {% endfor %}
from
    {{ ref('int_user_orders') }} uo
join
    {{ ref('stg_order_items') }} as oi
on uo.order_id=oi.order_id
group by 1,2
```
# Part 5
the DAG file doesn't look too different since I didn't create many more tables, I rather practiced macros on existing tables.