import pytest
import json
import os
import time
import responses
import sys
sys.path.append('/workspace/projects/iOS-Jira-TimeTracker')

from jira_sync_service import JiraSyncService
from timer_manager import TimerManager

@pytest.fixture
def timer_manager():
    path = "test_timer_data.json"
    if os.path.exists(path):
        os.remove(path)
    tm = TimerManager(path)
    yield tm
    if os.path.exists(path):
        os.remove(path)

def test_criterion_5_persistence(timer_manager):
    """Criterion 5: All timer data and project entries persist across app relaunches."""
    timer_manager.start("Project A")
    time.sleep(0.5)
    timer_manager.pause()
    
    # Simulate relaunch
    tm2 = TimerManager("test_timer_data.json")
    assert tm2.project_name == "Project A"
    assert tm2.elapsed > 0
    assert tm2.running == False

def test_criterion_7_background_suspension(timer_manager):
    """Criterion 7: Gracefully handles iOS background suspension."""
    timer_manager.start("Project B")
    time.sleep(0.5)
    timer_manager.go_to_background()
    
    assert timer_manager.running == False
    assert timer_manager.paused_start is not None
    
    timer_manager.go_to_foreground()
    assert timer_manager.running == True

def test_criterion_6_networking_layer():
    """Criterion 6: Networking layer handles HTTP requests with mocked endpoints."""
    with responses.RequestsMock() as rsps:
        rsps.add(
            responses.GET,
            url="https://mock-jira.atlassian.net/rest/api/3/project",
            body=json.dumps([{"id": "100", "name": "TestProject"}]),
            status=200
        )
        
        service = JiraSyncService(base_url="https://mock-jira.atlassian.net", username="test", api_key="test")
        projects = service.get_projects()
        
        assert len(projects) == 1
        assert projects[0]["name"] == "TestProject"
