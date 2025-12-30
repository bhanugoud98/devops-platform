# Phase 11: Security & Best Practices - DevSecOps

> **Objective:** Security is not an "Add-on" at the end. It is integrated into every phase (Shift Left).

## 1. The "Shift Left" Philosophy
Traditionally, Security Audit happened one week before launch.
**DevSecOps:** Security happens *before* code is merged.
*   **Design Phase:** Threat Modeling.
*   **Code Phase:** IDE Plugins (SonarLint).
*   **Build Phase:** SAST (Static Analysis) & SCA (Dependency Scanning).
*   **Deploy Phase:** DAST (Dynamic Analysis).

## 2. Our Security Layers (Defense in Depth)

### Layer 1: Code Security (SCA)
*   **Tool:** Trivy (Already in Phase 4).
*   **Goal:** Catch `vulnerable-lib-1.0.jar`.
*   **Policy:** Fail build on CRITICAL severity.

### Layer 2: Container Security
*   **User:** `appuser` (Non-root).
*   **Image:** Minimal base image (`slim`).

### Layer 3: Infrastructure Security (AWS & K8s)
*   **IAM:** Least Privilege. `s3:GetObject` (Good) vs `s3:*` (Bad).
*   **Security Groups:** Whitelisting IP/Ports.
*   **Secrets:** Never commit `.env`.

## 3. Secret Rotation Strategy
*   **Problem:** A developer accidentally committed a typo-ed AWS Key.
*   **Reaction:**
    1.  **Revoke** the key immediately in IAM.
    2.  **Rotate** (Create new key).
    3.  **Update** the App Secrets.
    4.  **Audit** logs to see if the leaked key was used.

## 4. Work Execution Plan
1.  Create `trivy.yaml` to formalize our scan policy.
2.  Review our IAM Policy (Mock audit).

**Key Takeaway for Interviews:**
"I view security as an enabler, not a blocker. By automating checks like Trivy and OPA in the pipeline, I give developers confidence that their code is secure without waiting for a manual audit."
