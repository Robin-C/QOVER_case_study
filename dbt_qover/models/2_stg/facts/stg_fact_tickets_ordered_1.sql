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
    , type
  from source
)

, final as (
  select *
  from add_step_number
)

select *
from final
