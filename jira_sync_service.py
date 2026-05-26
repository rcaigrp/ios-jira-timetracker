import requests

class JiraService:
    def __init__(self, base_url, username, api_key):
        self.base_url = base_url
        self.username = username
        self.api_key = api_key
        
    def fetch_projects(self):
        url = f"{self.base_url}/rest/api/project"
        headers = {"Authorization": f"Bearer {self.api_key}"}
        response = requests.get(url, headers=headers)
        return response.json()
    
    def fetch_issues(self):
        url = f"{self.base_url}/rest/api/issue"
        headers = {"Authorization": f"Bearer {self.api_key}"}
        response = requests.get(url, headers=headers)
        return response.json()
