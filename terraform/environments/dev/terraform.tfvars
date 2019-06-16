# Provide here the aws access key of your acoount on Amazon AWS
access_key = ""

# Provide here the aws secret key of your acoount on Amazon AWS
secret_key = ""

# Provide here the ssh key (public) name here which will be created in AWS
ssh_key_pair_name = ""

# Provide here the ssh key (public) file path. Use ssh-keygen to generate the ssh key pair
public_key_path = ""

# Provide here the Region to be used for your whole multi AZ cluster
region = "us-east-1"

# Provide here the owner name tag for the AWS resources which will be created 
owner = "rashid"

# Provide here the CIDR to be used in the VPC
vpc_cidr = "10.0.0.0/16"

# Provide here three Avalilability Zones inside the Region
azs = ["us-east-1a","us-east-1b","us-east-1c"]

# Provide here three public subnets to be used in three Avalilability Zones
public_subnets = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]

# Provide here three private subnets to be used in three Avalilability Zones
private_subnets = ["10.0.4.0/24","10.0.5.0/24","10.0.6.0/24"]

# Provide here the flavor to be used fot the EC2 instances
instance_type = "t2.micro"

# Provide here the min expected nodes in one ASG
asg_min_size = 3

# Provide here the max expected nodes in one ASG
asg_max_size = 3

# Provide here the desired expected nodes in one ASG
asg_desired_capacity = 3
