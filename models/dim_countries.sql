{{ config(materialized="table") }}

with
    countries as (
        select
            country, iso, fips, capital, currency_code, currency_name, area, population
        from `gdelt-bq.extra.countryinfo2`
    ),
    sources as (
        select countryname, fips, domain from `gdelt-bq.extra.sourcesbycountry`
    ),
    country_sources as (
        select
            countryname as country,
            fips as fips,
            count(domain) as sources,
            count(distinct domain) as distinct_sources
        from sources
        group by 1, 2
    ),
    final as (
        select c.*, cs.sources, cs.distinct_sources
        from countries c
        left join country_sources cs using (country, fips)
    )
select *
from final
