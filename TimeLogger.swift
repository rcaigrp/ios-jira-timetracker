import Foundation

class TimeLogger {
    var startTime: Date?
    var elapsedTime: TimeInterval = 0

    func start() {
        startTime = Date()
        elapsedTime = 0
    }

    func stop() -> TimeInterval {
        if let start = startTime {
            elapsedTime += Date().timeIntervalSince(start)
            startTime = nil
        }
        return elapsedTime
    }

    func getElapsed() -> TimeInterval {
        if let start = startTime {
            return elapsedTime + Date().timeIntervalSince(start)
        }
        return elapsedTime
    }
}