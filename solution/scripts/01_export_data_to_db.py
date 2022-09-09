import logging
import os

import boto3

from academy_capstone.util.spark import ClosableSparkSession
from academy_capstone.util.s3 import get_spark_datalink
from academy_capstone.db_export.export import read_json_as_df, flatten_df
from academy_capstone.util.spark import string_columns_to_timestamp, write_df_with_options
from academy_capstone.util.snowflake import get_snowflake_creds_from_sm


def main():
    additional_spark_config = {}
    if os.environ.get("RUN_LOCAL"): # when running locally, this setting allows to check for AWS env vars or profile
        additional_spark_config.update({
            "fs.s3a.aws.credentials.provider": "com.amazonaws.auth.DefaultAWSCredentialsProviderChain",
        })
    with ClosableSparkSession("export", spark_config=additional_spark_config) as spark:
        df = (read_json_as_df(spark, get_spark_datalink("raw/open_aq"))
              .transform(flatten_df)
              .drop("local")
              .transform(string_columns_to_timestamp({"utc"})))

        SNOWFLAKE_SOURCE_NAME = "net.snowflake.spark.snowflake"

        sfOptions = get_snowflake_creds_from_sm("arn:aws:secretsmanager:eu-west-1:338791806049:secret:snowflake/capstone/login")
        sfOptions.update({
            "sfSchema": "CAPSTONE_TUTOR",
            "dbtable": "TEMP"

        }
        )
        logging.info(sfOptions)
        write_df_with_options(df, format=SNOWFLAKE_SOURCE_NAME, options=sfOptions, mode="overwrite")


if __name__ == "__main__":
    main()
