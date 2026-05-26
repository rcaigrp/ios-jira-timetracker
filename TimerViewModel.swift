import Foundation
import Combine

class TimerViewModel: ObservableObject {
    @Published var isRunning: Bool = false
    @Published var elapsedTime: TimeInterval = 0
    @Published var startDate: Date?
    
    func startTimer() {
        isRunning = true
        startDate = Date()
    }
    
    func pauseTimer() {
        isRunning = false
    }
    
    func stopTimer() {
        isRunning = false
        elapsedTime = 0
        startDate = nil
    }
}
