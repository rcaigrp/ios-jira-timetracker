import requests
from typing import List, Dict, Optional

class JiraSyncService:
    def __init__(self, base_url: str, username: str, api_key: str):
        self.base_url = base_url.rstrip('/')
        self.username = username
        self.api_key = api_key
        self.session = requests.Session()
        self.session.auth = (username, api_key)
        self.session.headers.update({'Content-Type': 'application/json'})

    def validate_credentials(self) -> bool:
        try:
            response = self.session.get(f"{self.base_url}/rest/api/client/notifications")
            return response.status_code == 200
        except requests.RequestException:
            return False

    def fetch_projects(self) -> List[Dict]:
        try:
            response = self.session.get(f"{self.base_url}/rest/api/latest/project")
            response.raise_for_status()
            return response.json()
        except requests.RequestException:
            return []
