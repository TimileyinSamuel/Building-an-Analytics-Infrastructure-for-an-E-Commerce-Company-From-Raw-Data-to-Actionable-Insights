WITH base AS (
    SELECT
        r.review_id,
        r.order_id,
        r.review_score,
        r.review_creation_date,
        r.review_answer_timestamp,
        r.has_comment,
        r.review_comment_title,
        r.review_comment_message,
        r.last_updated_at
    FROM {{ ref('stg_order_reviews') }} r
)

SELECT *
FROM base