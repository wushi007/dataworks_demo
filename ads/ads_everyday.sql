INSERT OVERWRITE iceberg_lab_iceberg.iceberg_inc.ads_daily_overview
SELECT
    event_date,
    COUNT(DISTINCT user_id) AS total_uv,
    SUM(CASE WHEN behavior_type = 'pv' THEN 1 ELSE 0 END) AS total_pv,
    SUM(CASE WHEN behavior_type = 'buy' THEN 1 ELSE 0 END) AS total_buy,
    COUNT(DISTINCT CASE WHEN behavior_type = 'buy' THEN user_id END) AS buy_user_cnt,
    ROUND(
        SUM(CASE WHEN behavior_type = 'buy' THEN 1 ELSE 0 END) * 1.0
        / NULLIF(SUM(CASE WHEN behavior_type = 'pv' THEN 1 ELSE 0 END), 0),
        4
    ) AS buy_rate,
    CURRENT_TIMESTAMP AS etl_time
FROM iceberg_lab_iceberg.iceberg_inc.dwd_taobao_behavior
WHERE event_date = to_date('${bizdate}', 'yyyyMMdd')
  AND user_id > 0
GROUP BY event_date;
