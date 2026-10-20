from pyspark.sql import SparkSession
from pyspark.sql.types import StructType, StructField, LongType, StringType
from datetime import datetime

def main():
    spark = SparkSession.builder.enableHiveSupport().getOrCreate()
    spark.conf.set("spark.sql.session.timeZone", "Asia/Shanghai")

    df_raw = None
    try:
        bizdate = spark.conf.get("spark.emr.SKYNET_BIZDATE")
        bizdate_dash = datetime.strptime(bizdate, "%Y%m%d").strftime("%Y-%m-%d")

        schema = StructType([
            StructField("user_id", LongType(), nullable=True),
            StructField("item_id", LongType(), nullable=True),
            StructField("category_id", LongType(), nullable=True),
            StructField("behavior_type", StringType(), nullable=True),
            StructField("timestamp", LongType(), nullable=True)
        ])

        source_path = f"oss://your-bucket/data/taobao_raw_partitioned/event_date={bizdate_dash}/"
        df_raw = spark.read.schema(schema).option("header", "false").csv(source_path)
        df_raw.cache()

        total_raw_cnt = df_raw.count()

        df_valid = df_raw.filter("""
            user_id IS NOT NULL AND user_id > 0
            AND item_id IS NOT NULL AND item_id > 0
            AND category_id IS NOT NULL AND category_id > 0
            AND behavior_type IN ('pv','cart','fav','buy')
            AND timestamp IS NOT NULL
            AND timestamp BETWEEN 1511539200 AND 1512316799
        """)
        valid_cnt = df_valid.count()
        bad_cnt = total_raw_cnt - valid_cnt
        bad_ratio = bad_cnt / total_raw_cnt if total_raw_cnt > 0 else 1.0
        print(f"📊 原始: {total_raw_cnt}, 合法: {valid_cnt}, 脏数据: {bad_cnt}, 脏占比:{bad_ratio:.2%}")

        if bad_ratio > 0.05:
            raise Exception(f"❌ 脏数据占比超标({bad_ratio:.2%}>5%), 任务终止 bizdate={bizdate}")

        df_ods = df_valid.selectExpr(
            "user_id",
            "item_id",
            "category_id",
            "behavior_type",
            "timestamp AS behavior_time",
            "to_date(from_unixtime(timestamp)) AS event_date"
        ).filter(f"event_date = '{bizdate_dash}'")

        df_ods.createOrReplaceTempView("tmp_ods_taobao_behavior")
        pre_write_cnt = df_ods.count()
        print(f"🔍 待写入行数: {pre_write_cnt}")
        if pre_write_cnt <= 0:
            raise Exception(f"❌ 待写入数据为0，禁止覆盖分区 bizdate={bizdate}")

        spark.sql(f"""
            INSERT OVERWRITE iceberg_lab_iceberg.iceberg_inc.taobao_behavior
            PARTITION (event_date = '{bizdate_dash}')
            SELECT
                user_id,
                item_id,
                category_id,
                behavior_type,
                behavior_time
            FROM tmp_ods_taobao_behavior
        """)

        write_cnt = spark.sql(f"""
            SELECT COUNT(*) FROM iceberg_lab_iceberg.iceberg_inc.taobao_behavior
            WHERE event_date = '{bizdate_dash}'
        """).collect()[0][0]
        print(f"✅ 写入完成，分区{bizdate_dash}，入库行数：{write_cnt}")

    finally:
        if df_raw is not None:
            df_raw.unpersist()
        spark.stop()

if __name__ == "__main__":
    main()
