import Foundation

struct TimeEntry: Codable, Identifiable, Hashable {
    var id: UUID
    var project: String
    var date: Date
    var startTime: Date
    var endTime: Date?
    var duration: TimeInterval
    var notes: String?
    
    init(id: UUID = UUID(), project: String, date: Date = Date(), startTime: Date, endTime: Date? = nil, duration: TimeInterval = 0, notes: String? = nil) {
        self.id = id
        self.project = project
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.duration = duration
        self.notes = notes
    }
    
    var isRunning: Bool {
        return endTime == nil
    }
}
