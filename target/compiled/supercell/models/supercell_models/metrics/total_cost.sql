

with base as (
    select
        fact_bill_generation.resource_id,
        date_trunc('month', fact_bill_generation.bill_date) as month,
        fact_bill_generation.bill_amount,
        dim_resource.instance_type,
        dim_resource.product,
        dim_resource.region,
        dim_resource.pricing_model,
        dim_resource.tag_keys,
        dim_resource.tag_values
    from "supercell"."main"."fact_bill_generation" as fact_bill_generation
    left join "supercell"."main"."dim_resource" as dim_resource
        on fact_bill_generation.resource_id = dim_resource.resource_id
)

select
    month,
    sum(bill_amount) as total_cost,
    instance_type,
    product,
    region,
    pricing_model,
    tag_keys,
    tag_values
from base
group by
    month,
    instance_type,
    product,
    region,
    pricing_model,
    tag_keys,
    tag_values
order by
    month,
    instance_type,
    product,
    region,
    pricing_model,
    tag_keys,
    tag_values