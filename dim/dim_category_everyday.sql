INSERT OVERWRITE iceberg_lab_iceberg.iceberg_inc.dim_category
SELECT
    category_id AS category_key,
    COUNT(DISTINCT item_id) AS item_count,
    COUNT(DISTINCT user_id) AS user_count,
    CASE
        WHEN COUNT(DISTINCT item_id) >= 500 THEN '热门类目'
        WHEN COUNT(DISTINCT item_id) >= 200 THEN '一般类目'
        WHEN COUNT(DISTINCT item_id) >= 50  THEN '小众类目'
        ELSE '冷门类目'
    END AS category_level,
    CURRENT_TIMESTAMP AS etl_time
FROM iceberg_lab_iceberg.iceberg_inc.dwd_taobao_behavior
WHERE category_id > 0
  AND item_id > 0
  AND user_id > 0
GROUP BY category_id
ORDER BY category_key;
