import os
import pytest

def test_criterion_1_dashboard_exists():
    main_swift = "/workspace/projects/iOS-Jira-TimeTracker/main.swift"
    assert os.path.exists(main_swift)
    with open(main_swift, "r") as f:
        content = f.read()
    assert "DashboardView" in content

def test_criterion_2_timer_controls():
    main_swift = "/workspace/projects/iOS-Jira-TimeTracker/main.swift"
    with open(main_swift, "r") as f:
        content = f.read()
    assert "toggleTimer" in content

def test_criterion_3_project_list():
    main_swift = "/workspace/projects/iOS-Jira-TimeTracker/main.swift"
    with open(main_swift, "r") as f:
        content = f.read()
    assert "ProjectList" in content

def test_criterion_4_jira_integration_stub():
    jira_file = "/workspace/projects/iOS-Jira-TimeTracker/jira_sync_service.py"
    assert os.path.exists(jira_file)

def test_criterion_5_persistence():
    main_swift = "/workspace/projects/iOS-Jira-TimeTracker/main.swift"
    with open(main_swift, "r") as f:
        content = f.read()
    assert "UserDefaults" in content

def test_criterion_6_networking():
    jira_file = "/workspace/projects/iOS-Jira-TimeTracker/jira_sync_service.py"
    with open(jira_file, "r") as f:
        content = f.read()
    assert "JiraService" in content

def test_criterion_7_background():
    main_swift = "/workspace/projects/iOS-Jira-TimeTracker/main.swift"
    with open(main_swift, "r") as f:
        content = f.read()
    assert "NotificationCenter" in content
