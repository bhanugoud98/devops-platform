# Phase 2: Application Setup - The "12-Factor" Standard

> **Objective:** Build a microservice that is "Cloud-Native Ready". It must not rely on local files, hardcoded passwords, or specific servers.

## 1. The "Why": Developer vs. DevOps Friction
**Scenario:** A developer gives you a jar file. You deploy it. It crashes because it tried to write to `C:\Logs` (which doesn't exist on Linux) and couldn't find the Database password because it was hardcoded for `localhost`.

**Our Solution:** We will build a **12-Factor App** (The Gold Standard for SaaS).
We will build a **Python Flask Payment API**.

## 2. Key Principles We Will Implement

### A. Config (Factor III)
*   **Bad:** `db_password = "password123"` in code.
*   **Good:** `db_password = os.getenv('DB_PASSWORD')`.
*   **Why:** We can deploy the *exact same code* to Dev, Test, and Prod, just by changing the environment variables in the Deployment config.

### B. Logs (Factor XI)
*   **Bad:** Writing to `/var/log/myapp.log`. (What if the server dies? The logs die with it).
*   **Good:** Write to `STDOUT` (Standard Output).
*   **Real World:** In K8s, a sidecar (Fluentd) picks up everything printed to stdout and sends it to ElasticSearch/Splunk.
*   **Format:** **JSON**. `{"level": "info", "message": "Payment processed", "amount": 100}`. This is machine-parsable.

### C. Disposability (Factor IX)
*   The app should start fast and shut down gracefully (handling SIGTERM signals).

## 3. The Application: `payments-service`
We will build a simple REST API with these endpoints:
*   `GET /health`: Returns 200 OK (For Kubernetes Liveness Probes).
*   `POST /process`: Simulates a payment transaction.
*   `GET /`: Welcome message.

## 4. Work Execution Plan
1.  **Dependencies:** `flask`, `python-dotenv`.
2.  **Code:** `src/app.py`.
3.  **Config:** Use `os.environ`.
4.  **Logging:** Setup Python `logging` to output JSON.

**Key Takeaway for Interviews:**
"I ensure developers follow 12-Factor principles. Specifically, I mandate that configuration is injected via Environment Variables and logs are written to Stdout as JSON, which allows seamless integration with our K8s logging stack."
