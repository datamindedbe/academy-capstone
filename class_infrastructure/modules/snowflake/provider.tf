provider "aws" {
  region = "eu-west-1"
}

terraform {
  required_providers {
    snowflake = {
      source = "chanzuckerberg/snowflake"
      version = "0.25.31"
    }
  }
}

provider "snowflake" {
  username = "TERRAFORM_ADMIN"
  account = "yw41113"
  region = "eu-west-1"
  password = data.aws_secretsmanager_secret_version.snowflake_admin.secret_string
  role = "ACCOUNTADMIN"
}

data "aws_secretsmanager_secret_version" "snowflake_admin" {
  secret_id = "snowflake/terraform/password"
}