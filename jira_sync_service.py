import requests

class JiraSyncService:
    def __init__(self, base_url, username, api_key):
        self.base_url = base_url
        self.username = username
        self.api_key = api_key

    def fetch_projects(self):
        url = f"{self.base_url}/rest/api/2/project"
        response = requests.get(url, auth=(self.username, self.api_key))
        response.raise_for_status()
        return response.json()
