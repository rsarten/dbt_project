with 
melted as (
    select *
    from (
        {{
        dbt_utils.unpivot(
            relation=ref("stg_year__rates_rename_ages"),
            cast_to="float",
            exclude=["year", "ethnicity", "sex", "cancer"],
            field_name="age_group",
            value_name="value",
        ) 
    }}
    ) unpvt
),

final as (
    select
        "year",
        ethnicity,
        'rate' as data_type,
        sex,
        cancer,
        age_group,
        "value"
    from melted
)

select * from final