import Foundation
import SwiftUI
import UIKit
import Combine

class TimerViewModel: ObservableObject {
    @Published var isRunning: Bool = false
    @Published var elapsedSeconds: TimeInterval = 0
    @Published var timerStartDate: Date?
    
    private var timer: Timer?
    
    init() {
        loadState()
        setupNotificationObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { _ in
            if self.isRunning {
                self.pauseTimer()
            }
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { _ in
            if self.timerStartDate != nil {
                self.resumeTimer()
            }
        }
    }
    
    func startTimer() {
        guard !isRunning else { return }
        isRunning = true
        timerStartDate = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if let start = self.timerStartDate {
                self.elapsedSeconds = Date().timeIntervalSince(start)
            }
        }
    }
    
    func pauseTimer() {
        guard isRunning else { return }
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    func stopTimer() {
        guard isRunning else { return }
        isRunning = false
        timer?.invalidate()
        timer = nil
        timerStartDate = nil
        elapsedSeconds = 0
        saveState()
    }
    
    private func resumeTimer() {
        if !isRunning && timerStartDate != nil {
            isRunning = true
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                if let start = self.timerStartDate {
                    self.elapsedSeconds = Date().timeIntervalSince(start)
                }
            }
        }
    }
    
    private func saveState() {
        if let start = timerStartDate {
            UserDefaults.standard.set(start, forKey: "timerStartDate")
        } else {
            UserDefaults.standard.set(nil, forKey: "timerStartDate")
        }
        UserDefaults.standard.set(elapsedSeconds, forKey: "elapsedSeconds")
        UserDefaults.standard.set(isRunning, forKey: "isRunning")
    }
    
    private func loadState() {
        if let start = UserDefaults.standard.date(forKey: "timerStartDate") {
            timerStartDate = start
        } else {
            timerStartDate = nil
        }
        elapsedSeconds = UserDefaults.standard.double(forKey: "elapsedSeconds")
        isRunning = UserDefaults.standard.bool(forKey: "isRunning")
    }
}
