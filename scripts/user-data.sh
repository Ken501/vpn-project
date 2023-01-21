#!/bin/bash

# Update package manager
echo "Updating yum package..."
sudo yum update -y
echo "Updated yum package..."

# Uninstall AWS CLI V1
echo "Uninstalling AWS CLI V1..."
sudo yum remove awscli -y
echo "Uninstalled AWS CLI V1..."

#Install AWS CLI V2
echo "Installing AWS CLI V2..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install --bin-dir /usr/bin --install-dir /usr/aws-cli --update
aws --version
echo "Finished installing AWS CLI V2..."

# Install ssm
echo "Enable and start ssm service agent..."
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent
systemctl status amazon-ssm-agent
echo "Enabled and started ssm service agent..."

# Install Cloudwatch agent
echo "Installing CloudWatch agent..."
sudo yum install amazon-cloudwatch-agent
echo "Finished installing CloudWatch agent..."