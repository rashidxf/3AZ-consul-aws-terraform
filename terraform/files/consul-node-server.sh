#!/bin/bash

# Set log files.
set -x
exec > /var/log/user-data.log 2>&1

ASG_NAME_ONE="${asg_name_one}"
ASG_NAME_TWO="${asg_name_two}"
REGION="${region}"
SIZE="${size}" 

# Update the system.

until ping -c1 www.google.com &>/dev/null; do
    echo "Waiting for network ..."
    sleep 1
done

sudo yum update -y

# Install Docker, add ec2-user, start Docker and ensure startup on restart
yum install -y docker
usermod -a -G docker ec2-user
service docker start	
chkconfig docker on

# Return the id of each instance in the Public ASG cluster.
function cluster-instance-ids {
    # Grab every line which contains 'InstanceId', cut on double quotes and grab the ID:

    aws --region="$REGION" autoscaling describe-auto-scaling-groups --auto-scaling-group-name $ASG_NAME_ONE \
        | grep InstanceId \
        | cut -d '"' -f4
    aws --region="$REGION" autoscaling describe-auto-scaling-groups --auto-scaling-group-name $ASG_NAME_TWO \
        | grep InstanceId \
        | cut -d '"' -f4

}

# Return the private DNS Hostname of each instance in the cluster.
function cluster-hostnames {
    for id in $(cluster-instance-ids)
    do
        aws --region="$REGION" ec2 describe-instances \
            --query="Reservations[].Instances[].[PrivateDnsName]" \
            --output="text" \
            --instance-ids="$id"
    done
}

# Wait until we have as many cluster instances as we are expecting.
while COUNT=$(cluster-instance-ids | wc -l) && [ "$COUNT" -lt "$SIZE" ]
do
    echo "$COUNT instances in the cluster, waiting for $SIZE instances to warm up..."
    sleep 1
done

# Get my IP, list of all Hostnames in the ASG, and list of all hostnames in ASG except my DNS hostname

HOSTNAME=$(hostname)
IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
mapfile -t ALL_HOSTNAMES < <(cluster-hostnames)
OTHER_HOSTNAMES=($${ALL_HOSTNAMES[@]/$${HOSTNAME}/})
echo "Instance IP is: $$IP, Cluster IPs are: $${ALL_HOSTNAMES[@]}, Other Hostnames are: $${OTHER_HOSTNAMES[@]}"

# Start the Consul server node.
docker run -d --net=host \
    --name=consul \
    consul agent -server -ui \
    -bind="$IP" \
    -client="0.0.0.0" \
    -retry-join="$${OTHER_HOSTNAMES[0]}" -retry-join="$${OTHER_HOSTNAMES[1]}" \
    -retry-join="$${OTHER_HOSTNAMES[2]}" -retry-join="$${OTHER_HOSTNAMES[3]}" -retry-join="$${OTHER_HOSTNAMES[4]}" \
    -bootstrap-expect="$SIZE"
