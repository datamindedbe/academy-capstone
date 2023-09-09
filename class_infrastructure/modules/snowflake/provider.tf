provider "aws" {
  region = "eu-west-1"
  profile = "instructor"
}

terraform {
  required_providers {
    snowflake = {
      source = "Snowflake-Labs/snowflake"
      version = "0.70.1"
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