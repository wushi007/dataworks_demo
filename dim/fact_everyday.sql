INSERT OVERWRITE iceberg_lab_iceberg.iceberg_inc.fact_user_behavior
(
    user_key,
    item_key,
    category_key,
    behavior_key,
    behavior_cnt,
    etl_time,
    date_key
)
SELECT
    user_id          AS user_key,
    item_id          AS item_key,
    category_id      AS category_key,
    behavior_type    AS behavior_key,
    COUNT(*)         AS behavior_cnt,
    CURRENT_TIMESTAMP AS etl_time,
    to_date(event_date) AS date_key
FROM iceberg_lab_iceberg.iceberg_inc.dwd_taobao_behavior
WHERE event_date = to_date('${bizdate}', 'yyyyMMdd')
  AND user_id > 0
  AND item_id > 0
  AND category_id > 0
GROUP BY user_id, item_id, category_id, behavior_type, event_date;
