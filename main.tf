# Configure the AWS Provider
provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "tfstatedb"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}