from timer_manager import TimerManager
from jira_sync_service import JiraSyncService
from settings_manager import SettingsManager

def main():
    timer = TimerManager()
    settings = SettingsManager()
    base_url, username, api_key = settings.get_credentials()

    if base_url and username and api_key:
        jira_service = JiraSyncService(base_url, username, api_key)
        try:
            projects = jira_service.fetch_projects()
            print("Projects fetched successfully:", len(projects))
        except Exception as e:
            print("Failed to fetch projects:", e)

    print("Timer state:", timer.get_elapsed())

if __name__ == '__main__':
    main()
