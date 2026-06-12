# EP02 — Terraform State File: Terraform ki Memory Kaise Kaam Karti Hai

> **Terraform Series** | Episode 2 | Practical DevOps by [TechOps Hub](https://www.youtube.com/@TechOpsHubOfficial)

---

## 🎬 Watch on YouTube

[![Watch on YouTube](https://img.shields.io/badge/YouTube-EP02%20Watch%20Now-red?logo=youtube&logoColor=white&style=for-the-badge)](https://www.youtube.com/watch?v=Gl7CQAibyWg)
[![GitHub Repo](https://img.shields.io/badge/GitHub-terraform--series-black?logo=github&style=for-the-badge)](https://github.com/techopshubofficial/terraform-series)

---

## Is Episode Mein Kya Seekhoge

- `.terraform.lock.hcl` kya hota hai aur kyun zaroori hai
- `terraform.tfstate` ke andar kya hota hai — live EC2 example ke saath
- State file rename karke Terraform ko confuse karna — live demo
- **Desired State vs Current State** — manual drift detect karna
- `terraform state list`, `terraform state show`, `terraform show` commands
- Local state ki limitations aur real-world problems

---

## Prerequisites

EP01 pehle dekho → [EP01 — Terraform Intro: S3 Bucket](../ep01-intro-s3/README.md)

| Tool | Version |
|------|---------|
| [Terraform](https://developer.hashicorp.com/terraform/install) | `>= 1.0` |
| [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) | `>= 2.0` |
| AWS Account (EC2 permissions) | Free Tier works |

---

## Project Structure

```
ep02-local-state/
├── main.tf        # EC2 instance + AMI data source
├── .gitignore     # tfstate aur .terraform/ ignore
└── README.md
```

---

## Hands-on Demo Steps

### Step 1 — Clone & Setup
```bash
git clone https://github.com/techopshubofficial/terraform-series.git
cd terraform-series/ep02-local-state
```

### Step 2 — Init karo, Lock File Dekho
```bash
terraform init
cat .terraform.lock.hcl
```
> Provider version yahan lock ho jaati hai — team mein sab same version use karein

### Step 3 — EC2 Instance Banao
```bash
terraform apply
```

### Step 4 — State File Explore Karo
```bash
ls -la                                   # terraform.tfstate dekho
cat terraform.tfstate                    # instance ID, AMI, IP — sab andar hai
terraform state list                     # kaunse resources track ho rahe hain
terraform state show aws_instance.demo   # ek resource ki poori detail
terraform show                           # human-readable summary
```

### Step 5 — State File Rename Demo (Terraform ko Confuse Karo)
```bash
mv terraform.tfstate terraform.tfstate.bak
terraform plan
# Output: "will create 1 EC2 instance" — instance already exist karti hai AWS pe!

mv terraform.tfstate.bak terraform.tfstate
terraform plan
# Output: "No changes" — state wapas aayi, sab normal
```

### Step 6 — Desired vs Current State: Drift Demo
1. AWS Console → EC2 → apna instance select karo
2. **Tags** → `Environment` ki value `learning` se `production` karo (manually)
3. Terminal pe aao:
```bash
terraform plan
```
Output:
```
~ aws_instance.demo
  ~ tags = {
      ~ "Environment" = "production" -> "learning"
    }
```
> **Yahi hai Drift.** Terraform jaanta hai kya hona chahiye (`main.tf`) vs kya actually hai (AWS) — aur difference dikhata hai.

```bash
terraform apply   # drift fix ho jayega
```

### Step 7 — Cleanup
```bash
terraform destroy
```

---

## Key Concepts

| Concept | Kya hai |
|---------|---------|
| `.terraform.lock.hcl` | Provider version lock — reproducible builds |
| `terraform.tfstate` | Terraform ki memory — real infra ka snapshot |
| **Desired State** | Jo `main.tf` mein likha hai |
| **Current State** | Jo actually AWS pe exist karta hai |
| **Drift** | Desired aur Current mein difference |

---

## Local State ki Problem

```
Developer A  ──┐
               ├──►  tfstate sirf ek laptop pe  ──►  Team mein kaam nahi karta!
Developer B  ──┘
```

| Problem | Kya hoga |
|---------|----------|
| Alag-alag state files | Resource conflicts |
| State GitHub pe push | Secrets leak (instance IDs, IPs andar hote hain) |
| 2 log ek saath `apply` | Race condition → infra corrupt |

**Solution → EP03:** Remote State with S3 + DynamoDB Locking

---

## Useful Links

- [Terraform State Docs](https://developer.hashicorp.com/terraform/language/state)
- [terraform state CLI](https://developer.hashicorp.com/terraform/cli/commands/state)
- [aws_instance resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)
- [.gitignore for Terraform](https://github.com/github/gitignore/blob/main/Terraform.gitignore)

---

*Agar helpful laga toh video ko Like karo, channel Subscribe karo — aur GitHub pe Star dena mat bhoolo!*
⭐ [github.com/techopshubofficial/terraform-series](https://github.com/techopshubofficial/terraform-series)
