import pytest
import json
import os
import responses
from timer_manager import TimerManager
from jira_sync_service import JiraSyncService

TEST_DATA_FILE = "test_timer_data.json"

@pytest.fixture
def timer_manager():
    tm = TimerManager(data_file=TEST_DATA_FILE)
    tm.running = False
    tm.start_time = None
    tm.elapsed = 0
    tm.save_state()
    yield tm
    if os.path.exists(TEST_DATA_FILE):
        os.remove(TEST_DATA_FILE)

def test_timer_start_persistence(timer_manager):
    timer_manager.start()
    assert timer_manager.running is True
    assert timer_manager.start_time is not None
    with open(TEST_DATA_FILE) as f:
        state = json.load(f)
    assert state['running'] is True
    assert state['start_time'] is not None

def test_timer_pause_resume(timer_manager):
    timer_manager.start()
    import time
    time.sleep(0.1)
    timer_manager.pause()
    assert timer_manager.running is False
    assert timer_manager.elapsed > 0
    timer_manager.save_state()
    
    tm2 = TimerManager(data_file=TEST_DATA_FILE)
    assert tm2.running is False
    assert tm2.elapsed > 0

@responses.activate
def test_jira_sync_service_get_projects():
    responses.add(
        responses.GET,
        "https://example.atlassian.net/rest/api/latest/project",
        body=json.dumps([{"id": "1", "name": "TestProject"}]),
        status=200
    )
    service = JiraSyncService("https://example.atlassian.net", "user", "key")
    result = service.get_projects()
    assert len(result) == 1
    assert result[0]['name'] == "TestProject"
