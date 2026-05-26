import Foundation

class PersistenceManager {
    static let shared = PersistenceManager()
    let defaults = UserDefaults.standard
    
    // Timer Keys
    let timerStartDateKey = "timer_start_date"
    let timerElapsedKey = "timer_elapsed"
    let timerRunningKey = "timer_is_running"
    
    // Settings Keys
    let settingsBaseUrlKey = "jira_base_url"
    let settingsUsernameKey = "jira_username"
    let settingsApiKeyKey = "jira_api_key"
    
    private init() {}
    
    func saveTimerState(startDate: Date? = nil, elapsedSeconds: Double = 0, isRunning: Bool = false) {
        if let startDate = startDate {
            defaults.set(startDate, forKey: timerStartDateKey)
        }
        defaults.set(elapsedSeconds, forKey: timerElapsedKey)
        defaults.set(isRunning, forKey: timerRunningKey)
    }
    
    func loadTimerState() -> (startDate: Date?, elapsedSeconds: Double, isRunning: Bool) {
        let startDate = defaults.object(forKey: timerStartDateKey) as? Date
        let elapsedSeconds = defaults.double(forKey: timerElapsedKey)
        let isRunning = defaults.bool(forKey: timerRunningKey)
        return (startDate, elapsedSeconds, isRunning)
    }
    
    func clearTimer() {
        defaults.removeObject(forKey: timerStartDateKey)
        defaults.removeObject(forKey: timerElapsedKey)
        defaults.removeObject(forKey: timerRunningKey)
    }
    
    // Settings
    func saveSettings(baseUrl: String? = nil, username: String? = nil, apiKey: String? = nil) {
        if let baseUrl = baseUrl {
            defaults.set(baseUrl, forKey: settingsBaseUrlKey)
        }
        if let username = username {
            defaults.set(username, forKey: settingsUsernameKey)
        }
        if let apiKey = apiKey {
            defaults.set(apiKey, forKey: settingsApiKeyKey)
        }
    }
    
    func loadSettings() -> (baseUrl: String?, username: String?, apiKey: String?) {
        let baseUrl = defaults.string(forKey: settingsBaseUrlKey)
        let username = defaults.string(forKey: settingsUsernameKey)
        let apiKey = defaults.string(forKey: settingsApiKeyKey)
        return (baseUrl, username, apiKey)
    }
}
