with
    source as (
        select * 
        from {{ source("gdelt-bq_extra", "sourcesbycountry") }}
    ),
    sources as (
        select countryname, fips, domain 
        from source
    )
select *
from sources
