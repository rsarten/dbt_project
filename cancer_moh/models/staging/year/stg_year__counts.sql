with 
counts_maori as (
    select * 
    from {{ source('health', 'counts_maori') }}
),

counts_non_maori as (
    select * 
    from {{ source('health', 'counts_non_maori') }}
),

maori as (
    select
        *,
        'Maori' as ethnicity
    from counts_maori
),

non_maori as (
    select
        *,
        'Non-Maori' as ethnicity
    from counts_non_maori
),

-- stack count tables
final as (
    select * 
    from maori
    union all
        select *
        from non_maori
)

select * from final



