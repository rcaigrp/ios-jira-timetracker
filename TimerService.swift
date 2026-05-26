import Foundation
import UIKit

class TimerService: ObservableObject {
    @Published var elapsed: TimeInterval = 0
    @Published var isRunning: Bool = false
    
    private var startTime: Date?
    private var pausedTime: TimeInterval = 0
    
    init() {
        loadState()
        observeNotifications()
    }
    
    func start() {
        startTime = Date()
        isRunning = true
        saveState()
    }
    
    func pause() {
        if let start = startTime {
            pausedTime = elapsed + Date().timeIntervalSince(start)
        }
        isRunning = false
        saveState()
    }
    
    func resume() {
        startTime = Date()
        isRunning = true
        saveState()
    }
    
    func stop() {
        if let start = startTime {
            let duration = Date().timeIntervalSince(start)
            let entry = TimeEntry(project: "Manual", startTime: start, endTime: Date(), duration: duration, notes: "")
            saveEntry(entry)
        }
        startTime = nil
        pausedTime = 0
        elapsed = 0
        isRunning = false
        saveState()
    }
    
    private func loadState() {
        let state = UserDefaults.standard.dictionary(forKey: "timer_state") as? [String: Any]
        if let startTimestamp = state?["startTime"] as? Double, state?["isRunning"] as? Bool == true {
            startTime = Date.init(timeIntervalSinceReferenceDate: startTimestamp)
            isRunning = true
            elapsed = Date().timeIntervalSince(startTime!)
        } else if let paused = state?["pausedTime"] as? TimeInterval {
            pausedTime = paused
        }
    }
    
    private func saveState() {
        var state: [String: Any] = ["isRunning": isRunning]
        if let start = startTime {
            state["startTime"] = start.timeIntervalSinceReferenceDate
        }
        state["pausedTime"] = pausedTime
        UserDefaults.standard.set(state, forKey: "timer_state")
    }
    
    private func saveEntry(_ entry: TimeEntry) {
        var entries = UserDefaults.standard.array(forKey: "time_entries") as? [TimeEntry] ?? []
        entries.append(entry)
        UserDefaults.standard.set(entries, forKey: "time_entries")
    }
    
    private func observeNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleBackground),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }
    
    @objc func handleBackground() {
        if isRunning {
            pause()
        }
    }
    
    @objc func handleForeground() {
        // Logic handled by pause/resume
    }
}

struct TimeEntry: Codable {
    let project: String
    let startTime: Date
    let endTime: Date
    let duration: TimeInterval
    let notes: String
}
