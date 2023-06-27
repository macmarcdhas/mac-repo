variable "region" {
    type = string
}

variable "ACCESS_KEY" {
    type = string
}

variable "SECRET_KEY" {
    type = string
}


variable "bucket_name" {
    type = string
}

variable "table_name" {
    type = string
}

variable "vpc_cidr" {
    type = string
}

variable "environment" {
    type = string
}

# variable "subnet_info"{
#     type = map(any)
#     default = {
#         "public_subnet" = {
#             subnet_cidr     = "172.20.10.0/24"
#             subnet_tags = {
#                 "Name" = "public_subnet" 
#             }
#             availability_zone = "us-east-2a"
#         },
#         "private_subnet" = {
#             subnet_cidr     = "172.20.20.0/24"
#             subnet_tags = {
#                 "Name" = "private_subnet" 
#             }
#             availability_zone = "us-east-2a"
#         },
#         "private_subnet_1" = {
#             subnet_cidr     = "172.20.30.0/24"
#             subnet_tags = {
#                 "Name" = "private_subnet_1" 
#             }
#             availability_zone = "us-east-2a"
#         }
#         }
# }

variable "public_subnets_cidr" {
  type        = list(any)
  description = "CIDR block for Public Subnet"
  default     = ["172.20.10.0/24"]
}

variable "private_subnets_cidr" {
  type        = list(any)
  description = "CIDR block for Private Subnet"
  default     = ["172.20.20.0/24"]
}

variable "build_instance_count" {
  type = number
}

variable "target_instance_count" {
  type = number
}

# variable "prefix" {
#     type = string
# }
