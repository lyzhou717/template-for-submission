{{
  config(
    materialized='view'
  )
}}

WITH vendors_grouped_country AS (
  SELECT 
    orders.country_name, 
    SUM(orders.gmv_local) as total_gmv, 
    orders.vendor_id
  FROM foodpanda.orders
  GROUP BY orders.country_name, orders.vendor_id
),

ordered_vendors_grouped_country AS (
  SELECT 
    ROW_NUMBER() OVER (PARTITION BY country_name ORDER BY total_gmv DESC) rn, 
    *
  FROM vendors_grouped_country
),

top_active_vendors AS (
  SELECT 
    vendors.country_name, 
    vendors.vendor_name, 
    total_gmv
  FROM ordered_vendors_grouped_country
  JOIN foodpanda.vendors ON vendor_id = vendors.id
  WHERE rn = 1
)

SELECT * FROM top_active_vendors
