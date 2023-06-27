resource "aws_security_group" "private" {
  name        = "${var.environment}-private-sg"
  description = "private Internet Access"
  vpc_id      = var.vpc_id

  tags = {
    Environment          = "${var.environment}"
    git_commit           = "f2bd4b6926060f359fed0eebe0e36371c430fa75"
    git_file             = "modules/target_instances/main.tf"
    git_last_modified_at = "2022-08-17 16:10:02"
    git_last_modified_by = "macmarkdhas.kumaradhas@innovasolutions.com"
    git_modifiers        = "macmarkdhas.kumaradhas"
    git_org              = "macmarcdhas"
    git_repo             = "equalexperts"
    yor_name             = "private"
    yor_trace            = "42906c67-cb5f-4e08-9b3a-3d1d1e650512"
  }
}

resource "aws_security_group_rule" "private_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.private.id
}

resource "aws_security_group_rule" "private_in_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = tolist(var.vpc_cidr[*])
  security_group_id = aws_security_group.private.id
}

resource "aws_security_group_rule" "private_in_grafana" {
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  cidr_blocks       = tolist(var.vpc_cidr[*])
  security_group_id = aws_security_group.private.id
}

resource "aws_instance" "target_instance" {
  ami                    = "ami-051dfed8f67f095f5"
  instance_type          = "t2.medium"
  count                  = var.target_instance_count
  vpc_security_group_ids = tolist(aws_security_group.private[*].id)
  #associate_public_ip_address = true
  user_data = "${file("target.sh")}"
  subnet_id = var.private_subnets_id
  tags = {
    Name                 = "${var.prefix}${count.index}"
    git_commit           = "0fec9a6eaea0ac35245aeb0327bb239c25bc100d"
    git_file             = "modules/target_instances/main.tf"
    git_last_modified_at = "2022-08-25 05:28:53"
    git_last_modified_by = "macmarkdhas.kumaradhas@innovasolutions.com"
    git_modifiers        = "macmarkdhas.kumaradhas"
    git_org              = "macmarcdhas"
    git_repo             = "equalexperts"
    yor_name             = "target_instance"
    yor_trace            = "5d47044a-0f99-43d2-afe9-9f4bd5aa561f"
  }
}