SELECT *
FROM {{ ref('stg_order_items') }}
WHERE total_item_value != price + freight_value
OR total_item_value IS NULL 
OR price IS NULL
OR freight_value IS NULL