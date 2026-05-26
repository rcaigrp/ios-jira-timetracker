import pytest
import responses
from jira_sync_service import JiraService

class TestJiraService:
    @responses.activate
    def test_fetch_projects(self):
        responses.add(
            responses.GET,
            "https://test.com/rest/api/2/project",
            body='[{"id": "1", "name": "Test Project"}]',
            status=200,
            content_type='application/json'
        )
        
        service = JiraService("https://test.com", "user", "key")
        projects = service.fetch_projects()
        assert len(projects) == 1
        assert projects[0]["name"] == "Test Project"
