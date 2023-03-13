locals {
  env_name      = "academy-capstone-pxl-2023"
  s3_bucket_arn = "arn:aws:s3:::academy-capstone-resources"
  account_id    = "338791806049"
  region        = "eu-west-1"
  secret_name   = "demoenv/snowflake/login"
  group_name    = yamldecode(file("${path.root}/participants-access.yaml")).group
  participants  = toset(yamldecode(file("${path.root}/participants-access.yaml")).users)
}