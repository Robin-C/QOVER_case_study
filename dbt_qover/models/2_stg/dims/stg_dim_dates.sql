/* https://gist.github.com/ewhauser/d7dd635ad2d4b20331c7f18038f04817 */

SELECT
  FORMAT_DATE('%F', d)                                                           AS id
  , d                                                                            AS full_date
  , EXTRACT(YEAR FROM d)                                                         AS year
  , EXTRACT(WEEK FROM d)                                                         AS year_week
  , EXTRACT(DAY FROM d)                                                          AS year_day
  , EXTRACT(YEAR FROM d)                                                         AS fiscal_year
  , FORMAT_DATE('%Q', d)                                                         AS fiscal_qtr
  , EXTRACT(MONTH FROM d)                                                        AS month
  , FORMAT_DATE('%B', d)                                                         AS month_name
  , FORMAT_DATE('%w', d)                                                         AS week_day
  , FORMAT_DATE('%A', d)                                                         AS day_name
  , (CASE WHEN FORMAT_DATE('%A', d) IN ('Sunday', 'Saturday') THEN 0 ELSE 1 END)
    AS day_is_weekday
    /* added some fields*/
  , CAST(d AS timestamp)                                                         AS full_date_ts
  , FORMAT_DATE('%Y-%m', d)                                                      AS year_month
  , FORMAT_DATE('%Y-%b', d)                                                      AS year_month_name_short
  , DATE_TRUNC(d, MONTH) - 1                                                     AS last_day_prev_month
FROM (
  SELECT *
  FROM
    UNNEST(GENERATE_DATE_ARRAY('2020-01-01', '2025-01-01', INTERVAL 1 DAY)) AS d
)
ORDER BY 1
