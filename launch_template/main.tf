
provider "aws" {
  region = "us-east-2"
}
resource "aws_launch_template" "web1" {
  name          = "web1"
  image_id      = "ami-0e38b48473ea57778"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["sg-037a20d5f1f863286"]
  
  placement {
    availability_zone = "us-east-2a"
  }

  tags = {
    Name = "web1-launch-template"
  }
}

