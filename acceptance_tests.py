import unittest
from unittest.mock import patch, MagicMock
import responses
import sys
import os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from jira_sync_service import JiraService

class TestJiraService(unittest.TestCase):
    @responses.activate
    def test_fetch_projects(self):
        service = JiraService("https://test.com", "user", "key")
        responses.add(
            responses.GET,
            "https://test.com/rest/api/2/project",
            json=[{"id": "1", "name": "Test"}],
            status=200
        )
        result = service.fetch_projects()
        self.assertEqual(len(result), 1)
        self.assertEqual(result[0]["name"], "Test")

if __name__ == "__main__":
    unittest.main()
