import Foundation
import Combine
import UIKit

class TimerViewModel: ObservableObject {
    @Published var elapsed: TimeInterval = 0
    @Published var isRunning: Bool = false
    
    private var timer: Timer?
    private var startDate: Date?
    private var backgroundObserver: Any?
    private var wasRunning: Bool = false
    
    init() {
        loadState()
        setupBackgroundObserver()
    }
    
    private func setupBackgroundObserver() {
        backgroundObserver = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { _ in
            if self.isRunning {
                self.pause()
                self.wasRunning = true
            }
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: nil) { _ in
            if self.wasRunning {
                self.resume()
                self.wasRunning = false
            }
        }
    }
    
    func start() {
        isRunning = true
        startDate = Date()
        startTimer()
    }
    
    func pause() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    func resume() {
        isRunning = true
        startDate = Date()
        startTimer()
    }
    
    func stop() {
        isRunning = false
        timer?.invalidate()
        timer = nil
        saveState()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if let startDate = self.startDate {
                self.elapsed = Date().timeIntervalSince(startDate)
            }
        }
    }
    
    private func loadState() {
        if let savedDate = UserDefaults.standard.object(forKey: "timerStartDate") as? Date {
            self.startDate = savedDate
            self.elapsed = Date().timeIntervalSince(savedDate)
            self.isRunning = true
        }
    }
    
    private func saveState() {
        if isRunning {
            UserDefaults.standard.set(startDate, forKey: "timerStartDate")
        } else {
            UserDefaults.standard.removeObject(forKey: "timerStartDate")
        }
    }
    
    deinit {
        if let observer = backgroundObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}