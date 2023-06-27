variable "vpc_id" {
    type = string
}

variable "vpc_cidr" {
    type = string
}

variable "environment" {
    type = string
}

# variable "public_subnets_id" {
#   type = string
# }

variable "private_subnets_id" {
  type = string
}

variable "prefix" {
  description = "servername prefix"
  default = "target-server"
}

variable "target_instance_count" {
  type = number
}