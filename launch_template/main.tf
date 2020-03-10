
provider "aws" {
  region = "us-east-2"
}
resource "aws_launch_template" "web1" {
  name                   = "web1"
  image_id               = "ami-0e38b48473ea57778"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-037a20d5f1f863286"]

  tags = {
    Name = "web1-launch-template"
  }
}

resource "aws_autoscaling_group" "web1" {
  availability_zones = ["us-east-2a", "us-east-2b"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.web1.id
    version = "$Latest"
  }
}
