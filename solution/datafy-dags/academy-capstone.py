from airflow import DAG
from datafy.operators import DatafySparkSubmitOperatorV2
from datetime import timedelta
from airflow.utils import dates


default_args = {
    "owner": "Datafy",
    "depends_on_past": False,
    "start_date": dates.days_ago(2),
    "email": [],
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 0,
    "retry_delay": timedelta(minutes=5),
}


dag = DAG(
    "academy-capstone",
    default_args=default_args,
    schedule_interval="@daily",
    max_active_runs=1,
)

sample_task = DatafySparkSubmitOperatorV2(
    dag=dag,
    task_id="capstone",
    num_executors="1",
    driver_instance_type="mx_small",
    executor_instance_type="mx_small",
    aws_role="temp-{{ macros.datafy.env() }}",
    spark_main_version=3,
    application="local:///opt/spark/work-dir/scripts/01_export_data_to_db.py",
    application_args=[],
)
