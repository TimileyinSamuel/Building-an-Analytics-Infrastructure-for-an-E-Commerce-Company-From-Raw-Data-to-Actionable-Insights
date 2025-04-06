WITH date_spine AS (
    SELECT
        day AS full_date
    FROM
        UNNEST(GENERATE_DATE_ARRAY('2016-01-01', '2019-12-31')) AS day
),

enriched_dates AS (
    SELECT
        CAST(FORMAT_DATE('%Y%m%d', full_date) AS INT64) AS date_id,
        full_date,
        FORMAT_DATE('%A', full_date) AS day_of_week,
        EXTRACT(DAYOFWEEK FROM full_date) IN (1, 7) AS is_weekend,
        EXTRACT(MONTH FROM full_date) AS month,
        FORMAT_DATE('%B', full_date) AS month_name,
        EXTRACT(QUARTER FROM full_date) AS quarter,
        EXTRACT(YEAR FROM full_date) AS year,
        FORMAT_DATE('%V', full_date) AS week_of_year,
        CASE
            WHEN EXTRACT(MONTH FROM full_date) IN (6, 7, 8) THEN 'Summer'
        WHEN EXTRACT(MONTH FROM full_date) IN (9, 10, 11) THEN 'Autumn'
        WHEN EXTRACT(MONTH FROM full_date) IN (12, 1, 2) THEN 'Winter'
        WHEN EXTRACT(MONTH FROM full_date) IN (3, 4, 5) THEN 'Spring'
        END AS season
    FROM date_spine
)

SELECT *
FROM enriched_dates
