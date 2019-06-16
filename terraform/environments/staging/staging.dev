// AWS credentials 

provider "aws" {
  region     = "${var.region}"
  profile    = "default"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

// SSH key pair export to AWS

resource "aws_key_pair" "auth" {
  key_name   = "${var.ssh_key_pair_name}"
  public_key = "${file(var.public_key_path)}"
}

// Virtual Private Cloud

module "vpc" {
  source                = "../../modules/vpc"
  owner                 = "${var.owner}"
  vpc_cidr              = "${var.vpc_cidr}"
  public_subnets        = "${var.public_subnets}"
  private_subnets       = "${var.private_subnets}"
  azs                   = "${var.azs}"
  enable_dns_hostnames  = "${var.enable_dns_hostnames}"
}

// Auto Scaling Groups

module "asg" {
  source                = "../../modules/asg"
  region                = "${var.region}"
  prsubnets             = "${module.vpc.private_subnet_ids}"
  pubsubnets            = "${module.vpc.public_subnet_ids}"
  max_size              = "${var.asg_max_size}"
  min_size              = "${var.asg_min_size}"
  desired_capacity      = "${var.asg_desired_capacity}"
  instance_type         = "${var.instance_type}"
  ami                   = "${module.ami.amazonlinux}"
  key_name              = "${var.ssh_key_pair_name}"
  secg-http             = "${module.secgroups.secg-http}"
  secg-vpc              = "${module.secgroups.secg-vpc}"
  asgprofile            = "${module.iam.instanceprofile}"
}

// Security Groups

module "secgroups" {
  source                = "../../modules/secgroups"
  vpc_id                = "${module.vpc.vpc_id}" 
  owner                 = "${var.owner}"
}

// Amazon Linux 

module "ami" {
  source                = "../../modules/ami"
  ami                   = "${module.ami.amazonlinux}"
}

// Bastion Instance for secure access 

module "bastion" {
  source                = "../../modules/bastion"
  owner                 = "${var.owner}"
  ami                   = "${module.ami.amazonlinux}"
  pubsubnets            = "${module.vpc.public_subnet_ids}"
  key_name              = "${var.ssh_key_pair_name}"
  instance_type         = "${var.instance_type}"
  azs                   = "${var.azs}"
  secg-http             = "${module.secgroups.secg-http}"
  secg-bastion          = "${module.secgroups.secg-bastion-machine}"
}

// IAM policies  

module "iam" {
  source                = "../../modules/iam"
  asgprofile            = "${module.iam.instanceprofile}"
}

