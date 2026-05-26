import unittest
import responses
import sys
sys.path.append('/workspace/projects/iOS-Jira-TimeTracker')

from jira_sync_service import JiraSyncService

class TestJiraSyncService(unittest.TestCase):
    def setUp(self):
        self.service = JiraSyncService(
            base_url="https://test.atlassian.net",
            username="testuser",
            api_key="testkey"
        )

    @responses.activate
    def test_fetch_projects(self):
        responses.add(
            responses.GET,
            "https://test.atlassian.net/rest/api/3/project",
            json=[{"id": "10000", "name": "Test Project"}],
            status=200
        )
        projects = self.service.fetch_projects()
        assert len(projects) == 1
        assert projects[0]['name'] == "Test Project"

    @responses.activate
    def test_fetch_issues(self):
        responses.add(
            responses.GET,
            "https://test.atlassian.net/rest/api/3/search",
            json={"issues": [{"id": "1", "fields": {"summary": "Test Issue"}}]},
            status=200
        )
        issues = self.service.fetch_issues("TEST")
        assert len(issues) == 1
        assert issues[0]['fields']['summary'] == "Test Issue"

    @responses.activate
    def test_invalid_credentials(self):
        responses.add(
            responses.GET,
            "https://test.atlassian.net/rest/api/3/project",
            json={"error": "Unauthorized"},
            status=401
        )
        try:
            self.service.fetch_projects()
            assert False, "Expected exception"
        except Exception:
            pass  # Expected failure

if __name__ == '__main__':
    unittest.main()