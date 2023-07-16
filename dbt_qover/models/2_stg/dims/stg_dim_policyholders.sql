with source as (
    select policyholder_id
    , age
    , gender
    , first_name
    , last_name
    , concat(first_name, ' ', last_name) as full_name
    , address
    , language
    , loaded_at
    , {{ snapshot_rename_cols() }}
    from {{ ref('src_core_policyholders') }}
),

/* Here we could potentially add infos from other sources such as salesforce data etc... */

reorder_cols as (
    select sk_id
         , policyholder_id
         , age
         , gender
         , full_name
         , first_name
         , last_name
         , address
         , language
         , loaded_at
         , valid_from
         , valid_to
         , updated_at
    from source
),

final as (
    select *
    from reorder_cols
)

select *
from source