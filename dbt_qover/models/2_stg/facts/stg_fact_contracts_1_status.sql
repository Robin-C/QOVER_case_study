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

, clean_cancel_reason as (
  select
    contract_id
    , policyholder_id
    , start_date
    , end_date
    , case when end_date is null then null else cancel_reason end as cancel_reason
    , loaded_at
    , has_churned
  from add_contract_status

)

, final as (
  select *
  from clean_cancel_reason
)

select *
from final
