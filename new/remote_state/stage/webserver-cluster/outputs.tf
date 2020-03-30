output "elb_dns_name" {
  value = aws_elb.web-elb.dns_name
  description = "The DNS name the ELB ends up with"
}