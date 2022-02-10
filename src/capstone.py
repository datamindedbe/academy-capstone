import pandas as pd
import boto3
import io
import os
from pathlib import Path
from pyspark.sql import SparkSession
import pyspark.sql.functions as psf
from pyspark.sql.functions import col, to_timestamp
import json
#add jars to use aws cli in pyspark 
spark = SparkSession.builder.appName("capstone").config('spark.jars.packages', 'org.apache.hadoop:hadoop-aws:3.1.2,net.snowflake:spark-snowflake_2.12:2.9.0-spark_3.1,net.snowflake:snowflake-jdbc:3.13.3').getOrCreate()

#add credentials
#print(os.environ["AWS_SECRET_VALUE"])
#print(os.environ["AWS_ACCESS_VALUE"])
#spark.sparkContext._jsc.hadoopConfiguration().set("fs.s3a.access.key", os.environ["AWS_ACCESS_VALUE"])
#spark.sparkContext._jsc.hadoopConfiguration().set("fs.s3a.secret.key", os.environ["AWS_SECRET_VALUE"])
#spark.sparkContext._jsc.hadoopConfiguration().set("fs.s3n.endpoint", "s3.amazonaws.com")

#or add credential provider
spark.sparkContext._jsc.hadoopConfiguration().set("fs.s3a.aws.credentials.provider", "com.amazonaws.auth.DefaultAWSCredentialsProviderChain")

#add file system
spark.sparkContext._jsc.hadoopConfiguration().set("fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem")

#to load the all the json files into a frame
frame=spark.read.format('org.apache.spark.sql.json') \
        .load("s3a://dataminded-academy-capstone-resources/raw/open_aq/*.json") #change later to *.json
frame.show()
frame.printSchema()


#bucket='dataminded-academy-capstone-resources'
#file_key = 'raw/open_aq/data_part_1.json'

#`s3://dataminded-academy-capstone-resources/raw/open_aq/`
#s3 = boto3.resource('s3')
#my_bucket = s3.Bucket('dataminded-academy-capstone-resources')

#for my_bucket_object in my_bucket.objects.all():
#    print(my_bucket_object)
    
#s3_client = boto3.client('s3')


#task: to fix the data types and flatten nested colmns
import pyspark.sql.functions as F

def flatten_df(nested_df):
    flat_cols = [c[0] for c in nested_df.dtypes if c[1][:6] != 'struct']
    nested_cols = [c[0] for c in nested_df.dtypes if c[1][:6] == 'struct']

    flat_df = nested_df.select(flat_cols +
                               [F.col(nc+'.'+c).alias(nc+'_'+c)
                                for nc in nested_cols
                                for c in nested_df.select(nc+'.*').columns])
    return flat_df

flatframe = flatten_df(frame)
flatframe.printSchema()
flatframe.show()

flatframe = flatframe.withColumn("date_local_timestamp",to_timestamp('date_local'))
flatframe = flatframe.withColumn("date_utc_timestamp",to_timestamp('date_utc'))

flatframe.printSchema()

#step2
client = boto3.client('secretsmanager') 
response = client.get_secret_value( SecretId='snowflake/capstone/login' ) 
database_secrets = json.loads(response['SecretString']) 
print(database_secrets)

sfOptions = {
"sfURL": f"{database_secrets['URL']}.snowflakecomputing.com/",
"sfUser": f"{database_secrets['USER_NAME']}",
"sfPassword" : f"{database_secrets['PASSWORD']}",
"sfDatabase": f"{database_secrets['DATABASE']}",
"sfSchema": "VEDAVYAS",
"sfWarehouse": f"{database_secrets['WAREHOUSE']}",
"parallelism": "64",
"dbtable":"VV_table",
}

flatframe.write.format("net.snowflake.spark.snowflake").options(**sfOptions).mode("overwrite").save()
