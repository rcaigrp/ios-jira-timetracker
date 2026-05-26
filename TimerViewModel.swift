import Foundation

class TimerViewModel: ObservableObject {
    @Published var isRunning = false
    @Published var elapsedSeconds: Double = 0
    @Published var startDate: Date?
    
    private var timer: Timer?
    private let persistence = PersistenceManager.shared
    
    init() {
        let state = persistence.loadTimerState()
        self.startDate = state.startDate
        self.elapsedSeconds = state.elapsedSeconds
        self.isRunning = state.isRunning
        
        if isRunning {
            startTimer()
        }
    }
    
    func startTimer() {
        if let startDate = startDate {
            let now = Date()
            let delta = now.timeIntervalSince(startDate)
            self.elapsedSeconds = delta + elapsedSeconds
        } else {
            self.startDate = Date()
            self.elapsedSeconds = 0
        }
        self.isRunning = true
        startTimer()
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            if let self = self {
                let now = Date()
                if let startDate = self.startDate {
                    self.elapsedSeconds = now.timeIntervalSince(startDate) + self.persistence.loadTimerState().elapsedSeconds
                }
            }
        }
        persistence.saveTimerState(startDate: startDate, elapsedSeconds: elapsedSeconds, isRunning: isRunning)
    }
    
    func pauseTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        persistence.saveTimerState(startDate: startDate, elapsedSeconds: elapsedSeconds, isRunning: false)
    }
    
    func resumeTimer() {
        startTimer()
        persistence.saveTimerState(startDate: startDate, elapsedSeconds: elapsedSeconds, isRunning: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        let now = Date()
        if let startDate = startDate {
            elapsedSeconds = now.timeIntervalSince(startDate) + elapsedSeconds
        }
        self.startDate = nil
        persistence.saveTimerState(startDate: nil, elapsedSeconds: elapsedSeconds, isRunning: false)
    }
}
