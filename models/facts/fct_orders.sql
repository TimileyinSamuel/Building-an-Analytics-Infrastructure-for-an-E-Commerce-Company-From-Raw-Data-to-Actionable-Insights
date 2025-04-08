{{ 
  config(
    materialized = 'incremental',
    unique_key = 'order_id',
    incremental_strategy = 'merge'
  ) 
}}

WITH base AS (
    SELECT
        o.order_id,
        c.customer_id,
        c.unique_customer_id,
        o.order_status,
        o.order_purchase_timestamp,
        o.order_approved_at,
        o.order_delivered_carrier_date,
        o.order_delivered_customer_date,
        o.order_estimated_delivery_date,
        o.is_late_delivery,
        o.is_estimate_met,
        c.customer_city,
        c.customer_state,
        o.last_updated_at
    FROM {{ ref('stg_orders') }} o
    LEFT JOIN {{ ref('stg_customers') }} c ON o.customer_id = c.customer_id
    {% if is_incremental() %}
      WHERE o.order_purchase_timestamp >= (
        SELECT MAX(order_purchase_timestamp) FROM {{ this }}
      )
    {% endif %}
)

SELECT *
FROM base