CREATE TABLE IF NOT EXISTS iceberg_lab_iceberg.iceberg_inc.ads_daily_overview (
    event_date      DATE      COMMENT '日期',
    total_uv        BIGINT    COMMENT '日活用户数',
    total_pv        BIGINT    COMMENT '总浏览量',
    total_buy       BIGINT    COMMENT '总购买次数',
    buy_user_cnt    BIGINT    COMMENT '购买用户数',
    buy_rate        DOUBLE    COMMENT '购买转化率',
    etl_time        TIMESTAMP COMMENT 'ETL时间'
) USING iceberg
PARTITIONED BY (event_date)
COMMENT 'ADS每日大盘概览';

CREATE TABLE IF NOT EXISTS iceberg_lab_iceberg.iceberg_inc.ads_hour_traffic_day (
    event_date      DATE      COMMENT '日期',
    event_hour      INT       COMMENT '行为小时(0-23)',
    pv_cnt          BIGINT    COMMENT '浏览次数',
    uv_cnt          BIGINT    COMMENT '去重访客数',
    buy_cnt         BIGINT    COMMENT '购买次数',
    hour_buy_rate   DOUBLE    COMMENT '小时购买转化率',
    is_weekend      BOOLEAN   COMMENT '是否周末',
    etl_time        TIMESTAMP COMMENT 'ETL时间'
) USING iceberg
PARTITIONED BY (event_date)
COMMENT 'ADS分时流量与转化';
