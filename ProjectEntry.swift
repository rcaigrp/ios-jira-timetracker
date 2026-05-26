import Foundation

struct ProjectEntry: Codable {
    var id: String
    var project: String
    var date: String
    var startTime: String
    var endTime: String
    var duration: TimeInterval
    var notes: String
}
