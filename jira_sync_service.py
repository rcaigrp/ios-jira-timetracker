import requests

class JiraSyncService:
    def __init__(self, base_url, username, api_key):
        self.base_url = base_url
        self.username = username
        self.api_key = api_key
        self.auth = (username, api_key)

    def fetch_projects(self):
        url = f"{self.base_url}/rest/api/2/project"
        response = requests.get(url, auth=self.auth)
        response.raise_for_status()
        return response.json()

    def fetch_issues(self, project_key):
        url = f"{self.base_url}/rest/api/2/issue?jql=project={project_key}"
        response = requests.get(url, auth=self.auth)
        response.raise_for_status()
        return response.json()

    def save_credentials(self, credentials):
        self.username = credentials['username']
        self.api_key = credentials['api_key']
        self.auth = (self.username, self.api_key)

    def get_credentials(self):
        return {
            'username': self.username,
            'api_key': self.api_key
        }
