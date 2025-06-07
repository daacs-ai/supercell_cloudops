{{ 
    config(
        materialized='table'
    ) 
}}


select
    toString(resource_id) as resource_id,
    linked_account_id as linked_account_id,
    region,
    service_code as product,
    instance_type as instance_type,
    pricing_model as pricing_model,
    tag_keys as tag_keys,
    tag_values as tag_values
from {{ ref('cleaned_usagelogs') }}