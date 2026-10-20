MERGE INTO iceberg_lab_iceberg.iceberg_inc.dim_user target
USING (
    SELECT
        user_id,
        SUM(CASE WHEN behavior_type = 'pv' THEN 1 ELSE 0 END) AS day_pv,
        SUM(CASE WHEN behavior_type = 'buy' THEN 1 ELSE 0 END) AS day_buy,
        SUM(CASE WHEN behavior_type = 'cart' THEN 1 ELSE 0 END) AS day_cart,
        SUM(CASE WHEN behavior_type = 'fav' THEN 1 ELSE 0 END) AS day_fav,
        ROUND(
            SUM(CASE WHEN behavior_type = 'buy' THEN 1 ELSE 0 END) * 1.0 
            / NULLIF(SUM(CASE WHEN behavior_type = 'pv' THEN 1 ELSE 0 END), 0),
            4
        ) AS day_buy_rate,
        MIN(event_date) AS first_active_date,
        MAX(event_date) AS last_active_date,
        CURRENT_TIMESTAMP AS etl_time
    FROM iceberg_lab_iceberg.iceberg_inc.dwd_taobao_behavior
    WHERE event_date = to_date('${bizdate}', 'yyyyMMdd')
      AND user_id > 0
    GROUP BY user_id
) source
ON target.user_key = source.user_id

WHEN MATCHED THEN UPDATE SET
    last_active_date    = source.last_active_date,
    active_days         = target.active_days + 1,
    total_pv            = target.total_pv + source.day_pv,
    total_buy           = target.total_buy + source.day_buy,
    total_cart          = target.total_cart + source.day_cart,
    total_fav           = target.total_fav + source.day_fav,
    buy_rate            = ROUND(
                                (target.total_buy + source.day_buy) * 1.0 
                                / NULLIF(target.total_pv + source.day_pv, 0),
                                4
                            ),
    user_value_level    = CASE
                            WHEN target.total_buy + source.day_buy >= 10 
                                 AND target.total_pv + source.day_pv >= 50 THEN '高价值用户'
                            WHEN target.total_buy + source.day_buy >= 3  
                                 AND target.total_pv + source.day_pv >= 10 THEN '中价值用户'
                            WHEN target.total_buy + source.day_buy >= 1 THEN '低价值用户'
                            ELSE '潜在用户'
                          END,
    user_activity_level = CASE
                            WHEN target.total_pv + source.day_pv >= 500 THEN '超级活跃'
                            WHEN target.total_pv + source.day_pv >= 100 THEN '活跃用户'
                            WHEN target.total_pv + source.day_pv >= 10  THEN '一般用户'
                            ELSE '沉默用户'
                          END,
    etl_time            = source.etl_time

WHEN NOT MATCHED THEN INSERT 
    (user_key, first_active_date, last_active_date, active_days,
     total_pv, total_buy, total_cart, total_fav, buy_rate,
     user_value_level, user_activity_level, etl_time)
VALUES 
    (source.user_id, source.first_active_date, source.last_active_date, 1,
     source.day_pv, source.day_buy, source.day_cart, source.day_fav, source.day_buy_rate,
     CASE
         WHEN source.day_buy >= 10 AND source.day_pv >= 50 THEN '高价值用户'
         WHEN source.day_buy >= 3  AND source.day_pv >= 10 THEN '中价值用户'
         WHEN source.day_buy >= 1 THEN '低价值用户'
         ELSE '潜在用户'
      END,
      CASE
         WHEN source.day_pv >= 500 THEN '超级活跃'
         WHEN source.day_pv >= 100 THEN '活跃用户'
         WHEN source.day_pv >= 10  THEN '一般用户'
         ELSE '沉默用户'
      END,
     source.etl_time);
