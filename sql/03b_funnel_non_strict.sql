WITH session_events AS (
  SELECT
    CONCAT(user_pseudo_id, '-',
      CAST((SELECT value.int_value FROM UNNEST(event_params)
            WHERE key = 'ga_session_id') AS STRING)) AS session_id,
    event_name
  FROM `YOUR_PROJECT_ID.ga4_raw.events`
  WHERE event_name IN ('session_start', 'view_item', 'add_to_cart',
                       'begin_checkout', 'add_shipping_info',
                       'add_payment_info', 'purchase')
  GROUP BY session_id, event_name
)
SELECT event_name, COUNT(*) AS sessions
FROM session_events
WHERE session_id IS NOT NULL
GROUP BY event_name
ORDER BY sessions DESC;
