resource "aws_vpc" "customvpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name                 = "custom"
    git_commit           = "f2bd4b6926060f359fed0eebe0e36371c430fa75"
    git_file             = "modules/vpc/main.tf"
    git_last_modified_at = "2022-08-17 16:10:02"
    git_last_modified_by = "macmarkdhas.kumaradhas@innovasolutions.com"
    git_modifiers        = "macmarkdhas.kumaradhas"
    git_org              = "macmarcdhas"
    git_repo             = "equalexperts"
    yor_name             = "customvpc"
    yor_trace            = "d1ddce9b-c26f-4a3e-ad4b-f81b532d43b1"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.customvpc.id
  tags = {
    Name                 = "${var.environment}-igw"
    Environment          = var.environment
    git_commit           = "f2bd4b6926060f359fed0eebe0e36371c430fa75"
    git_file             = "modules/vpc/main.tf"
    git_last_modified_at = "2022-08-17 16:10:02"
    git_last_modified_by = "macmarkdhas.kumaradhas@innovasolutions.com"
    git_modifiers        = "macmarkdhas.kumaradhas"
    git_org              = "macmarcdhas"
    git_repo             = "equalexperts"
    yor_name             = "igw"
    yor_trace            = "316d54d4-b564-4322-b585-cac8d2ecd300"
  }
}

# Elastic-IP (eip) for NAT
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
  tags = {
    git_commit           = "f2bd4b6926060f359fed0eebe0e36371c430fa75"
    git_file             = "modules/vpc/main.tf"
    git_last_modified_at = "2022-08-17 16:10:02"
    git_last_modified_by = "macmarkdhas.kumaradhas@innovasolutions.com"
    git_modifiers        = "macmarkdhas.kumaradhas"
    git_org              = "macmarcdhas"
    git_repo             = "equalexperts"
    yor_name             = "nat_eip"
    yor_trace            = "3ee21b0f-0d7d-4833-8e37-42bc8e3a2151"
  }
}