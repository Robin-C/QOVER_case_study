{{
    config(
        materialized='incremental',
        unique_key='ticket_id'
    )
}}

with source as (
  select
    ticket_id
    , contract_id
    , duration as duration_day
    , case when type = 'claims' then 'claim' else type end as type
    , loaded_at
  from {{ source('raw_core', 'src_tickets') }}
)

, final as (
  select *
  from source
)

select *
from final
