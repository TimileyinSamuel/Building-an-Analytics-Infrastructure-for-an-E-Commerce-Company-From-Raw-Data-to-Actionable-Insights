WITH base AS (
    SELECT
        oi.order_id,
        oi.order_item_id,
        oi.product_id,
        oi.seller_id,
        oi.shipping_limit_date,
        oi.price,
        oi.freight_value,
        oi.total_item_value,
        oi.last_updated_at,
        p.product_category_name,
        s.seller_city,
        s.seller_state
    FROM {{ ref('stg_order_items') }} oi
    LEFT JOIN {{ ref('stg_products') }} p ON oi.product_id = p.product_id
    LEFT JOIN {{ ref('stg_sellers') }} s ON oi.seller_id = s.seller_id
)

SELECT *
FROM base