import pytest
import responses
from jira_sync_service import JiraService

class TestJiraService:
    @responses.activate
    def test_validate_credentials_success(self):
        service = JiraService('https://jira.example.com', 'user', 'key')
        responses.add(
            responses.GET,
            'https://jira.example.com/rest/api/1.0/myself',
            json={'self': 'https://jira.example.com/rest/api/1.0/myself', 'displayName': 'User'},
            status=200
        )
        assert service.validate_credentials() == True

    @responses.activate
    def test_validate_credentials_failure(self):
        service = JiraService('https://jira.example.com', 'user', 'bad_key')
        responses.add(
            responses.GET,
            'https://jira.example.com/rest/api/1.0/myself',
            json={'errors': []},
            status=401
        )
        assert service.validate_credentials() == False

    @responses.activate
    def test_fetch_projects(self):
        service = JiraService('https://jira.example.com', 'user', 'key')
        projects_response = [
            {'id': '10001', 'key': 'PROJ1', 'name': 'Project 1'},
            {'id': '10002', 'key': 'PROJ2', 'name': 'Project 2'}
        ]
        responses.add(
            responses.GET,
            'https://jira.example.com/rest/api/2/project',
            json=projects_response,
            status=200
        )
        result = service.get_projects()
        assert len(result) == 2
        assert result[0]['key'] == 'PROJ1'

    @responses.activate
    def test_fetch_projects_error_handling(self):
        service = JiraService('https://jira.example.com', 'user', 'key')
        responses.add(
            responses.GET,
            'https://jira.example.com/rest/api/2/project',
            body='Internal Server Error',
            status=500
        )
        with pytest.raises(Exception):
            service.get_projects()
