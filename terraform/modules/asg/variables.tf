variable "name" {
  description = "The Environment name of the VPC"
  default = "publicASG"
}

variable "region" {
  description = "The Environment name of the VPC"
  default = "Region to deploy the AWS cluster"
}

variable "pubsubnets" {
  description = "list of subnets to launch Bastions into. Should be public subnets"
}

variable "prsubnets" {
  description = "list of subnets to launch consul nodes into. Should be private subnets"
}

variable "max_size" {
  description = "The min number of instances to have in each ASG"
  default = "3"
}

variable "min_size" {
  description = "The min number of instances to have in the each ASG"
  default = "3"
}

variable "desired_capacity" {
  description = "The desired number of instances to have in the each ASG"
  default = "3"
}

variable "ami" {
  description = "ami to be used to launch nodes"
}

variable "instance_type" {
  description = "instance flavor type i.e. t2.micro"
}

variable "key_name" {
  description = "SSH key name to be assigned to the launched nodes"
}

variable "secg-http" {
  description = "web security group for consul nodes"
}
variable "secg-vpc" {
  description = "security group for th e nodes present in the vpc to communicate internally"
}
variable "asgprofile" {
  description = "proflr containing the role and policies for the launched nodes"
}

