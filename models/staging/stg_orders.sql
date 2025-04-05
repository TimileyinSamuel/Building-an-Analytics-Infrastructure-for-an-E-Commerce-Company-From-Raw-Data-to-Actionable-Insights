WITH raw_orders AS (
    SELECT *
    FROM {{ source('ecommerce', 'orders') }}
)

SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date, 
    order_delivered_customer_date,
    order_estimated_delivery_date,
    CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN TRUE ELSE FALSE END AS is_late_delivery,
    CASE WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN TRUE ELSE FALSE END AS is_estimate_met,
    _fivetran_synced as last_updated_at
FROM raw_orders