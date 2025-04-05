WITH raw_order_reviews AS (
    SELECT *
    FROM {{ source('ecommerce', 'order_reviews') }}
)

SELECT
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp,
    CASE WHEN review_comment_message IS NOT NULL THEN TRUE ELSE FALSE END AS has_comment,
    _fivetran_synced as last_updated_at
FROM raw_order_reviews