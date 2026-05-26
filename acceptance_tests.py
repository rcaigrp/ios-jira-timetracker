import pytest
import responses
from jira_sync_service import JiraService


@pytest.fixture
def jira_service():
    return JiraService("https://test.jira.com", "user", "token")


@responses.activate
def test_criterion_6_successful_fetch(h)
