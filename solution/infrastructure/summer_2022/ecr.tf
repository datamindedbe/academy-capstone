resource "aws_ecr_repository" "repo" {
  name = "${local.user_name}-${local.env_name}"
}