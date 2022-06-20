# Question 1: Repeat Rate = Users who purchased 2 or more times / users who purchased
```
with orders_per_user as(
select o.user_id, 
count(distinct order_id) order_count
from dbt_darima_p.stg_orders o 
left join dbt_darima_p.stg_users u on o.user_id=u.user_id
group by 1

),

user_with_2_and_more_orders as
(
select user_id,
count(distinct user_id) user_count,
count(case when order_count>=2 then user_id end) user_with_2_plus_orders_count
from orders_per_user
group by 1

)

select sum(user_count),
sum(user_with_2_plus_orders_count),
sum(user_with_2_plus_orders_count)/sum(user_count) as repeat_rate
from user_with_2_and_more_orders

79.8% repeat rate
```

# What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

- I would look at the customer satisfaction, the rating they left for the purchased items, the NPS score: how satisfied are our customers with the services and products?
- look at the marketing channels that we acuired the customer from: are some marketing channels give us bad quality customers?
- look at delivery times: ho fast are we delivering and do we keep the time of delivery promised to the customer, does it influence the repeat_rate of the customer?


# Explain the marts models you added. Why did you organize the models in the way you did?
as was mentioned in the project description, I added dim_products, dim_users and fct_orders to the core folder. Those tables are further used in intermediate tables under marketing and product projects. Lastly, fact tables are build in marketinf and product projects that combine the intermediate tables with other tables for enriching the data and getting it aggregated on the needed level. 

# Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through

as i understand those column level tests implemented will fail with the dbt build command if something doesn't pass the tests. So, I would connect it to Slack, so the Data team is notified whenever those tests are failing.