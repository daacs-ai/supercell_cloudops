


select
    md5(concat(linked_account_id, '_', service_code, '_', instance_type, '_', region, '_', CAST(usage_start_date AS VARCHAR), '_', CAST(usage_end_date AS VARCHAR))) AS resource_id,
    linked_account_id as linked_account_id,
    region,
    service_code as product,
    instance_type as instance_type,
    pricing_model as pricing_model,
    tag_keys as tag_keys,
    tag_values as tag_values
from "supercell"."main"."cleaned_usagelogs"