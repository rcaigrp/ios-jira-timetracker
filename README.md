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
- `TimerManager.swift`: Manages timer lifecycle, state persistence, and resume logic.
- `ProjectModel.swift`: Defines Project model and ProjectStore for CRUD/JSON persistence.
- `DashboardView.swift`: Main SwiftUI view integrating timer, controls, and project list.
- `acceptance_tests.py`: Pytest suite for networking and data validation.

## Status
Active. Meeting 2 completed. Dashboard UI and core logic implemented.