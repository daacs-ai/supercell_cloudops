{{ config(
    materialized='table'
) }}

select * from supercell_usagelogs