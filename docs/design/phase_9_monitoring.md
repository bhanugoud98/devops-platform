# Phase 9: Monitoring & Alerting - "Eyes on Glass"

> **Objective:** Know that the system is broken *before* the customer tweets about it.

## 1. The Strategy: 4 Golden Signals (Google SRE)
We don't just "monitor CPU". We monitor User Experience.

1.  **Latency:** "Is it slow?" (Target: 99% of requests < 200ms).
2.  **Traffic:** "Is it busy?" (Req/sec).
3.  **Errors:** "Is it broken?" (HTTP 5xx rate).
4.  **Saturation:** "Is it full?" (CPU/Memory/Disk usage).

## 2. Layers of Monitoring
*   **Infrastructure (AWS):** EC2 CPU, Disk I/O. (Tool: CloudWatch).
*   **Cluster (K8s):** Node health, Pod restarts. (Tool: Container Insights / Prometheus).
*   **Application (Code):** "Payment Processed", "Payment Failed". (Tool: Our JSON Logs -> CloudWatch Logs).
*   **Business:** "Revenue per hour".

## 3. Alerting Philosophy
*   **P1 (Critical):** Wake me up at 3 AM. (e.g., "Site Down", "Payment Success Rate < 90%").
*   **P3 (Warning):** Send me a ticket/slack message. Check it tomorrow. (e.g., "Disk 80% full", "High Latency on non-critical path").

## 4. The Action Plan (Terraform)
We will use **Infrastructure as Code** to build our Dashboards.
*   *Why?* Because clicking "Create Dashboard" in the console is manual work. If we delete the account, we lose the dashboard.
*   **Resource:** `aws_cloudwatch_dashboard`
*   **Resource:** `aws_cloudwatch_metric_alarm`

## 5. Work Execution Plan
1.  Create `infrastructure/terraform/modules/monitoring/main.tf`.
2.  Define a Dashboard JSON body.
3.  Define a "High CPU" Alarm.

**Key Takeaway for Interviews:**
"I focus on Symptom-based monitoring (Golden Signals) rather than Cause-based monitoring. I alert on 'High Error Rate' (Symptom) rather than 'Database CPU High' (Cause), because High CPU might not actually be impacting users, but High Error Rate definitely is."
