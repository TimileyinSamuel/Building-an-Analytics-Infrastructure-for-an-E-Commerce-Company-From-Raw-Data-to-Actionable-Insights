WITH raw_order_payments AS (
    SELECT *
    FROM {{ source('ecommerce', 'order_payments') }}
)

SELECT 
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value,
    _fivetran_synced as last_updated_at
FROM raw_order_payments