INSERT INTO iceberg_lab_iceberg.iceberg_inc.dim_date
SELECT
    date_key,
    YEAR(date_key),
    MONTH(date_key),
    DAY(date_key),
    DAYOFWEEK(date_key),
    CASE DAYOFWEEK(date_key)
        WHEN 1 THEN '周日' WHEN 2 THEN '周一'
        WHEN 3 THEN '周二' WHEN 4 THEN '周三'
        WHEN 5 THEN '周四' WHEN 6 THEN '周五'
        WHEN 7 THEN '周六'
    END,
    DAYOFWEEK(date_key) IN (1, 7),
    WEEKOFYEAR(date_key)
FROM (
    SELECT DISTINCT event_date AS date_key
    FROM iceberg_lab_iceberg.iceberg_inc.dwd_taobao_behavior
    WHERE event_date = to_date('${bizdate}', 'yyyyMMdd')
) t
LEFT ANTI JOIN iceberg_lab_iceberg.iceberg_inc.dim_date d
    ON t.date_key = d.date_key;
