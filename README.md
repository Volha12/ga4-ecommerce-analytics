# ga4-ecommerce-analytics
E-commerce funnel, retention and marketing channel analysis on GA4 data (BigQuery SQL, dbt, Looker Studio, Tableau)
# E-commerce Funnel Analysis (GA4, BigQuery)

## Business question
Where do users drop off in the purchase funnel, and which
acquisition channels bring the most valuable customers?

## Data
Google Merchandise Store sample dataset
(`bigquery-public-data.ga4_obfuscated_sample_ecommerce`),
events from 2020-11-01 to 2021-01-31.

## Key findings
(заполнишь в конце: 4-5 пунктов с цифрами)

## Approach
1. Funnel: session_start → view_item → add_to_cart → begin_checkout → purchase
2. Cohort retention by first-visit week
3. Channel performance: sessions, conversion rate, revenue
4. A/B test analysis (separate dataset)

## Dashboards
- Looker Studio: [link]
- Tableau Public: [link]

## Tech stack
BigQuery SQL, dbt, Looker Studio, Tableau, Python

## Repository structure
ecommerce-funnel-analysis/
├── README.md
├── sql/
│   ├── 01_events_and_params.sql
│   ├── 02_sessions_and_users.sql
│   ├── 03_funnel.sql
│   ├── 04_cohort_retention.sql
│   └── 05_channel_performance.sql
├── dbt/              (появится на неделе 6)
├── notebooks/
│   └── ab_test_analysis.ipynb
├── docs/
│   └── ga4_events_to_metrics.md
└── images/  
