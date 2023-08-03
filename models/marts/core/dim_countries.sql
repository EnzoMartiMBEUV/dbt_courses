with
    countries as (select * from {{ ref("stg_countries") }}),
    sources as (select * from {{ ref("stg_sources") }}),
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
