with source as (
    select *
    from {{ ref('stg_fact_tickets_ordered_1') }}
),

add_contract_data as (
    select source.*
        , case when gce.end_date is null then false else true end as has_churned
        , gce.end_date
        , gce.cancel_reason
        , gce.language
    from source
    left join {{ ref('_gold_contracts_enriched') }} gce on source.contract_id = gce.contract_id
),

final as (
    select *
    from add_contract_data
)

select *
from final