WITH session_events AS (
  -- one row per session and event type
  SELECT
    CONCAT(user_pseudo_id, '-',
      CAST((SELECT value.int_value FROM UNNEST(event_params)
            WHERE key = 'ga_session_id') AS STRING)) AS session_id,
    event_name
  FROM `ga4-ecommerce-analysis-511509.ga4_raw.events`
  WHERE event_name IN ('session_start', 'view_item', 'add_to_cart',
                       'begin_checkout', 'add_shipping_info',
                       'add_payment_info', 'purchase')
  GROUP BY session_id, event_name
),

sessions AS (
  -- one row per session with a flag for each funnel step
  SELECT
    session_id,
    MAX(IF(event_name = 'session_start', 1, 0))     AS session_start,
    MAX(IF(event_name = 'view_item', 1, 0))         AS view_item,
    MAX(IF(event_name = 'add_to_cart', 1, 0))       AS add_to_cart,
    MAX(IF(event_name = 'begin_checkout', 1, 0))    AS begin_checkout,
    MAX(IF(event_name = 'add_shipping_info', 1, 0)) AS add_shipping_info,
    MAX(IF(event_name = 'add_payment_info', 1, 0))  AS add_payment_info,
    MAX(IF(event_name = 'purchase', 1, 0))          AS purchase
  FROM session_events
  WHERE session_id IS NOT NULL
  GROUP BY session_id
),

counts AS (
  -- strict funnel: a session counts at a step only if it passed all previous steps
  SELECT
    COUNTIF(session_start = 1) AS s1,
    COUNTIF(session_start = 1 AND view_item = 1) AS s2,
    COUNTIF(session_start = 1 AND view_item = 1 AND add_to_cart = 1) AS s3,
    COUNTIF(session_start = 1 AND view_item = 1 AND add_to_cart = 1
            AND begin_checkout = 1) AS s4,
    COUNTIF(session_start = 1 AND view_item = 1 AND add_to_cart = 1
            AND begin_checkout = 1 AND add_shipping_info = 1) AS s5,
    COUNTIF(session_start = 1 AND view_item = 1 AND add_to_cart = 1
            AND begin_checkout = 1 AND add_shipping_info = 1
            AND add_payment_info = 1) AS s6,
    COUNTIF(session_start = 1 AND view_item = 1 AND add_to_cart = 1
            AND begin_checkout = 1 AND add_shipping_info = 1
            AND add_payment_info = 1 AND purchase = 1) AS s7
  FROM sessions
)

SELECT
  step_n,
  step,
  sessions,
  ROUND(100 * SAFE_DIVIDE(sessions, LAG(sessions) OVER (ORDER BY step_n)), 1) AS pct_of_previous,
  ROUND(100 * SAFE_DIVIDE(sessions, FIRST_VALUE(sessions) OVER (ORDER BY step_n)), 2) AS pct_of_first
FROM counts,
UNNEST([
  STRUCT(1 AS step_n, 'session_start'     AS step, s1 AS sessions),
  STRUCT(2, 'view_item',         s2),
  STRUCT(3, 'add_to_cart',       s3),
  STRUCT(4, 'begin_checkout',    s4),
  STRUCT(5, 'add_shipping_info', s5),
  STRUCT(6, 'add_payment_info',  s6),
  STRUCT(7, 'purchase',          s7)
])
ORDER BY step_n
