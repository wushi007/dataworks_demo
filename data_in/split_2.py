from pyspark.sql import SparkSession
from pyspark.sql.types import StructType, StructField, LongType, StringType

def main():
    spark = SparkSession.builder.enableHiveSupport().getOrCreate()

    schema = StructType([
        StructField("user_id", LongType()),
        StructField("item_id", LongType()),
        StructField("category_id", LongType()),
        StructField("behavior_type", StringType()),
        StructField("timestamp", LongType())
    ])

    src_path = "oss://your-bucket/data/taobao_raw/UserBehavior.csv"
    reader = spark.read.schema(schema)
    reader = reader.option("header", "false")
    reader = reader.option("delimiter", ",")
    reader = reader.option("mode", "DROPMALFORMED")
    df_full = reader.csv(src_path)

    cnt = df_full.count()
    print(f"📊 读取到 {cnt} 条原始记录")
    if cnt == 0:
        raise ValueError("原始数据为空，请检查路径和文件格式！")

    df_date = df_full.selectExpr("*", "to_date(from_unixtime(timestamp)) AS event_date")

    dst_path = "oss://your-bucket/data/taobao_raw_partitioned/"
    writer = df_date.write.mode("overwrite").partitionBy("event_date")
    writer = writer.option("header", "false").option("delimiter", ",")
    writer.csv(dst_path)

    print(f"✅ 按日期拆分完成，输出目录：{dst_path}")
    print("💡 原始数据保持不变，位于：" + src_path)

if __name__ == "__main__":
    main()
