# EP03 — Terraform Remote State: S3 Backend + DynamoDB Locking

**Terraform Series** | Episode 3 | Practical DevOps by [TechOps Hub](https://www.youtube.com/@TECHOPSHUBOFFICIAL)

## 🎬 Watch on YouTube

[![YouTube](https://img.shields.io/badge/YouTube-EP03%20WATCH%20NOW-red?style=for-the-badge&logo=youtube)](https://youtu.be/shEQpX30rpI)
[![GitHub](https://img.shields.io/badge/GitHub-terraform--series-black?style=for-the-badge&logo=github)](https://github.com/mohitthakur3/terraform-series)

## Is Episode Mein Kya Seekhoge

- Local state ka kya problem hai team mein
- Remote state kya hota hai aur kyun zaroori hai
- S3 bucket se state kaise store karte hain
- DynamoDB se state locking kaise kaam karti hai
- `terraform init` se local state ko S3 pe migrate karna
- Live demo: DynamoDB mein LockID entry aana aur jaana

---

## Series Navigation

| Episode | Topic | Link |
|---|---|---|
| EP01 | Installation + S3 Bucket | [Watch](https://www.youtube.com/@TECHOPSHUBOFFICIAL) |
| EP02 | Terraform State File Deep Dive | [Watch](https://www.youtube.com/@TECHOPSHUBOFFICIAL) |
| **EP03** | **Remote State: S3 + DynamoDB** | **You are here** |
| EP04 | Terraform Modules | [Watch](https://youtu.be/x1NDBmaqf8s) |

---

How teams store Terraform state remotely in S3 so everyone shares the same state — and how DynamoDB locking prevents two engineers from corrupting it at the same time.

---

## The Problem with Local State

```
Engineer A: terraform apply  ──┐
                                ├──  two different local state files = drift + corruption
Engineer B: terraform apply  ──┘
```

**Fix:** store state in one shared place (S3) and lock it while someone is applying.

---

## How It Works (Terraform 1.10+)

```
terraform apply
    │
    ├── 1. writes  ep03/terraform.tfstate.tflock   ← lock (other engineers blocked)
    ├── 2. reads   ep03/terraform.tfstate           ← current state
    ├── 3. applies changes to AWS
    ├── 4. writes  ep03/terraform.tfstate           ← updated state
    └── 5. deletes ep03/terraform.tfstate.tflock    ← lock released
```

No DynamoDB needed — S3 handles locking natively via a `.tflock` file (Terraform >= 1.10).

---

## What Gets Created

| Resource | Purpose |
|---|---|
| S3 bucket | Stores all `.tfstate` files |
| Public access block | State files must never be public |
| Versioning | Restore any previous state version if corrupted |
| Encryption (AES-256) | State contains sensitive resource details |

---

## Step-by-Step

### Step 1 — Copy vars file

```bash
cd ep03-remote-state
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` → set `state_bucket_name` to something globally unique.

### Step 2 — Init

```bash
terraform init
```

### Step 3 — Plan (read-only)

```bash
terraform plan
```

Expect **4 resources to add** (S3 bucket + public access block + versioning + encryption).

### Step 4 — Apply (creates the S3 bucket)

```bash
terraform apply
```

Note the `backend_config` output — you'll need it next.

### Step 5 — Uncomment backend block in main.tf

Open `main.tf` and uncomment the `backend "s3"` block. Fill in your bucket name:

```hcl
backend "s3" {
  bucket       = "techops-hub-terraform-state-2026"
  key          = "ep03/terraform.tfstate"
  region       = "us-east-1"
  profile      = "techops-demo"
  use_lockfile = true
  encrypt      = true
}
```

### Step 6 — Re-init to migrate local state → S3

```bash
terraform init
```

Terraform will prompt:
```
Do you want to copy existing state to the new backend? yes
```

Type `yes`. Local state migrates to S3.

### Step 7 — Verify

**S3 Console:** open bucket → see `ep03/terraform.tfstate` and `ep03/terraform.tfstate.tflock` (lock file appears briefly during apply).

**Run plan** — state is now read from S3:
```bash
terraform plan
```

---

## Cleanup (after recording)

S3 bucket must be empty before destroy:

```bash
# 1. Comment out the backend block in main.tf
# 2. Pull state back to local
terraform init -migrate-state

# 3. Empty the bucket
aws s3 rm s3://<your-bucket-name> --recursive --profile techops-demo

# 4. Destroy
terraform destroy
```

---

## Key Concepts

**Why versioning on the state bucket?**
Every `terraform apply` overwrites the state file. With versioning, you can restore a previous version if state is accidentally corrupted or deleted.

**Why encrypt the state bucket?**
State files contain resource IDs, internal IPs, database endpoints — information you don't want exposed. AES-256 at rest, `encrypt = true` in backend for in-transit encryption.

**Why `use_lockfile` instead of DynamoDB?**
Terraform 1.10+ added native S3 locking. A `.tflock` object is created in S3 before each operation and deleted after. Simpler — no extra AWS service to manage. (Older Terraform versions used DynamoDB for this.)

**One bucket, many projects:**
The `key` in backend config is the S3 path. One bucket can hold state for every project:
```
my-company-terraform-state/
├── ep03/terraform.tfstate
├── ep04/terraform.tfstate
├── production-vpc/terraform.tfstate
└── prod-eks-cluster/terraform.tfstate
```

---

## File Structure

```
ep03-remote-state/
├── main.tf                    # provider + backend config (commented until Step 5)
├── variables.tf               # input variables
├── s3.tf                      # S3 state bucket
├── outputs.tf                 # bucket name + ready-to-use backend config snippet
├── terraform.tfvars.example   # copy to terraform.tfvars
└── README.md
```
