with
    source as (
        select * 
        from {{ source("gdelt-bq_extra", "countryinfo2") }}
    ),
    countries as (
        select
            country, iso, fips, capital, currency_code, currency_name, {{ total_to_thousands('area') }} as area, population
        from source
    )
select *
from countries
