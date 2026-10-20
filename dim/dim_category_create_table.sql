CREATE TABLE IF NOT EXISTS iceberg_lab_iceberg.iceberg_inc.dim_category (
    category_key   BIGINT    COMMENT '类目主键',
    item_count     BIGINT    COMMENT '商品数',
    user_count     BIGINT    COMMENT '用户数',
    category_level STRING    COMMENT '类目热度',
    etl_time       TIMESTAMP COMMENT 'ETL时间'
) USING iceberg
COMMENT 'DIM类目维度表';
