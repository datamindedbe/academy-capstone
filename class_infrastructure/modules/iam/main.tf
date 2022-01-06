locals {
  group_name = var.participants_permissions.group
}

resource "aws_iam_group_policy" "capstone_participants_s3_group_policy" {
  group = local.group_name
  name = "${local.group_name}-s3-read-access"
  policy = data.aws_iam_policy_document.capstone_s3_access.json
}

resource "aws_iam_group_policy_attachment" "capstone_participants_ssm_role_group_policy" {
  group = local.group_name
  policy_arn = aws_iam_policy.tf_state_policy.arn
}

resource "aws_iam_group_policy" "capstone_participants_sm_group_policy" {
  group = local.group_name
  name = "${local.group_name}-sm-read-access"
  policy = data.aws_iam_policy_document.capstone_secret_read_access.json
}

resource "aws_iam_group_policy" "capstone_participants_mwaa_group_policy" {
  group = local.group_name
  name = "${local.group_name}-mwaa-access"
  policy = data.aws_iam_policy_document.capstone_mwaa_access.json
}

resource "aws_iam_group_policy" "capstone_participants_batch_group_policy" {
  group = local.group_name
  name = "${local.group_name}-batch-access"
  policy = data.aws_iam_policy_document.capstone_batch_access.json
}

resource "aws_iam_group_policy" "capstone_participants_ecr_group_policy" {
  group = local.group_name
  name = "${local.group_name}-ecr-access"
  policy = data.aws_iam_policy_document.capstone_ecr_access.json
}

resource "aws_iam_group_policy" "capstone_participants_pass_batch_role_group_policy" {
  group = local.group_name
  name = "${local.group_name}-pass-batch-role"
  policy = data.aws_iam_policy_document.pass_batch_job_role.json
}

resource "aws_iam_group_policy" "capstone_participants_pass_mwaa_role_group_policy" {
  group = local.group_name
  name = "${local.group_name}-pass-mwaa-role"
  policy = data.aws_iam_policy_document.pass_mwaa_role.json
}

resource "aws_iam_group_policy" "capstone_participants_ssm_role_group_policy" {
  group = local.group_name
  name = "${local.group_name}-ssm-access"
  policy = data.aws_iam_policy_document.parameter_store_access.json
}