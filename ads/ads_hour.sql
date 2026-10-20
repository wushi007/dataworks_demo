INSERT OVERWRITE iceberg_lab_iceberg.iceberg_inc.ads_hour_traffic_day
SELECT
    dwd.event_date,
    dwd.event_hour,
    SUM(CASE WHEN dwd.behavior_type = 'pv' THEN 1 ELSE 0 END) AS pv_cnt,
    COUNT(DISTINCT dwd.user_id) AS uv_cnt,
    SUM(CASE WHEN dwd.behavior_type = 'buy' THEN 1 ELSE 0 END) AS buy_cnt,
    ROUND(
        SUM(CASE WHEN dwd.behavior_type = 'buy' THEN 1 ELSE 0 END) * 1.0
        / NULLIF(SUM(CASE WHEN dwd.behavior_type = 'pv' THEN 1 ELSE 0 END), 0),
        4
    ) AS hour_buy_rate,
    dd.is_weekend,
    CURRENT_TIMESTAMP AS etl_time
FROM iceberg_lab_iceberg.iceberg_inc.dwd_taobao_behavior dwd
JOIN iceberg_lab_iceberg.iceberg_inc.dim_date dd
  ON dwd.event_date = dd.date_key
WHERE dwd.event_date = to_date('${bizdate}', 'yyyyMMdd')
  AND dwd.user_id > 0
GROUP BY dwd.event_date, dwd.event_hour, dd.is_weekend
ORDER BY dwd.event_hour;
