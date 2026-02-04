<<<<<<< HEAD
-- just a test
=======
-- a merge conflict test
>>>>>>> 04b3d7b993e60e20f1354935fd385cf5fff647e1
with order_items as (
    select * from {{ ref('order_items') }}
), 

part_suppliers as (
    select * from {{ ref('part_suppliers') }}
),

final as (
     select
     {{ dbt_utils.generate_surrogate_key(['o.order_key', 'o.supplier_key', 'o.part_key']) }} as fct_order_item_key,
    o.ORDER_DATE, o.ORDER_TIME, o.TOTAL_PRICE, o.LINE_NUMBER, o.LINE_QUANTITY_ORDERED, o.LINE_EXTENDED_PRICE, o.LINE_DISCOUNT, o.LINE_TAX,
    p.PART_RETAIL_PRICE,  p.PART_AVAILABLE_QUANTITY

     from order_items o
     left join part_suppliers p using (part_key, supplier_key)

    
)

select * from final
