CREATE TABLE IF NOT EXISTS iceberg_lab_iceberg.iceberg_inc.taobao_behavior (
    user_id        BIGINT    COMMENT '用户ID',
    item_id        BIGINT    COMMENT '商品ID',
    category_id    BIGINT    COMMENT '类目ID',
    behavior_type  STRING    COMMENT '行为类型：pv/cart/fav/buy',
    behavior_time  BIGINT    COMMENT '行为时间戳（秒）',
    event_date     DATE      COMMENT '行为日期'
) USING iceberg
PARTITIONED BY (event_date)
COMMENT 'ODS淘宝用户行为明细';
