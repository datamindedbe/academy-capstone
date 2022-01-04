resource "aws_iam_role" "job_role" {
  name = "${var.environment}-batch-job-role"
  path = "/${var.environment}/"
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Attach S3 policy to project role
resource "aws_iam_role_policy" "s3_policy" {
  name = "s3_policy"
  policy = data.aws_iam_policy_document.capstone_s3_read_access.json
  role = aws_iam_role.job_role.id
}

resource "aws_iam_role_policy" "secret_manager" {
  name = "secret_policy"
  policy = data.aws_iam_policy_document.capstone_secret_read_access.json
  role = aws_iam_role.job_role.id
}

//resource "aws_iam_role_policy_attachment" "preprocessor_pipeline_role_batch_policy" {
//  policy_arn = "arn:aws:iam::aws:policy/AWSBatchFullAccess"
//  role       = aws_iam_role.job_role.name
//}

resource "aws_iam_role_policy_attachment" "preprocessor_pipeline_role_cloudwatch_policy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchEventsFullAccess"
  role       = aws_iam_role.job_role.name
}