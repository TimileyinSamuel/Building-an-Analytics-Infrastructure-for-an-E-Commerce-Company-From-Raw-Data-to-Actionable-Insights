WITH base AS (
    SELECT
        order_id,
        order_purchase_timestamp,
        order_delivered_customer_date,
        order_estimated_delivery_date,
        DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY) AS actual_delivery_days,
        DATE_DIFF(order_estimated_delivery_date, order_purchase_timestamp, DAY) AS estimated_delivery_days
    FROM {{ ref('stg_orders') }}
    WHERE order_delivered_customer_date IS NOT NULL
)

SELECT *
FROM base