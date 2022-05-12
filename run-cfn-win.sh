#!/bin/bash

set -euo pipefail

# . run-cfn-win.sh YOUR_SECRET_KEY

# $1 <--- YOUR_SECRET_KEY
key_name=$1
key_path=${HOME}"/.ssh/${key_name}.pem"
stack_name="winZoom"

aws cloudformation create-stack \
  --template-body file://cfn-win-template.yml \
  --stack-name "${stack_name}" \
  --parameters \
    ParameterKey=KeyName,ParameterValue="${key_name}" \
    #ParameterKey=SourceCidrForRDP,ParameterValue="$(curl -s ifconfig.io)/32" \
    ParameterKey=SourceCidrForRDP,ParameterValue="$(curl inet-ip.info)/32" \
    #ParameterKey=SourceCidrForRDP,ParameterValue="0.0.0.0/32" \
    ParameterKey=TagName,ParameterValue="${stack_name}"

aws cloudformation wait stack-create-complete --stack-name "${stack_name}"

hostname=$(aws cloudformation describe-stacks \
  --stack-name "${stack_name}" \
  | jq -r '.Stacks[].Outputs[] | select(.OutputKey=="WindowsServerHostname") | .OutputValue')
instance_id=$(aws cloudformation list-stack-resources \
  --stack-name "${stack_name}" \
  | jq -r '.StackResourceSummaries[] | select(.LogicalResourceId=="WindowsServer") | .PhysicalResourceId')
password=$(aws ec2 get-password-data \
  --instance-id "${instance_id}" \
  --priv-launch-key "${key_path}" \
  | jq -r '.PasswordData')

echo "hostname: ${hostname}"
echo "password: ${password}"
