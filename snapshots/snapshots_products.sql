{% snapshot products_snapshot %}
{{
    config(
        target_schema='snapshots',
        unique_key='product_id',
        strategy='check',
        check_cols=['product_category_name', 'product_weight_g', 'product_length_cm', 'product_height_cm', 'product_width_cm'],
        invalidate_hard_deletes=True
    )
}}

SELECT * FROM {{ source('ecommerce', 'products') }}

{% endsnapshot %}
