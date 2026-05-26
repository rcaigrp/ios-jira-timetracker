import requests
import urllib.parse
import json

class JiraService:
    def __init__(self, base_url, username, api_key):
        self.base_url = base_url.rstrip('/')
        self.username = username
        self.api_key = api_key
        self.session = requests.Session()
        self.session.auth = (self.username, self.api_key)
        self.session.headers.update({'Content-Type': 'application/json'})

    def validate_credentials(self):
        """Validates credentials by checking a protected endpoint."""
        try:
            url = urllib.parse.urljoin(self.base_url, 'rest/api/1.0/myself')
            response = self.session.get(url)
            if response.status_code in (200, 404): # 404 might mean endpoint exists but user info is restricted, auth is valid
                return True
            if response.status_code in (401, 403):
                return False
            return False
        except Exception:
            return False

    def get_projects(self):
        """Fetches list of projects from Jira."""
        try:
            url = urllib.parse.urljoin(self.base_url, 'rest/api/2/project')
            response = self.session.get(url)
            response.raise_for_status()
            return response.json()
        except requests.exceptions.HTTPError as e:
            raise Exception(f'HTTP Error fetching projects: {e}')
        except Exception as e:
            raise Exception(f'Network Error fetching projects: {e}')
