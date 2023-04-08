{{
  config(
    materialized='view'
  )
}}

WITH taiwan_vendors AS (
  SELECT
    vendors.vendor_name,
    COUNT(DISTINCT(orders.customer_id)), 
    SUM(orders.gmv_local) AS total_gmv
  FROM foodpanda.orders JOIN foodpanda.vendors ON orders.vendor_id = vendors.id
  WHERE orders.country_name = 'Taiwan'
  GROUP BY vendors.vendor_name 
  ORDER BY total_gmv DESC
)

SELECT * FROM taiwan_vendors
