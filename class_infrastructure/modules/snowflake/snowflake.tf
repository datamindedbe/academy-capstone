data "aws_iam_group" "participants" {
  group_name = var.group
}

resource "snowflake_warehouse" "wh" {
  name           = upper(replace("${var.group}-warehouse", "-", "_"))
  warehouse_size = "small"
}

resource "snowflake_database" "database" {
  name = upper(replace("${var.group}-capstone-database", "-", "_"))
}

resource "snowflake_schema" "participants_schemas" {
  for_each = toset(data.aws_iam_group.participants.users[*].user_name)
  database = snowflake_database.database.name
  name     = upper(replace(each.key, "-", "_"))

}

resource "random_string" "sf_user_password" {
  length = 10
}

resource "snowflake_user" "user" {
  name       = upper(replace("${var.group}-sf-user", "-", "_"))
  login_name = upper(replace("${var.group}-user", "-", "_"))
  password   = random_string.sf_user_password.result

  default_warehouse = snowflake_warehouse.wh.name
  default_role      = snowflake_role.participants_role.name

  must_change_password = false
}

resource "snowflake_role" "participants_role" {
  name = upper(replace("${var.group}-role", "-", "_"))
}


resource "snowflake_role_grants" "grants" {
  role_name = snowflake_role.participants_role.name

  users = [
    snowflake_user.user.name,
  ]
}


resource "snowflake_grant_privileges_to_role" "schema_grants" {
  privileges = ["USAGE", "CREATE TABLE"]
  role_name  = snowflake_role.participants_role.name
  on_schema {
    all_schemas_in_database = snowflake_database.database.name
  }
  with_grant_option = false
}

resource "snowflake_grant_privileges_to_role" "schema_future_grants" {
  privileges = ["USAGE", "CREATE TABLE"]
  role_name  = snowflake_role.participants_role.name
  on_schema {
    future_schemas_in_database = snowflake_database.database.name
  }
  with_grant_option = false
}
resource "snowflake_grant_privileges_to_role" "database_grant" {
  privileges = ["USAGE"]
  role_name  = snowflake_role.participants_role.name
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.database.name
  }
  with_grant_option = false
}


resource "snowflake_grant_privileges_to_role" "warehouse_grant" {
  privileges = ["USAGE"]
  role_name  = snowflake_role.participants_role.name
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.wh.name
  }
  with_grant_option = false
}



resource "aws_secretsmanager_secret" "snowflake_login" {
  name                    = var.secret_name
  recovery_window_in_days = 0
  kms_key_id              = aws_kms_key.sm_key.id
  policy                  = data.aws_iam_policy_document.secret_policy.json
}

resource "aws_secretsmanager_secret_version" "snowflake_login" {
  secret_id = aws_secretsmanager_secret.snowflake_login.id
  secret_string = jsonencode(
    {
      "URL" : "yw41113.eu-west-1.snowflakecomputing.com",
      "PASSWORD" : snowflake_user.user.password,
      "USER_NAME" : snowflake_user.user.login_name,
      "WAREHOUSE" : snowflake_warehouse.wh.name,
      "DATABASE" : snowflake_database.database.name,
      "ROLE" : snowflake_role.participants_role.name
    }
  )
}

resource "aws_kms_key" "sm_key" {
  policy = data.aws_iam_policy_document.sm_key.json
}

data "aws_iam_policy_document" "sm_key" {
  statement {
    effect = "Allow"
    principals {
      identifiers = ["arn:aws:iam::130966031144:root"]
      type        = "AWS"
    }
    actions = ["kms:Decrypt",
    "kms"]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    principals {
      identifiers = ["338791806049"]
      type        = "AWS"
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "secret_policy" {
  statement {
    effect = "Allow"
    principals {
      identifiers = ["arn:aws:iam::130966031144:root"]
      type        = "AWS"
    }
    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["*"]
  }
}
