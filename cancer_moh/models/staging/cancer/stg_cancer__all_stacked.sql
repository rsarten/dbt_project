with
cervical as (
    select 
        *,
        'cervical' as cancer 
    from {{ source('health', 'cervical') }}
),

colorectal as (
    select
        *,
        'colorectal' as cancer 
    from {{ source('health', 'colorectal') }}
),

female_breast as (
    select
        *,
        'female_breast' as cancer 
    from {{ source('health', 'female_breast') }}
),

hodgkin as (
    select
        *,
        'hodgkin' as cancer 
    from {{ source('health', 'hodgkin') }}
),

leukaemia as (
    select
        *,
        'leukaemia' as cancer 
    from {{ source('health', 'leukaemia') }}
),

lung as (
    select
        *,
        'lung' as cancer 
    from {{ source('health', 'lung') }}
),

melanoma as (
    select
        *,
        'melanoma' as cancer 
    from {{ source('health', 'melanoma') }}
),

myeloproliferative as (
    select
        *,
        'myeloproliferative' as cancer 
    from {{ source('health', 'myeloproliferative') }}
),

non_hodgkin as (
    select
        *,
        'non_hodgkin' as cancer 
    from {{ source('health', 'non_hodgkin') }}
),

prostate as (
    select
        *,
        'prostate' as cancer 
    from {{ source('health', 'prostate') }}
),

final as (
    select *
    from cervical
    union all
        select *
        from colorectal
    union all
        select *
        from female_breast
    union all
        select *
        from hodgkin
    union all
        select *
        from leukaemia
    union all
        select *
        from lung
    union all
        select *
        from melanoma
    union all
        select *
        from myeloproliferative
    union all
        select *
        from non_hodgkin
    union all
        select *
        from prostate
)

select * from final
