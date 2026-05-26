import Foundation

class AppViewModel: ObservableObject {
    @Published var entries: [Entry] = []
    
    init() {
        loadEntries()
    }
    
    func addEntry(_ entry: Entry) {
        entries.append(entry)
        saveEntries()
    }
    
    private func saveEntries() {
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: "entries")
        }
    }
    
    private func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: "entries"), let decoded = try? JSONDecoder().decode([Entry].self, from: data) {
            entries = decoded
        }
    }
}

struct Entry: Codable, Identifiable {
    var id: String = UUID().uuidString
    var project: String
    var date: String
    var startTime: String
    var endTime: String
    var duration: TimeInterval
    var notes: String?
}
