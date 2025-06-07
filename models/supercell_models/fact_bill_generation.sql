{{ 
    config(
        materialized='table'
    ) 
}}


SELECT
    concat(toString(resource_id), '_', toString(usage_start_date)) AS billing_log_id,
    toString(resource_id) as resource_id,
    usage_start_date AS start_date,
    usage_end_date AS bill_date,
    amortized_cost AS bill_amount,
    operation
from {{ ref('cleaned_usagelogs') }}