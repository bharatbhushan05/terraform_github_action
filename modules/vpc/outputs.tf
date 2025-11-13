output "vpc_id" {
  value = aws_vpc.cluster.id  # This becomes the output value
}

output "vpc_cidr_block" {
  value = aws_vpc.cluster.cidr_block  # This becomes the output value
}