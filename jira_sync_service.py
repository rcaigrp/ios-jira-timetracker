import requests

class JiraSyncService:
    def __init__(self, base_url, username, api_key):
        self.base_url = base_url
        self.username = username
        self.api_key = api_key

    def _get_headers(self):
        return {
            'Authorization': f'Basic {self._encode_credentials()}'
        }

    def _encode_credentials(self):
        import base64
        credentials = f"{self.username}:{self.api_key}"
        return base64.b64encode(credentials.encode()).decode()

    def fetch_projects(self):
        url = f"{self.base_url}/rest/api/2/project"
        response = requests.get(url, headers=self._get_headers())
        response.raise_for_status()
        return response.json()

    def fetch_issues(self, project_key):
        url = f"{self.base_url}/rest/api/2/search"
        payload = {
            'jql': f"project = '{project_key}'"
        }
        response = requests.get(url, headers=self._get_headers(), params=payload)
        response.raise_for_status()
        return response.json()
