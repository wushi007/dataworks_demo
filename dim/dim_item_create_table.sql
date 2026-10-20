CREATE TABLE IF NOT EXISTS iceberg_lab_iceberg.iceberg_inc.dim_item (
    item_key        BIGINT    COMMENT '商品主键',
    category_id     BIGINT    COMMENT '所属类目',
    first_seen_date DATE      COMMENT '首次出现日期',
    total_pv        BIGINT    COMMENT '累计浏览量',
    total_buy       BIGINT    COMMENT '累计购买量',
    item_hot_level  STRING    COMMENT '热度等级',
    etl_time        TIMESTAMP COMMENT 'ETL时间'
) USING iceberg
COMMENT 'DIM商品维度表';
