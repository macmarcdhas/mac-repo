output "vpc_id" {
  value = aws_vpc.customvpc.id
}

output "allocation_id" {
  value = aws_eip.nat_eip.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}