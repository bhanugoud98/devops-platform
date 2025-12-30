# Phase 6: Terraform - Infrastructure as Code

> **Objective:** Define our infrastructure in text files so we can version, review, and automate it.

## 1. The Holy Grail: `terraform.tfstate`
The most important concept to master.
*   **What is it?** A JSON file that maps your Terraform code to Real World AWS IDs (e.g., `resource "aws_vpc" "main"` -> `vpc-0a1b2c3d`).
*   **Where does it live?**
    *   *Bad:* On your laptop (If you lose your laptop, you lose the infra).
    *   *Bad:* In Git (It contains secrets).
    *   *Good:* **S3 Backend with DynamoDB Locking**.
        *   **S3**: Stores the file securely.
        *   **DynamoDB**: Prevents two engineers from running `terraform apply` at the same time (State Locking).

## 2. Project Structure (Enterprise Standard)
We separate "Blueprints" (Modules) from "Houses" (Environments).

```text
infrastructure/terraform/
├── modules/                 # REUSABLE Code (The Blueprints)
│   └── vpc/
│       ├── main.tf          # The resources (AWS VPC, Subnets)
│       ├── variables.tf     # Inputs (CIDR block, AZs)
│       └── outputs.tf       # Outputs (VPC ID, Subnet IDs)
└── environments/            # REAL Deployments (The Houses)
    └── dev/
        ├── main.tf          # Calls modules/vpc
        ├── provider.tf      # AWS Region setup
        └── terraform.tfvars # "10.0.0.0/16", "us-east-1"
```

## 3. The Workflow
1.  **`terraform init`**: Downloads providers (AWS plugin) and initializes the backend.
2.  **`terraform plan`**: DRY RUN. It compares your Code vs Real World (State). It tells you what it *will* do.
    *   *Green (+)*: Create.
    *   *Yellow (~)*: Modify.
    *   *Red (-)*: Destroy.
3.  **`terraform apply`**: Executes the plan.

## 4. Drift Management
**Scenario:** You created a Security Group with Terraform allowing port 80.
**Drift:** A junior admin manually logs into AWS Console and opens Port 22.
**Fix:** Run `terraform plan`. It will see the extra rule and say: "I need to remove this to match the code." -> `terraform apply` removes the manual change.
**Lesson:** Terraform enforces the state.

## 5. Work Execution Plan
1.  **Create Module:** `modules/vpc`.
2.  **Create Environment:** `environments/dev`.
3.  **Simulate:** Since we don't have AWS credentials, we will run `terraform init` and `terraform validate` to prove the code is syntactically correct.

**Key Takeaway for Interviews:**
"I structure Terraform into Modules and Environments to ensure DRY (Don't Repeat Yourself) code. I always use Remote State with S3 and DynamoDB to prevent state corruption when working in a team."
