output "security_group_id" {
  description = "The ID of the security group created by Terraform"
  value       = aws_security_group.web_sg.id
}