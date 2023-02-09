locals {
  s3_bucket      = var.participants_permissions.s3_access.bucket
  s3_path        = var.participants_permissions.s3_access.path
  s3_dags_folder = var.participants_permissions.s3_access.dags_folder
  group          = var.participants_permissions.group
}

data "aws_iam_group" "participants" {
  group_name = local.group
}

#resource "aws_mwaa_environment" "mwaa" {
#  count                 = length(data.aws_iam_group.participants.users)
#  dag_s3_path           = "${data.aws_iam_group.participants.users[count.index].user_name}/${local.s3_dags_folder}/"
#  execution_role_arn    = var.mwaa_role_arn
#  webserver_access_mode = "PUBLIC_ONLY"
#
#  logging_configuration {
#    dag_processing_logs {
#      enabled   = true
#      log_level = "INFO"
#    }
#
#    scheduler_logs {
#      enabled   = true
#      log_level = "INFO"
#    }
#
#    task_logs {
#      enabled   = true
#      log_level = "INFO"
#    }
#
#    webserver_logs {
#      enabled   = true
#      log_level = "INFO"
#    }
#
#    worker_logs {
#      enabled   = true
#      log_level = "INFO"
#    }
#  }
#
#  name = "${data.aws_iam_group.participants.users[count.index].user_name}-mwaa-env"
#
#  network_configuration {
#    security_group_ids = [aws_security_group.mwaa_sg.id]
#    subnet_ids         = split(",", var.subnet_ids )
#  }
#
#  source_bucket_arn = "arn:aws:s3:::${local.s3_bucket}"
#  tags              = {
#    environment = var.environment
#  }
#}

resource "aws_mwaa_environment" "mwaa_shared" {
  dag_s3_path           = "${local.s3_dags_folder}/"
  execution_role_arn    = var.mwaa_role_arn
  webserver_access_mode = "PUBLIC_ONLY"

  logging_configuration {
    dag_processing_logs {
      enabled   = true
      log_level = "INFO"
    }

    scheduler_logs {
      enabled   = true
      log_level = "INFO"
    }

    task_logs {
      enabled   = true
      log_level = "INFO"
    }

    webserver_logs {
      enabled   = true
      log_level = "INFO"
    }

    worker_logs {
      enabled   = true
      log_level = "INFO"
    }
  }

  name = "shared-mwaa-env"

  network_configuration {
    security_group_ids = [aws_security_group.mwaa_sg.id]
    subnet_ids         = split(",", var.subnet_ids )
  }

  source_bucket_arn = "arn:aws:s3:::${local.s3_bucket}"
  tags              = {
    environment = var.environment
  }
}