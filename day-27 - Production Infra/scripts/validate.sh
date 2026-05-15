#!/usr/bin/env bash
set -euo pipefail

ALB_DNS=$(terraform output -raw load_balancer_dns)
TG_ARN=$(terraform output -raw target_group_arn)
ASG_NAME=$(terraform output -raw asg_name)
VPC_ID=$(terraform output -raw vpc_id)
S3_BUCKET=$(terraform output -raw s3_bucket_name)

echo "Application URL: http://$ALB_DNS"
curl -I "http://$ALB_DNS"

echo "Target health:"
aws elbv2 describe-target-health \
  --target-group-arn "$TG_ARN" \
  --query "TargetHealthDescriptions[*].[Target.Id,TargetHealth.State,TargetHealth.Description]" \
  --output table

echo "Auto Scaling Group:"
aws autoscaling describe-auto-scaling-groups \
  --auto-scaling-group-names "$ASG_NAME" \
  --query "AutoScalingGroups[*].[AutoScalingGroupName,DesiredCapacity,MinSize,MaxSize,length(Instances)]" \
  --output table

echo "Subnets:"
aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  --query "Subnets[*].[SubnetId,CidrBlock,AvailabilityZone,MapPublicIpOnLaunch,Tags[?Key=='Tier'].Value|[0]]" \
  --output table

echo "S3 bucket:"
aws s3 ls "s3://$S3_BUCKET/" || true
