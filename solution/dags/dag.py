import datetime
import os

from airflow import DAG
from airflow.providers.amazon.aws.operators.batch import AwsBatchOperator

dag = DAG(
    dag_id="summer-capstone-tutor-dag",
    default_view="graph",
    schedule_interval=None,
    start_date=datetime.datetime(2020, 1, 1),
    catchup=False,
)

task1 = AwsBatchOperator(
    dag=dag,
    task_id="snowflake_ingest",
    job_definition="summer-capstone-export",
    job_queue="summer-capstone-default",
    job_name="snowflake_ingest_tutor",
    overrides={}
)

