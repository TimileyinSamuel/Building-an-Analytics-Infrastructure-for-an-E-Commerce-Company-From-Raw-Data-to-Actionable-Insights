WITH raw_sellers AS (
    SELECT *
    FROM {{ ref('sellers_snapshot') }}
    WHERE dbt_valid_to IS NULL
)

SELECT 
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state,
    _fivetran_synced as last_updated_at
FROM raw_sellers