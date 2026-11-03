WITH base AS (
  SELECT
    CONCAT(user_pseudo_id, '-',
      CAST((SELECT value.int_value FROM UNNEST(event_params)
            WHERE key = 'ga_session_id') AS STRING)) AS session_id,
    traffic_source.medium AS medium,
    event_name,
    ecommerce.purchase_revenue_in_usd AS revenue
  FROM `YOUR_PROJECT_ID.ga4_raw.events`
)
SELECT
  medium,
  COUNT(DISTINCT session_id) AS sessions,
  COUNT(DISTINCT IF(event_name = 'purchase', session_id, NULL)) AS purchase_sessions,
  ROUND(100 * SAFE_DIVIDE(
    COUNT(DISTINCT IF(event_name = 'purchase', session_id, NULL)),
    COUNT(DISTINCT session_id)), 2) AS conversion_pct,
  ROUND(SUM(IF(event_name = 'purchase', revenue, 0)), 0) AS revenue_usd
FROM base
WHERE session_id IS NOT NULL
GROUP BY medium
ORDER BY sessions DESC;
