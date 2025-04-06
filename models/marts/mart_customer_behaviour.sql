WITH customer_orders AS (
    SELECT
        unique_customer_id,
        order_id,
        order_purchase_timestamp,
        LAG(order_purchase_timestamp) OVER (
            PARTITION BY unique_customer_id 
            ORDER BY order_purchase_timestamp
        ) AS previous_order_timestamp
    FROM {{ ref('fct_orders') }}
),

order_diffs AS (
    SELECT
        unique_customer_id,
        DATE_DIFF(order_purchase_timestamp, previous_order_timestamp, DAY) AS days_between_orders
    FROM customer_orders
    WHERE previous_order_timestamp IS NOT NULL
),

aggregated_customers AS (
    SELECT
        unique_customer_id,
        MIN(order_purchase_timestamp) AS first_order_date,
        MAX(order_purchase_timestamp) AS last_order_date,
        COUNT(order_id) AS total_orders
    FROM {{ ref('fct_orders') }}
    GROUP BY unique_customer_id
),

average_days AS (
    SELECT
        unique_customer_id,
        ROUND(AVG(days_between_orders), 1) AS avg_days_between_orders
    FROM order_diffs
    GROUP BY unique_customer_id
),

customer_classification AS (
    SELECT 
        a.*,
        ad.avg_days_between_orders,
        CASE 
            WHEN total_orders = 1 THEN 'New'
            WHEN total_orders BETWEEN 2 AND 4 THEN 'Repeat'
            ELSE 'VIP'
        END AS loyalty_tier
    FROM aggregated_customers a
    LEFT JOIN average_days ad
        ON a.unique_customer_id = ad.unique_customer_id
)

SELECT 
    cc.unique_customer_id,
    cc.first_order_date,
    cc.last_order_date,
    cc.total_orders,
    cc.avg_days_between_orders,
    cc.loyalty_tier,
    dc.customer_city,
    dc.customer_state
FROM customer_classification cc
LEFT JOIN {{ ref('dim_customers') }} dc
    ON cc.unique_customer_id = dc.unique_customer_id

