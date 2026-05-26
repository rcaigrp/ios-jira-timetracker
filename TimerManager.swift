import Foundation

extension Int {
    var formattedDuration: String {
        let minutes = self / 60
        let seconds = self % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

@MainActor
class TimerManager: ObservableObject {
    @Published var isRunning: Bool = false
    @Published var elapsedSeconds: Int = 0
    @Published var startTime: Date?
    
    private var timer: Timer?
    
    func startTimer() {
        self.isRunning = true
        self.startTime = Date()
        self.elapsedSeconds = 0
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            if let self = self {
                self.elapsedSeconds = Int(Date().timeIntervalSince(self.startTime!))
            }
        }
    }
    
    func pauseTimer() {
        self.isRunning = false
        self.timer?.invalidate()
        self.timer = nil
        if let start = self.startTime {
            UserDefaults.standard.set(start, forKey: "timer_start_time")
            UserDefaults.standard.set(self.elapsedSeconds, forKey: "timer_elapsed_seconds")
        }
    }
    
    func stopTimer() {
        self.isRunning = false
        self.timer?.invalidate()
        self.timer = nil
        UserDefaults.standard.set(nil, forKey: "timer_start_time")
        UserDefaults.standard.set(0, forKey: "timer_elapsed_seconds")
    }
    
    func resumeTimer() {
        if let savedStart = UserDefaults.standard.object(forKey: "timer_start_time") as? Date {
            self.startTime = savedStart
            self.isRunning = true
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                if let self = self {
                    self.elapsedSeconds = Int(Date().timeIntervalSince(self.startTime!))
                }
            }
        }
    }
}