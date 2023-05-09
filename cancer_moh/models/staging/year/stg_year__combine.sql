
with
rates as (
    select *
    from {{ ref('stg_year__rates_melt')}}
),

counts as (
    select *
    from {{ ref('stg_year__counts_melt')}}
),

final as (
    select *
    from rates
    union all
        select *
        from counts
)

select * from final
