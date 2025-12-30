import pytest
from app import app
import json

@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_health_check(client):
    """Test the health check endpoint."""
    response = client.get('/health')
    assert response.status_code == 200
    assert response.json['status'] == 'healthy'

def test_process_payment_success(client):
    """Test a valid payment transaction."""
    payload = {
        "amount": 50.00,
        "currency": "USD",
        "user_id": "test_user"
    }
    response = client.post('/process', 
                           data=json.dumps(payload),
                           content_type='application/json')
    
    assert response.status_code == 200
    data = response.json
    assert data['status'] == 'success'
    assert data['amount'] == 50.00
    assert 'transaction_id' in data

def test_process_payment_missing_fields(client):
    """Test invalid request handling."""
    payload = {"currency": "USD"} # Missing amount
    response = client.post('/process', 
                           data=json.dumps(payload),
                           content_type='application/json')
    
    assert response.status_code == 400
    assert "error" in response.json
