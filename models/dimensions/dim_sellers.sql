WITH orders_per_seller AS (
    SELECT 
        seller_id,
        COUNT(DISTINCT order_id) AS total_orders_fulfilled,
        MAX(shipping_limit_date) AS last_shipping_deadline
    FROM {{ ref('stg_order_items') }}
    GROUP BY seller_id
)

SELECT 
    s.seller_id,
    s.seller_zip_code_prefix,
    s.seller_city,
    s.seller_state,
    ops.total_orders_fulfilled,
    ops.last_shipping_deadline,
    s.last_updated_at
FROM {{ ref('stg_sellers') }} s
LEFT JOIN orders_per_seller ops
    ON s.seller_id = ops.seller_id