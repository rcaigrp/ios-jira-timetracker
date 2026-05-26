import Foundation

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var displayTime = "00:00"
    @Published var isRunning = false
    @Published var projectName = ""
    @Published var projects: [Project] = []
    
    private var timer: Timer?
    
    func startTimer() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.displayTime = "00:01" // Mock update
        }
    }
    
    func stopTimer() {
        isRunning = false
        timer?.invalidate()
    }
    
    func addManualEntry() {
        let project = Project(id: UUID().uuidString, name: projectName)
        projects.append(project)
        projectName = ""
    }
}

struct Project: Identifiable, Codable {
    let id: String
    let name: String
}
