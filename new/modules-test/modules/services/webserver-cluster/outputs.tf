output "elb_dns_name" {
  value = aws_elb.web-elb.dns_name
  description = "The DNS name the ELB ends up with"
}

output "asg_name" {
  value       = aws_autoscaling_group.asg_webserver.name
  description = "The name of the Auto Scaling Group"
}