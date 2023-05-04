{{ config(materialized='table') }}

with 
all_iris as (
    select *
    from {{ ref('raw_iris') }}
),

full_iris as (
    select 
        *,
        row_number() over(order by (select NULL)) as row_num
    from all_iris
),

max_pl as (
    select
        *,
        'max petal length' as description
    from full_iris
    order by petal_length desc
    limit 1
),

max_pw as (
    select
        *,
        'max petal width' as description
    from full_iris
    order by petal_width desc
    limit 1
),

max_sl as (
    select
        *,
        'max sepal length' as description
    from full_iris
    order by sepal_length desc
    limit 1
),

max_sw as (
    select
        *,
        'max sepal width' as description
    from full_iris
    order by sepal_width desc
    limit 1
)

select *
from max_pl
union 
    select * from max_pw
union 
    select * from max_sl
union 
    select * from max_sw