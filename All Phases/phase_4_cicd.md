# Phase 4: CI/CD with GitHub Actions

> **Objective:** Build a "Factory" that turns code into running applications automatically and safely.

## 1. The Pipeline Architecture
A robust DevOps pipeline has 4 distinct stages. We will implement them all in a single YAML workflow.

### Stage 1: Continuous Integration (CI) - "The Quality Gate"
*   **Trigger:** Push to any branch.
*   **Steps:**
    1.  **Checkout Code:** Get the latest commit.
    2.  **Unit Tests:** Run `pytest`. If this fails, STOP.
    3.  **Linting:** Check for messy code (Flake8).

### Stage 2: Security (DevSecOps) - "The Safety Gate"
*   **Tool:** **Trivy** (Aqua Security).
*   **Action:** Scan the *File System* for vulnerabilities in dependencies (checking `requirements.txt` against CVE databases).
*   **Rule:** If a "High" or "Critical" vulnerability is found, fail the build.

### Stage 3: Build & Publish - "The Artifact"
*   **Trigger:** Only on `push` to `main` or `develop`.
*   **Steps:**
    1.  **Login to DockerHub/ECR** (Simulated).
    2.  **Build Docker Image**: Use the Dockerfile from Phase 3.
    3.  **Push Image**: Tag with `${{ github.sha }}`.

### Stage 4: Continuous Deployment (CD) - "The Release"
*   **Environment Strategy:**
    *   **Dev:** Deploys automatically on merge to `develop`.
    *   **Prod:** Deploys on merge to `main`, but waits for **Manual Approval** (simulated via Environments protection rules).

## 2. GitHub Actions vs Jenkins
*   **Jenkins:** Old school, requires managing a master/agent server. Groovy scripts are hard to debug.
*   **GitHub Actions:** Modern, SaaS, YAML-based, integration with the repo.
    *   *Interview Note:* "I prefer GitHub Actions because the pipeline definition lives right next to the code, and I don't need to patch a Jenkins server."

## 3. Work Execution Plan
1.  **Create Tests:** `application/tests/test_app.py`. (You can't have CI without tests!).
2.  **Create Workflow:** `.github/workflows/ci-cd.yaml`.
3.  **Simulate:** Since we don't have a real GitHub remote to push to, I will verify the *steps* locally (run tests, run build) to prove the pipeline logic works.

**Key Takeaway for Interviews:**
"I build pipeline stages in parallel where possible to save time, but I strictly enforce sequential gating for Security. My pipelines always scan for CVEs before ever building a container."
