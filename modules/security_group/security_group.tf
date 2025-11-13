resource "aws_security_group" "cluster_sg" {
  name        = "cluster-sg"
  description = "Security group for web application"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "cluster-sg"
    Environment = var.environment
  }
}

locals {
  # Fixed syntax - removed trailing commas and proper list formatting
  master_node_ports = [80, 443, 22, 8080, 6443, 10250, 10259, 10257]
  worker_node_ports = [80, 443, 22, 8080, 6443, 10250, 10259, 10257]
  
  # For port ranges, we need to handle them separately
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

# Single port rules for master nodes
resource "aws_vpc_security_group_ingress_rule" "master_ports" {
  for_each = toset(local.master_node_ports)

  security_group_id = aws_security_group.cluster_sg.id  # Fixed: was web_app
  cidr_ipv4         = aws_vpc.cluster.cidr_block
  from_port         = each.value
  ip_protocol       = "tcp"
  to_port           = each.value
}

# Single port rules for worker nodes  
resource "aws_vpc_security_group_ingress_rule" "worker_ports" {
  for_each = toset(local.worker_node_ports)

  security_group_id = aws_security_group.cluster_sg.id  # Fixed: was web_app
  cidr_ipv4         = aws_vpc.cluster.cidr_block
  from_port         = each.value
  ip_protocol       = "tcp"
  to_port           = each.value
}

# Port range rules for master nodes
resource "aws_vpc_security_group_ingress_rule" "master_port_ranges" {
  for_each = { for idx, range in local.master_port_ranges : idx => range }

  security_group_id = aws_security_group.cluster_sg.id
  cidr_ipv4         = aws_vpc.cluster.cidr_block
  from_port         = each.value.from_port
  ip_protocol       = "tcp"
  to_port           = each.value.to_port
}

# Port range rules for worker nodes
resource "aws_vpc_security_group_ingress_rule" "worker_port_ranges" {
  for_each = { for idx, range in local.worker_port_ranges : idx => range }

  security_group_id = aws_security_group.cluster_sg.id
  cidr_ipv4         = aws_vpc.cluster.cidr_block
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