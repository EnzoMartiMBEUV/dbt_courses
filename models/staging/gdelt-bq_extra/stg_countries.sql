with
    countries as (
        select
            country, iso, fips, capital, currency_code, currency_name, area, population
        from `gdelt-bq.extra.countryinfo2`
    )
select *
from countries
