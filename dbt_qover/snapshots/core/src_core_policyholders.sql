{% snapshot src_core_policyholders %}

{{
    config(
      unique_key='policyholder_id',
      strategy='check',
      check_cols=['contract_id', 'gender', 'first_name', 'last_name', 'address', 'language'],
      post_hook=snapshot_backdate('{{ this }}')
    )
}}

with source as (
    select policyholder_id
    , safe_cast(age as float64) as age --to cast the column to float instead of string
    , gender
    , first_name
    , last_name
    , address
    , language
    , loaded_at
    from {{ source('raw_core', 'src_policyholders') }}
),

final as (
    select *
    from source
)

select *
from final

{% endsnapshot %}