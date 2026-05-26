# iOS Jira Time Tracker

## Goal
Build a native iOS application that enables users to track time spent on development projects through both manual entries and seamless Jira integration via configured API endpoints.

## Acceptance Criteria
1. Dashboard with timer and project list.
2. Manual entry creation and persistence.
3. Secure credential storage for Jira.
4. Jira project/issue fetching.
5. Data persistence across relaunches.
6. Networking layer tested via pytest.
7. Background suspension handling.

## Structure
- `timer_manager.py`: Python module for timer state management and persistence.
- `jira_sync_service.py`: Python module for Jira API communication.
- `acceptance_tests.py`: Pytest tests for networking and data layers.
- Swift files: UI and logic implementation.

## Status
Active. Meeting 2 completed. All acceptance criteria tests passed.
