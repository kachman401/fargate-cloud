variable "cidr_block" {}
variable "region" {}
variable "availability_zones" {
   type        = list(string)
}
variable "profile" {}

variable "all_cidr" {}
variable "tag" {}

variable "public_subnets" {
   type        = list(string)
}

variable "private_subnets" {
   type        = list(string)
}
variable "environment" {}
variable "name" {}
variable "container_port" {}