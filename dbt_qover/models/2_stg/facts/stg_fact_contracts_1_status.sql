{{
    config(
        materialized='ephemeral'
    )
}}


with source as (
  select
    contract_id
    , policyholder_id
    , start_date
    , end_date
    , cancel_reason
    , loaded_at
  from {{ ref('src_core_contracts') }}
)

, add_contract_status as (
  select
    *
    , not coalesce(end_date is null, false) as has_churned
  from source
)

, final as (
  select *
  from add_contract_status
)

select *
from final
