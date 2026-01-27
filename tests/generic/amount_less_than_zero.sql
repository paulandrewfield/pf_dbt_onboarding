{% test amount_less_than_zero( model, column_name, group_by_column) %}

select 
    {{ group_by_column }},
    sum( {{ column_name }} ) as amount

from {{ model }}
group by 1
having not(amount >= 0)


{% endtest %}