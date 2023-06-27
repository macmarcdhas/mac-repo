variable "vpc_id" {
    type = string
}

variable "environment" {
    type = string
}

variable "public_subnets_id" {
  type = string
}

# variable "private_subnets_id" {
#   type = string
# }

variable "prefix" {
  description = "servername prefix"
  default = "build-server"
}

variable "build_instance_count" {
  type = number
}