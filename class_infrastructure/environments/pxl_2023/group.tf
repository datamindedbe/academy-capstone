resource "aws_iam_group" "participants" {
  name = local.group_name
}


variable "keybase_user" {
  description = <<-EOM
    Enter the keybase id of a person to encrypt the AWS IAM secret access key.
    Note that you need access to its private key so you can decrypt it. In
    practice that means you specify your own keybase account id.
    EOM
}


resource "aws_iam_user" "participant" {
  for_each = local.participants
  name     = each.value
}

resource "aws_iam_access_key" "participant" {
  for_each = local.participants

  user    = aws_iam_user.participant[each.value].name
  pgp_key = "keybase:${var.keybase_user}"
}

resource "aws_iam_user_login_profile" "participant" {
  for_each = local.participants

  user    = aws_iam_user.participant[each.value].name
  pgp_key = "keybase:${var.keybase_user}"
}

resource "aws_iam_user_group_membership" "membership" {
  for_each = local.participants
  user = aws_iam_user.participant[each.value].name
  groups = [aws_iam_group.participants.name]
}

output "iam_console_password" {
  value = [for p in aws_iam_user_login_profile.participant : p.encrypted_password]
}

output "iam_access_key" {
  value = [for p in aws_iam_access_key.participant : p.id]
}

output "pgp_encrypted_iam_secret_access_key" {
  value = [for p in aws_iam_access_key.participant : p.encrypted_secret]
  # Decrypt using your private PGP key:
  # terraform output -raw iam_access_key | base64 --decode | keybase pgp decrypt
}