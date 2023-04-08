{{
  config(
    materialized='view'
  )
}}

WITH top_vendor_2014_groupedby_country AS (
  SELECT 
    year, 
    vendors.country_name, 
    vendor_name, 
    total_gmv 
  FROM {{ ref('q4') }}
)

SELECT * FROM top_vendor_2014_groupedby_country
