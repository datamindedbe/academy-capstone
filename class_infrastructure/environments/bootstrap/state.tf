terraform {
  backend "s3" {
    bucket  = "dataminded-academy-shared-infrastructure"
    region  = "eu-west-1"
    encrypt = "true"
    key     = "states/capstone-bootstrap.tfstate"
    profile = "instructor"
  }
}
