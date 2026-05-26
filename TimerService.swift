import Foundation

class TimerService: ObservableObject {
    @Published var isRunning = false
    @Published var totalElapsed: TimeInterval = 0
    @Published var currentStart: Date?
    
    private var backgroundObserver: NSNotification?
    private var foregroundObserver: NSNotification?
    
    init() {
        setupNotifications()
    }
    
    deinit {
        if let observer = backgroundObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        if let observer = foregroundObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    private func setupNotifications() {
        let nc = NotificationCenter.default
        backgroundObserver = nc.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { _ in
            if self.isRunning {
                self.pause()
            }
        }
        foregroundObserver = nc.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: nil) { _ in
            if !self.isRunning && self.currentStart == nil && self.totalElapsed > 0 {
                self.resume()
            }
        }
    }
    
    func start() {
        isRunning = true
        currentStart = Date()
        totalElapsed = 0
    }
    
    func pause() {
        if isRunning {
            isRunning = false
            if let start = currentStart {
                totalElapsed = Date().timeIntervalSince(start)
                currentStart = nil
            }
        }
    }
    
    func resume() {
        if !isRunning && currentStart == nil && totalElapsed > 0 {
            currentStart = Date().addingTimeInterval(-totalElapsed)
            isRunning = true
        } else if !isRunning && currentStart != nil {
            isRunning = true
        }
    }
    
    func stop() {
        isRunning = false
        if let start = currentStart {
            totalElapsed = Date().timeIntervalSince(start)
        }
        currentStart = nil
    }
}
