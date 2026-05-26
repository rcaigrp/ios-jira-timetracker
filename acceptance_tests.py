import unittest
import os
import json
import time
import responses
from unittest.mock import patch
from timer_manager import TimerManager
from jira_sync_service import JiraSyncService

class TestTimerManager(unittest.TestCase):
    def setUp(self):
        self.temp_file = "test_timer_data.json"
        if os.path.exists(self.temp_file):
            os.remove(self.temp_file)
        self.manager = TimerManager(self.temp_file)

    def tearDown(self):
        if os.path.exists(self.temp_file):
            os.remove(self.temp_file)

    def test_criterion_2_manual_entry(self):
        res = self.manager.start("Project A")
        assert res['status'] == 'running'
        assert self.manager.running == True
        res = self.manager.pause()
        assert res['status'] == 'paused'
        assert self.manager.running == False
        assert self.manager.should_resume == True

    def test_criterion_5_persistence(self):
        self.manager.start("Project B")
        self.manager.pause()
        new_manager = TimerManager(self.temp_file)
        assert new_manager.running == False
        assert new_manager.should_resume == True
        assert new_manager.project_name == "Project B"
        assert new_manager.elapsed > 0

    def test_criterion_7_background_suspension(self):
        self.manager.start("Project C")
        self.manager.pause()
        res = self.manager.resume()
        assert res['status'] == 'running'
        assert self.manager.running == True
        assert self.manager.should_resume == False

class TestJiraSyncService(unittest.TestCase):
    @responses.activate
    def test_criterion_6_networking(self):
        base_url = "https://testjira.atlassian.net"
        service = JiraSyncService(base_url, "user", "apikey")
        mock_projects = [{"id": "10001", "name": "TestProject"}]
        responses.add(
            responses.GET,
            f"{base_url}/rest/api/2/project",
            json=mock_projects,
            status=200
        )
        projects = service.fetch_projects()
        assert len(projects) == 1
        assert projects[0]['name'] == "TestProject"

    def test_criterion_3_credentials(self):
        service = JiraSyncService("https://test.com", "user", "apikey")
        assert service.base_url == "https://test.com"
        assert service.username == "user"
        assert service.api_key == "apikey"

if __name__ == '__main__':
    unittest.main()
