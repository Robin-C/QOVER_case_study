with source as (
  select *
  from {{ ref('src_core_tickets') }}
)

/* we add the ticket number to get a sense of history regarding a specific contract */
, add_step_number as (
  select
    ticket_id
    , contract_id
    , row_number() over (partition by contract_id order by ticket_id) as ticket_number
    , duration_day
    , case
        when duration_day >= 0 and duration_day < 10 then '[0,10['
        when duration_day >= 10 and duration_day < 20 then '[10,20['
        when duration_day >= 20 and duration_day < 30 then '[20,30['
        when duration_day >= 30 and duration_day < 40 then '[30,40['
        when duration_day >= 40 and duration_day < 50 then '[40,50['
        else '>50'
      end as duration_day_bracket
    , type
  from source
)

, final as (
  select *
  from add_step_number
)

select *
from final
