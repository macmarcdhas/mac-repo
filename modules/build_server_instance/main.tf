resource "aws_security_group" "public" {
  name        = "${var.environment}-public-sg"
  description = "Public Internet Access"
  vpc_id      = var.vpc_id

  tags = {
    Environment          = "${var.environment}"
    git_commit           = "f2bd4b6926060f359fed0eebe0e36371c430fa75"
    git_file             = "modules/build_server_instance/main.tf"
    git_last_modified_at = "2022-08-17 16:10:02"
    git_last_modified_by = "macmarkdhas.kumaradhas@innovasolutions.com"
    git_modifiers        = "macmarkdhas.kumaradhas"
    git_org              = "macmarcdhas"
    git_repo             = "equalexperts"
    yor_name             = "public"
    yor_trace            = "52052ba0-d2ae-48c8-aa25-8ce2cef292c1"
  }
}

resource "aws_security_group_rule" "public_out" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.public.id
}


resource "aws_security_group_rule" "public_in_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public.id
}

resource "aws_security_group_rule" "public_in_jenkins" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.public.id
}

resource "aws_instance" "build_instance" {
  ami                         = "ami-051dfed8f67f095f5"
  instance_type               = "t2.medium"
  count                       = var.build_instance_count
  vpc_security_group_ids      = tolist(aws_security_group.public[*].id)
  user_data                   = "${file("init.sh")}"
  associate_public_ip_address = true
  subnet_id                   = var.public_subnets_id
  tags = {
    Name                 = "${var.prefix}${count.index}"
    git_commit           = "f2bd4b6926060f359fed0eebe0e36371c430fa75"
    git_file             = "modules/build_server_instance/main.tf"
    git_last_modified_at = "2022-08-17 16:10:02"
    git_last_modified_by = "macmarkdhas.kumaradhas@innovasolutions.com"
    git_modifiers        = "macmarkdhas.kumaradhas"
    git_org              = "macmarcdhas"
    git_repo             = "equalexperts"
    yor_name             = "build_instance"
    yor_trace            = "50bbe6e5-a148-4bed-83bb-dcbae04bef1e"
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = "${file("secret_pem_file")}"
  }

  provisioner "file" {
    source      = "secret_pem_file"
    destination = "/home/ec2-user/secret_pem_file"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo rm -f /etc/ansible/ansible.cfg",
      "echo $'[defaults]\nhost_key_checking = False' |sudo tee /etc/ansible/ansible.cfg",
      "chmod 400 /home/ec2-user/secret_pem_file"
    ]
  }
}