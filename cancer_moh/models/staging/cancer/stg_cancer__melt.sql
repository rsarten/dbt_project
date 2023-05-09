with 
melted as (
    select *
    from (
        {{
        dbt_utils.unpivot(
            relation=ref("stg_cancer__cleaned"),
            cast_to="float",
            exclude=["year", "ethnicity", "data_type", "cancer"],
            field_name="age_group",
            value_name="obs_value",
        ) 
    }}
    ) unpvt
),

-- get rid of 'total' metrics
obs as (
    select *
    from melted
    where data_type not like '%total'
),

-- tidy up values
-- split data_type to get the value type and the sex
-- sadly remove macron from Maori for standardisation
-- make sure year is an integer
obs_class as (
    select
        cast("year" as integer) as "year",
        case 
			when ethnicity like 'M%' then 'Maori'
			when ethnicity like 'N%' then 'Non-Maori'
		end as ethnicity,
        case 
            when data_type like 'count%' then 'count'
            when data_type like 'rate%' then 'rate'
        end as data_type,
        case 
            when data_type like '%male' then 'Male'
            when data_type like '%female' then 'Female'
        end as sex,
        cancer,
        age_group,
        coalesce(obs_value, 0) as "value"
    from obs
),

final as (
    select *
    from obs_class
)

select * from final