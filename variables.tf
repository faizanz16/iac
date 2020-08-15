variable "cidr_block" {
  type        = "string"
  description = "VPC cidr block"
}

variable "environment" {
  type    = "string"
  default = "test"
}

variable "region" {
  type = "string"
}

variable "availability_zones" {
  type = "list"
}

variable "db_name" {
  type = "string"
}

variable "username" {
  type = "string"
}

variable "instance_class" {
  type = "string"
}