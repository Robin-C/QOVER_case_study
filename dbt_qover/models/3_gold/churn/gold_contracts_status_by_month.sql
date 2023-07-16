with source as (
  select *
  from {{ ref('gold_contracts_enriched') }}
)

, dates as (
  select *
  from {{ ref('stg_dim_dates') }}
)

, crossjoined as (
  select
    dates.year_month
    , source.*
  from source
  cross join dates
  where
    source.start_date <= dates.full_date
    and coalesce(source.end_date, date_trunc(cast(current_timestamp() as date), month)) >= full_date
  group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
)

, add_prev_period_was_present as (
    select *
         , case when 
             lag(year_month, 1) over(partition by contract_id order by year_month) is null then false 
             else true end 
           as was_present_prev_period
    from crossjoined
)

, add_has_churned_this_period as (
  select
    *
    , coalesce(format_date('%Y-%m', end_date) = year_month, false) as has_churned_this_period
  from add_prev_period_was_present
)

, reorder_cols as (
  select
    year_month
    , was_present_prev_period
    , has_churned_this_period
    , contract_id
    , policyholder_id
    , start_date
    , end_date
    , has_churned
    , cancel_reason
    , loaded_at
    , age
    , gender
    , full_name
    , address
    , language
  from add_has_churned_this_period
)

, final as (
  select *
  from reorder_cols
)

select *
from final
