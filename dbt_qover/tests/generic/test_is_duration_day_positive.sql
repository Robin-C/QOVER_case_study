{% test is_duration_day_positive(model, column_name) %}

with source as (
  select {{ column_name }} as col
  from {{ model }}
),

final as (
  select col
  from source
  where col < 0
)

select *
from final

{% endtest %}
