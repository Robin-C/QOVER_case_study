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

, final as (
  select *
  from add_policyholders_information
)

select *
from final
