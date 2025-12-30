# Phase 0: Project Understanding & Architecture Foundation

> **Objective:** Establish the detailed "Why", "What", and "How" of our Enterprise Cloud-Native Platform before writing a single line of code. This mimics the "Design & Planning" phase in a real company.

## 1. The Business Problem (Real World Scenario)
A fintech startup "FinTechCorp" currently deploys their payment processing microservice manually.
*   **Pain Points:**
    *   Deployments take 2 hours (copying jars to servers manually).
    *   "It works on my machine" bugs happen weekly.
    *   Server configurations drift (Dev server has different libs than Prod).
    *   No automatic scaling during Black Friday traffic.
    *   Security audits failing due to manual key management.

*   **Our Job (The DevOps Solution):**
    *   Build a **Self-Healing, Automated Platform**.
    *   **Goal:** "Commit to Production in 15 minutes" (safely).
    *   **Deliverable:** A fully automated pipeline where a developer pushes code, and it runs API tests, security scans, and deploys to a Kubernetes cluster on AWS without human intervention.

## 2. Methodology: The DevOps Lifecycle
We will map our tools to the standard lifecycle:

1.  **PLAN:** Jira/Confluence (We simulate this with `task.md` and this doc).
2.  **CODE:** Git (GitHub).
3.  **BUILD:** Docker (Containerization).
4.  **TEST:** PyTest/GoTest (Unit tests) + Trivy (Security scan).
5.  **RELEASE (CI):** GitHub Actions.
6.  **DEPLOY (CD):** GitHub Actions -> AWS EKS.
7.  **OPERATE:** Kubernetes (Self-healing).
8.  **MONITOR:** CloudWatch/Grafana.

## 3. High-Level Architecture Strategy

### A. Infrastructure Layer (The Foundation)
*   **Provider:** **AWS** (Market leader, requires knowledge for 80% of DevOps jobs).
*   **Provisioning:** **Terraform** (Infrastructure as Code). We will not click buttons in the AWS Console.
    *   *Why?* Reproducibility. We can destroy and recreate Prod in minutes.
*   **Networking:** Custom **VPC** with Public/Private subnets.
    *   *Real World Rule:* Databases and Apps never go in Public subnets. Only Load Balancers (ALBs) or Bastions do.

### B. Application Layer (The Workload)
*   **Compute:** **Kubernetes (EKS)**.
    *   *Why?* Industry standard for container orchestration. Handles scaling and self-healing automatically.
*   **App Format:** **Docker Containers**.
    *   *Why?* Immutable infrastructure. The exact same binary runs in Dev and Prod.

### C. Pipeline Layer (The Factory)
*   **Tool:** **GitHub Actions**.
    *   *Why?* Seamless integration with code. No need to maintain a separate Jenkins server (modern trend).
*   **Flow:**
    1.  Feature Branch Push -> Run Unit Tests.
    2.  Merge to Develop -> Deploy to Dev Cluster.
    3.  Merge to Main -> Deploy to Prod Cluster (with manual approval gate).

## 4. Tool Selection: The "Why" Interview Answers

| Tool | Why this one? | Interview Answer |
| :--- | :--- | :--- |
| **Linux** | The OS of the Internet. | "I use Linux because I need granular control over kernel namespaces for containers and systemd for process management." |
| **Git** | Distributed Version Control. | "Git allows my team to work in parallel using Feature Branches, ensuring Main is always deployable." |
| **Docker** | Isolation & Portability. | "It eliminates environment drift. I package the OS libs with the app." |
| **Kubernetes** | Orchestration. | "Docker runs the container; K8s manages the lifecycle, scaling, and networking across multiple nodes." |
| **Terraform** | IaC. | "It manages the state of my infrastructure. I can see exactly what changed before verifying with `terraform plan`." |
| **Ansible** | Config Management. | "While Terraform builds the 'house' (servers), Ansible arranges the 'furniture' (conf files, agents) inside it. (Though with K8s, usage is lower)." |

## 5. A "Day in the Life" of this Project
Throughout this project, you are **NOT** a student. You are a **Site Reliability Engineer (SRE)**.

**Your Daily Routine:**
1.  **Check Tickets (Task list):** What is blocked?
2.  **Write Code (IaC/App):** VS Code is your hammer.
3.  **Test Locally:** Docker Desktop / Minikube.
4.  **Push & Pray (Just kidding, Push & Verify):** Watch the pipeline green-light your work.
5.  **Debug Logs:** `kubectl logs`, CloudWatch.

## 6. Phase 0 Deliverables Check
- [x] Understanding the problem (Manual vs Automated).
- [x] Architecture defined (AWS + K8s + Terraform + GitHub Actions).
- [x] Mindset shifted to "Production First".

**Ready to proceed to Phase 1: Linux & Git Setup.**
