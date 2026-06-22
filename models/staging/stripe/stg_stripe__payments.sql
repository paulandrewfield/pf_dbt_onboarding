{{
    config(
        required_tests=None
    )
}}

with source as (

    select * from {{ source('stripe', 'payment') }}

),

transformed as (
    select 
        id as payment_id
        ,orderid as order_id
        ,paymentmethod as payment_method
        ,amount
        ,{{cents_to_dollars("amount")}} as amount_macro
        ,status as payment_status
        ,created as created_at
        , _batched_at

from source
)

select * from transformed