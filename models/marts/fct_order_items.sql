
with order_items as (
    select * from {{ ref('order_items') }}
), 

part_suppliers as (
    select * from {{ ref('part_suppliers') }}
),

final as (
     select
     {{ dbt_utils.generate_surrogate_key(['o.order_key', 'o.supplier_key', 'o.part_key']) }} as fct_order_item_key,
    o.ORDER_DATE, year(o.ORDER_DATE) as order_year, o.ORDER_TIME, o.TOTAL_PRICE, o.LINE_NUMBER, o.LINE_QUANTITY_ORDERED, o.LINE_EXTENDED_PRICE, o.LINE_DISCOUNT, o.LINE_TAX,
<<<<<<< HEAD
    p.PART_RETAIL_PRICE,  p.PART_AVAILABLE_QUANTITY*2 AS PART_AVAILABLE_QUANTITY, 1 as test
=======
    p.PART_RETAIL_PRICE, p.PART_AVAILABLE_QUANTITY
>>>>>>> 9d173fe8caaf6a127f29e30ca867a4fbd2a0774a
     from order_items o
     left join part_suppliers p using (part_key, supplier_key)

    
)

select * from final
