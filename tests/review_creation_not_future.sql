SELECT *
FROM {{ ref('stg_order_reviews') }}
WHERE review_creation_date > CURRENT_DATE