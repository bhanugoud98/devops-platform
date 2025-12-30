# Phase 7: Kubernetes - Real Cluster Operations

> **Objective:** Deploy and Manage our application on a container orchestration platform.

## 1. Cluster Architecture (The Brain & The Muscle)
*   **Control Plane (The Boss):**
    *   *API Server:* The front desk. All `kubectl` commands go here.
    *   *Scheduler:* Decides which node a pod goes to.
    *   *Etcd:* The database (stores cluster state).
*   **Worker Nodes (The Workers):**
    *   *Kubelet:* The agent that talks to the Control Plane.
    *   *Kube-proxy:* Handles networking rules.
    *   *Container Runtime:* Docker/Containerd (Runs the app).

## 2. Manifest Strategy (The "State")
We define everything in YAML.

### A. Deployment (`deployment.yaml`)
*   Manages **Pods** (ReplicaSets).
*   **Replicas:** 3 (High Availability).
*   **Strategy:** Rolling Update (Zero Downtime).
*   **Liveness Probe:** Checks `/health`. If fails, K8s kills the pod and starts a new one (Self-Healing).

### B. Service (`service.yaml`)
*   The stable endpoint. Pods die and get new IPs; the Service IP stays static.
*   **Type:** `LoadBalancer` (Open to world) or `ClusterIP` (Internal).

### C. ConfigMap & Secret
*   **ConfigMap:** Non-sensitive data (`LOG_LEVEL`, `ENVIRONMENT`).
*   **Secret:** Sensitive data (`DB_PASSWORD`). *Base64 encoded.*

## 3. Real World Operations

### Self-Healing Scenario
1.  Pod A crashes (OOMKilled).
2.  ReplicaSet sees 2/3 pods are running.
3.  ReplicaSet requests Scheduler to create 1 new pod.
4.  Scheduler finds a Node.
5.  Kubelet starts the pod.
6.  Customer never noticed.

### Rolling Update Scenario
1.  Update Image `v1` -> `v2`.
2.  K8s starts 1 pod of `v2`.
3.  Waits for `readinessProbe` to pass.
4.  Kills 1 pod of `v1`.
5.  Repeats until all are `v2`.

## 4. Troubleshooting (Interview Gold)
*   **Pod Pending?** No resources (CPU/RAM) or Node Taints. -> `kubectl describe pod`
*   **CrashLoopBackOff?** App failing to start. -> `kubectl logs`
*   **Service Unreachable?** Label mismatch. -> Check `selector` in Service vs `labels` in Pod.

## 5. Work Execution Plan
1.  Create `infrastructure/k8s/namespace.yaml`
2.  Create `infrastructure/k8s/configmap.yaml` & `secrets.yaml`
3.  Create `infrastructure/k8s/deployment.yaml`
4.  Create `infrastructure/k8s/service.yaml`
5.  Verify YAML syntax.

**Key Takeaway for Interviews:**
"I use Kubernetes deployments with Liveness/Readiness probes to ensure self-healing. I manage configuration via ConfigMaps and Secrets to decouple the app from the infrastructure, allowing the same container image to run in Dev, Test, and Prod."
