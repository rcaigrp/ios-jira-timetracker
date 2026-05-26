import unittest
import os
import json
import time
import responses
import requests
import sys
import pathlib

sys.path.insert(0, '/workspace/projects/iOS-Jira-TimeTracker')

from timer_manager import TimerManager
from jira_sync_service import JiraSyncService
from settings_manager import SettingsManager

class TestTimerManager(unittest.TestCase):
    def setUp(self):
        self.data_file = 'test_timer.json'
        self.manager = TimerManager(self.data_file)

    def tearDown(self):
        if os.path.exists(self.data_file):
            os.remove(self.data_file)

    def test_start_timer(self):
        self.manager.start_timer('Project A')
        self.assertTrue(self.manager.is_running)
        self.assertEqual(self.manager.current_project, 'Project A')

    def test_pause_timer(self):
        self.manager.start_timer('Project A')
        time.sleep(0.01)
        self.manager.pause_timer()
        self.assertFalse(self.manager.is_running)

    def test_resume_timer(self):
        self.manager.start_timer('Project A')
        self.manager.pause_timer()
        self.manager.resume_timer()
        self.assertTrue(self.manager.is_running)

    def test_stop_timer_creates_entry(self):
        self.manager.start_timer('Project A')
        self.manager.stop_timer()
        self.assertEqual(len(self.manager.entries), 1)
        self.assertEqual(self.manager.entries[0]['project'], 'Project A')

    def test_persistence(self):
        self.manager.start_timer('Project A')
        self.manager.stop_timer()
        manager2 = TimerManager(self.data_file)
        self.assertEqual(len(manager2.entries), 1)

class TestJiraSyncService(unittest.TestCase):
    @responses.activate
    def test_fetch_projects(self):
        base_url = "https://test.atlassian.net"
        service = JiraSyncService(base_url, 'user', 'key')
        
        responses.add(
            responses.GET,
            f"{base_url}/rest/api/2/project",
            body=json.dumps([{'id': '1', 'name': 'Test Project'}]),
            status=200
        )
        
        projects = service.fetch_projects()
        self.assertEqual(len(projects), 1)
        self.assertEqual(projects[0]['name'], 'Test Project')

    @responses.activate
    def test_fetch_issues(self):
        base_url = "https://test.atlassian.net"
        service = JiraSyncService(base_url, 'user', 'key')
        
        responses.add(
            responses.GET,
            f"{base_url}/rest/api/2/search",
            body=json.dumps({'issues': [{'id': '1', 'fields': {'summary': 'Test Issue'}}]}),
            status=200
        )
        
        issues = service.fetch_issues('TEST')
        self.assertEqual(len(issues['issues']), 1)

class TestSettingsManager(unittest.TestCase):
    def test_save_credentials(self):
        settings = SettingsManager('test_settings.json')
        settings.save_credentials('https://test.atlassian.net', 'user', 'key')
        self.assertTrue(os.path.exists('test_settings.json'))
        with open('test_settings.json', 'r') as f:
            data = json.load(f)
        self.assertEqual(data['base_url'], 'https://test.atlassian.net')
        self.assertEqual(data['username'], 'user')
        self.assertEqual(data['api_key'], 'key')

if __name__ == '__main__':
    unittest.main()
