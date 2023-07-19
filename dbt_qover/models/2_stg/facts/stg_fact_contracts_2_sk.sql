with source as (
  select
    contract_id
    , policyholder_id
    , start_date
    , end_date
    , has_churned
    , cancel_reason
    , loaded_at
  from {{ ref('stg_fact_contracts_1_status') }}
)

, add_customer_sk as (
  select
    contract_id
    , policyholders.sk_id /* todo test not null */
    , src.policyholder_id
    , start_date
    , end_date
    , has_churned
    , cancel_reason
    , src.loaded_at
  from source as src
  left join {{ ref('stg_dim_policyholders') }} as policyholders on policyholders.policyholder_id = src.policyholder_id
  where
    1 = 1
    and cast(start_date as timestamp) >= policyholders.valid_from
    and coalesce(cast(start_date as timestamp), cast('2099-12-31' as timestamp)) <= policyholders.valid_to
)

, final as (
  select *
  from add_customer_sk
)

select *
from final
