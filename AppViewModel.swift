import Foundation

struct TimeEntry: Identifiable, Codable {
    let id: String
    let project: String
    let date: String
    let duration: TimeInterval
    let notes: String
}

class AppViewModel: ObservableObject {
    @Published var entries: [TimeEntry] = []
    
    init() {
        loadEntries()
    }
    
    func addEntry(project: String, date: String, notes: String) {
        let entry = TimeEntry(
            id: UUID().uuidString,
            project: project,
            date: date,
            duration: 0,
            notes: notes
        )
        entries.append(entry)
        saveEntries()
    }
    
    private func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: "timeEntries"), let entries = try? JSONDecoder().decode([TimeEntry].self, from: data) {
            self.entries = entries
        }
    }
    
    private func saveEntries() {
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: "timeEntries")
        }
    }
}