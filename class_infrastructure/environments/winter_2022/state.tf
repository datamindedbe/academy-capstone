terraform {
  backend "s3" {
    bucket         = {}
    region         = "eu-west-1"
    encrypt        = "true"
    key            = {}
    dynamodb_table = {}
  }
}
