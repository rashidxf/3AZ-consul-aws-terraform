resource "aws_iam_policy" "leader-discovery" {
  name        = "consul-node-leader-discovery"
  path        = "/"
  description = "This policy allows an instance to discover a consul cluster leader by examinig the instances. See bash files."

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1468377974000",
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeAutoScalingGroups",
                "ec2:DescribeInstances"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
    EOF
}

resource "aws_iam_role" "consul-instance-role" {
  name = "consul-instance-role"
  description = "A role which consul instances will assume"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "consul-instance-leader-discovery" {
  name       = "consul-instance-leader-discovery"
  roles      = ["${aws_iam_role.consul-instance-role.name}"]
  policy_arn = "${aws_iam_policy.leader-discovery.arn}"
}

//  Create a instance profile for the role. This profile can be used by instances created in an ASG 
resource "aws_iam_instance_profile" "consul-instance-profile" {
  name  = "consul-instance-profile"
  role = "${aws_iam_role.consul-instance-role.name}"
}
