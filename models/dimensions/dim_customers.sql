WITH base_customers AS (
    SELECT
        unique_customer_id,
        customer_zip_code_prefix,
        customer_city,
        customer_state,
        last_updated_at,
        ROW_NUMBER() OVER (
            PARTITION BY unique_customer_id 
            ORDER BY last_updated_at DESC
        ) AS row_num
    FROM {{ ref('stg_customers') }}
),

deduped_customers AS (
    SELECT *
    FROM base_customers
    WHERE row_num = 1
),

orders_per_customer AS (
    SELECT 
        c.unique_customer_id,
        MIN(o.order_purchase_timestamp) AS first_order_date,
        MAX(o.order_purchase_timestamp) AS last_order_date,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM {{ ref('stg_orders') }} o
    LEFT JOIN {{ ref('stg_customers') }} c
        ON o.customer_id = c.customer_id
    GROUP BY c.unique_customer_id
)

SELECT 
    dc.unique_customer_id,
    dc.customer_zip_code_prefix,
    dc.customer_city,
    dc.customer_state,
    op.first_order_date,
    op.last_order_date,
    op.total_orders,
    CASE 
        WHEN op.total_orders = 1 THEN 'New'
        ELSE 'Repeat'
    END AS customer_type,
    dc.last_updated_at
FROM deduped_customers dc
LEFT JOIN orders_per_customer op
    ON dc.unique_customer_id = op.unique_customer_id

