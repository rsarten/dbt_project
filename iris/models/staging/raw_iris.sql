with source_data as (

    select * 
    from {{ source('public', 'iris') }}
)

select *
from source_data

