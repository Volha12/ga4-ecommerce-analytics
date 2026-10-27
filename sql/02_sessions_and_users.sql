SELECT
  FORMAT_DATE('%Y-%m', event_date_dt) AS month,
  COUNT(DISTINCT user_pseudo_id) AS users,
  COUNT(DISTINCT CONCAT(
    user_pseudo_id, '-',
    (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id')
  )) AS sessions
FROM `ga4-ecommerce-analysis-511509.ga4_raw.events`
GROUP BY month
ORDER BY month
