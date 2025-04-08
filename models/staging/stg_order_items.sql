WITH raw_order_items AS (
    SELECT *
    FROM {{ source('ecommerce', 'order_items') }}
)

SELECT
    order_id, 
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value,
    price + freight_value AS total_item_value,
    _fivetran_synced as last_updated_at
FROM raw_order_items