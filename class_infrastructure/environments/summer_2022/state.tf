terraform {
  backend "s3" {
    bucket         = "dataminded-academy-capstone-resources"
    region         = "eu-west-1"
    encrypt        = "true"
    key            = "states/capstone-summer-2022.tfstate"
#    dynamodb_table = "dataminded-academy-state-locks"
  }
}
