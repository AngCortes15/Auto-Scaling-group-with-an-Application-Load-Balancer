# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Terraform configuration for an AWS lab that creates a highly available and scalable Café web application environment across two Availability Zones. This builds on top of existing AWS lab infrastructure.

## Architecture

- **VPC**: 10.0.0.0/16 (pre-existing)
- **Public Subnets**: 10.0.0.0/24 (AZ-A), 10.0.1.0/24 (AZ-B) - for NAT Gateways and ALB
- **Private Subnets**: 10.0.2.0/24 (AZ-A), 10.0.3.0/24 (AZ-B) - for web servers via ASG
- **Components**: NAT Gateway (AZ-B), Launch Template, Auto Scaling Group, Application Load Balancer

## Common Commands

```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Format code
terraform fmt

# Preview changes
terraform plan

# Apply changes
terraform apply

# Destroy resources
terraform destroy
```

## File Structure

- `main.tf` - Provider configuration
- `variables.tf` - Input variables (aws_region, project_name)
- `data.tf` - Data sources referencing existing lab resources (VPC, subnets, CafeSG, AMI, CafeRole)
- `nat-gateway.tf` - NAT Gateway for AZ-B and route table updates
- `launch-template.tf` - EC2 launch template using Cafe WebServer AMI
- `autoscaling.tf` - Auto Scaling Group with target tracking policy
- `loadbalancer.tf` - Application Load Balancer with target group
- `outputs.tf` - Output values (ALB DNS name)

## Key Data Sources

The configuration references pre-existing AWS lab resources:
- VPC by CIDR `10.0.0.0/16`
- Subnets by their CIDR blocks
- Security group `CafeSG`
- AMI matching `*Cafe*WebServer*`
- IAM instance profile `CafeRole`
