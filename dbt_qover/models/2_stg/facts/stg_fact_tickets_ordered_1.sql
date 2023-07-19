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
),

clean_duration as (
  select ticket_id
  , contract_id
  , ticket_number
  , case when duration_day < 0 then 0 else duration_day end as duration_day
  , type
  from add_step_number
),

add_duration_bracket as (
  select *
      , {{ tickets_duration_brackets('duration_day', false) }} as duration_day_bracket
  from clean_duration
)

, final as (
  select *
  from add_duration_bracket
)

select *
from final
