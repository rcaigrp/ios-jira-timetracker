import pytest
import responses
from jira_sync_service import JiraSyncService

class TestJiraSyncService:
    BASE_URL = "https://test.jira.com"
    USERNAME = "testuser"
    API_KEY = "testkey"

    @responses.activate
    def test_criterion_3_validate_credentials_success(self):
        responses.add(
            responses.GET,
            f"{self.BASE_URL}/rest/api/client/notifications",
            body="{}",
            status=200
        )
        service = JiraSyncService(self.BASE_URL, self.USERNAME, self.API_KEY)
        assert service.validate_credentials() is True

    @responses.activate
    def test_criterion_3_validate_credentials_failure(self):
        responses.add(
            responses.GET,
            f"{self.BASE_URL}/rest/api/client/notifications",
            body="{}",
            status=401
        )
        service = JiraSyncService(self.BASE_URL, self.USERNAME, self.API_KEY)
        assert service.validate_credentials() is False

    @responses.activate
    def test_criterion_4_fetch_projects_success(self):
        mock_projects = [
            {"id": "123", "name": "Project A"},
            {"id": "456", "name": "Project B"}
        ]
        responses.add(
            responses.GET,
            f"{self.BASE_URL}/rest/api/latest/project",
            json=mock_projects,
            status=200
        )
        service = JiraSyncService(self.BASE_URL, self.USERNAME, self.API_KEY)
        projects = service.fetch_projects()
        assert len(projects) == 2
        assert projects[0]["name"] == "Project A"

    @responses.activate
    def test_criterion_6_networking_error_handling(self):
        responses.add(
            responses.GET,
            f"{self.BASE_URL}/rest/api/latest/project",
            body="Internal Server Error",
            status=500
        )
        service = JiraSyncService(self.BASE_URL, self.USERNAME, self.API_KEY)
        projects = service.fetch_projects()
        assert projects == []
