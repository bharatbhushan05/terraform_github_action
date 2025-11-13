resource "aws_security_group" "cluster_sg" {
  name        = "cluster-sg"
  description = "Security group for Kubernetes cluster"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "cluster-sg"
    Environment = var.environment
  }
}

locals {
  # Common ports for both master and worker nodes
  common_ports = [80, 443, 22, 8080, 6443]
  
  # Master-specific ports
  master_node_ports = [10250, 10259, 10257]
  
  # Worker-specific ports  
  worker_node_ports = [30000, 30001, 30002]  # Example worker-specific ports
  
  # Port ranges
  master_port_ranges = [
    {
      from_port = 2379
      to_port   = 2380
    }
  ]
  worker_port_ranges = [
    {
      from_port = 30000
      to_port   = 32767
    }
  ]
}

# Common ports for both master and worker nodes
resource "aws_vpc_security_group_ingress_rule" "common_ports" {
  for_each = toset([for port in local.common_ports : tostring(port)])

  security_group_id = aws_security_group.cluster_sg.id
  cidr_ipv4         = var.vpc_cidr_block
  from_port         = each.value
  ip_protocol       = "tcp"
  to_port           = each.value
}

# Master-specific ports
resource "aws_vpc_security_group_ingress_rule" "master_ports" {
  for_each = toset([for port in local.master_node_ports : tostring(port)])

  security_group_id = aws_security_group.cluster_sg.id
  cidr_ipv4         = var.vpc_cidr_block
  from_port         = each.value
  ip_protocol       = "tcp"
  to_port           = each.value
}

# Worker-specific ports
resource "aws_vpc_security_group_ingress_rule" "worker_ports" {
  for_each = toset([for port in local.worker_node_ports : tostring(port)])

  security_group_id = aws_security_group.cluster_sg.id
  cidr_ipv4         = var.vpc_cidr_block
  from_port         = each.value
  ip_protocol       = "tcp"
  to_port           = each.value
}

# Port range rules for master nodes
resource "aws_vpc_security_group_ingress_rule" "master_port_ranges" {
  for_each = { for idx, range in local.master_port_ranges : tostring(idx) => range }

  security_group_id = aws_security_group.cluster_sg.id
  cidr_ipv4         = var.vpc_cidr_block
  from_port         = each.value.from_port
  ip_protocol       = "tcp"
  to_port           = each.value.to_port
}

# Port range rules for worker nodes
resource "aws_vpc_security_group_ingress_rule" "worker_port_ranges" {
  for_each = { for idx, range in local.worker_port_ranges : tostring(idx) => range }

  security_group_id = aws_security_group.cluster_sg.id
  cidr_ipv4         = var.vpc_cidr_block
  from_port         = each.value.from_port
  ip_protocol       = "tcp"
  to_port           = each.value.to_port
}

# Outbound
resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.cluster_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}