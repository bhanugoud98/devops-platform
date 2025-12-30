# Incident Post-Mortem: Payment Service Outage

**Date:** 2024-12-30
**Severity:** SEV-1 (Critical)
**Duration:** 25 Minutes (10:00 AM - 10:25 AM UTC)
**Authors:** DevOps Team

## 1. Executive Summary
At 10:00 AM UTC, the `payments-service` began returning HTTP 500 errors for 100% of traffic.
The incident was caused by a malformed ConfigMap deployed to the Production cluster.
Service was restored by rolling back the deployment to the previous stable version.

## 2. Impact
*   **User Impact:** Customers could not process payments.
*   **Revenue Impact:** Estimated $5,000 lost transaction volume.
*   **Support Impact:** 45 tickets logged within 20 minutes.

## 3. Timeline
*   **10:00 AM:** Deploy pipeline completes for `release-v1.2.0`.
*   **10:01 AM:** CloudWatch Alarm `High-5xx-Error-Rate` triggers (State: ALARM).
*   **10:03 AM:** PagerDuty pages the On-Call Engineer (You).
*   **10:05 AM:** Engineer acknowledges page and joins Bridge Call.
*   **10:08 AM:** Engineer attempts to restart pods. Issue persists.
*   **10:12 AM:** Engineer identifies logs showing `KeyError: 'DB_HOST'` in the application.
*   **10:15 AM:** Decision made to Rollback to `v1.1.0`.
*   **10:18 AM:** Rollback complete. Error rate drops to 0%.
*   **10:25 AM:** Incident marked Resolved.

## 4. Root Cause Analysis (5 Whys)
*   **Why did the service fail?** It couldn't connect to the database.
*   **Why?** The `DB_HOST` environment variable was missing.
*   **Why?** The ConfigMap for `payments-service` was updated with a typo (`DBHOST` instead of `DB_HOST`).
*   **Why?** The deployment pipeline successfully applied the bad YAML.
*   **Why?** The pipeline only checks for *Syntactic* Validity (valid YAML), not *Schema* Validity (correct keys for the app).

**Root Cause:** Lack of Schema Validation in the CD Pipeline allowed a semantic config error to reach Production.

## 5. Action Items (Prevention)
| Action Item | Type | Owner | Priority | Ticket |
| :--- | :--- | :--- | :--- | :--- |
| Add `kubectl apply --dry-run=server` to CD pipeline | Prevent | DevOps | P1 | OPS-101 |
| Create "Smoke Test" stage in CD to verify `/health` after deploy | Detect | DevOps | P1 | OPS-102 |
| Implement JSON Schema validation for ConfigMaps | Prevent | Dev | P2 | DEV-205 |

## 6. Lessons Learned
*   **What went well?** Alerting was instant. Rollback execution was fast (< 3 mins).
*   **What went poorly?** We spent 5 minutes restarting pods hoping it would fix itself (Hope is not a strategy).
