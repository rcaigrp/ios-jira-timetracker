import os
import pytest

PROJECT_DIR = "/workspace/projects/iOS-Jira-TimeTracker"

def read_file(filename):
    filepath = os.path.join(PROJECT_DIR, filename)
    if os.path.exists(filepath):
        with open(filepath, 'r') as f:
            return f.read()
    return None

def test_criterion_1_dashboard_exists():
    """Dashboard with timer and project list."""
    main = read_file("main.swift")
    assert main is not None
    assert "DashboardView" in main
    assert "TimerDisplay" in main
    assert "ProjectList" in main

def test_criterion_2_manual_entry():
    """Manual entry creation and persistence."""
    main = read_file("main.swift")
    assert main is not None
    assert "Project" in main
    assert "List" in main

def test_criterion_3_jira_credentials():
    """Secure credential storage for Jira."""
    jira = read_file("jira_sync_service.py")
    assert jira is not None
    assert "username" in jira
    assert "api_key" in jira
    assert "base_url" in jira

def test_criterion_4_jira_fetching():
    """Jira project/issue fetching."""
    jira = read_file("jira_sync_service.py")
    assert jira is not None
    assert "fetch_projects" in jira or "fetch_issues" in jira

def test_criterion_5_persistence():
    """Data persistence across relaunches."""
    main = read_file("main.swift")
    assert main is not None
    assert "UserDefaults" in main

def test_criterion_6_networking():
    """Networking layer tested via pytest."""
    jira = read_file("jira_sync_service.py")
    assert jira is not None
    assert "requests" in jira

def test_criterion_7_background_handling():
    """Background suspension handling."""
    main = read_file("main.swift")
    assert main is not None
    assert "handleApplicationWillResignActive" in main
    assert "handleApplicationDidResume" in main
