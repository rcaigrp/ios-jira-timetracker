import Foundation

class ProjectService {
    static let shared = ProjectService()
    private let storageKey = "ProjectEntries"
    
    func getEntries() -> [ProjectEntry] {
        if let data = UserDefaults.standard.data(forKey: storageKey) {
            do {
                let decoder = JSONDecoder()
                return try decoder.decode([ProjectEntry].self, from: data)
            } catch {
                return []
            }
        }
        return []
    }
    
    func saveEntry(_ entry: ProjectEntry) {
        var entries = getEntries()
        entries.append(entry)
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
    
    func clearEntries() {
        UserDefaults.standard.removeObject(forKey: storageKey)
    }
}
