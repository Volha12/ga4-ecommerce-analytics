# E-commerce Funnel Analysis (GA4, BigQuery)

End-to-end analysis of a GA4 e-commerce dataset: purchase funnel, marketing channel performance, cohort retention, dashboards and an A/B test.

## Business question
Where do users drop off in the purchase funnel, and which acquisition channels bring the most valuable customers?

## Data
Google Merchandise Store sample dataset (`bigquery-public-data.ga4_obfuscated_sample_ecommerce`), GA4 events from November 2020 to January 2021 (about 80-100K users and 110-130K sessions per month).

## Key findings
1. **The biggest loss is at the top of the funnel.** Only about 22% of sessions reach a product page, and only about 20% of those add an item to the cart. Overall, 1.4% of sessions end in a purchase (4,848 of 354,857).
2. **Referral traffic is the most valuable identifiable channel.** It converts at 1.66% (vs 1.10% for organic) and brings $1.31 revenue per session. Organic is the largest source of revenue (about 29%), but converts below average. Paid search (cpc) has the lowest average order value ($59 vs $74-79 for other channels) on a small traffic base (4% of sessions).
3. **Strict and non-strict funnels differ a lot.** 47% of sessions with `begin_checkout` have no `add_to_cart` in the same session, so a strict funnel understates conversion (2,816 purchasing sessions vs 4,848).
4. **Retention is low and drops fast.** Only about 2-6% of new users come back in the week after their first visit (4-6% for November cohorts, 2-3% for December), and about 1-3% in the second week. From around week 7 the curve levels off at 0.2-0.4%, so repeat engagement is mostly decided in the first two weeks.

## Funnel (non-strict, each step counted independently)
| Step | Sessions | % of sessions |
|---|---|---|
| session_start | 354,857 | 100% |
| view_item | 77,020 | 21.7% |
| add_to_cart | 15,188 | 4.3% |
| begin_checkout | 11,106 | 3.1% |
| add_payment_info | 6,815 | 1.9% |
| purchase | 4,848 | 1.4% |

## Approach
1. Copy the public dataset into my own BigQuery project
2. Funnel analysis (strict and non-strict versions)
3. Channel performance: sessions, conversion rate, revenue
4. Cohort retention by first-visit week (in progress)
5. Dashboards in Looker Studio and Tableau Public
6. A/B test analysis (separate dataset, Python)
7. Models and tests in dbt

## Data limitations
- `add_shipping_info` is almost identical to `begin_checkout` (11,105 vs 11,106 sessions), so it is excluded from the funnel.
- `traffic_source` is first-touch: it shows how a user first arrived, not the source of the current session.
- `(data deleted)` and `<Other>` are obfuscation artifacts of the sample dataset, not real channels, so no conclusions are drawn from them.
- A session is defined as `user_pseudo_id` + `ga_session_id`.
- Retention counts any event in a week, not only purchases
- Later cohorts have fewer observed weeks because the data ends on 2021-01-31

## Dashboards
- Looker Studio: (https://datastudio.google.com/reporting/e7449b5e-1de6-4884-9d20-b5847801e66e)
- Tableau Public: [link]

## Tech stack
BigQuery SQL, dbt, Looker Studio, Tableau, Python

## How to reproduce
1. Create a Google Cloud project and open BigQuery Sandbox (no billing needed).
2. Run `sql/00_copy_raw_data.sql`, replacing `YOUR_PROJECT_ID` with your project ID.
3. Run the other queries in `sql/` in order. Replace the project ID in table names the same way.

## Repository structure
```
ga4-ecommerce-analytics/
├── README.md
├── sql/
│   ├── 00_copy_raw_data.sql
│   ├── 01_events_and_params.sql
│   ├── 02_sessions_and_users.sql
│   ├── 03_funnel.sql
│   ├── 03b_funnel_non_strict.sql
│   ├── 04_channel_performance.sql
│   └── 05_cohort_retention.sql      
├── dbt/                             (planned)
├── notebooks/
│   └── ab_test_analysis.ipynb       (planned)
├── docs/
│   └── ga4_events_to_metrics.md     (planned)
└── images/
│   ├── 01_funnel.png
│   ├── 02_channels.png
│   ├── 03_retention.png
└── data/
│   ├── ga4_channels.csv
│   ├── ga4_funnel.csv
│   ├── ga4_retention.csv
```
