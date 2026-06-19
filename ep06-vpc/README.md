# EP06 — VPC from Scratch with Terraform

**Terraform Series** | Episode 6 | Practical DevOps by [TechOps Hub](https://www.youtube.com/@TECHOPSHUBOFFICIAL)

## Watch on YouTube

[![YouTube](https://img.shields.io/badge/YouTube-EP06%20WATCH%20NOW-red?style=for-the-badge&logo=youtube)](https://youtu.be/g7uWrANVziU)
[![GitHub](https://img.shields.io/badge/GitHub-terraform--series-black?style=for-the-badge&logo=github)](https://github.com/mohitthakur3/terraform-series)

## What You Will Learn

- What is a VPC and why every production setup needs one
- Public vs Private subnets — the difference and when to use each
- Internet Gateway — how your VPC connects to the internet
- NAT Gateway — how private instances reach the internet without being exposed
- Route Tables — how AWS decides where to send network traffic
- `count` + `count.index` pattern for creating multi-AZ resources without copy-paste
- `depends_on` — when and why to use explicit dependencies

---

## Series Navigation

| Episode | Topic | Link |
|---|---|---|
| EP01 | Installation + S3 Bucket | [Watch](https://www.youtube.com/@TECHOPSHUBOFFICIAL) |
| EP02 | Terraform State File Deep Dive | [Watch](https://www.youtube.com/@TECHOPSHUBOFFICIAL) |
| EP03 | Remote State: S3 + DynamoDB | [Watch](https://youtu.be/shEQpX30rpI) |
| EP04 | Terraform Modules | [Watch](https://youtu.be/x1NDBmaqf8s) |
| EP05 | Terraform Workspaces | [Watch](https://www.youtube.com/@TECHOPSHUBOFFICIAL) |
| **EP06** | **VPC from Scratch** | **You are here** |

---

## What This Code Builds

```
Internet
    │
    ▼
Internet Gateway (IGW)
    │
    ▼
┌──────────────────────────────────────────────┐
│                VPC  10.0.0.0/16              │
│                                              │
│  Public Subnet 1  Public Subnet 2  Public 3  │
│  10.0.1.0/24      10.0.2.0/24    10.0.3.0/24│
│  (us-east-1a)     (us-east-1b)   (us-east-1c)│
│       │                                      │
│   NAT Gateway                                │
│       │                                      │
│  Private Subnet 1  Private Subnet 2  Priv 3  │
│  10.0.11.0/24    10.0.12.0/24  10.0.13.0/24 │
│  (us-east-1a)    (us-east-1b)  (us-east-1c) │
└──────────────────────────────────────────────┘
```

**Resources created:**
- 1 VPC
- 1 Internet Gateway
- 3 Public Subnets (one per AZ)
- 3 Private Subnets (one per AZ)
- 1 Elastic IP
- 1 NAT Gateway
- 2 Route Tables (public + private)
- 6 Route Table Associations

---

## File Structure

```
ep06-vpc/
├── main.tf                   # Terraform + AWS provider config
├── variables.tf              # All input variables
├── vpc.tf                    # VPC, IGW, subnets, NAT, route tables
├── outputs.tf                # VPC ID, subnet IDs, NAT IP
└── terraform.tfvars.example  # Example values
```

---

## Step-by-Step

**1. Clone and go to the folder**

```bash
git clone https://github.com/mohitthakur3/terraform-series.git
cd terraform-series/ep06-vpc
```

**2. Create your tfvars file**

```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your aws_profile
```

**3. Init and plan**

```bash
terraform init
terraform plan
```

**4. Apply**

```bash
terraform apply
```

After apply, outputs will show:

```
vpc_id              = "vpc-0abc123..."
public_subnet_ids   = ["subnet-xxx", "subnet-yyy", "subnet-zzz"]
private_subnet_ids  = ["subnet-aaa", "subnet-bbb", "subnet-ccc"]
nat_gateway_ip      = "54.x.x.x"
```

**5. Destroy when done**

```bash
terraform destroy
```

> **Cost note:** NAT Gateway costs ~$0.045/hr. Always destroy after the demo.

---

## Key Concepts

### Public vs Private Subnet

| | Public Subnet | Private Subnet |
|---|---|---|
| Public IP | Assigned automatically | Not assigned |
| Route to internet | Via IGW (direct) | Via NAT (outbound only) |
| Use case | Load balancers, Bastion host | App servers, RDS, EKS nodes |

### Why NAT Gateway must be in a public subnet

NAT Gateway routes private instance traffic to the internet using its Elastic IP. To do that, it needs a path to the internet itself — which only exists in a public subnet (via the IGW route). Placing NAT in a private subnet creates an infinite routing loop.

### `depends_on` on NAT Gateway

NAT Gateway does not directly reference the Internet Gateway in code, so Terraform cannot automatically detect the dependency. `depends_on` ensures IGW is fully created before NAT Gateway is provisioned.

### `count` pattern

```hcl
resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)   # loops 3 times
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]
}
```

Instead of writing 3 separate subnet blocks, `count` loops over the list. `count.index` picks the right CIDR and AZ for each iteration.

---

## What Real Teams Add Next

- Per-AZ NAT Gateways (high availability — one NAT per AZ)
- VPC Flow Logs (CloudWatch / S3)
- Network ACLs (subnet-level firewall rules)
- VPC Endpoints for S3 and DynamoDB (private access, no NAT cost)
- Separate route table per private subnet (fault isolation)
