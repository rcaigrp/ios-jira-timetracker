import requests

class JiraService:
    def __init__(self, base_url, username, api_key):
        self.base_url = base_url
        self.username = username
        self.api_key = api_key
        self.session = requests.Session()
        self.session.auth = (username, api_key)
        self.session.headers.update({'Content-Type': 'application/json'})

    def fetch_projects(self):
        url = f"{self.base_url}/rest/api/2/project"
        response = self.session.get(url)
        response.raise_for_status()
        return response.json()

    def fetch_issues(self, project_key):
        url = f"{self.base_url}/rest/api/2/search"
        payload = {"jql": f"project={project_key}"}
        response = self.session.post(url, json=payload)
        response.raise_for_status()
        return response.json()
