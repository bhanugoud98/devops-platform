# Phase 3: Docker - Production Containerization

> **Objective:** Package our application into an immutable artifact (Docker Image) that can run anywhere.

## 1. Dockerfile Best Practices (The "Why")
Most tutorials write bad Dockerfiles. In Production, we care about:

1.  **Image Size:** Smaller images = Faster scaling and lower storage costs.
    *   *Solution:* **Multi-Stage Builds**. We use a big image to build (if needed) and a tiny image (Alpine/Slim) to run.
2.  **Security:**
    *   *Rule:* **NEVER run as ROOT**. If a hacker breaks into the container, they have root inside (which can escape to the host).
    *   *Solution:* Create a specific user (`appuser`).
3.  **Reproducibility:**
    *   *Bad:* `FROM python:latest` (This changes daily).
    *   *Good:* `FROM python:3.9-slim-bullseye` (Pinned version).
4.  **Caching (Layer Optimization):**
    *   Docker caches layers. Things that change least often (OS, Dependencies) should be at the top. Code (which changes most) should be at the bottom.

## 2. The Build Strategy
We will use a **Multi-Stage Build** (even for Python, it helps with venvs and cleanup).

*   **Stage 1: Builder**
    *   Install compilers (gcc) if needed for some Python libs.
    *   Install pip packages into a `venv`.
*   **Stage 2: Runner**
    *   Copy the `venv` from Builder.
    *   Copy the App Code.
    *   Set the `USER`.
    *   Define the `CMD`.

## 3. Versioning Strategy (Tagging)
How do we track releases?
*   **`latest` tag**: DANGEROUS in prod. "Latest" changes.
*   **Semantic Versioning**: `v1.0.0`, `v1.0.1`.
*   **Git SHA**: `git-a1b2c3d`. (Best for tracing back to code).
*   **Strategy**: We tag with **BOTH**.
    *   `payments-service:v1.0.0`
    *   `payments-service:a1b2c3d`

## 4. Common Production Issues
*   **PID 1 (Zombie Processes):** If Python runs as PID 1, it might not handle signals (SIGTERM) correctly.
    *   *Fix:* Use `CMD ["python", "app.py"]` (exec form) or a supervisor like `tini` (built into docker now via `--init`).

## 5. Work Execution Plan
1.  **Create `.dockerignore`**: Don't copy `venv`, `.env` or `__pycache__` into the image!
2.  **Create `Dockerfile`**: The blueprint.
3.  **Build**: `docker build -t payments-service:v1 .`
4.  **Run**: `docker run -p 5000:5000 payments-service:v1`

**Key Takeaway for Interviews:**
"I optimize Dockerfiles for layer caching and security. I always use multi-stage builds to strip build dependencies, and I enforce a non-root user for execution to minimize the attack surface."
