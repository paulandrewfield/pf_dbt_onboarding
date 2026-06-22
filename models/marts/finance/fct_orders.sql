{{
    config(
        materialized='incremental',
    )
}}

select 
    o.order_id
    , o.customer_id
    , coalesce(p.amount, 0) as amount
    ,order_date
from {{ ref('stg_jaffle_shop__orders') }} o
    left join {{ ref('stg_stripe__payments') }} p using (order_id)

{% if is_incremental() %}
    -- this filter will only be applied on an incremental run
    where order_date > (select max(order_date) from {{ this }}) 
{% endif %}