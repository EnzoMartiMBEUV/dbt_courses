with
    source as (
        select * 
        from {{ source("gdelt-bq_extra", "countryinfo2") }}
    ),
    countries (
        select
            country, iso, fips, capital, currency_code, currency_name, area, population
        from source
    )
select *
from countries
