import unittest
import json
import os
import time
import responses
import sys
sys.path.insert(0, '/workspace/projects/iOS-Jira-TimeTracker')

from TimerManager import TimerManager
from jira_sync_service import JiraSyncService

class TestTimerManager(unittest.TestCase):
    def setUp(self):
        self.manager = TimerManager()
        # Ensure clean state for tests
        self.manager.running = False
        self.manager.start_time = None
        self.manager.elapsed = 0
        self.manager.project = ""
        self.manager.should_resume = False
        self.manager.save_state()

    def tearDown(self):
        # Cleanup
        if os.path.exists(self.manager.state_file):
            os.remove(self.manager.state_file)

    def test_timer_persistence(self):
        # Start timer
        self.manager.start_timer("TestProject")
        time.sleep(0.1) # Small delay
        # Save state (simulated by calling start which saves)
        # Simulate restart
        manager2 = TimerManager()
        self.assertTrue(manager2.running)
        self.assertEqual(manager2.project, "TestProject")
        self.assertIsNotNone(manager2.start_time)

    def test_background_suspension(self):
        self.manager.start_timer("TestProject")
        time.sleep(0.1)
        # Simulate suspend
        self.manager.handle_background_suspend()
        # Check state
        self.assertFalse(self.manager.running)
        self.assertEqual(self.manager.should_resume, True)
        self.assertGreaterEqual(self.manager.elapsed, 0.1)

    def test_foreground_resume(self):
        self.manager.start_timer("TestProject")
        time.sleep(0.1)
        self.manager.handle_background_suspend()
        # Simulate resume
        self.manager.handle_foreground_resume()
        self.assertTrue(self.manager.running)
        self.assertEqual(self.manager.should_resume, False)

    def test_stop_timer(self):
        self.manager.start_timer("TestProject")
        time.sleep(0.1)
        elapsed = self.manager.stop_timer()
        self.assertFalse(self.manager.running)
        self.assertGreaterEqual(elapsed, 0.1)

class TestJiraSyncService(unittest.TestCase):
    @responses.activate
    def test_get_projects(self):
        base_url = "https://test.jira.com"
        username = "user"
        api_key = "key"
        service = JiraSyncService(base_url, username, api_key)
        
        mock_response = [{"id": "1", "name": "Project 1"}]
        responses.add(
            responses.GET,
            f"{base_url}/rest/api/2/project",
            body=json.dumps(mock_response),
            status=200
        )
        
        projects = service.get_projects()
        self.assertEqual(projects, mock_response)

if __name__ == '__main__':
    unittest.main()
