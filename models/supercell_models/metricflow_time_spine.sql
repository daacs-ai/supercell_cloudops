{{
    config(
        materialized='table'
    )
}}

WITH days AS (
    SELECT
        toDate('2000-01-01') + INTERVAL number DAY AS date_day
    FROM numbers(
        datediff('day', toDate('2000-01-01'), toDate('2027-01-01'))
    )
),

final AS (
    SELECT cast(date_day AS Date) AS date_day
    FROM days
)

SELECT *
FROM final