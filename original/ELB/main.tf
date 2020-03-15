provider "aws" {
  region = "us-east-2"
}

resource "aws_alb" "web1elb" {
  name               = "terraform-web1-elb"
  internal           = false
  load_balancer_type = "application"
  subnets            = ["subnet-1b9f6970", "subnet-594bdf15"]
tags = {
  Environment = "development"
}
}
