INSERT OVERWRITE iceberg_lab_iceberg.iceberg_inc.dws_hour_behavior_day
SELECT
    event_hour,
    SUM(CASE WHEN behavior_type = 'pv' THEN 1 ELSE 0 END) AS pv_cnt,
    COUNT(DISTINCT user_id) AS uv_cnt,
    SUM(CASE WHEN behavior_type = 'buy' THEN 1 ELSE 0 END) AS buy_cnt,
    event_date,
    CURRENT_TIMESTAMP AS etl_time
FROM iceberg_lab_iceberg.iceberg_inc.dwd_taobao_behavior
WHERE event_date = to_date('${bizdate}', 'yyyyMMdd')
GROUP BY event_hour, event_date
ORDER BY event_hour;
