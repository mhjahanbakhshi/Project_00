SELECT
  DATE_ADD(PARSE_DATE("%Y%m%d", date), INTERVAL 2436 DAY) AS date,
  trafficSource.medium AS channel,
  trafficSource.source AS source,
  FORMAT_DATE("%w", DATE_ADD(PARSE_DATE("%Y%m%d", date), INTERVAL 2436 DAY)) AS weekday,
  device.deviceCategory AS device_type,
  COUNT(*) AS total_sessions,
  COUNT(DISTINCT fullVisitorId) AS total_users,
  SUM(totals.pageviews) AS total_pageviews,
  SUM(IF(totals.bounces = 1, 1, 0)) / COUNT(*) AS bounce_rate,
  SUM(IF(totals.bounces = 1, 1, 0)) AS total_bounce,
  AVG(totals.timeOnSite / 60) AS average_session_duration_minutes
FROM
  `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE
  DATE_ADD(PARSE_DATE("%Y%m%d", date), INTERVAL 2436 DAY) < CURRENT_DATE()
GROUP BY
  date, weekday, source, device_type, channel
ORDER BY
  date DESC, weekday, source, device_type, channel
