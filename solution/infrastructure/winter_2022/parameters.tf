data "aws_ssm_parameter" "s3_bucket" {
  name = "/${local.env_name}/s3_bucket"
}

data "aws_ssm_parameter" "vpc_id" {
  name = "/${local.env_name}/vpc_id"
}

data "aws_ssm_parameter" "subnet_ids" {
  name = "/${local.env_name}/subnet_ids"
}

data "aws_ssm_parameter" "mwaa_role_arn" {
  name = "/${local.env_name}/mwaa_role_arn"
}

data "aws_ssm_parameter" "batch_job_role_arn" {
  name = "/${local.env_name}/batch_job_role_arn"
}

data "aws_ssm_parameter" "mwaa_sg_id" {
  name = "/${local.env_name}/mwaa_sg_id"
}