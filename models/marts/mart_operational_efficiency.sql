WITH order_metrics AS (
    SELECT
        o.order_id,
        d.date_id,
        o.order_delivered_customer_date,
        o.order_estimated_delivery_date,
        o.is_late_delivery,
        o.is_estimate_met,
        DATE_DIFF(DATE(o.order_delivered_customer_date), DATE(o.order_purchase_timestamp), DAY) AS delivery_days
    FROM {{ ref('fct_orders') }} o
    LEFT JOIN {{ ref('dim_dates') }} d 
        ON DATE(o.order_delivered_customer_date) = d.full_date
    WHERE o.order_status = 'delivered'
),

agg_metrics AS (
    SELECT
        date_id,
        COUNT(order_id) AS total_delivered_orders,
        SUM(CASE WHEN is_late_delivery THEN 1 ELSE 0 END) AS late_deliveries,
        SUM(CASE WHEN is_estimate_met THEN 1 ELSE 0 END) AS on_time_deliveries,
        ROUND(AVG(delivery_days), 2) AS avg_delivery_days,
        ROUND(SAFE_DIVIDE(SUM(CASE WHEN is_late_delivery THEN 1 ELSE 0 END), COUNT(order_id)) * 100, 2) AS pct_late_deliveries,
        ROUND(SAFE_DIVIDE(SUM(CASE WHEN is_estimate_met THEN 1 ELSE 0 END), COUNT(order_id)) * 100, 2) AS pct_on_time_deliveries
    FROM order_metrics
    GROUP BY date_id
)

SELECT 
    d.full_date,
    d.year,
    d.month,
    d.month_name,
    d.week_of_year,
    d.quarter,
    d.season,
    a.total_delivered_orders,
    a.late_deliveries,
    a.on_time_deliveries,
    a.avg_delivery_days,
    a.pct_late_deliveries,
    a.pct_on_time_deliveries
FROM agg_metrics a
LEFT JOIN {{ ref('dim_dates') }} d 
    ON a.date_id = d.date_id
ORDER BY d.full_date
