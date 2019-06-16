## 3AZ-consul-aws-terraform
Terraform templates to deploy Consul cluster spannig three Availability Zones on AWS Cloud

### Architecture
![3AZ-consul-aws-terraform ](/images/3AZ-consul-cluster.jpg)

### Project Structure
```
terraform/environments/dev/dev.tf           # Cluster development environment main file.
terraform/environments/dev/variables.tf     # Inputs for Cluster development environment main file.
terraform/environments/dev/terraform.tfvars # Inputs for Cluster development environment variables.tf file.

environments/staging/staging.tf             # Cluster staging environment main file.
environments/staging/variables.tf           # Inputs for Cluster staging environment main file.
environments/staging/terraform.tfvars       # Inputs for Cluster staging environment variables.tf file.

terraform/modules/vpc                       # Creates the VPC
terraform/modules/asg                       # Creates the Auto Scaling Groups
terraform/modules/secgroups                 # Creates the security groups
terraform/modules/ami                       # Defines the AMI
terraform/modules/iam                       # Creates required iam policies, roles, profiles
terraform/modules/bastion                   # Creates Bastion nodes for secure access

terraform/files/                            # BASH script required for boostraping consul cluster using Docker
images/                                     # Images for the README.md
```

### Prerequisites
```
Install Terraform
You must have an AWS account. 
You will need your AWS credentials.
This deployment includes NAT gateways, which are not included in AWS free tier.
```

### Creating the Cluster
```
Generate a SSH Key Pair 
Change the directory to terraform/environments/dev
Input the required values in terraform.tfvars file
```

```bash
# Initialize terraform for first time
terraform init

# See the resources plan
terraform plan

# Create the cluster
terraform apply
```

### Accessing the Consul CLI

```bash
# SSH into one of the Bastion node

ssh -i <path-to-private-key> ec2-user@<bastion-vm-ip>

# SSH into one of the consul server node from the Bastion node

ssh -i <path-to-private-key> ec2-user@<consul-server-ip>

# Connect to consul docker container 

docker exec -it consul \sh

# Execute the consul commands inside consul container

consul members
```
### Accessing the Consul GUI 
```
#Check the IP address of one of the Bastion node from AWS dashboard
#Check the IP address of one of the consul server node from AWS dashboard 
#Create a SSH Tunnel 
```

```bash
# Create the SSH tunnel

ssh -L 8500:<consul-server-internal-ip>:8500 -i <path-to-private-key> ec2-user@<bastion-vm-ip>

# Point the browser to 

localhost:8500

```
### Destroying the Cluster

```bash
terraform destroy
```

