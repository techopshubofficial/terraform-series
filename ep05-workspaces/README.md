# EP05 — Terraform Workspaces: Ek Code, Multiple Environments

**Terraform Series** | Episode 5 | Practical DevOps by [TechOps Hub](https://www.youtube.com/@TECHOPSHUBOFFICIAL)

## 🎬 Watch on YouTube

[![YouTube](https://img.shields.io/badge/YouTube-EP05%20WATCH%20NOW-red?style=for-the-badge&logo=youtube)](https://www.youtube.com/@TECHOPSHUBOFFICIAL)
[![GitHub](https://img.shields.io/badge/GitHub-terraform--series-black?style=for-the-badge&logo=github)](https://github.com/mohitthakur3/terraform-series)

## Is Episode Mein Kya Seekhoge

- Workspaces kya hote hain aur kyun zaroori hain
- `terraform.workspace` variable kaise use karte hain
- Dev, staging, prod ke liye alag resources ek hi code se
- Per-environment config map pattern
- Workspace state kahan store hoti hai
- Workspaces ki limitations aur kab use karein

---

## Series Navigation

| Episode | Topic | Link |
|---|---|---|
| EP01 | Installation + S3 Bucket | [Watch](https://www.youtube.com/@TECHOPSHUBOFFICIAL) |
| EP02 | Terraform State File Deep Dive | [Watch](https://www.youtube.com/@TECHOPSHUBOFFICIAL) |
| EP03 | Remote State: S3 + DynamoDB | [Watch](https://youtu.be/shEQpX30rpI) |
| EP04 | Terraform Modules | [Watch](https://youtu.be/x1NDBmaqf8s) |
| **EP05** | **Terraform Workspaces** | **You are here** |

---

## Problem — EP04 mein kya tha

EP04 mein hum ne 2 alag module calls likhi thi:

```hcl
module "dev_bucket"  { ... }
module "prod_bucket" { ... }
```

Naya environment chahiye? Naya block likho. 10 environments = 10 blocks.

**Workspace ka solution:** ek hi code, sirf workspace switch karo.

---

## Workspace Kaise Kaam Karta Hai

```
terraform.workspace  →  "dev" / "staging" / "prod"

bucket name          →  "techops-hub-dev-app-2026"
                     →  "techops-hub-staging-app-2026"
                     →  "techops-hub-prod-app-2026"

state file           →  terraform.tfstate.d/dev/terraform.tfstate
                     →  terraform.tfstate.d/staging/terraform.tfstate
                     →  terraform.tfstate.d/prod/terraform.tfstate
```

Har workspace ki **alag state file** — resources independently manage hote hain.

---

## Step-by-Step

### Step 1 — Copy vars file

```bash
cd ep05-workspaces
cp terraform.tfvars.example terraform.tfvars
```

### Step 2 — Init

```bash
terraform init
```

### Step 3 — Default workspace check karo

```bash
terraform workspace list
```

Output:
```
* default
```

`*` active workspace dikhata hai.

### Step 4 — Dev workspace banao aur switch karo

```bash
terraform workspace new dev
terraform workspace list
```

Output:
```
  default
* dev
```

### Step 5 — Dev mein apply karo

```bash
terraform plan    # bucket name mein "dev" dikhega
terraform apply
```

Output mein dekho:
```
workspace         = "dev"
bucket_name       = "techops-hub-dev-app-2026"
versioning_status = "Disabled"
```

### Step 6 — Prod workspace banao

```bash
terraform workspace new prod
terraform apply
```

Output:
```
workspace         = "prod"
bucket_name       = "techops-hub-prod-app-2026"
versioning_status = "Enabled"
```

### Step 7 — Workspaces list karo

```bash
terraform workspace list
```

```
  default
  dev
* prod
```

### Step 8 — State files dekho (local)

```bash
ls terraform.tfstate.d/
# dev/  prod/
```

Har environment ki alag state file — dono independent hain.

### Step 9 — Switch back karo

```bash
terraform workspace select dev
terraform workspace show    # current workspace print karta hai
```

### Step 10 — Destroy (after recording)

```bash
# Dev destroy
terraform workspace select dev
terraform destroy

# Prod destroy
terraform workspace select prod
terraform destroy
```

---

## Key Concepts

**`terraform.workspace`**
Built-in variable — current workspace ka naam return karta hai. Default workspace ka naam `"default"` hota hai.

**`var.env_config[terraform.workspace]`**
Map lookup pattern — workspace ke naam se per-environment config nikalo. Dev mein versioning off, prod mein on. Ek hi code mein sab manage hota hai.

**Alag state files**
```
terraform.tfstate.d/
├── dev/terraform.tfstate    ← sirf dev ke resources
└── prod/terraform.tfstate   ← sirf prod ke resources
```
Dono completely independent hain — prod destroy karne se dev affect nahi hoga.

**Default workspace**
`terraform init` ke baad hamesha `default` workspace hota hai. Real projects mein `default` workspace use nahi karte — hamesha named workspace banao.

---

## Workspaces Kab Use Karein

| Situation | Use Workspaces? |
|---|---|
| Solo developer, 2-3 environments | ✅ Haan — simple aur fast |
| Small team, similar environments | ✅ Haan |
| Large team, environments alag configs hain | ⚠️ Consider Terragrunt ya alag directories |
| Completely different infrastructure per env | ❌ Alag repos better |

---

## File Structure

```
ep05-workspaces/
├── main.tf                    # provider + default_tags with terraform.workspace
├── variables.tf               # env_config map — per-workspace settings
├── s3.tf                      # bucket name uses terraform.workspace
├── outputs.tf                 # workspace + bucket name + versioning status
├── terraform.tfvars.example
└── README.md
```
