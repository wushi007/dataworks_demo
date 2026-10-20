MERGE INTO iceberg_lab_iceberg.iceberg_inc.dim_item target
USING (
    SELECT
        item_id,
        category_id,
        day_pv,
        day_buy,
        first_seen_date,
        etl_time
    FROM (
        SELECT
            item_id,
            category_id,
            SUM(CASE WHEN behavior_type = 'pv' THEN 1 ELSE 0 END) AS day_pv,
            SUM(CASE WHEN behavior_type = 'buy' THEN 1 ELSE 0 END) AS day_buy,
            MIN(event_date) AS first_seen_date,
            CURRENT_TIMESTAMP AS etl_time,
            ROW_NUMBER() OVER(PARTITION BY item_id ORDER BY COUNT(*) DESC) AS rn
        FROM iceberg_lab_iceberg.iceberg_inc.dwd_taobao_behavior
        WHERE event_date = to_date('${bizdate}', 'yyyyMMdd')
          AND item_id > 0
          AND category_id > 0
        GROUP BY item_id, category_id
    ) t
    WHERE rn = 1
) source
ON target.item_key = source.item_id

WHEN MATCHED THEN UPDATE SET
    category_id     = source.category_id,
    total_pv        = target.total_pv + source.day_pv,
    total_buy       = target.total_buy + source.day_buy,
    item_hot_level  = CASE
                        WHEN target.total_pv + source.day_pv >= 1000 THEN '爆款'
                        WHEN target.total_pv + source.day_pv >= 500  THEN '热门'
                        WHEN target.total_pv + source.day_pv >= 100  THEN '一般'
                        ELSE '冷门'
                      END,
    etl_time        = source.etl_time

WHEN NOT MATCHED THEN INSERT
    (item_key, category_id, first_seen_date, total_pv, total_buy, item_hot_level, etl_time)
VALUES
    (source.item_id, source.category_id, source.first_seen_date, source.day_pv, source.day_buy,
     CASE
         WHEN source.day_pv >= 1000 THEN '爆款'
         WHEN source.day_pv >= 500  THEN '热门'
         WHEN source.day_pv >= 100  THEN '一般'
         ELSE '冷门'
      END,
     source.etl_time);
