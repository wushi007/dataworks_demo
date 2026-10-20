CREATE TABLE IF NOT EXISTS iceberg_lab_iceberg.iceberg_inc.fact_user_behavior (
    user_key     BIGINT    COMMENT '用户ID，关联dim_user',
    item_key     BIGINT    COMMENT '商品ID，关联dim_item',
    category_key BIGINT    COMMENT '类目ID，关联dim_category',
    date_key     DATE      COMMENT '日期，关联dim_date',
    behavior_key STRING    COMMENT '行为类型：pv/buy/cart/fav',
    behavior_cnt BIGINT    COMMENT '行为发生次数',
    etl_time     TIMESTAMP COMMENT 'ETL执行时间'
) USING iceberg
PARTITIONED BY (date_key)
COMMENT 'DWS用户行为事实表';
