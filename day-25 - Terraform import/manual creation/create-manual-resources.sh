#!/usr/bin/env bash
set -e

REGION="us-east-1"
BUCKET_NAME="day25-import-demo-katta698"
KEY_NAME="day25-import-key"
SG_NAME="day25-import-sg"
EC2_NAME="day25-import-ec2"
INSTANCE_TYPE="t2.micro"

echo "Getting default VPC..."
VPC_ID=$(aws ec2 describe-vpcs \
  --region "$REGION" \
  --filters "Name=is-default,Values=true" \
  --query "Vpcs[0].VpcId" \
  --output text)

echo "VPC_ID=$VPC_ID"

echo "Getting default subnet..."
SUBNET_ID=$(aws ec2 describe-subnets \
  --region "$REGION" \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  --query "Subnets[0].SubnetId" \
  --output text)

echo "SUBNET_ID=$SUBNET_ID"

echo "Getting latest Amazon Linux 2023 AMI..."
AMI_ID=$(aws ec2 describe-images \
  --region "$REGION" \
  --owners amazon \
  --filters "Name=name,Values=al2023-ami-2023*-x86_64" "Name=state,Values=available" \
  --query "sort_by(Images, &CreationDate)[-1].ImageId" \
  --output text)

echo "AMI_ID=$AMI_ID"

echo "Creating S3 bucket..."
aws s3api create-bucket \
  --bucket "$BUCKET_NAME" \
  --region "$REGION"

aws s3api put-bucket-tagging \
  --bucket "$BUCKET_NAME" \
  --tagging "TagSet=[{Key=Name,Value=$BUCKET_NAME},{Key=Project,Value=Day25TerraformImport},{Key=ManagedBy,Value=Manual},{Key=Environment,Value=dev}]"

echo "Creating security group..."
SG_ID=$(aws ec2 create-security-group \
  --region "$REGION" \
  --group-name "$SG_NAME" \
  --description "Created manually" \
  --vpc-id "$VPC_ID" \
  --query "GroupId" \
  --output text)

echo "SG_ID=$SG_ID"

aws ec2 create-tags \
  --region "$REGION" \
  --resources "$SG_ID" \
  --tags Key=Name,Value="$SG_NAME" Key=Project,Value=Day25TerraformImport Key=ManagedBy,Value=Manual Key=Environment,Value=dev

echo "Allowing HTTP inbound..."
aws ec2 authorize-security-group-ingress \
  --region "$REGION" \
  --group-id "$SG_ID" \
  --protocol tcp \
  --port 80 \
  --cidr 0.0.0.0/0

echo "Creating EC2 instance..."
INSTANCE_ID=$(aws ec2 run-instances \
  --region "$REGION" \
  --image-id "$AMI_ID" \
  --instance-type "$INSTANCE_TYPE" \
  --subnet-id "$SUBNET_ID" \
  --security-group-ids "$SG_ID" \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$EC2_NAME},{Key=Project,Value=Day25TerraformImport},{Key=ManagedBy,Value=Manual},{Key=Environment,Value=dev}]" \
  --query "Instances[0].InstanceId" \
  --output text)

echo "INSTANCE_ID=$INSTANCE_ID"

echo "Waiting for EC2 to run..."
aws ec2 wait instance-running \
  --region "$REGION" \
  --instance-ids "$INSTANCE_ID"

echo ""
echo "Resources created successfully:"
echo "Bucket Name: $BUCKET_NAME"
echo "VPC ID: $VPC_ID"
echo "Subnet ID: $SUBNET_ID"
echo "Security Group ID: $SG_ID"
echo "EC2 Instance ID: $INSTANCE_ID"
echo "AMI ID: $AMI_ID"
echo "Instance Type: $INSTANCE_TYPE"