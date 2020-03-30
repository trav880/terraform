output "elb_dns_name" {
  value       = module.webserver_cluster.elb_dns_name
  description = "The domain name of the load balancer"
}