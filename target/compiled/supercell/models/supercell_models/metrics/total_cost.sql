


select
    DATE_TRUNC('month', usage_end_date)  as month,
    region,
    instance_type,
    pricing_model,
    service_code,
    tag_values as tag_values,
    SUM(amortized_cost) as total_cost
from "supercell"."main"."cleaned_usagelogs"
group by month,region, instance_type, pricing_model, service_code, tag_values