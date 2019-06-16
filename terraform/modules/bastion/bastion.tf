resource "aws_instance" "bastion" {
  count =                     "3"
  ami                         = "${var.ami}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  monitoring                  = true
  vpc_security_group_ids      = ["${var.secg-bastion}"]
  subnet_id                   =  "${element(split(",", var.pubsubnets), count.index)}"
  associate_public_ip_address = true

  tags = {
    Owner = "${var.owner}"
    Name = "Bastion-${element(var.azs, count.index)}"
  }
}

