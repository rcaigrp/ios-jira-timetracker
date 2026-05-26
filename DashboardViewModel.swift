import Foundation
import Combine

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var timerRunning: Bool = false
    @Published var elapsedTime: TimeInterval = 0
    @Published var startTime: Date?
    @Published var projects: [Project] = []
    @Published var currentProjectName: String = ""
    
    private var timerTask: Timer?
    
    struct Project: Identifiable, Codable {
        let id: UUID
        let name: String
        let startDate: Date
        let endDate: Date?
        let duration: TimeInterval
        
        init(name: String, startDate: Date, endDate: Date? = nil, duration: TimeInterval = 0) {
            self.id = UUID()
            self.name = name
            self.startDate = startDate
            self.endDate = endDate
            self.duration = duration
        }
    }
    
    func startTimer() {
        if !timerRunning {
            timerRunning = true
            startTime = Date()
            timerTask = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                if let start = self?.startTime {
                    self?.elapsedTime = Date().timeIntervalSince(start)
                }
            }
        }
    }
    
    func pauseTimer() {
        if timerRunning {
            timerRunning = false
            timerTask?.invalidate()
            timerTask = nil
        }
    }
    
    func stopTimer() {
        if let start = startTime {
            let duration = Date().timeIntervalSince(start)
            let newProject = Project(name: currentProjectName.isEmpty ? "Session" : currentProjectName, startDate: start, endDate: Date(), duration: duration)
            projects.append(newProject)
        }
        timerRunning = false
        elapsedTime = 0
        startTime = nil
        timerTask?.invalidate()
        timerTask = nil
    }
    
    func resumeTimer() {
        if elapsedTime > 0 && startTime != nil {
            startTime = Date().addingTimeInterval(-elapsedTime)
            timerTask = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                if let start = self?.startTime {
                    self?.elapsedTime = Date().timeIntervalSince(start)
                }
            }
            timerRunning = true
        }
    }
}