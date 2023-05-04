{{ config(materialized='table') }}

with 
all_iris as (
    select *
    from {{ ref('raw_iris') }}
)

select
    avg(petal_length) as av_pl,
    avg(petal_width) as av_pw,
    avg(sepal_length) as av_sl,
    avg(sepal_width) as av_sw,
    iris_class
from all_iris
group by iris_class