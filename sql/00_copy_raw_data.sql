-- Copy the public GA4 sample dataset into your own project (BigQuery Sandbox).
-- Replace YOUR_PROJECT_ID with your Google Cloud project ID before running.
-- Sandbox tables expire after 60 days: rerun this script to recreate them.

CREATE SCHEMA IF NOT EXISTS `YOUR_PROJECT_ID.ga4_raw`
OPTIONS (location = 'US');

CREATE TABLE `YOUR_PROJECT_ID.ga4_raw.events`
CLUSTER BY event_name
AS
SELECT
  PARSE_DATE('%Y%m%d', event_date) AS event_date_dt,
  *
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;
