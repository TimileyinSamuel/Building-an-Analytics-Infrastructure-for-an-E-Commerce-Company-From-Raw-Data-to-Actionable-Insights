WITH base AS (
    SELECT
        op.order_id,
        op.payment_sequential,
        op.payment_type,
        op.payment_installments,
        op.payment_value,
        op.last_updated_at
    FROM {{ ref('stg_order_payments') }} op
)

SELECT *
FROM base