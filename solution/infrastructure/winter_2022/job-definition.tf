resource "aws_batch_job_definition" "job_definition" {
  name = "${local.user_name}-job-definition"
  type = "container"
  tags = {
    "environment": local.env_name
  }
  container_properties = <<CONTAINER_PROPERTIES
{
  "command": ["python3", "/opt/spark/work-dir/scripts/01_export_data_to_db.py"],
  "image": "${aws_ecr_repository.repo.repository_url}:latest",
  "executionRoleArn": "${data.aws_ssm_parameter.batch_job_role_arn.value}",
  "resourceRequirements": [
      {"type": "VCPU", "value": "2"},
      {"type": "MEMORY", "value": "2048"}
    ]
}
CONTAINER_PROPERTIES
}
