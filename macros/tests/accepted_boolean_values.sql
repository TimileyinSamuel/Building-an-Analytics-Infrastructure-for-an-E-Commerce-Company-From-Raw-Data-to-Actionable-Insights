{% test accepted_boolean_values(model, column_name) %}
SELECT *
FROM {{ model }}
WHERE {{ column_name }} NOT IN (true, false)
{% endtest %}
