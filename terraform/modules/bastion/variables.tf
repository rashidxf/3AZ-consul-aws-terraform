variable "instance_type" {
  description = "The EC2 Instance Type to use for the bastion host"
}

variable "owner" {
  description = "The owner of the resources created"
}

variable "key_name" {
  description = "The EC2 Key Pair name to use with the Bastion host"
}

variable "secg-http" {
  description = "The EC2 Key Pair name to use with the Bastion host"
}

variable "secg-bastion" {
  description = "The EC2 Key Pair name to use with the Bastion host"
}

variable "ami" {
  description = "ami to be used to launch the nodes"
}

variable "pubsubnets" {
  description = "list of subnets to launch instances into. Should be public subnets"
}

variable "azs" {
  description = "list of AZs"
}


