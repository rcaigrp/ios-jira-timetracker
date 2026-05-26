import Foundation

class Persistence {
    static let shared = Persistence()
    private let storageKey = "timerEntries"
    
    func saveEntries(_ entries: [TimeIntervalEntry]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(entries) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    func loadEntries() -> [TimeIntervalEntry] {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let entries = try? JSONDecoder().decode([TimeIntervalEntry].self, from: data) {
            return entries
        }
        return []
    }
}

struct TimeIntervalEntry: Codable {
    var id: String
    var project: String
    var date: String
    var startTime: String
    var endTime: String
    var duration: TimeInterval
    var notes: String?
}
