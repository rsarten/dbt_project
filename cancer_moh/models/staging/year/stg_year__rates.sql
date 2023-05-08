with
rates_maori as (
    select * 
    from {{ source('health', 'rates_maori') }}
),

rates_non_maori as (
    select * 
    from {{ source('health', 'rates_non_maori') }}
),

maori as (
    select
        *,
        'Maori' as ethnicity
    from rates_maori
),

non_maori as (
    select
        *,
        'Non-Maori' as ethnicity
    from rates_non_maori
),

-- stack rates tables
final as (
    select * 
    from maori
    union all
        select *
        from non_maori
)

select * from final
