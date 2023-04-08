{{
  config(
    materialized='view'
  )
}}

WITH country_gmv AS (
  SELECT 
    country_name,
    SUM(gmv_local) AS total_gmv
  FROM foodpanda.orders
  GROUP BY country_name
)

SELECT * FROM country_gmv
