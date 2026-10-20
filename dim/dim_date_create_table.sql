CREATE TABLE IF NOT EXISTS iceberg_lab_iceberg.iceberg_inc.dim_date (
    date_key         DATE    COMMENT '日期主键',
    year             INT     COMMENT '年',
    month            INT     COMMENT '月',
    day              INT     COMMENT '日',
    day_of_week      INT     COMMENT '星期几(1=周日)',
    day_of_week_name STRING  COMMENT '星期名称',
    is_weekend       BOOLEAN COMMENT '是否周末',
    week_of_year     INT     COMMENT '第几周'
) USING iceberg
COMMENT 'DIM日期维度表';
