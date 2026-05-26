import pytest
import responses
from jira_sync_service import JiraService

@pytest.fixture
def service():
    return JiraService('https://jira.example.com', 'user', 'token')

@responses.activate
def test_fetch_projects(service):
    responses.add(
        responses.GET,
        'https://jira.example.com/rest/api/2/project',
        json=[{'id': '1', 'name': 'TestProject'}],
        status=200
    )
    result = service.fetch_projects()
    assert len(result) == 1
    assert result[0]['name'] == 'TestProject'

@responses.activate
def test_fetch_issues(service):
    responses.add(
        responses.GET,
        'https://jira.example.com/rest/api/2/search',
        json={'issues': [{'id': '1', 'fields': {'summary': 'Bug'}}]},
        status=200
    )
    result = service.fetch_issues('TP')
    assert len(result['issues']) == 1
    assert result['issues'][0]['fields']['summary'] == 'Bug'

@responses.activate
def test_fetch_projects_error(service):
    responses.add(
        responses.GET,
        'https://jira.example.com/rest/api/2/project',
        json={'error': 'Unauthorized'},
        status=401
    )
    with pytest.raises(Exception) as exc:
        service.fetch_projects()
    assert 'HTTP Error' in str(exc)
