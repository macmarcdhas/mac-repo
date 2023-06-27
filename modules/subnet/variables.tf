variable "public_subnets_cidr" {
  type        = list(any)
  description = "CIDR block for Public Subnet"
}

variable "private_subnets_cidr" {
  type        = list(any)
  description = "CIDR block for Private Subnet"
}

variable "availability_zones" {
  type        = list(any)
  description = "AZ in which all the resources will be deployed"
}

variable "environment" {
    type = string
}

variable "igw_id" {
    type  = string
}

variable "nat_eip_id" {
    type = string
}

variable "vpc_id" {
    type = string
}

# variable "subnet_tags" {
#     type = map
# }

# variable "subnet_cidr" {
#     type = string
# }

# variable "availability_zone" {
#     type = string
# }