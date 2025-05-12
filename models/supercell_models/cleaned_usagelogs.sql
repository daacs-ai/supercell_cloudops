{{ config(
    materialized='table'
) }}


SELECT
    CAST("LinkedAccountId" AS VARCHAR) AS linked_account_id,
    CAST("bill/PayerAccountId" AS VARCHAR) AS payer_account_id,
    CAST("lineItem/UsageStartDate" AS TIMESTAMP) AS usage_start_date,
    CAST("lineItem/UsageEndDate" AS TIMESTAMP) AS usage_end_date,
    CAST("lineItem/UsageAmount" AS DECIMAL(18, 6)) AS usage_amount,
    CAST("lineItem/Operation" AS VARCHAR) AS operation,
    CAST("pricing/PricingModel" AS VARCHAR) AS pricing_model,
    CAST("resourceTags/TagKeys" AS VARCHAR) AS tag_keys,
    CAST("resourceTags/TagValues" AS VARCHAR) AS tag_values,
    CAST("product/Region" AS VARCHAR) AS region,
    CAST("product/ServiceCode" AS VARCHAR) AS service_code,
    CAST("product/InstanceType" AS VARCHAR) AS instance_type,
    CAST("amortized_cost" AS DECIMAL(18, 6)) AS amortized_cost,
    CAST("product/Description" AS VARCHAR) AS description
FROM {{ref('raw_usagelogs')}}
WHERE
    "LinkedAccountId" IS NOT NULL
    AND "bill/PayerAccountId" IS NOT NULL
    AND "lineItem/UsageStartDate" IS NOT NULL
    AND "lineItem/UsageEndDate" IS NOT NULL
    AND "lineItem/UsageAmount" IS NOT NULL
    AND "lineItem/Operation" IS NOT NULL
    AND "pricing/PricingModel" IS NOT NULL
    AND "resourceTags/TagKeys" IS NOT NULL
    AND "resourceTags/TagValues" IS NOT NULL
    AND "product/Region" IS NOT NULL
    AND "product/ServiceCode" IS NOT NULL
    AND "product/InstanceType" IS NOT NULL
    AND "amortized_cost" IS NOT NULL
    AND "product/Description" IS NOT NULL