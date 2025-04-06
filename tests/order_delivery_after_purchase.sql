SELECT *
FROM {{ ref('stg_orders') }}
WHERE order_delivered_customer_date < order_purchase_timestamp
