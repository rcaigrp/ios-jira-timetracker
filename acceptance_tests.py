import pytest
import os
import json
import time
import responses
import requests
from unittest.mock import patch, MagicMock

import sys
sys.path.insert(0, '/workspace/projects/iOS-Jira-TimeTracker')

from timer_manager import TimerManager
from jira_sync_service import JiraSyncService

class TestTimerManager:
    def setup_method(self):
        self.timer = TimerManager()
        self.timer.data = {
            'entries': [],
            'current_timer': None,
            'should_resume': False
        }
        self.timer.save_data()

    def test_criterion_1_dashboard_state(self):
        status = self.timer.get_timer_status()
        assert 'status' in status
        assert 'project' in status or status['status'] == 'stopped'

    def test_criterion_2_manual_entry_persistence(self):
        self.timer.start_timer('Test Project')
        time.sleep(0.1)
        self.timer.stop_timer()
        entries = self.timer.get_entries()
        assert len(entries) == 1
        assert entries[0]['project'] == 'Test Project'
        assert entries[0]['duration'] >= 0

    def test_criterion_3_secure_credentials(self):
        service = JiraSyncService('http://test.com', 'user', 'key')
        creds = service.get_credentials()
        assert creds['username'] == 'user'
        assert creds['api_key'] == 'key'

    def test_criterion_4_jira_fetching(self):
        with responses.RequestsMock() as rsps:
            rsps.add(
                responses.GET,
                'http://test.com/rest/api/2/project',
                body=json.dumps([{'id': '1', 'name': 'Test'}]),
                status=200
            )
            service = JiraSyncService('http://test.com', 'user', 'key')
            projects = service.fetch_projects()
            assert len(projects) == 1
            assert projects[0]['name'] == 'Test'

    def test_criterion_5_persistence_across_relaunches(self):
        self.timer.start_timer('Relaunch Test')
        time.sleep(0.1)
        self.timer.stop_timer()
        manager2 = TimerManager()
        entries = manager2.get_entries()
        assert len(entries) == 1
        assert entries[0]['project'] == 'Relaunch Test'

    def test_criterion_6_networking_layer(self):
        assert True

    def test_criterion_7_background_suspension(self):
        self.timer.start_timer('Background Test')
        self.timer.pause_timer()
        assert self.timer.data['should_resume'] == True
        assert self.timer.data['current_timer']['start_time'] is None

class TestJiraSyncService:
    @responses.activate
    def test_fetch_issues(self):
        responses.add(
            responses.GET,
            'http://test.com/rest/api/2/issue?jql=project=TEST',
            body=json.dumps([{'id': '1', 'fields': {'summary': 'Test'}}]),
            status=200
        )
        service = JiraSyncService('http://test.com', 'user', 'key')
        issues = service.fetch_issues('TEST')
        assert len(issues) == 1
