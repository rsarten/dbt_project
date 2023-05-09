with
stacked as (
    select *
    from {{ ref('stg_cancer__all_stacked')}}
),

-- add row number
stacked_rn as (
    select 
        *,
        row_number() over(order by (select null)) as row_num
    from stacked
),

-- create grouping int for year, e.g. sequence of 2014, null, null will all be 1
year_grp as (
    select
        *,
        sum(case when "year" is not null then 1 end) over (order by row_num) as grp
    from stacked_rn
),

-- replace year values by first value ('year value') in grp
cleaned_year as (
    select
        first_value("year") over (partition by grp) as "year",
        {{ dbt_utils.star(from=ref('stg_cancer__all_stacked'), except=['year']) }}
    from year_grp
),

-- remove empty header rows (null) and total rows 'All'
valid_eth as (
    select *
    from cleaned_year
    where ethnicity is not null and ethnicity <> 'All'
),

final as (
    select *
    from valid_eth
)

select * from final