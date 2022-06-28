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