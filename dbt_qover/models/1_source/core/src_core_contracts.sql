{{
    config(
        materialized='incremental',
        unique_key='contract_id'
    )
}}

with source as (
  select
    contract_id
    , policyholder_id
    , safe_cast(start_date as date) as start_date
    , safe_cast(end_date as date)   as end_date
    , cancel_reason
    , loaded_at
  from {{ source('raw_core', 'src_contracts') }}
)

, final as (
  select *
  from source
)

select *
from final
