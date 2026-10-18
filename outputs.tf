
# Display the public IP address after deployment.
output "instance_public_ip" {
  description = "Public IPv4 address of the Nginx EC2 instance"
  value       = aws_instance.nginx_server.public_ip
}

# Display the public URL of the Nginx server.
output "nginx_url" {
  description = "URL to access the custom Nginx webpage"
  value       = "http://${aws_instance.nginx_server.public_ip}"
}


