from fastapi.testclient import TestClient
import os
from webapp.src.app import app
client = TestClient(app)

def test_get_star_wars_data():
    response = client.get("/data/1")
    assert response.status_code == 200
    assert "name" in response.json()

# Additional test cases can be added by the candidate
def test_root_api():
    # Test case for API HTTP error. For example, fetch a Star Wars character with an ID that doesn't exist.
    response = client.get("/")
    assert response.status_code == 200
    assert "message" in response.json() and response.json()["message"] == os.environ['ROOT_MESSAGE']

def test_data_root_api():
    response = client.get("/data")
    assert response.status_code == 404
    assert "detail" in response.json()

def test_data_not_exist_api():
    response = client.get("/data/invalid")
    assert response.status_code == 422
    assert "detail" in response.json()

def test_data_id_not_int():
    response = client.get("/data/abc")
    assert response.status_code == 422
    assert "detail" in response.json()

def test_bmi_api():
    response = client.get("/top-people-by-bmi")
    assert response.status_code == 200
    assert response.json() != []