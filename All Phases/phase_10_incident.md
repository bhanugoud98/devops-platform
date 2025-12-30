# Phase 10: Incident Management - SRE Operations

> **Objective:** When things break (and they will), how do we handle it professionally?

## 1. Severity Levels (The Dictionary)
*   **SEV-1 (Critical):** "We are losing money right now."
    *   *Example:* Payment API returns 500 Errors. Site is down.
    *   *Action:* PagerDuty wakes up the On-Call Engineer. Bridge call started.
*   **SEV-2 (High):** "We are losing some features."
    *   *Example:* Recommended Products widget is broken, but Checkout still works.
    *   *Action:* Alert Slack channel. Fix within today.
*   **SEV-3 (Medium):** "Ideally shouldn't happen."
    *   *Example:* Latency increased by 10% (but still within SLA).
    *   *Action:* Triage during next sprint planning.

## 2. The Golden Rule: "Mitigate, THEN Fix"
*   **Mitigation:** Stop the bleeding. (e.g., Rollback the deployment, Restart the server, Block the traffic). **Goal:** Restore Service.
*   **Resolution:** Fix the actual bug. **Goal:** Prevent recurrence.
*   *Interview Note:* "In a P1, I don't debug code. I roll back. My priority is Up-time, not understanding the bug *during* the outage."

## 3. The "Post-Mortem" (RCA)
After the fire is out, we write a report. It must be **Blameless**.
*   *Bad:* "Bob pushed bad code."
*   *Good:* "The CI pipeline did not catch the syntax error in the config file, allowing bad code to reach Prod."

## 4. The "5 Whys" Technique
Problem: The Database Crashed.
1.  **Why?** It ran out of disk space.
2.  **Why?** Logs filled up the disk.
3.  **Why?** The app was logging in DEBUG mode in Production.
4.  **Why?** A config change passed through CD without validation.
5.  **Why?** We lack a policy to lint config files in CI.
**Root Cause:** Missing CI validation for Config Maps.

## 5. Work Execution Plan
1.  **Simulation:** We will "pretend" that the `payments-service` deployment failed.
2.  **Artifact:** We will write a formal **Post-Mortem Report** (`docs/incident_reports/2023-12-30-payment-outage.md`).

**Key Takeaway for Interviews:**
"I adhere to a blameless culture. I focus on improving *systems* (better tests, better alerts) rather than blaming *people*. Every incident is an opportunity to harden the platform."
