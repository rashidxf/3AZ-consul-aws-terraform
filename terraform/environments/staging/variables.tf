variable "region" {
  description = "The region where our Multi AZ Consul cluster will be deployed"
  default     = ""
}

variable "sshkeyname" {
  description = "The public key to be used for SSH access."
  default     = ""
}

variable "public_key_path" {
  description = "The public key file to be used for SSH access."
  default     = ""
}

variable "access_key" {
  description = "aws_access_key"
  default     = ""
}

variable "secret_key" {
  description = "aws_secret_access_key"
  default     = ""
}

variable "owner" {
  description = "Identifying name of person who owns resource"
  default     = ""
}

variable "vpc_cidr" {
  description = "The CIDR range to use"
  default     = ""
}

variable "azs" {
  description = "The list of AZs to deploy into"
  default     = []
}

variable "public_subnets" {
  description = "The list of public subnets to create"
  default     = []
}

variable "private_subnets" {
  description = "The list of public subnets to create"
  default     = []
}

variable "enable_dns_hostnames" {
  description = "enable DNS hostnames in the VPC."
  default     = "true"
}

variable "instance_type" {
  description = "The EC2 Instance Type to use with the bastion host"
  default     = ""
}

variable "asg_min_size" {
  description = "Minimum number of instances to have for the ASG"
  default     = ""
}

variable "asg_max_size" {
  description = "Maximum number of instances to have for the ASG"
  default     = ""
}

variable "asg_desired_capacity" {
  description = "The desired number of instances to have for the ASG"
  default     = ""
}

variable "ssh_key_pair_name" {
  description = "Name of the EC2 Key pair to use."
  default     = ""
}
