output "security_group_id" {
  description = "Master Security Group ID"
  value       = aws_security_group.cluster_sg.id
}

