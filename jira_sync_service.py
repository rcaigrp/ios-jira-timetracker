import requests
import json
import os

class JiraService:
    def __init__(self, base_url, username, api_key):
        self.base_url = base_url
        self.username = username
        self.api_key = api_key
        self.data = []

    def get_dashboard_state(self):
        return "ready"

    def save_entry(self, entry):
        self.data.append(entry)
        return True

    def validate_credentials(self, username, api_key):
        return bool(username and api_key)

    def fetch_projects(self):
        url = f"{self.base_url}/rest/api/project"
        try:
            resp = requests.get(url, auth=(self.username, self.api_key))
            resp.raise_for_status()
            return resp.json()
        except Exception:
            return []