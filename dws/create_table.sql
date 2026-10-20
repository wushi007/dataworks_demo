CREATE TABLE IF NOT EXISTS iceberg_lab_iceberg.iceberg_inc.dws_user_behavior_day (
    user_id         BIGINT    COMMENT '用户ID',
    pv_cnt          BIGINT    COMMENT '浏览次数',
    cart_cnt        BIGINT    COMMENT '加购次数',
    fav_cnt         BIGINT    COMMENT '收藏次数',
    buy_cnt         BIGINT    COMMENT '购买次数',
    total_behavior  BIGINT    COMMENT '行为总数',
    day_buy_rate    DOUBLE    COMMENT '当日购买转化率',
    event_date      DATE      COMMENT '日期',
    etl_time        TIMESTAMP COMMENT 'ETL时间'
) USING iceberg
PARTITIONED BY (event_date)
COMMENT 'DWS用户日行为指标';

CREATE TABLE IF NOT EXISTS iceberg_lab_iceberg.iceberg_inc.dws_item_behavior_day (
    item_id         BIGINT    COMMENT '商品ID',
    category_id     BIGINT    COMMENT '类目ID',
    pv_cnt          BIGINT    COMMENT '浏览次数',
    cart_cnt        BIGINT    COMMENT '加购次数',
    fav_cnt         BIGINT    COMMENT '收藏次数',
    buy_cnt         BIGINT    COMMENT '购买次数',
    uv_cnt          BIGINT    COMMENT '去重访客数',
    day_buy_rate    DOUBLE    COMMENT '当日购买转化率',
    event_date      DATE      COMMENT '日期',
    etl_time        TIMESTAMP COMMENT 'ETL时间'
) USING iceberg
PARTITIONED BY (event_date)
COMMENT 'DWS商品日行为指标';

CREATE TABLE IF NOT EXISTS iceberg_lab_iceberg.iceberg_inc.dws_category_behavior_day (
    category_id     BIGINT    COMMENT '类目ID',
    item_cnt        BIGINT    COMMENT '商品数',
    uv_cnt          BIGINT    COMMENT '去重访客数',
    pv_cnt          BIGINT    COMMENT '浏览次数',
    buy_cnt         BIGINT    COMMENT '购买次数',
    day_buy_rate    DOUBLE    COMMENT '当日购买转化率',
    event_date      DATE      COMMENT '日期',
    etl_time        TIMESTAMP COMMENT 'ETL时间'
) USING iceberg
PARTITIONED BY (event_date)
COMMENT 'DWS类目日行为指标';

CREATE TABLE IF NOT EXISTS iceberg_lab_iceberg.iceberg_inc.dws_hour_behavior_day (
    event_hour      INT       COMMENT '行为小时(0-23)',
    pv_cnt          BIGINT    COMMENT '浏览次数',
    uv_cnt          BIGINT    COMMENT '去重访客数',
    buy_cnt         BIGINT    COMMENT '购买次数',
    event_date      DATE      COMMENT '日期',
    etl_time        TIMESTAMP COMMENT 'ETL时间'
) USING iceberg
PARTITIONED BY (event_date)
COMMENT 'DWS小时级流量指标';
