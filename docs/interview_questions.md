# DevOps Interview Questions & Answers

> **Be ready to explain specific decisions made in this project.**

## 1. "Walk me through your CI/CD pipeline."
**Answer:**
"I built a pipeline using GitHub Actions with 4 stages:
1.  **CI:** Triggers on push. Runs `pytest` and linter to ensure code quality.
2.  **Security:** Runs `trivy` fs scan. If high-severity CVEs are found, the build fails immediately.
3.  **Build:** Builds the Docker image (Multi-stage) and pushes to the registry tagged with the Git SHA.
4.  **CD:** Deploys to Dev automatically. Deploys to Prod only after manual approval, updating the Kubernetes deployment image."

## 2. "Why do you use Terraform State Management?"
**Answer:**
"Terraform is stateful. It needs to know which real-world resource maps to which code block. I store the state in **S3** (encrypted) for durability and use **DynamoDB** for locking. This prevents race conditions where two engineers might try to modify the infra simultaneously."

## 3. "How do you handle Secrets in Kubernetes?"
**Answer:**
"I never commit secrets to Git. In this project, I demonstrated using **Kubernetes Secrets** (Base64 encoded). In a real enterprise scenario, I would recommend integrating **HashiCorp Vault** or **AWS Secrets Manager** with the ExternalSecrets operator to inject secrets directly into pods at runtime."

## 4. "Your server is running slow. How do you debug?"
**Answer:**
"I follow the USE method (Utilization, Saturation, Errors).
1.  Check **CloudWatch** metrics for CPU/Memory spikes.
2.  Check **Logs** (Application logs for errors, System logs for OOM kills).
3.  If it's a specific pod, I use `kubectl top pod` and `kubectl logs`.
4.  I check if a neighbor pod is hogging resources (Noisy Neighbor problem)."

## 5. "What is the difference between a Security Group and NACL?"
**Answer:**
"Security Groups are **Stateful** (return traffic is automatically allowed) and apply to the Instance level. NACLs are **Stateless** (you must explicitly allow return traffic) and apply to the Subnet level. I mostly use SGs for granular control."
