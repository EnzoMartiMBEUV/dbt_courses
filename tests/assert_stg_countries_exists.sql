with countries as (
    select * from {{ ref('stg_countries') }}
)
select * from countries where country is null