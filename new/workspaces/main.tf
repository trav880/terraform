provider "aws" {
  region = "us-east-2"
}

terraform {
  backend "s3" {
    bucket = "terraform-up-and-running-state-s3test-0192"
    key = "workspaces-terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "terraform-up-and-running-state-s3test-0192-locks"
    encrypt = true
  }
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}