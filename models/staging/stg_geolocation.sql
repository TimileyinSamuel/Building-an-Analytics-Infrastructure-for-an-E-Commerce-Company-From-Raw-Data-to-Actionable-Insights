WITH raw_geolocation AS (
    SELECT * 
    FROM {{ source("ecommerce", "geolocation") }}
)

SELECT
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state,
    _fivetran_synced as last_updated_at
FROM raw_geolocation
WHERE geolocation_lat IS NOT NULL AND geolocation_lng IS NOT NULL
