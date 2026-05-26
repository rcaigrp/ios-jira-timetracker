import requests
import json
from typing import List, Dict, Optional

class JiraSyncService:
    def __init__(self, base_url: str, username: str, api_key: str):
        self.base_url = base_url
        self.username = username
        self.api_key = api_key
        self.session = requests.Session()
        self.session.auth = (username, api_key)

    def fetch_projects(self) -> List[Dict]:
        url = f"{self.base_url}/rest/api/3/project"
        response = self.session.get(url)
        response.raise_for_status()
        return response.json()

    def fetch_issues(self, project_key: str) -> List[Dict]:
        jql = f"project = {project_key}"
        url = f"{self.base_url}/rest/api/3/search?jql={jql}"
        response = self.session.get(url)
        response.raise_for_status()
        return response.json().get('issues', [])