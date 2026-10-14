output "server_public_ips" {
  description = "Public IPs of all web servers"
  value       = [for instance in aws_instance.this : "http://${instance.public_ip}"]
}