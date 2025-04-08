WITH order_items_agg AS (
    SELECT
        order_id,
        SUM(price) AS total_product_value,
        SUM(freight_value) AS total_freight_value,
        SUM(price + freight_value) AS total_order_value
    FROM {{ ref('fct_order_items') }}
    GROUP BY order_id
),

payments_agg AS (
    SELECT
        order_id,
        SUM(payment_value) AS total_payment_value
    FROM {{ ref('fct_payments') }}
    GROUP BY order_id
),

final_agg AS (
    SELECT
        o.order_id,
        o.order_purchase_timestamp,
        d.date_id,
        d.year,
        d.month,
        o.customer_id,
        o.unique_customer_id,
        o.order_status,
        o.customer_city,
        o.customer_state,

        oi.total_product_value,
        oi.total_freight_value,
        oi.total_order_value,
        p.total_payment_value,

        SAFE_DIVIDE(oi.total_freight_value, p.total_payment_value) AS freight_cost_ratio,
        SAFE_DIVIDE(oi.total_product_value, p.total_payment_value) AS product_value_ratio

    FROM {{ ref('fct_orders') }} o

    LEFT JOIN order_items_agg oi ON o.order_id = oi.order_id
    LEFT JOIN payments_agg p ON o.order_id = p.order_id
    LEFT JOIN {{ ref('dim_dates') }} d ON DATE(o.order_purchase_timestamp) = d.full_date
)

SELECT *
FROM final_agg
WHERE year IS NOT NULL
