import pytest
import responses
from jira_sync_service import JiraSyncService

class TestJiraSyncService:
    @responses.activate
    def test_fetch_projects(self):
        base_url = "https://test.jira.com"
        service = JiraSyncService(base_url, "user", "key")
        responses.add(
            responses.GET,
            f"{base_url}/rest/api/2/project",
            json=[{"id": "1", "name": "TestProject"}],
            status=200
        )
        projects = service.fetch_projects()
        assert len(projects) == 1
        assert projects[0]["name"] == "TestProject"

    @responses.activate
    def test_fetch_issues(self):
        base_url = "https://test.jira.com"
        service = JiraSyncService(base_url, "user", "key")
        responses.add(
            responses.GET,
            f"{base_url}/rest/api/2/search",
            json={"issues": [{"id": "100", "fields": {"summary": "Test Issue"}}]},
            status=200
        )
        issues = service.fetch_issues("TP")
        assert len(issues) == 1
        assert issues[0]["fields"]["summary"] == "Test Issue"

    @responses.activate
    def test_fetch_projects_fails_on_error(self):
        base_url = "https://test.jira.com"
        service = JiraSyncService(base_url, "user", "key")
        responses.add(
            responses.GET,
            f"{base_url}/rest/api/2/project",
            json={"error": "Unauthorized"},
            status=401
        )
        with pytest.raises(Exception):
            service.fetch_projects()
