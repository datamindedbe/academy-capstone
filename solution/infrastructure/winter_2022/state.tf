terraform {
  backend "s3" {
    bucket         = "dataminded-academy-capstone-resources"
    region         = "eu-west-1"
//    encrypt        = "true"
    key            = "states/academy-capstone-winter-2022-capstone-tutor.tfstate"
//    dynamodb_table = "dataminded-academy-state-locks"
  }
}
