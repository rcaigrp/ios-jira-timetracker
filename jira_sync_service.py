import requests
from typing import List, Dict

class JiraService:
    def __init__(self, base_url: str, username: str, api_key: str):
        self.base_url = base_url
        self.username = username
        self.api_key = api_key
        
    def fetch_projects(self) -> List[Dict]:
        url = f"{self.base_url}/rest/api/2/project"
        headers = {
            "Authorization": f"Basic {self.username}:{self.api_key}"
        }
        response = requests.get(url, headers=headers)
        response.raise_for_status()
        return response.json()
