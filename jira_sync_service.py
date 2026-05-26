import requests

class JiraSyncService:
    def __init__(self, base_url, username, api_key):
        self.base_url = base_url
        self.username = username
        self.api_key = api_key
        self.auth = (username, api_key)

    def get_projects(self):
        url = f"{self.base_url}/rest/api/latest/project"
        response = requests.get(url, auth=self.auth)
        response.raise_for_status()
        return response.json()

    def get_issues(self, project_key):
        url = f"{self.base_url}/rest/api/latest/search"
        params = {"jql": f"project={project_key}"}
        response = requests.get(url, auth=self.auth, params=params)
        response.raise_for_status()
        return response.json()
