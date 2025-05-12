


select
    md5(concat(linked_account_id, '_', service_code, '_', instance_type, '_', region, '_', CAST(usage_start_date AS VARCHAR), '_', CAST(usage_end_date AS VARCHAR))) AS resource_id,
    usage_start_date as start_date,
    usage_end_date as bill_date,
    usage_amount as bill_amount,
    operation
from "supercell"."main"."cleaned_usagelogs"