{{ config(
    materialized='table'
) }}

SELECT
    generateUUIDv4() AS resource_id,
    LinkedAccountId AS linked_account_id,
    bill_PayerAccountId AS payer_account_id,
    lineItem_UsageStartDate AS usage_start_date,
    lineItem_UsageEndDate AS usage_end_date,
    toFloat64(lineItem_UsageAmount) AS usage_amount,
    lineItem_Operation AS operation,
    pricing_PricingModel AS pricing_model,
    resourceTags_TagKeys AS tag_keys,
    resourceTags_TagValues AS tag_values,
    product_Region AS region,
    product_ServiceCode AS service_code,
    product_InstanceType AS instance_type,
    toFloat64(amortized_cost) AS amortized_cost,
    product_Description AS description
FROM {{ ref('raw_usagelogs') }}
WHERE
    LinkedAccountId IS NOT NULL AND
    bill_PayerAccountId IS NOT NULL AND
    lineItem_UsageStartDate IS NOT NULL AND
    lineItem_UsageEndDate IS NOT NULL AND
    lineItem_UsageAmount IS NOT NULL AND
    lineItem_Operation IS NOT NULL AND
    pricing_PricingModel IS NOT NULL AND
    resourceTags_TagKeys IS NOT NULL AND
    resourceTags_TagValues IS NOT NULL AND
    product_Region IS NOT NULL AND
    product_ServiceCode IS NOT NULL AND
    product_InstanceType IS NOT NULL AND
    amortized_cost IS NOT NULL AND
    product_Description IS NOT NULL
