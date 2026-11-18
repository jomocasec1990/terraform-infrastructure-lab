
@'
# Lab 01 — Terraform Core Workflow on AWS

## Overview

This hands-on lab demonstrates the complete Terraform infrastructure lifecycle on AWS, including provisioning, configuration validation, state inspection, drift detection, saved execution plans, and safe resource destruction.

The lab was built as part of a practical Infrastructure as Code (IaC) learning project.

## Architecture

The infrastructure consisted of an AWS VPC and a subnet deployed in the `us-east-1` region.

```text
AWS Cloud (us-east-1)
|
+-- VPC: Lab01-VPC
|   CIDR: 10.50.0.0/16
|   DNS Support: Enabled
|   DNS Hostnames: Enabled
|
+-- Subnet: Lab01-Subnet
    CIDR: 10.50.1.0/24
    Availability Zone: us-east-1e
    Public IP Auto-Assignment: Disabled
```

The subnet depends on the VPC through the reference `aws_vpc.lab.id`, allowing Terraform to automatically determine resource creation and destruction order.

## Technologies

- HashiCorp Terraform
- AWS VPC and EC2 networking APIs
- AWS CLI
- HCL
- PowerShell
- Git and GitHub

## Project Structure

```text
lab01-core-workflow/
|-- .terraform.lock.hcl
|-- main.tf
|-- outputs.tf
|-- provider.tf
|-- terraform.tfvars.example
|-- variables.tf
|-- versions.tf
`-- README.md
```

### File Responsibilities

| File | Purpose |
|------|---------|
| `versions.tf` | Defines Terraform and AWS provider version constraints |
| `provider.tf` | Configures the AWS provider, region, and default tags |
| `variables.tf` | Defines input variables, types, defaults, and validation |
| `terraform.tfvars.example` | Provides example configuration values |
| `main.tf` | Declares the VPC and subnet resources |
| `outputs.tf` | Exposes the VPC ID, subnet ID, and VPC CIDR |
| `.terraform.lock.hcl` | Records provider selections and checksums |

## Configuration

The lab uses the following example variables:

```hcl
aws_region  = "us-east-1"
vpc_cidr    = "10.50.0.0/16"
subnet_cidr = "10.50.1.0/24"
```

Copy `terraform.tfvars.example` to `terraform.tfvars` before deploying.

The AWS provider applies common tags:

- Project: Terraform-Lab01
- Environment: Lab
- ManagedBy: Terraform

## Terraform Workflow

### 1. Initialize the Working Directory

```bash
terraform init
```

Downloads and initializes the required providers and prepares the working directory.

### 2. Format and Validate

```bash
terraform fmt
terraform validate
```

Checks formatting and configuration validity.

### 3. Preview Infrastructure Changes

```bash
terraform plan
```

The initial deployment plan reported:

```text
Plan: 2 to add, 0 to change, 0 to destroy.
```

### 4. Deploy Infrastructure

```bash
terraform apply
```

Terraform created the VPC first, followed by the subnet.

### 5. Inspect Terraform State

```bash
terraform state list
terraform state show aws_vpc.lab
terraform show
terraform output
```

These commands were used to inspect the resources managed by Terraform and their attributes.

## Configuration Drift Experiment

A controlled drift experiment was performed by modifying the VPC Name tag directly through AWS CLI.

### Original Tag

```text
Name = Lab01-VPC
```

### Manual Change

```bash
aws ec2 create-tags \
  --resources vpc-0ae4e01d9555848b3 \
  --tags Key=Name,Value=Lab01-VPC-ManualChange \
  --region us-east-1
```

The manual change was verified through AWS CLI.

### Detecting Drift

Running:

```bash
terraform plan
```

Detected that the actual AWS resource differed from the Terraform configuration.

Terraform proposed restoring the tag:

```diff
~ "Name" = "Lab01-VPC-ManualChange" -> "Lab01-VPC"
```

The plan reported:

```text
Plan: 0 to add, 1 to change, 0 to destroy.
```

### Refresh-Only Experiment

```bash
terraform plan -refresh-only
```

This command previewed how Terraform state would be updated to reflect the manually changed AWS resource without proposing infrastructure modifications.

The refresh-only plan was inspected but not applied.

### Restoring the Desired Configuration

```bash
terraform apply
```

Terraform restored the original Name tag.

A subsequent `terraform plan` confirmed:

```text
No changes. Your infrastructure matches the configuration.
```

## Saved Execution Plans

A saved execution plan was generated using:

```bash
terraform plan -out lab01.tfplan
```

The saved plan was inspected with:

```bash
terraform show lab01.tfplan
```

The plan confirmed that no infrastructure changes were pending.

Saved plans should not be committed to Git because they may contain sensitive values.

## Terraform State and Locking

Terraform state maintains the mapping between configuration resources and actual infrastructure.

State locking helps prevent conflicting concurrent operations when supported by the backend.

This lab used local Terraform state. Remote state backends and collaborative state management are planned for future labs.

## Infrastructure Destruction

Before cleanup, the destruction plan was inspected:

```bash
terraform plan -destroy
```

Terraform reported:

```text
Plan: 0 to add, 0 to change, 2 to destroy.
```

After verifying the resources, the infrastructure was removed:

```bash
terraform destroy
```

The subnet was destroyed before the VPC, demonstrating Terraform dependency handling.

Final result:

```text
Destroy complete! Resources: 2 destroyed.
```

### Cleanup Verification

```bash
terraform state list
terraform output
```

The state contained no managed resources, and no outputs remained.

The saved plan file was also removed.

## Security and Git Best Practices

The following files are excluded from Git:

- `.terraform/`
- `terraform.tfstate`
- `terraform.tfstate.backup`
- `terraform.tfvars`
- `*.tfplan`

The `.terraform.lock.hcl` file is committed to support reproducible provider selection.

AWS credentials must not be stored in Terraform configuration files or committed to Git.

## Key Learning Outcomes

1. Understand the Terraform core workflow.
2. Configure providers and version constraints.
3. Use input variables and validation.
4. Understand implicit resource dependencies.
5. Inspect and interpret Terraform state.
6. Detect and reconcile configuration drift.
7. Distinguish refresh-only plans from normal plans.
8. Generate and inspect saved execution plans.
9. Understand state locking concepts.
10. Safely destroy infrastructure and verify cleanup.

## Lab Status

**Completed successfully.**

The AWS VPC and subnet were deployed, inspected, modified during a controlled drift experiment, restored, and safely destroyed.

No managed infrastructure remains in the lab state.
'@ | Set-Content -Path .\README.md -Encoding UTF8
