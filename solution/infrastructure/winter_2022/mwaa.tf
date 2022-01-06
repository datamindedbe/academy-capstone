resource "aws_mwaa_environment" "mwaa" {
  dag_s3_path = "${local.user_name}/dags/"
  execution_role_arn = data.aws_ssm_parameter.mwaa_role_arn.value
  webserver_access_mode = "PUBLIC_ONLY"

  logging_configuration {
    dag_processing_logs {
      enabled = true
      log_level = "INFO"
    }

    scheduler_logs {
      enabled = true
      log_level = "INFO"
    }

    task_logs {
      enabled = true
      log_level = "INFO"
    }

    webserver_logs {
      enabled = true
      log_level = "INFO"
    }

    worker_logs {
      enabled = true
      log_level = "INFO"
    }
  }

  name = "${local.user_name}-mwaa-env"

  network_configuration {
    security_group_ids = [
      data.aws_ssm_parameter.mwaa_sg_id.value]
    subnet_ids = split(",",data.aws_ssm_parameter.subnet_ids.value )
  }

  source_bucket_arn = "arn:aws:s3:::${data.aws_ssm_parameter.s3_bucket.value}"
  tags = {
    environment = local.env_name
  }
}