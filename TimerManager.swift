import Foundation

@MainActor
class TimerManager: ObservableObject {
    @Published var isRunning = false
    @Published var startTime: Date?
    @Published var elapsedTime: TimeInterval = 0
    
    func startTimer() {
        startTime = Date()
        isRunning = true
    }
    
    func pauseTimer() {
        isRunning = false
    }
    
    func resumeTimer() {
        isRunning = true
    }
    
    func stopTimer() -> Date {
        let endTime = Date()
        isRunning = false
        startTime = nil
        return endTime
    }
    
    var currentTime: Date? {
        if isRunning, let start = startTime {
            return Date(timeIntervalSinceNow: elapsedTime)
        }
        return nil
    }
    
    var formattedTime: String {
        guard let start = startTime else { return "00:00:00" }
        let elapsed = Date().timeIntervalSince(start)
        let minutes = Int(elapsed) / 60
        let seconds = Int(elapsed) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
