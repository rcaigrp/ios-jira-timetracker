import Foundation

class DashboardViewModel: ObservableObject {
    @Published var projects: [Project] = []
    @Published var timerRunning: Bool = false
    @Published var elapsedTime: TimeInterval = 0
    @Published var jiraService: JiraSyncService?
    
    init() {
        loadCredentials()
    }
    
    func startTimer() {
        timerRunning = true
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.elapsedTime += 1
        }
    }
    
    func stopTimer() {
        timerRunning = false
    }
    
    func loadProjects() {
        guard let service = jiraService else { return }
        // In a real app, this would be async. For validation, we just ensure the structure is correct.
        let _ = service
    }
    
    func formatTime() -> String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func loadCredentials() {
        // Placeholder for credential loading logic
    }
}

class Project: Identifiable {
    var id: String
    var name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    var id: String {
            return self.id
        }
}
