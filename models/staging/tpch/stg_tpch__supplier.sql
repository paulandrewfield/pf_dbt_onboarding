with 

source as (

    select * from {{ source('tpch', 'supplier') }}

),

renamed as (

    select
        s_suppkey as supplier_key,
        s_name as supplier_name,
        s_address as supplier_addres,
        s_nationkey as nation_key,
        s_phone as supplier_phone,
        s_acctbal as supplier_account_balance,
        s_comment as supplier_comment

    from source

)

select * from renamed