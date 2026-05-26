import Foundation

class TimerManager {
    static let shared = TimerManager()
    private var isRunning = false
    private var startTime: Date?
    private var pausedDuration: TimeInterval = 0
    private var totalPausedTime: TimeInterval = 0
    
    private let storageKey = "TimerState"
    
    init() {
        self.loadState()
    }
    
    private func saveState() {
        let state = [
            "isRunning": isRunning,
            "startTime": startTime?.timeIntervalSince1970,
            "pausedDuration": pausedDuration,
            "totalPausedTime": totalPausedTime
        ]
        UserDefaults.standard.set(state, forKey: storageKey)
    }
    
    private func loadState() {
        if let state = UserDefaults.standard.dictionary(forKey: storageKey) {
            isRunning = state["isRunning"] as? Bool ?? false
            startTime = state["startTime"] != nil ? Date(timeIntervalSince1970: state["startTime"] as! TimeInterval) : nil
            pausedDuration = state["pausedDuration"] as? TimeInterval ?? 0
            totalPausedTime = state["totalPausedTime"] as? TimeInterval ?? 0
        }
    }
    
    func start() {
        isRunning = true
        startTime = Date()
        pausedDuration = 0
        saveState()
    }
    
    func pause() {
        if isRunning {
            let elapsed = Date().timeIntervalSince(self.startTime ?? Date())
            pausedDuration += elapsed
            isRunning = false
            saveState()
        }
    }
    
    func resume() {
        if !isRunning {
            startTime = Date()
            isRunning = true
            saveState()
        }
    }
    
    func stop() {
        isRunning = false
        startTime = nil
        pausedDuration = 0
        totalPausedTime = 0
        saveState()
    }
    
    func toggle() {
        if isRunning {
            pause()
        } else {
            resume()
        }
    }
    
    func getElapsed() -> TimeInterval {
        if isRunning {
            let currentElapsed = Date().timeIntervalSince(startTime ?? Date())
            return pausedDuration + currentElapsed
        }
        return pausedDuration
    }
    
    func getFormattedTime() -> String {
        let totalSeconds = Int(getElapsed())
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func isRunningState() -> Bool {
        isRunning
    }
}
