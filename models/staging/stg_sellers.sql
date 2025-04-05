WITH raw_sellers AS (
    SELECT *
    FROM {{ source('ecommerce', 'sellers') }}
)

SELECT 
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state,
    _fivetran_synced as last_updated_at
FROM raw_sellers