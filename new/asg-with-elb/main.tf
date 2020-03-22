provider "aws" {
  region = "us-east-2"
}

variable "server_port" {
  description = "whatever port the server uses"
  type = number
  default = 8080
}

data "aws_availability_zones" "all" {}

resource "aws_security_group" "web-server" {
  name = "web-server"

  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_launch_configuration" "launch_config_name" {
  image_id = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.web-server.id]
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg_webserver" {
  launch_configuration = aws_launch_configuration.launch_config_name.id
  availability_zones = data.aws_availability_zones.all.names
  min_size = 2
  max_size = 10

  load_balancers = [aws_elb.web-elb.name]
  health_check_type = "ELB"

  tag {
    key = "Name"
    value = "terraform-asg-example"
    propagate_at_launch = true
  }

}

resource "aws_elb" "web-elb" {
  name =  "terraform-elb-example"
  security_groups = [aws_security_group.elb.id]
  availability_zones = data.aws_availability_zones.all.names

  health_check {
    target = "HTTP:${var.server_port}/"
    interval = 30
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
    
  }

  # Adding listener for incoming HTTP requests
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = var.server_port
    instance_protocol = "http"
  }
}

resource "aws_security_group" "elb" {
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }  
}



output "elb_dns_name" {
  value = aws_elb.web-elb.dns_name
  description = "The DNS name the ELB ends up with"
}