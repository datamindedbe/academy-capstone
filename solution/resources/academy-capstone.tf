locals {
  project_name = "academy-capstone"
}

resource "aws_iam_role" "default" {
  name = "${local.project_name}-${var.env_name}"
  assume_role_policy = data.aws_iam_policy_document.default_assume_role.json
}

data "aws_iam_policy_document" "default_assume_role" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity"]
    effect = "Allow"

    condition {
      test = "StringLike"
      variable = "${replace(var.aws_iam_openid_connect_provider_url, "https://", "")}:sub"
      values = [
        "system:serviceaccount:${var.env_name}:${replace(local.project_name, "_", ".")}-*"]
    }

    principals {
      identifiers = [
        var.aws_iam_openid_connect_provider_arn]
      type = "Federated"
    }
  }
}

resource "aws_iam_role_policy" "default" {
  name = "${local.project_name}-${var.env_name}"
  role = aws_iam_role.default.id
  policy = data.aws_iam_policy_document.default.json
}

data "aws_iam_policy_document" "default" {
  statement {
    actions = [
      "s3:*"
    ]
    resources = [
      "arn:aws:s3:::*",
      "arn:aws:s3:::dataminded-academy-capstone-resources/*",
      "arn:aws:s3:::dataminded-academy-capstone-resources",
    ]
    effect = "Allow"
  }
  statement {
    actions = [
      "secretsmanager:ListSecrets"]
    resources = [
      "*",
      "arn:aws:secretsmanager:eu-west-1:338791806049:secret:snowflake/capstone/login"]
  }
  statement {
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"]
    resources = [
      "*",
      "arn:aws:secretsmanager:eu-west-1:338791806049:secret:snowflake/capstone/login"]
  }
  statement {
    actions = ["kms:Decrypt"]
    resources = ["arn:aws:kms:eu-west-1:338791806049:key/f66c11df-10b3-424a-a801-02aed8d7f592"]
  }
}