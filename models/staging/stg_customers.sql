WITH raw_customers AS (
    SELECT *
    FROM {{ ref('customers_snapshot') }}
    WHERE dbt_valid_to IS NULL
)

SELECT customer_id,
       customer_unique_id AS unique_customer_id,
       customer_zip_code_prefix, 
       customer_city, customer_state, 
       _fivetran_synced AS last_updated_at
FROM raw_customers