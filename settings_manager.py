import json
import os

class SettingsManager:
    def __init__(self, data_file='data/settings.json'):
        self.data_file = data_file
        self.settings = self.load_settings()

    def load_settings(self):
        if os.path.exists(self.data_file):
            with open(self.data_file, 'r') as f:
                return json.load(f)
        return {}

    def save_settings(self):
        os.makedirs(os.path.dirname(self.data_file), exist_ok=True)
        with open(self.data_file, 'w') as f:
            json.dump(self.settings, f)

    def save_credentials(self, base_url, username, api_key):
        self.settings['base_url'] = base_url
        self.settings['username'] = username
        self.settings['api_key'] = api_key
        self.save_settings()

    def get_credentials(self):
        return self.settings.get('base_url'), self.settings.get('username'), self.settings.get('api_key')
