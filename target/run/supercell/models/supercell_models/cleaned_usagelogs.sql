
  
    
    

    create  table
      "supercell"."main"."cleaned_usagelogs__dbt_tmp"
  
    as (
      


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
FROM supercell_usagelogs
    );
  
  