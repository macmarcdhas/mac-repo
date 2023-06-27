# resource "aws_subnet" "customsubnet" {
#   vpc_id = var.vpc_id
#   cidr_block = var.subnet_cidr
#   tags = var.subnet_tags
#   availability_zone = var.availability_zone
#   map_public_ip_on_launch = false
# }

# data "aws_subnets" "public" {
#   filter {
#     name   = "vpc-id"
#     values = [var.vpc_id]
#   }

#   tags = {
#     Name = "public_subnet"
#   }
# }

# data "aws_subnets" "private" {
#   filter {
#     name   = "vpc-id"
#     values = [var.vpc_id]
#   }

#   tags = {
#     Name = "private_subnet*"
#   }
# }

# Public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = var.vpc_id
  count                   = length(var.public_subnets_cidr)
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name                 = "${var.environment}-${element(var.availability_zones, count.index)}-public-subnet"
    Environment          = "${var.environment}"
    git_commit           = "f2bd4b6926060f359fed0eebe0e36371c430fa75"
    git_file             = "modules/subnet/main.tf"
    git_last_modified_at = "2022-08-17 16:10:02"
    git_last_modified_by = "macmarkdhas.kumaradhas@innovasolutions.com"
    git_modifiers        = "macmarkdhas.kumaradhas"
    git_org              = "macmarcdhas"
    git_repo             = "equalexperts"
    yor_name             = "public_subnet"
    yor_trace            = "94724c53-8034-4f34-a869-ab7ca83fcb3d"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = var.vpc_id
  count                   = length(var.private_subnets_cidr)
  cidr_block              = element(var.private_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name                 = "${var.environment}-${element(var.availability_zones, count.index)}-private-subnet"
    Environment          = "${var.environment}"
    git_commit           = "f2bd4b6926060f359fed0eebe0e36371c430fa75"
    git_file             = "modules/subnet/main.tf"
    git_last_modified_at = "2022-08-17 16:10:02"
    git_last_modified_by = "macmarkdhas.kumaradhas@innovasolutions.com"
    git_modifiers        = "macmarkdhas.kumaradhas"
    git_org              = "macmarcdhas"
    git_repo             = "equalexperts"
    yor_name             = "private_subnet"
    yor_trace            = "fb0b06ba-f5cd-4584-b514-5ddabf8c97a3"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = var.nat_eip_id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)

  tags = {
    Name                 = "nat"
    Environment          = "${var.environment}"
    git_commit           = "f2bd4b6926060f359fed0eebe0e36371c430fa75"
    git_file             = "modules/subnet/main.tf"
    git_last_modified_at = "2022-08-17 16:10:02"
    git_last_modified_by = "macmarkdhas.kumaradhas@innovasolutions.com"
    git_modifiers        = "macmarkdhas.kumaradhas"
    git_org              = "macmarcdhas"
    git_repo             = "equalexperts"
    yor_name             = "nat"
    yor_trace            = "9938e154-11ad-4af6-9eef-5766593ae749"
  }
}

# Routing tables to route traffic for Private Subnet
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  tags = {
    Name                 = "${var.environment}-private-route-table"
    Environment          = "${var.environment}"
    git_commit           = "f2bd4b6926060f359fed0eebe0e36371c430fa75"
    git_file             = "modules/subnet/main.tf"
    git_last_modified_at = "2022-08-17 16:10:02"
    git_last_modified_by = "macmarkdhas.kumaradhas@innovasolutions.com"
    git_modifiers        = "macmarkdhas.kumaradhas"
    git_org              = "macmarcdhas"
    git_repo             = "equalexperts"
    yor_name             = "private"
    yor_trace            = "3f08d231-b4c4-423c-91e7-f1776580af78"
  }
}

# Routing tables to route traffic for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = {
    Name                 = "${var.environment}-public-route-table"
    Environment          = "${var.environment}"
    git_commit           = "f2bd4b6926060f359fed0eebe0e36371c430fa75"
    git_file             = "modules/subnet/main.tf"
    git_last_modified_at = "2022-08-17 16:10:02"
    git_last_modified_by = "macmarkdhas.kumaradhas@innovasolutions.com"
    git_modifiers        = "macmarkdhas.kumaradhas"
    git_org              = "macmarcdhas"
    git_repo             = "equalexperts"
    yor_name             = "public"
    yor_trace            = "096996c9-9944-486e-9fd8-a20cf3895a9f"
  }
}

# Route for Internet Gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.igw_id
}

# Route for NAT
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# Route table associations for both Public & Private Subnets
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "default" {
  name        = "${var.environment}-default-sg"
  description = "Default SG to alllow traffic from the VPC"
  vpc_id      = var.vpc_id
  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  tags = {
    Environment          = "${var.environment}"
    git_commit           = "f2bd4b6926060f359fed0eebe0e36371c430fa75"
    git_file             = "modules/subnet/main.tf"
    git_last_modified_at = "2022-08-17 16:10:02"
    git_last_modified_by = "macmarkdhas.kumaradhas@innovasolutions.com"
    git_modifiers        = "macmarkdhas.kumaradhas"
    git_org              = "macmarcdhas"
    git_repo             = "equalexperts"
    yor_name             = "default"
    yor_trace            = "82e4c0f4-65b4-4a15-afb8-14a3a09cb1d6"
  }
}
