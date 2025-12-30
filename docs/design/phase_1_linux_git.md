# Phase 1: Linux & Git - The Production Foundation

> **Objective:** Set up the workspace and standards exactly how a Principal DevOps Engineer would for a new bank or startup project.

## 1. The "Golden" Directory Structure
In a real enterprise, chaos usually starts with "Where isn't the Terraform code?" or "Why is the app code mixed with shell scripts?".
We will enforce this structure:

```text
devops-platform/
├── .github/              # CI/CD Pipelines (GitHub Actions)
├── application/          # Source Code (The Microservice)
│   ├── src/
│   ├── Dockerfile
│   └── tests/
├── infrastructure/       # Infrastructure as Code
│   ├── terraform/        # AWS Provisioning
│   │   ├── modules/
│   │   └── environments/ # dev/prod specific tfvars
│   └── k8s/              # Kubernetes Manifests (YAMLs)
├── scripts/              # Automation Scripts (Bash/Python)
├── docs/                 # Documentation (Runbooks, Diagrams)
└── .gitignore            # Critical for security (never commit secrets)
```

## 2. Linux Production Expectations
Even though you are on Windows, you will write scripts and configs for **Amazon Linux 2023** (our target OS).
Real companies care about:
*   **Non-Root User:** NEVER run apps as root. We will create an `app_user`.
*   **Standard Paths:** Apps go in `/opt/my-app` or `/var/www` or `/usr/local/bin`, NOT `/home/ubuntu`.
*   **Logs:** Logs must go to `/var/log/my-app/` or `stdout` (for containers).
*   **Security:** `chmod 600` for keys, `chmod 755` for scripts.

## 3. Git Strategy (Enterprise Grade)
We will use a simplified **GitFlow** which is standard in 90% of companies.

*   **`main`**: PRODUCTION Ready. Protected branch. No direct commits.
*   **`develop`**: Integration testing. Deploys to Dev/Stage.
*   **`feature/xyz-123`**: Your working branch.
    *   *Naming Convention:* `feature/<jira-ticket>-<short-desc>`
    *   *Example:* `feature/OPS-101-setup-vpc`

## 4. Work Execution Plan
1.  **Create Directory Structure:** We will create the folders above.
2.  **Initialize Git:** `git init`.
3.  **Create .gitignore:** Exclude `.tfstate`, `venv`, `__pycache__`, `.env` (Secrets!).
4.  **Create Setup Script:** `scripts/setup_linux.sh` (We will write this to demonstrate Linux knowledge, even if we don't run it locally).

**Key Takeaway for Interviews:**
"I organize my repository to separate Infrastructure (lifecycle: months) from Application Code (lifecycle: hours). This allows independent versioning and cleaner pipelines."
