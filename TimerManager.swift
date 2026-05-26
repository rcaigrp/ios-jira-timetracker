import Foundation

@MainActor
class TimerManager: ObservableObject {
    @Published var elapsedTime = "00:00"
    @Published var isRunning = false
    
    private var timer: Timer?
    private var startDate: Date?
    private var elapsed: TimeInterval = 0
    
    func start() {
        isRunning = true
        startDate = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateElapsed()
        }
    }
    
    func pause() {
        isRunning = false
        timer?.invalidate()
        timer = nil
        if let start = startDate {
            elapsed += Date().timeIntervalSince(start)
        }
        startDate = nil
    }
    
    func resume() {
        start()
    }
    
    func stop() {
        isRunning = false
        timer?.invalidate()
        timer = nil
        saveData()
    }
    
    private func updateElapsed() {
        if let start = startDate {
            let interval = Date().timeIntervalSince(start)
            let total = elapsed + interval
            elapsedTime = formatTime(total)
        }
    }
    
    private func saveData() {
        // Mock persistence
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
