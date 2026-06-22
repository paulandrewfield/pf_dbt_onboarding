-- import CTEs

with orders as (

select * from {{ ref('int__orders') }} 

),

customers as (

    select * from {{ ref('stg_jaffle_shop__customers') }}

),
--

customer_orders as (

    select 
        orders.*,
        customers.last_name,
        customers.first_name,
        customers.full_name,  

        -- customer level aggregegations
        min(order_date) over (
            partition by orders.customer_id
                    )
        as customer_first_order_date,


        min(valid_order_date) over (
            partition by orders.customer_id
        ) as customer_first_non_returned_order_date,


        max(valid_order_date) over (
            partition by orders.customer_id
        ) as customer_most_recent_non_returned_order_date,

        count(*) over (
            partition by orders.customer_id
        ) as customer_order_count,

        sum(nvl2(orders.valid_order_date , 1, 0) ) 
            over (
            partition by orders.customer_id
                )
            as customer_non_returned_order_count,

        sum(nvl2(orders.valid_order_date , order_value_dollars, 0)) 
            over (
            partition by orders.customer_id
                )
            as customer_total_lifetime_value,
            
        array_agg(distinct orders.order_id) over (
            partition by orders.customer_id
                )  as customer_order_ids


    from orders
    join customers on customers.customer_id = orders.customer_id
),

add_avg_order_value as (

    select
        *,
        customer_total_lifetime_value / customer_non_returned_order_count 
            as customer_avg_non_returned_order_value

    from customer_orders

),

-- Final CTEs

final as (

    select 
        order_id ,
        customer_id ,
        last_name,
        first_name,
        customer_first_order_date as first_order_date,
        customer_order_count as order_count,
        customer_total_lifetime_value as total_lifetime_value,
        order_value_dollars,
        order_status ,
        payment_status 
    from  add_avg_order_value

    

)

-- simple select statement
select * from final