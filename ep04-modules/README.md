# EP04 — Terraform Modules: Write Once, Use Everywhere

**Terraform Series** | Episode 4 | Practical DevOps by [TechOps Hub](https://www.youtube.com/@TECHOPSHUBOFFICIAL)

## 🎬 Watch on YouTube

[![YouTube](https://img.shields.io/badge/YouTube-EP04%20WATCH%20NOW-red?style=for-the-badge&logo=youtube)](https://youtu.be/x1NDBmaqf8s)
[![GitHub](https://img.shields.io/badge/GitHub-terraform--series-black?style=for-the-badge&logo=github)](https://github.com/mohitthakur3/terraform-series)

## Is Episode Mein Kya Seekhoge

- Copy-paste code ka kya problem hota hai production mein
- Terraform Module kya hota hai — function ki tarah socho
- Local module kaise banate hain
- Same module se dev aur prod dono kaise manage karte hain
- `terraform.workspace` variable ka use
- Real teams mein modules kahan se aate hain (local, Git, Registry)

---

## Series Navigation

| Episode | Topic | Link |
|---|---|---|
| EP01 | Installation + S3 Bucket | [Watch](https://www.youtube.com/@TECHOPSHUBOFFICIAL) |
| EP02 | Terraform State File Deep Dive | [Watch](https://www.youtube.com/@TECHOPSHUBOFFICIAL) |
| EP03 | Remote State: S3 + DynamoDB | [Watch](https://youtu.be/shEQpX30rpI) |
| **EP04** | **Terraform Modules** | **You are here** |
| EP05 | Terraform Workspaces | Coming Soon |

---

Stop copy-pasting infrastructure code. Modules let you write it once and reuse it everywhere — exactly how teams manage dev, staging, and prod environments.

---

## The Problem Without Modules

```
ep01/ → s3 bucket code
ep02/ → same s3 bucket code (copy-paste)
ep03/ → same s3 bucket code (copy-paste again)
```

Bug fix karo? Teen jagah karo. Koi jagah bhool gaye? Drift.

---

## Solution — Module

```
modules/s3-bucket/    ← ek baar likho
    ├── main.tf
    ├── variables.tf
    └── outputs.tf

main.tf               ← module ko jitni baar chaaho call karo
    module "dev_bucket"  { source = "./modules/s3-bucket" }
    module "prod_bucket" { source = "./modules/s3-bucket" }
```

---

## File Structure

```
ep04-modules/
├── main.tf                    # module calls (dev + prod)
├── variables.tf
├── outputs.tf
├── terraform.tfvars.example
├── README.md
└── modules/
    └── s3-bucket/             # reusable module
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

## Step-by-Step

### Step 1 — Copy vars file

```bash
cd ep04-modules
cp terraform.tfvars.example terraform.tfvars
```

### Step 2 — Init
```bash
terraform init
```

`terraform init` modules ko bhi download/load karta hai. Output mein dikhega:
```
Initializing modules...
- dev_bucket in modules/s3-bucket
- prod_bucket in modules/s3-bucket
```

### Step 3 — Plan

```bash
terraform plan
```

**8 resources** dikhenge — 4 per bucket (bucket + public access block + versioning + encryption).

### Step 4 — Apply

```bash
terraform apply
```

2 buckets ban jaayenge — dev aur prod — ek hi module se.

### Step 5 — Verify

```bash
terraform output
```

```
dev_bucket_name  = "techops-hub-dev-app-2026"
prod_bucket_name = "techops-hub-prod-app-2026"
```

### Step 6 — Destroy

```bash
terraform destroy
```

---

## Key Concepts

**`source`** — module kahan hai. Local path (`./modules/s3-bucket`) ya Terraform Registry (`hashicorp/s3-bucket/aws`).

**`this`** — module ke andar resources `this` naam se hote hain convention ke taur pe — kyunki module ko pata nahi ki isko kitni baar call karenge aur kis naam se.

**Module outputs** — module ke andar jo `output` define karo, usse bahar `module.dev_bucket.bucket_name` se access karo.

**`versioning_enabled` variable** — ek hi module se dev (versioning off) aur prod (versioning on) dono handle hote hain. Ye hai modules ki power.

---

## What Teams Actually Do

Real teams mein modules teen jagah se aate hain:

```hcl
# 1. Local module (is episode wala)
source = "./modules/s3-bucket"

# 2. Git repo se (team ka shared module repo)
source = "git::https://github.com/company/tf-modules.git//s3-bucket?ref=v1.2.0"

# 3. Terraform Registry se (community modules)
source  = "terraform-aws-modules/s3-bucket/aws"
version = "~> 4.0"
```
