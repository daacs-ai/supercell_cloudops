
  
    
    

    create  table
      "supercell"."main"."fact_bill_generation__dbt_tmp"
  
    as (
      


select
    resource_id,
    usage_start_date as start_date,
    usage_end_date as bill_date,
    amortized_cost as bill_amount,
    operation
from "supercell"."main"."cleaned_usagelogs"
    );
  
  