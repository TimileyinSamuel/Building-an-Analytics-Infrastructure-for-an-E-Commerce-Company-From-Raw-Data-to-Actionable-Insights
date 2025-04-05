WITH raw_products AS (
    SELECT *
    FROM {{ source('ecommerce', 'products') }}
)

SELECT
    product_id,
    product_category_name,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm,
    _fivetran_synced as last_updated_at
FROM raw_products