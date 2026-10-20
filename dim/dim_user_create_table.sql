CREATE TABLE IF NOT EXISTS iceberg_lab_iceberg.iceberg_inc.dim_user (
    user_key            BIGINT    COMMENT '用户主键',
    first_active_date   DATE      COMMENT '首次活跃日期',
    last_active_date    DATE      COMMENT '最后活跃日期',
    active_days         BIGINT    COMMENT '活跃天数',
    total_pv            BIGINT    COMMENT '累计浏览次数',
    total_buy           BIGINT    COMMENT '累计购买次数',
    total_cart          BIGINT    COMMENT '累计加购次数',
    total_fav           BIGINT    COMMENT '累计收藏次数',
    buy_rate            DOUBLE    COMMENT '购买转化率',
    user_value_level    STRING    COMMENT '用户价值等级',
    user_activity_level STRING    COMMENT '用户活跃度等级',
    etl_time            TIMESTAMP COMMENT 'ETL时间'
) USING iceberg
COMMENT 'DIM用户维度表';
