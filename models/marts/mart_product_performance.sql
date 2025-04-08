WITH orders_with_delivery AS (
    SELECT
        oi.product_id,
        oi.order_id,
        oi.price,
        oi.freight_value,
        o.order_purchase_timestamp,
        o.order_delivered_customer_date,
        o.order_estimated_delivery_date,
        o.is_late_delivery
    FROM {{ ref('fct_orders') }} o
    INNER JOIN {{ ref('stg_order_items') }} oi
        ON o.order_id = oi.order_id
),

reviews_per_product AS (
    SELECT
        oi.product_id,
        COUNT(DISTINCT r.review_id) AS num_reviews,
        AVG(r.review_score) AS avg_review_score
    FROM {{ ref('stg_order_items') }} oi
    LEFT JOIN {{ ref('fct_reviews') }} r
        ON oi.order_id = r.order_id
    GROUP BY oi.product_id
),

aggregated AS (
    SELECT
        od.product_id,
        COUNT(DISTINCT od.order_id) AS num_orders,
        COUNT(*) AS total_units_sold,
        SUM(od.price) AS total_revenue,
        AVG(od.freight_value) AS avg_freight_value,
        AVG(DATE_DIFF(od.order_delivered_customer_date, od.order_purchase_timestamp, DAY)) AS avg_days_to_deliver,
        COUNTIF(od.is_late_delivery = TRUE) AS num_late_deliveries,
        SAFE_DIVIDE(COUNTIF(od.is_late_delivery = TRUE), COUNT(*)) AS percent_late_deliveries,
        EXTRACT(YEAR FROM od.order_purchase_timestamp) AS year,
        EXTRACT(MONTH FROM od.order_purchase_timestamp) AS month
    FROM orders_with_delivery od
    GROUP BY od.product_id, year, month
)

SELECT 
    a.product_id,
    p.product_category_name,
    a.year,
    a.month,
    a.num_orders,
    a.total_units_sold,
    a.total_revenue,
    a.avg_freight_value,
    a.avg_days_to_deliver,
    a.num_late_deliveries,
    a.percent_late_deliveries,
    r.num_reviews,
    r.avg_review_score
FROM aggregated a
LEFT JOIN {{ ref('dim_products') }} p
    ON a.product_id = p.product_id
LEFT JOIN reviews_per_product r
    ON a.product_id = r.product_id
ORDER BY a.year, a.month, p.product_category_name