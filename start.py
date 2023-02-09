import pyspark
import boto3
from pyspark.sql import SQLContext
from pyspark.sql import SparkSession
from pyspark.sql.types import *
from pyspark.sql import SQLContext
import boto3
from pyspark.sql.types import *
from pyspark import SparkContext
sc = SparkContext()


s3 = boto3.resource('s3')
BUCKET = s3.Bucket('s3://dataminded-academy-capstone-resources/raw/open_aq/')
#KEY = 

#Configure spark with your S3 access keys
sc._jsc.hadoopConfiguration().set("fs.s3n.awsAccessKeyId", "AKIAU5YMQWRQZSNKWJPX")
sc._jsc.hadoopConfiguration().set("fs.s3n.awsSecretAccessKey", "IKwklvxoITml3uqHZe735G1tFR1uNwAYeTPkHqQG")
object_list = [k for k in BUCKET.objects.all() ]
key_list = [k.key for k in BUCKET.objects.all()]

#paths = ['s3n://'+o.bucket_name+'/'+ o.key for o in object_list ]

#dataframes = [sqlContext.read.json(path) for path in paths]

#df = dataframes[0]
#for idx, frame in enumerate(dataframes):
#   df = df.unionAll(frame)