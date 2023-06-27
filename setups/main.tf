terraform {
    required_version = "~> 1.5.0"
  backend "s3" {
    bucket        = "terra-state-aug15"
    key           = "global/s3/terraform.tfstate"
    region        = "us-east-2"
    dynamodb_table= "terra-locks-aug15"
    encrypt       = true
  }
}

provider "aws" {
      #version     = "~> 2.13.0"
      region      = "us-east-2"
      access_key  = var.ACCESS_KEY
      secret_key  = var.SECRET_KEY
  }

module "backend" {
  source = "../modules/backend"
  bucket_name = var.bucket_name
  table_name  = var.table_name
}

module "vpc" {
  source = "../modules/vpc"
  vpc_cidr = var.vpc_cidr
  environment  = var.environment
}

locals {
  dev_availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]
}

# module "subnet" {
#   source   = "../modules/subnet"
#   vpc_id    = module.vpc.vpc_id
#   for_each = var.subnet_info
#   subnet_cidr = each.value["subnet_cidr"]
#   availability_zone = each.value["availability_zone"]
#   subnet_tags   = each.value["subnet_tags"]
#   depends_on = [
#     module.vpc
#   ]
# }

module "subnet" {
  source                = "../modules/subnet"
  vpc_id                = module.vpc.vpc_id
  public_subnets_cidr   = var.public_subnets_cidr
  private_subnets_cidr  = var.private_subnets_cidr
  nat_eip_id            = module.vpc.allocation_id
  igw_id                = module.vpc.igw_id
  availability_zones    = local.dev_availability_zones
  environment           = var.environment
}

module "build_server_instance" {
  source                = "../modules/build_server_instance"
  vpc_id                = module.vpc.vpc_id
  environment           = var.environment
  public_subnets_id     = module.subnet.public_subnets_id.0[0]
  build_instance_count  = var.build_instance_count
  #prefix                = var.prefix
}

module "target_instances" {
  source                = "../modules/target_instances"
  vpc_id                = module.vpc.vpc_id
  environment           = var.environment
  private_subnets_id     = module.subnet.private_subnets_id.0[0]
  target_instance_count  = var.target_instance_count
  #prefix                = var.prefix
  vpc_cidr              = var.vpc_cidr
}

resource "local_file" "inventory" {
  filename = "../ansible/hosts.ini"
  content = <<EOF
    [webserver]
    ${module.target_instances.target_ip}
    [others]
  EOF
}

# resource "local_file" "inventory" {
#   filename = "../ansible/hosts.ini"
#   content = <<EOF
#     [webserver]
#     ${module.target_instances.target_ip}
#     [others]
#     [all:vars]
#     ansible_ssh_private_key_file=/home/ec2-user/secret_pem_file
#   EOF
# }
