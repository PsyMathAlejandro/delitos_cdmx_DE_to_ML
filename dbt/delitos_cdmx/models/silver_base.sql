{{ config(
    materialized='view',
    catalog='delitos',
    schema='gold'
) }}

SELECT *
FROM {{ source('silver', 'delitos_cdmx_silver') }}
