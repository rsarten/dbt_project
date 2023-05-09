with
counts as (
    select *
    from {{ ref('stg_year__counts')}}
),

-- add row number
counts_rn as (
    select 
        *,
        row_number() over(order by (select null)) as row_num
    from counts
),

-- create grouping int for year, e.g. sequence of 2014, null, null will all be 1
cancer_grp as (
    select
        *,
        sum(case when cancer is not null then 1 end) over (order by row_num) as grp
    from counts_rn
),

-- replace year values by first value ('year value') in grp
cancer_filled as (
    select
        first_value(cancer) over (partition by grp) as cancer,
        {{ dbt_utils.star(from=ref('stg_year__counts'), except=['cancer']) }}
    from cancer_grp
),

no_totals as (
    select
        {{ dbt_utils.star(from=ref('stg_year__counts'), except=['Total']) }}
    from cancer_filled
    where sex <> 'Total'
),

-- standardise cancer description
cancer_class as (
    select 
        case 
			when cancer like '%C53%' then 'cervical'
			when cancer like '%C18%' then 'colorectal'
            when cancer like '%C50%' then 'female_breast'
			when cancer like '%C91%' then 'leukaemia'
            when cancer like '%C43%' then 'melanoma'
			when cancer like '%C61%' then 'prostate'
            when cancer like '%C33%' then 'lung'
			when cancer like '%C81%' then 'hodgkin'
            when cancer like '%C82%' then 'non_hodgkin'
			when cancer like '%D45%' then 'myeloproliferative'
		end as cancer,
        {{ dbt_utils.star(from=ref('stg_year__counts'), except=['cancer', 'Total']) }}
    from no_totals
),

final as (
    select *
    from cancer_class
)

select * from final