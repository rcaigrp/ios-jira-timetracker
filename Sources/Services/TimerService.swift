import Foundation
import Combine

class TimerService: ObservableObject {
    @Published var isRunning: Bool = false
    @Published var elapsedTime: TimeInterval = 0
    @Published var currentEntry: TimeEntry?
    
    private var timer: Timer?
    private var startTime: Date?
    
    init() {
        loadState()
    }
    
    func startTimer(project: String) {
        if isRunning { return }
        isRunning = true
        startTime = Date()
        currentEntry = TimeEntry(project: project, startTime: startTime!)
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self, let startTime = self.startTime else { return }
            self.elapsedTime = Date().timeIntervalSince(startTime)
        }
        saveState()
    }
    
    func stopTimer() {
        if !isRunning { return }
        isRunning = false
        timer?.invalidate()
        timer = nil
        if let entry = currentEntry, let startTime = startTime {
            let endTime = Date()
            currentEntry = TimeEntry(
                id: entry.id,
                project: entry.project,
                date: entry.date,
                startTime: startTime,
                endTime: endTime,
                duration: endTime.timeIntervalSince(startTime)
            )
        }
        saveState()
    }
    
    private func saveState() {
        if let entry = currentEntry {
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(entry) {
                UserDefaults.standard.set(data, forKey: "CurrentEntry")
            }
        }
        UserDefaults.standard.set(isRunning, forKey: "IsRunning")
    }
    
    private func loadState() {
        if let data = UserDefaults.standard.data(forKey: "CurrentEntry") {
            let decoder = JSONDecoder()
            self.currentEntry = try? decoder.decode(TimeEntry.self, from: data)
        }
        self.isRunning = UserDefaults.standard.bool(forKey: "IsRunning")
    }
}
