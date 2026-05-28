# Terraform Cheatsheet

> Infrastructure as Code tool for provisioning cloud resources declaratively.
> Last verified: May 2026 | Version: 1.8

---

## Quick Reference

| Command | Description |
|---|---|
| `terraform init` | Initialize working directory |
| `terraform plan` | Preview changes to infrastructure |
| `terraform apply` | Apply the planned changes |
| `terraform destroy` | Destroy managed infrastructure |
| `terraform fmt` | Format configuration files |
| `terraform validate` | Validate configuration syntax |
| `terraform state list` | List resources in state |
| `terraform import` | Import existing resource to state |
| `terraform output` | Show output values |
| `terraform workspace list` | List workspaces |

---

## Core Workflow

### Initialize, Plan, Apply

```bash
# Initialize a working directory (download providers)
terraform init

# Initialize and upgrade providers to latest allowed
terraform init -upgrade

# Preview what Terraform will do
terraform plan

# Save plan to a file for later apply
terraform plan -out=tfplan

# Apply saved plan (no confirmation prompt)
terraform apply tfplan

# Apply directly (prompts for confirmation)
terraform apply

# Auto-approve (skip interactive approval)
terraform apply -auto-approve

# Destroy all resources managed by Terraform
terraform destroy

# Auto-approve destroy
terraform destroy -auto-approve

# Target a specific resource only
terraform apply -target=aws_instance.web

# Target multiple resources
terraform apply -target=aws_instance.web -target=aws_security_group.allow_web

# Replace (recreate) a specific resource
terraform apply -replace=aws_instance.web
```

### Format and Validate

```bash
# Format all .tf files in current directory
terraform fmt

# Format recursively
terraform fmt -recursive

# Check formatting without modifying (exit 1 if unformatted)
terraform fmt -check

# Validate configuration (no API calls)
terraform validate

# Show detailed validation output
terraform validate -json
```

---

## Configuration Syntax

### Resource Block

```hcl
# Basic resource definition
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"

  tags = {
    Name        = "WebServer"
    Environment = "production"
  }
}

# Reference another resource attribute
resource "aws_eip" "lb" {
  instance = aws_instance.web.id
  domain   = "vpc"
}
```

### Data Sources

```hcl
# Fetch existing AWS AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }
}

# Use data source in resource
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
}
```

---

## Variables

### Variable Declaration

```hcl
# String variable with default
variable "region" {
  type        = string
  description = "AWS region to deploy to"
  default     = "us-east-1"
}

# Number variable
variable "instance_count" {
  type        = number
  description = "Number of instances"
  default     = 2
}

# Boolean variable
variable "enable_monitoring" {
  type    = bool
  default = true
}

# List variable
variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

# Map variable
variable "tags" {
  type = map(string)
  default = {
    Project     = "myapp"
    Environment = "prod"
  }
}

# Object variable (structured)
variable "instance_config" {
  type = object({
    ami           = string
    instance_type = string
    volume_size   = number
  })
}

# Variable with validation
variable "environment" {
  type        = string
  description = "Deployment environment"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}
```

### Passing Variable Values

```bash
# Pass var on command line
terraform apply -var="region=us-west-2"
terraform apply -var="instance_count=3"

# Use a .tfvars file
terraform apply -var-file="prod.tfvars"

# Auto-loaded var files (no flag needed)
# terraform.tfvars or terraform.tfvars.json
# *.auto.tfvars or *.auto.tfvars.json

# Environment variable (TF_VAR_ prefix)
export TF_VAR_region="us-west-2"
export TF_VAR_instance_count=5
terraform apply
```

### tfvars File Example

```hcl
# prod.tfvars
region         = "us-east-1"
instance_count = 5
environment    = "prod"

tags = {
  Project     = "myapp"
  Environment = "prod"
  Owner       = "platform-team"
}
```

---

## Outputs

```hcl
# Define an output
output "instance_ip" {
  description = "The public IP of the web instance"
  value       = aws_instance.web.public_ip
}

# Output a list
output "instance_ids" {
  value = aws_instance.web[*].id
}

# Sensitive output (masked in CLI)
output "db_password" {
  value     = aws_db_instance.main.password
  sensitive = true
}

# Output with depends_on
output "endpoint" {
  value      = aws_lb.main.dns_name
  depends_on = [aws_lb_listener.http]
}
```

```bash
# Show all outputs
terraform output

# Show a specific output value
terraform output instance_ip

# Output as JSON
terraform output -json

# Output raw value (no quotes)
terraform output -raw instance_ip
```

---

## Locals

```hcl
# Define local values (computed/reused values)
locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }

  name_prefix  = "${var.project_name}-${var.environment}"
  is_prod      = var.environment == "prod"
  instance_type = local.is_prod ? "t3.large" : "t3.micro"
}

# Use a local
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.instance_type

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-web"
  })
}
```

---

## Modules

### Calling a Module

```hcl
# Call a local module
module "vpc" {
  source = "./modules/vpc"

  cidr_block = "10.0.0.0/16"
  region     = var.region
}

# Call a Terraform Registry module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
}

# Reference module outputs
resource "aws_instance" "web" {
  subnet_id = module.vpc.public_subnets[0]
}
```

### Module Commands

```bash
# Initialize modules (done as part of terraform init)
terraform init

# Get modules only
terraform get

# Update modules
terraform get -update
```

---

## State Management

### Viewing State

```bash
# List all resources in state
terraform state list

# Show details of a specific resource
terraform state show aws_instance.web

# Show full state (JSON)
terraform show -json

# Pull current state from backend
terraform state pull

# Push local state to remote backend
terraform state push terraform.tfstate
```

### Modifying State

```bash
# Import an existing resource into state
terraform import aws_instance.web i-1234567890abcdef0

# Import with var file
terraform import -var-file=prod.tfvars aws_s3_bucket.main my-bucket-name

# Move a resource within state (rename)
terraform state mv aws_instance.web aws_instance.app_server

# Move resource to a module
terraform state mv aws_instance.web module.app.aws_instance.web

# Remove resource from state (WITHOUT destroying)
terraform state rm aws_instance.web

# Remove a module from state
terraform state rm module.vpc
```

---

## Workspaces

```bash
# List all workspaces (default exists by default)
terraform workspace list

# Create a new workspace
terraform workspace new staging

# Switch to a workspace
terraform workspace select prod

# Show current workspace
terraform workspace show

# Delete a workspace
terraform workspace delete staging
```

```hcl
# Use workspace name in configuration
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = terraform.workspace == "prod" ? "t3.large" : "t3.micro"

  tags = {
    Name        = "web-${terraform.workspace}"
    Environment = terraform.workspace
  }
}
```

---

## Backends

### S3 Backend (AWS)

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
```

### GCS Backend (GCP)

```hcl
terraform {
  backend "gcs" {
    bucket = "my-terraform-state"
    prefix = "terraform/state"
  }
}
```

### Azure Backend

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-rg"
    storage_account_name = "tfstateaccount"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}
```

---

## Provider Configuration

### AWS Provider

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = "my-aws-profile"

  default_tags {
    tags = {
      ManagedBy = "terraform"
    }
  }
}

# Multiple provider aliases
provider "aws" {
  alias  = "us_east"
  region = "us-east-1"
}

provider "aws" {
  alias  = "us_west"
  region = "us-west-2"
}

# Use a specific provider alias
resource "aws_instance" "west_server" {
  provider      = aws.us_west
  ami           = "ami-xxx"
  instance_type = "t3.micro"
}
```

### GCP Provider

```hcl
provider "google" {
  project = var.project_id
  region  = "us-central1"
  zone    = "us-central1-a"
}
```

### Azure Provider

```hcl
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
```

---

## Meta-Arguments

```hcl
# count: create multiple resources
resource "aws_instance" "web" {
  count         = 3
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  tags = {
    Name = "web-${count.index}"
  }
}

# for_each: create from map or set
resource "aws_instance" "servers" {
  for_each = {
    web = "t3.micro"
    api = "t3.small"
    db  = "t3.medium"
  }
  ami           = data.aws_ami.ubuntu.id
  instance_type = each.value
  tags = {
    Name = each.key
  }
}

# depends_on: explicit dependency
resource "aws_instance" "app" {
  depends_on = [aws_db_instance.main]
}

# lifecycle: control resource lifecycle
resource "aws_instance" "web" {
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [tags, user_data]
    prevent_destroy       = true   # Blocks destroy
  }
}
```

---

## Expressions & Functions

```hcl
# Conditional expression
instance_type = var.environment == "prod" ? "t3.large" : "t3.micro"

# String interpolation
name = "web-${var.environment}-${count.index}"

# Template strings
user_data = templatefile("${path.module}/userdata.sh.tpl", {
  db_host = aws_db_instance.main.endpoint
})

# Common built-in functions
length(var.availability_zones)          # Length of list/string/map
join(",", var.subnets)                  # Join list into string
split(",", var.subnet_string)           # Split string into list
toset(["a", "b", "a"])                 # Convert list to set (dedup)
tolist(toset(["a", "b"]))             # Convert set to list
merge(local.common_tags, { Name = "web" }) # Merge maps
lookup(var.ami_map, var.region, "default") # Map lookup with default
flatten([["a","b"], ["c"]])            # Flatten nested lists
cidrsubnet("10.0.0.0/16", 8, 1)       # Calculate subnet CIDR
file("${path.module}/script.sh")       # Read file contents
base64encode("my-secret")              # Base64 encode
jsonencode({ key = "value" })          # Encode as JSON string
```

---

## Debugging & Logging

```bash
# Enable verbose logging
export TF_LOG=DEBUG
export TF_LOG=TRACE   # Maximum verbosity

# Write logs to a file
export TF_LOG_PATH=./terraform.log

# Disable logging
unset TF_LOG

# Show Terraform version info
terraform version

# Providers and versions in use
terraform providers

# Lock file for reproducible provider versions
# .terraform.lock.hcl is auto-generated, commit this to source control
```

---

## Tips & Tricks

- Always commit `.terraform.lock.hcl` to version control for reproducible provider versions
- Use `terraform plan -out=tfplan && terraform apply tfplan` in CI/CD to ensure what's applied matches what was planned
- `terraform console` opens an interactive REPL for testing expressions and functions
- Use `moved` blocks to refactor resource addresses without destroying and recreating them
- `terraform graph | dot -Tpng > graph.png` generates a visual dependency graph (requires Graphviz)
- Keep modules small and focused; use the Registry for battle-tested modules
- Use `sensitive = true` on outputs and variables containing secrets to prevent them being shown in logs
- Remote state with locking (e.g., S3 + DynamoDB) is essential for team collaboration
- Use `terraform validate` in CI before `plan` to catch syntax errors early
- The `-compact-warnings` flag reduces noisy output from deprecation warnings

---

*Contribute fixes or additions via pull request. See [CONTRIBUTING.md](../CONTRIBUTING.md).*
