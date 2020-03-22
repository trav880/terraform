provider "aws" {
  region = "us-east-2"
}

variable "server_port" {
  description = "whatever port the server uses"
  type = number
  default = 8080
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "ubuntu-server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF

  

  tags = {
    Name = "terraform-example"
  }
}

output "public_ip" {
  value = aws_instance.ubuntu-server.public_ip
  description = "The public IP the server ends up with"
}