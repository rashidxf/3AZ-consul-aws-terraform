output "amazonlinux" {
    value = "${data.aws_ami.amazonlinux.image_id}"
}
