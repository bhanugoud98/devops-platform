# Payment Service (Microservice)

This is a **Python Flask** application that simulates a payment processor.
It is designed following **12-Factor App** principles.

## Prerequisites
- Python 3.9+
- `pip`

## Local Development Setup

1.  **Create a Virtual Environment** (Isolate dependencies):
    ```bash
    python -m venv venv
    source venv/bin/activate  # Mac/Linux
    .\venv\Scripts\Activate   # Windows
    ```

2.  **Install Dependencies**:
    ```bash
    pip install -r src/requirements.txt
    ```

3.  **Configure Environment**:
    Create a `.env` file in `application/src/`:
    ```ini
    PORT=5000
    LOG_LEVEL=DEBUG
    ENVIRONMENT=local-dev
    ```

4.  **Run the App**:
    ```bash
    python src/app.py
    ```

## API Endpoints

### 1. Health Check
`GET /health`
Returns `200 OK` if the app is alive. Used by Kubernetes Probes.

### 2. Process Payment
`POST /process`
Simulates a transaction.

**Request:**
```json
{
  "amount": 100.50,
  "currency": "USD",
  "user_id": "user_123"
}
```

## Logging
Logs are output to `stdout` in JSON format for easy ingestion by ELK/Datadog.
