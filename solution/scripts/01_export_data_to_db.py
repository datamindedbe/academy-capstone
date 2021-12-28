import os

import boto3

from academy_capstone.util.spark import ClosableSparkSession
from academy_capstone.util.s3 import get_spark_datalink
from academy_capstone.db_export.export import read_json_as_df, flatten_df
from academy_capstone.util.spark import string_columns_to_timestamp, write_df_with_options
from academy_capstone.util.snowflake import get_snowflake_creds_from_sm


def main():
    aws_region = os.environ.get("AWS_REGION")

    with ClosableSparkSession("export") as spark:
        df = (read_json_as_df(spark, get_spark_datalink("raw/open_aq"))
              .transform(flatten_df)
              .drop("local")
              .transform(string_columns_to_timestamp({"utc"})))

        SNOWFLAKE_SOURCE_NAME = "net.snowflake.spark.snowflake"

        sess = boto3.Session(region_name=aws_region)
        sfOptions = get_snowflake_creds_from_sm("demoenv/snowflake/login", sess)
        sfOptions.update({
            "sfDatabase": "academy_capstone_STUDENTS",
            "sfWarehouse": "COMPUTE_WH",
            "sfRole": "academy_capstone",
            "sfSchema": "ACADEMY",
            "dbtable": "TEMP"
        }
        )
        write_df_with_options(df, format=SNOWFLAKE_SOURCE_NAME, options=sfOptions, mode="overwrite")


if __name__ == "__main__":
    main()
