// SET UP LAUNCH CONFIG FOR TWO ASGs 

resource "aws_launch_configuration" "asg_one" {                //launch config for ASG ONE
  name_prefix          = "asg-one-"
  image_id             = "${var.ami}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.key_name}"
  security_groups      = [ "${var.secg-vpc}", "${var.secg-http}"]
  iam_instance_profile = "${var.asgprofile}"
  user_data            = "${data.template_file.consul-cluster-servers.rendered}"
}

resource "aws_launch_configuration" "asg_two" {                //launch config for ASG TWO
  name_prefix          = "asg-two-"
  image_id             = "${var.ami}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.key_name}"
  security_groups      = [ "${var.secg-vpc}", "${var.secg-http}"]
  iam_instance_profile = "${var.asgprofile}"
  user_data            = "${data.template_file.consul-cluster-clients.rendered}"
}


data "template_file" "consul-cluster-servers" {                //templates files to be used in launch config 
  template = "${file("${local.filepath}/consul-node-server.sh")}"
  vars = {
    asg_name_one = "ASG-ONE"
    asg_name_two = "ASG-TWO"
    region  = "${var.region}"
    size    = "3"
  }
 
}

data "template_file" "consul-cluster-clients" {                //templates files to be used in launch config
  template = "${file("${local.filepath}/consul-node-client.sh")}"
  vars = {
    asg_name_one = "ASG-ONE"
    asg_name_two = "ASG-TWO" 
    region  = "${var.region}"
    size    = "3"  //Total number of consul server nodes in ASG-ONE
  }
}

locals {
  prsubids    = split(",","${var.prsubnets}")
  filepath = "../../files"
}

// SET UP TWO AUTO SCALING GROUPS 

resource "aws_autoscaling_group" "asg_one" {
  name              = "ASG-ONE"
  max_size          = "${var.max_size}"
  min_size          = "${var.min_size}"
  desired_capacity  = "${var.desired_capacity}"
  launch_configuration = "${aws_launch_configuration.asg_one.name}"

  vpc_zone_identifier  = ["${local.prsubids[0]}","${local.prsubids[1]}","${local.prsubids[2]}"]

 tag {
    key                 = "Name"
    value               = "Consul-server-ASG-one"
    propagate_at_launch = true
 }
}

resource "aws_autoscaling_group" "asg_two" {
  name              = "ASG-TWO"
  max_size          = "${var.max_size}"
  min_size          = "${var.min_size}"
  desired_capacity  = "${var.desired_capacity}"

  launch_configuration = "${aws_launch_configuration.asg_two.name}"

  vpc_zone_identifier  = ["${local.prsubids[0]}","${local.prsubids[1]}","${local.prsubids[2]}"]

  tag {
      key                 = "Name"
      value               = "Consul-client-ASG-two"
      propagate_at_launch = true
   }
}

