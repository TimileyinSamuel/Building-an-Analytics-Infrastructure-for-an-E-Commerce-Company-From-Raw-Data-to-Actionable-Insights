WITH order_revenue AS (
    SELECT
        oi.order_id,
        SUM(oi.total_item_value) AS total_order_value
    FROM {{ ref('fct_order_items') }} oi
    GROUP BY oi.order_id
),

order_summary AS (
    SELECT
        o.unique_customer_id,
        c.customer_city,
        c.customer_state,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(orv.total_order_value) AS total_revenue,
        AVG(DATE_DIFF(o.order_delivered_customer_date, o.order_purchase_timestamp, DAY)) AS avg_delivery_time,
        AVG(CASE WHEN o.is_late_delivery THEN 1 ELSE 0 END) AS pct_late_deliveries,
        -- Include Date Dimensions
        d.year,
        d.month,
        d.month_name,
        d.quarter,
        d.season
    FROM {{ ref('fct_orders') }} o
    LEFT JOIN {{ ref('dim_customers') }} c 
        ON o.unique_customer_id = c.unique_customer_id
    LEFT JOIN order_revenue orv 
        ON o.order_id = orv.order_id
    LEFT JOIN {{ ref('dim_dates') }} d
        ON DATE(o.order_delivered_customer_date) = d.full_date 
    GROUP BY c.customer_city, c.customer_state, o.unique_customer_id, d.year, d.month, d.month_name, d.quarter, d.season
),

review_summary AS (
    SELECT
        o.unique_customer_id,
        AVG(r.review_score) AS avg_review_score
    FROM {{ ref('fct_reviews') }} r
    LEFT JOIN {{ ref('fct_orders') }} o 
        ON r.order_id = o.order_id
    GROUP BY o.unique_customer_id
)

SELECT
    os.customer_state,
    os.customer_city,
    COUNT(DISTINCT os.unique_customer_id) AS unique_customers,
    SUM(os.total_orders) AS total_orders,
    SUM(os.total_revenue) AS total_revenue,
    ROUND(AVG(os.avg_delivery_time), 2) AS avg_delivery_time_days,
    ROUND(AVG(rs.avg_review_score), 2) AS avg_review_score,
    ROUND(AVG(os.pct_late_deliveries) * 100, 2) AS pct_late_deliveries,
    os.year,         
    os.month,        
    os.month_name,   
    os.quarter,      
    os.season        
FROM order_summary os
LEFT JOIN review_summary rs 
    ON os.unique_customer_id = rs.unique_customer_id
GROUP BY os.customer_state, os.customer_city, os.year, os.month, os.month_name, os.quarter, os.season
ORDER BY SUM(os.total_revenue) DESC  

