# EP01 — Terraform Introduction: Create an S3 Bucket on AWS

> **Terraform Series** | Episode 1

---

## YouTube Video

[![Watch on YouTube](https://img.shields.io/badge/YouTube-Watch%20Now-red?logo=youtube&logoColor=white&style=for-the-badge)](https://www.youtube.com/@TechOpsHubOfficial)

<!-- TODO: Replace the link above with the direct EP01 video URL once published -->

---

## What You'll Learn

- What Terraform is and why it matters
- How to configure the AWS provider
- How to write your first `resource` block
- How to create an S3 bucket using `aws_s3_bucket`
- Core Terraform workflow: `init` → `plan` → `apply` → `destroy`

---

## Prerequisites

| Tool | Minimum Version |
|------|----------------|
| [Terraform](https://developer.hashicorp.com/terraform/install) | `>= 1.0` |
| [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) | `>= 2.0` |
| AWS account with S3 permissions | — |

---

## Project Structure

```
ep01-intro-s3/
└── main.tf          # Provider config + S3 bucket resource
```

---

## Quick Start

**1. Clone the repo**
```bash
git clone https://github.com/<your-github-username>/terraform-series.git
cd terraform-series/ep01-intro-s3
```

**2. Configure AWS credentials**
```bash
aws configure --profile techops-demo
```

**3. Initialize Terraform**
```bash
terraform init
```

**4. Preview the plan**
```bash
terraform plan
```

**5. Apply (creates the bucket)**
```bash
terraform apply
```

**6. Destroy (cleanup)**
```bash
terraform destroy
```

---

## Code Walkthrough

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "techops-demo"
}

resource "aws_s3_bucket" "demo" {
  bucket = "techops-hub-ep011-demo-2026"

  tags = {
    Name        = "TechOps Hub EP01"
    Environment = "learning"
  }
}
```

| Block | Purpose |
|-------|---------|
| `terraform {}` | Declares the required AWS provider and its version constraint |
| `provider "aws"` | Tells Terraform which region and CLI profile to use |
| `resource "aws_s3_bucket"` | Creates an S3 bucket with a unique name and tags |

---

## Resources

- [Terraform AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)
- [AWS S3 Documentation](https://docs.aws.amazon.com/s3/index.html)
- [Terraform Getting Started](https://developer.hashicorp.com/terraform/tutorials/aws-get-started)

---

## GitHub Repo

[![GitHub](https://img.shields.io/badge/GitHub-terraform--series-black?logo=github&style=for-the-badge)](https://github.com/<your-github-username>/terraform-series)

---

*If this helped you, give the video a like and subscribe to the channel!*
