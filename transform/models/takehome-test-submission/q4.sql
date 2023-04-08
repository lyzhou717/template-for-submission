{{
  config(
    materialized='view'
  )
}}

WITH yearly_gmv_vendor_groupedby_country AS (
  SELECT 
    EXTRACT(year FROM orders.date_local) AS year, 
    orders.country_name, SUM(orders.gmv_local) as total_gmv, 
    orders.vendor_id
  FROM foodpanda.orders
  GROUP BY orders.country_name, EXTRACT(year FROM orders.date_local), orders.vendor_id
),

sorted_yearly_gmv_vendor_groupedby_country AS (
  SELECT 
    ROW_NUMBER() OVER (PARTITION BY country_name, year ORDER BY total_gmv DESC) rn, 
    *
  FROM yearly_gmv_vendor_groupedby_country
),

top_2_vendor_groupedby_country AS (
  SELECT 
    year, 
    vendors.country_name, 
    vendor_name, 
    total_gmv
  FROM sorted_yearly_gmv_vendor_groupedby_country
  JOIN foodpanda.vendors ON vendor_id = vendors.id
  WHERE rn = 1 OR rn = 2
  ORDER BY year ASC, country_name
)

SELECT * FROM top_2_vendor_groupedby_country
