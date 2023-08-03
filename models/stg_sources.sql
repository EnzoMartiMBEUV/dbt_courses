with
    sources as (select countryname, fips, domain from `gdelt-bq.extra.sourcesbycountry`)
select *
from sources
