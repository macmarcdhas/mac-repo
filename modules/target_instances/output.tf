output target_ip {
  value = aws_instance.target_instance[0].private_ip
}