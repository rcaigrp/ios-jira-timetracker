import requests
import os

class JiraService:
    def __init__(self, base_url: str, username: str, api_key: str):
        self.base_url = base_url.rstrip('/')
        self.username = username
        self.api_key = api_key

    def get_headers(self):
        return {
            'Authorization': f'Bearer {self.api_key}',
            'Content-Type': 'application/json'
        }

    def fetch_projects(self):
        url = f'{self.base_url}/rest/api/2/project'
        try:
            response = requests.get(url, headers=self.get_headers())
            response.raise_for_status()
            return response.json()
        except requests.exceptions.HTTPError as e:
            raise Exception(f'HTTP Error: {e}')
        except Exception as e:
            raise Exception(f'Network Error: {e}')

    def fetch_issues(self, project_key: str):
        url = f'{self.base_url}/rest/api/2/search'
        params = {
            'jql': f'project={project_key}'
        }
        try:
            response = requests.get(url, headers=self.get_headers(), params=params)
            response.raise_for_status()
            return response.json()
        except requests.exceptions.HTTPError as e:
            raise Exception(f'HTTP Error: {e}')
        except Exception as e:
            raise Exception(f'Network Error: {e}')
