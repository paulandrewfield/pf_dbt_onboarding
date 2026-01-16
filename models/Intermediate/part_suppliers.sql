with parts as (
    select * from {{ ref('stg_tpch__part') }}
), 

with partsupp as (
    select * from {{ ref('stg_tpch__partsupp') }}
), 

with supplier as (
    select * from {{ ref('stg_tpch__supplier') }}
)

final as (
    select * from parts 
    left join partsupp using (part_key)
    left join supplier using (supplier_key)
)

select * from final