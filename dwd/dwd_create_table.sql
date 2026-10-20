CREATE TABLE IF NOT EXISTS iceberg_lab_iceberg.iceberg_inc.dwd_taobao_behavior (
    user_id       BIGINT      COMMENT '用户ID',
    item_id       BIGINT      COMMENT '商品ID',
    category_id   BIGINT      COMMENT '类目ID',
    behavior_type STRING      COMMENT '行为类型',
    behavior_time BIGINT      COMMENT '时间戳',
    event_date    DATE        COMMENT '行为日期',
    event_hour    INT         COMMENT '行为小时',
    etl_time      TIMESTAMP   COMMENT 'ETL执行时间'
) USING iceberg
PARTITIONED BY (event_date)
COMMENT 'DWD淘宝用户行为明细（清洗分区表）';
