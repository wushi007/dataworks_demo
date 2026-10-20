INSERT OVERWRITE iceberg_lab_iceberg.iceberg_inc.dwd_taobao_behavior
SELECT
    user_id,
    item_id,
    category_id,
    behavior_type,
    behavior_time,
    event_date,
    event_hour,
    now() AS etl_time
FROM (
    SELECT
        user_id,
        item_id,
        category_id,
        lower(trim(behavior_type)) AS behavior_type,
        behavior_time,
        event_date,
        hour(from_unixtime(behavior_time)) AS event_hour,
        ROW_NUMBER() OVER(
            PARTITION BY user_id, item_id, behavior_type, behavior_time 
            ORDER BY behavior_time ASC
        ) AS rn
    FROM iceberg_lab_iceberg.iceberg_inc.taobao_behavior
    WHERE event_date = to_date('${bizdate}', 'yyyyMMdd')
      AND user_id > 0
      AND item_id > 0
      AND category_id > 0
      AND behavior_type IS NOT NULL
      AND lower(trim(behavior_type)) IN ('pv', 'buy', 'cart', 'fav')
      AND behavior_time > 0
) t
WHERE rn = 1;
