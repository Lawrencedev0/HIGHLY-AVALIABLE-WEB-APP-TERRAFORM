# Highly Available Web Application on AWS — Terraform

This project recreates the architecture in the supplied diagram using Terraform.

## Architecture

Users
→ Route 53 (optional DNS)
→ Application Load Balancer
→ EC2 Auto Scaling Group across 2 Availability Zones
→ Amazon RDS PostgreSQL Multi-AZ

Static content:
Amazon S3 (private)
→ CloudFront

Monitoring:
Amazon CloudWatch

Networking:
- 1 VPC
- 2 public subnets
- 2 private application subnets
- 2 private database subnets
- 2 NAT Gateways
- Internet Gateway
- Separate route tables
- Security Groups

## Files

- `versions.tf` — Terraform/provider requirements
- `variables.tf` — configurable inputs
- `main.tf` — AWS infrastructure
- `outputs.tf` — useful deployment outputs
- `terraform.tfvars.example` — example variables
- `.gitignore` — prevents state/secrets from being committed

## Prerequisites

1. AWS account
2. Terraform >= 1.6
3. AWS CLI configured
4. An IAM identity with permission to create the resources in this project

Configure AWS credentials before running Terraform. Do not put AWS access keys in Terraform files.

## Deploy

Copy the example variables file:

PowerShell:

    Copy-Item terraform.tfvars.example terraform.tfvars

Edit `terraform.tfvars` and set a real database password.

Then run:

    terraform fmt -recursive
    terraform init
    terraform validate
    terraform plan
    terraform apply

Type `yes` when Terraform asks for confirmation.

## Test

After `apply`, Terraform prints:

    load_balancer_dns

Open that address in a browser.

You can also test:

    http://<load-balancer-dns>/health

The ALB health check uses `/health`.

## Important notes

- The EC2 instances are private and receive internet access through NAT Gateways.
- The ALB is public and sends HTTP traffic to the private EC2 instances.
- RDS is private and accepts PostgreSQL traffic only from the application security group.
- The RDS instance is Multi-AZ.
- The Auto Scaling Group keeps at least two EC2 instances and distributes them across two AZs.
- CloudFront accesses the private S3 bucket using Origin Access Control.
- Route 53 DNS creation is optional. If `domain_name` is set, the domain must already exist as a public Route 53 hosted zone in the selected AWS account.
- The example intentionally uses HTTP for the ALB. For a real production deployment, add an ACM certificate and HTTPS listener.

## Destroy

When finished testing:

    terraform destroy

Review the resources carefully before confirming. RDS and other production resources can contain data.
