import requests


class JiraService:
    def __init__(self, base_url, username, api_key):
        self.base_url = base_url.rstrip('/')
        self.username = username
        self.api_key = api_key
        self.session = requests.Session()
        self.session.auth = (username, api_key)
        self.session.headers.update({'Content-Type': 'application/json'})

    def get_projects(self):
        url = f"{self.base_url}/rest/api/2/project"
        response = self.session.get(url)
        response.raise_for_status()
        return response.json()

    def get_issues(self, project_key):
        url = f"{self.base_url}/rest/api/2/search"
        payload = {
            "jql": f"project={project_key}",
            "fields": ["summary", "status", "assignee", "issueKey"]
        }
        response = self.session.post(url, json=payload)
        response.raise_for_status()
        return response.json()

    def validate_credentials(self):
        url = f"{self.base_url}/rest/api/2/myself"
        response = self.session.get(url)
        return response.status_code == 200
