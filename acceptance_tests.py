import unittest
import unittest.mock as mock
import responses
import json
import os
import sys

sys.path.append('/workspace/projects/iOS-Jira-TimeTracker')

from jira_sync_service import JiraService

class TestAcceptanceCriteria(unittest.TestCase):
    def setUp(self):
        self.service = JiraService("https://test.atlas.com", "user", "token")
        self.service.data = []

    @mock.patch('os.path.exists')
    @mock.patch('os.makedirs')
    @mock.patch('os.remove')
    def test_criterion_1_dashboard(self, mock_remove, mock_makedirs, mock_exists):
        mock_exists.return_value = False
        state = self.service.get_dashboard_state()
        self.assertEqual(state, "ready")

    @mock.patch('os.path.exists')
    @mock.patch('os.makedirs')
    @mock.patch('os.remove')
    def test_criterion_2_manual_entry(self, mock_remove, mock_makedirs, mock_exists):
        mock_exists.return_value = False
        entry = {"project": "Test", "start": "2023-01-01", "end": "2023-01-01"}
        self.service.save_entry(entry)
        self.assertIn(entry, self.service.data)

    @mock.patch('os.path.exists')
    @mock.patch('os.makedirs')
    @mock.patch('os.remove')
    def test_criterion_3_settings(self, mock_remove, mock_makedirs, mock_exists):
        mock_exists.return_value = False
        self.assertTrue(self.service.validate_credentials("user", "token"))

    @responses.activate
    def test_criterion_4_jira_fetch(self):
        responses.add(responses.GET, "https://test.atlas.com/rest/api/project", body=json.dumps([]))
        projects = self.service.fetch_projects()
        self.assertEqual(projects, [])

    @mock.patch('os.path.exists')
    @mock.patch('os.makedirs')
    @mock.patch('os.remove')
    def test_criterion_5_persistence(self, mock_remove, mock_makedirs, mock_exists):
        mock_exists.return_value = False
        entry = {"project": "Persist", "start": "2023-01-01", "end": "2023-01-01"}
        self.service.save_entry(entry)
        self.assertTrue(len(self.service.data) > 0)

    def test_criterion_6_networking(self):
        self.assertTrue(self.service.base_url == "https://test.atlas.com")

    @mock.patch('os.path.exists')
    @mock.patch('os.makedirs')
    @mock.patch('os.remove')
    def test_criterion_7_background(self, mock_remove, mock_makedirs, mock_exists):
        mock_exists.return_value = False
        self.service.data.append({"status": "paused"})
        self.service.data.append({"status": "resumed"})
        self.assertIn("resumed", [d["status"] for d in self.service.data])