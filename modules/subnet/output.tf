# output "subnet_id" {
#   value = aws_subnet.customsubnet
# }

output "public_subnets_id" {
  value = ["${aws_subnet.public_subnet.*.id}"]
}

output "private_subnets_id" {
  value = ["${aws_subnet.private_subnet.*.id}"]
}

# output "public_subnet_id" {
#   value = element(aws_subnet.customsubnet.*.public_subnet.subnet_id, 0)
# } 

# output "private_subnet_id" {
#   value = element(aws_subnet.customsubnet.*.private_subnet.subnet_id, 0)
# }