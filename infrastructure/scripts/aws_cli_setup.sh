#!/bin/bash
# ------------------------------------------------------------------
# [Title] Manual AWS Infrastructure Setup (The Hard Way)
# [Description] This script effectively builds Phase 5 using AWS CLI.
#               It demonstrates WHY we use Terraform in Phase 6.
#               Do NOT run this in production. It has no state management.
# ------------------------------------------------------------------

AWS_REGION="us-east-1"
VPC_CIDR="10.0.0.0/16"

echo ">>> Creating VPC..."
VPC_ID=$(aws ec2 create-vpc --cidr-block $VPC_CIDR --query 'Vpc.VpcId' --output text)
aws ec2 create-tags --resources $VPC_ID --tags Key=Name,Value=devops-platform-vpc
echo "VPC Created: $VPC_ID"

echo ">>> Creating Internet Gateway..."
IGW_ID=$(aws ec2 create-internet-gateway --query 'InternetGateway.InternetGatewayId' --output text)
aws ec2 attach-internet-gateway --vpc-id $VPC_ID --internet-gateway-id $IGW_ID
echo "IGW Attached: $IGW_ID"

echo ">>> Creating Public Subnet (Zone A)..."
SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.1.0/24 --availability-zone ${AWS_REGION}a --query 'Subnet.SubnetId' --output text)
aws ec2 create-tags --resources $SUBNET_ID --tags Key=Name,Value=public-subnet-a

echo ">>> Creating Route Table..."
RT_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID --query 'RouteTable.RouteTableId' --output text)
aws ec2 create-route --route-table-id $RT_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW_ID
aws ec2 associate-route-table --subnet-id $SUBNET_ID --route-table-id $RT_ID

echo ">>> Creating Security Group for App..."
SG_ID=$(aws ec2 create-security-group --group-name "app-sg" --description "Allow Web" --vpc-id $VPC_ID --query 'GroupId' --output text)
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 22 --cidr 1.2.3.4/32 # Bastion IP

echo ">>> Launching EC2 Instance..."
# AMI ID for Amazon Linux 2023 in us-east-1 (Changes often, strict hardcoding is bad)
AMI_ID="ami-051f7e7f6c2f40dc1" 
aws ec2 run-instances \
    --image-id $AMI_ID \
    --count 1 \
    --instance-type t2.micro \
    --key-name my-key \
    --security-group-ids $SG_ID \
    --subnet-id $SUBNET_ID \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=web-server-manual}]'

echo "======================================================="
echo "DONE. Now imagine managing 100 servers like this."
echo "State is lost. If you run this again, it duplicates everything."
echo "This is why we use TERRAFORM in Phase 6."
echo "======================================================="
