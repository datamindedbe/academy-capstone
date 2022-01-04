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
    job_definition="michiel-to-remove",
    job_queue="academy-capstone-winter-2022-default",
    job_name="snowflake_ingest_tutor",
    overrides={}
)

