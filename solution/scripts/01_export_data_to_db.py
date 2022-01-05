import logging
import os

import boto3

from academy_capstone.util.spark import ClosableSparkSession
from academy_capstone.util.s3 import get_spark_datalink
from academy_capstone.db_export.export import read_json_as_df, flatten_df
from academy_capstone.util.spark import string_columns_to_timestamp, write_df_with_options
from academy_capstone.util.snowflake import get_snowflake_creds_from_sm


def main():
    aws_region = os.environ.get("AWS_REGION")
    additional_spark_config = {}
    if os.environ.get("RUN_LOCAL"):
        additional_spark_config.update({
            "fs.s3a.aws.credentials.provider": "org.apache.hadoop.fs.s3a.SimpleAWSCredentialsProvider",
            "fs.s3a.access.key": os.environ.get("AWS_ACCESS_KEY_ID"),
            "fs.s3a.secret.key": os.environ.get("AWS_SECRET_ACCESS_KEY")
        })
    with ClosableSparkSession("export", spark_config=additional_spark_config) as spark:
        df = (read_json_as_df(spark, get_spark_datalink("raw/open_aq"))
              .transform(flatten_df)
              .drop("local")
              .transform(string_columns_to_timestamp({"utc"})))

        SNOWFLAKE_SOURCE_NAME = "net.snowflake.spark.snowflake"

        sfOptions = get_snowflake_creds_from_sm("snowflake/capstone/login")
        sfOptions.update({
            "sfSchema": "MICHIEL_ACADEMY_WINTER_2022_TEST",
            "dbtable": "TEMP"
        }
        )
        write_df_with_options(df, format=SNOWFLAKE_SOURCE_NAME, options=sfOptions, mode="overwrite")


if __name__ == "__main__":
    main()
