import os
import logging
import json
import time
from flask import Flask, request, jsonify
from pythonjsonlogger import jsonlogger
from dotenv import load_dotenv

# 1. Load Environment Variables (Local Dev only)
# In Prod, these come from K8s ConfigMaps/Secrets
load_dotenv()

# 2. Setup JSON Logging (12-Factor: Logs as Streams)
logger = logging.getLogger()
logHandler = logging.StreamHandler()
formatter = jsonlogger.JsonFormatter(
    '%(asctime)s %(levelname)s %(message)s %(module)s'
)
logHandler.setFormatter(formatter)
logger.addHandler(logHandler)
logger.setLevel(os.getenv("LOG_LEVEL", "INFO"))

app = Flask(__name__)

# Config
APP_VERSION = os.getenv("APP_VERSION", "1.0.0")
ENVIRONMENT = os.getenv("ENVIRONMENT", "local")

@app.route('/')
def home():
    logger.info("Home endpoint called")
    return jsonify({
        "message": "Welcome to the Payment Service",
        "version": APP_VERSION,
        "environment": ENVIRONMENT
    })

@app.route('/health')
def health():
    # K8s Liveness Probe calls this
    return jsonify({"status": "healthy"})

@app.route('/process', methods=['POST'])
def process_payment():
    start_time = time.time()
    data = request.json
    
    if not data or 'amount' not in data or 'currency' not in data:
        logger.error("Invalid payment request", extra={"payload": data})
        return jsonify({"error": "Invalid request. Amount and Currency required."}), 400

    # Simulate processing
    amount = data['amount']
    # Example logic: logging structured data for observability
    logger.info("Processing payment", extra={
        "amount": amount,
        "currency": data['currency'],
        "user_id": data.get("user_id", "anon")
    })

    # Simulate success
    response = {
        "status": "success",
        "transaction_id": f"txn_{int(time.time())}",
        "amount": amount
    }
    
    duration = time.time() - start_time
    logger.info("Payment processed successfully", extra={"duration": duration, "txn_id": response['transaction_id']})
    
    return jsonify(response), 200

if __name__ == '__main__':
    port = int(os.getenv("PORT", 5000))
    logger.info(f"Starting Payment Service on port {port}")
    app.run(host='0.0.0.0', port=port)
