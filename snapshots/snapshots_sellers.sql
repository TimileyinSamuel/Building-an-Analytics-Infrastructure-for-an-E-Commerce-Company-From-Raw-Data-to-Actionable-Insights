{% snapshot sellers_snapshot %}
{{
    config(
        target_schema='snapshots',
        unique_key='seller_id',
        strategy='check',
        check_cols=['seller_zip_code_prefix', 'seller_city', 'seller_state'],
        invalidate_hard_deletes=True
    )
}}

SELECT * FROM {{ source('ecommerce', 'sellers') }}

{% endsnapshot %}
