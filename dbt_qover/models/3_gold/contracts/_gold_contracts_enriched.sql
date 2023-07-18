with source as (
  select *
  from {{ ref('stg_fact_contracts_2_sk') }}
)

, add_policyholders_information as (
  select
    source.*
    , ph.age
    , ph.gender
    , ph.full_name
    , ph.address
    , ph.language
  from source
  inner join {{ ref('stg_dim_policyholders') }} as ph on source.sk_id = ph.sk_id
), 

add_ticket_data as (
  select api.*
     , string_agg(cast(tickets.ticket_id as string), ', ') as tickets_id
     , string_agg(tickets.type) as ticket_types
     , max(ticket_number) as tickets_count
     , sum(duration_day) as total_duration_day
    , {{ tickets_duration_brackets('duration_day', true) }} as total_duration_day_bracket 
  from add_policyholders_information api
  left join {{ ref('stg_fact_tickets_ordered_1') }} tickets on api.contract_id = tickets.contract_id 
  group by 1,2,3,4,5,6,7,8,9,10,11,12,13
)

, final as (
  select *
  from add_ticket_data
)

select *
from final
