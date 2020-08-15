provider "aws" {
  region  = "us-east-1"
  
  
}

terraform {
  required_version = ">= 0.11.7"

  backend "s3" {
    bucket = "bank-infra-backend"

    key = "test/backbone"

    region  = "us-east-1"
    encrypt = "true"
    dynamodb_table = "terraform-lock-table"
  }
}
