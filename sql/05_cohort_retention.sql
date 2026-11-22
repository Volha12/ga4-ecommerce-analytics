WITH first_visits AS (
  SELECT
    user_pseudo_id,
    MIN(event_date_dt) AS first_date
  FROM `YOUR_PROJECT_ID.ga4_raw.events`
  WHERE event_name = 'first_visit'
  GROUP BY user_pseudo_id
),

cohorts AS (
  SELECT
    user_pseudo_id,
    DATE_TRUNC(first_date, WEEK(MONDAY)) AS cohort_week
  FROM first_visits
),

cohort_sizes AS (
  SELECT cohort_week, COUNT(*) AS cohort_size
  FROM cohorts
  GROUP BY cohort_week
),

activity AS (
  -- one row per user and week in which the user had any event
  SELECT DISTINCT
    user_pseudo_id,
    DATE_TRUNC(event_date_dt, WEEK(MONDAY)) AS activity_week
  FROM `YOUR_PROJECT_ID.ga4_raw.events`
),

retained AS (
  SELECT
    c.cohort_week,
    DATE_DIFF(a.activity_week, c.cohort_week, WEEK(MONDAY)) AS week_n,
    COUNT(DISTINCT a.user_pseudo_id) AS active_users
  FROM cohorts AS c
  JOIN activity AS a USING (user_pseudo_id)
  WHERE a.activity_week >= c.cohort_week
  GROUP BY cohort_week, week_n
)

SELECT
  r.cohort_week,
  s.cohort_size,
  r.week_n,
  r.active_users,
  ROUND(100 * SAFE_DIVIDE(r.active_users, s.cohort_size), 1) AS retention_pct
FROM retained AS r
JOIN cohort_sizes AS s USING (cohort_week)
ORDER BY r.cohort_week, r.week_n;
