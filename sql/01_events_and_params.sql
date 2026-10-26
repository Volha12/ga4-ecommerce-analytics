-- 1. Event counts by event name for a single day
SELECT
  event_name,
  COUNT(*) AS events
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX = '20210131'
GROUP BY event_name
ORDER BY events DESC;

-- 2. Page views by page_location (extracting a param from event_params via UNNEST)
SELECT
  (SELECT value.string_value
   FROM UNNEST(event_params)
   WHERE key = 'page_location') AS page_location,
  COUNT(*) AS page_views
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX = '20210131'
  AND event_name = 'page_view'
GROUP BY page_location
ORDER BY page_views DESC
LIMIT 20;
