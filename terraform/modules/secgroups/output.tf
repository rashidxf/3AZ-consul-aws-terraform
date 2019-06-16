output "secg-vpc" {
  value = "${aws_security_group.consul-cluster-vpc.id}"
}

output "secg-http" {
  value = "${aws_security_group.consul-cluster-public-web.id}"
}

output "secg-bastion-machine" {
  value = "${aws_security_group.bastion.id}"
}

