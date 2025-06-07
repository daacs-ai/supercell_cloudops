{{ config(
    materialized='table'
) }}

select * from aws_cost_usage