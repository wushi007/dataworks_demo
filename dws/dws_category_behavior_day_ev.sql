INSERT OVERWRITE iceberg_lab_iceberg.iceberg_inc.dws_category_behavior_day
SELECT
    category_id,
    COUNT(DISTINCT item_id) AS item_cnt,
    COUNT(DISTINCT user_id) AS uv_cnt,
    SUM(CASE WHEN behavior_type = 'pv' THEN 1 ELSE 0 END) AS pv_cnt,
    SUM(CASE WHEN behavior_type = 'buy' THEN 1 ELSE 0 END) AS buy_cnt,
    ROUND(
        SUM(CASE WHEN behavior_type = 'buy' THEN 1 ELSE 0 END) * 1.0
        / NULLIF(SUM(CASE WHEN behavior_type = 'pv' THEN 1 ELSE 0 END), 0),
        4
    ) AS day_buy_rate,
    event_date,
    CURRENT_TIMESTAMP AS etl_time
FROM iceberg_lab_iceberg.iceberg_inc.dwd_taobao_behavior
WHERE event_date = to_date('${bizdate}', 'yyyyMMdd')
  AND category_id > 0
GROUP BY category_id, event_date;
