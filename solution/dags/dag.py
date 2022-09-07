import datetime

from airflow import DAG
from airflow.providers.amazon.aws.operators.batch import AwsBatchOperator

dag = DAG(
    dag_id="capstone-tutor-dag",
    default_view="graph",
    schedule_interval=None,
    start_date=datetime.datetime(2020, 1, 1),
    catchup=False,
)

task1 = AwsBatchOperator(
    dag=dag,
    task_id="snowflake_ingest",
    job_definition="capstone-tutor-job-definition",
    job_queue="academy-capstone-summer-2022-job-queue",
    job_name="snowflake_ingest_tutor",
    overrides={}
)

