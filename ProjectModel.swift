import Foundation

struct Project: Identifiable, Codable {
    var id: String
    var name: String
    var startTime: Date
    var endTime: Date?
    var duration: TimeInterval
    var notes: String
    
    init(id: String = UUID().uuidString, name: String, startTime: Date, endTime: Date? = nil, duration: TimeInterval = 0, notes: String = "") {
        self.id = id
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
        self.duration = duration
        self.notes = notes
    }
    
    var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

class ProjectStore: ObservableObject {
    @Published var projects: [Project] = []
    
    init() {
        self.loadProjects()
    }
    
    private func loadProjects() {
        let savedData = UserDefaults.standard.data(forKey: "projects")
        if let data = savedData, let decoded = try? JSONDecoder().decode([Project].self, from: data) {
            self.projects = decoded
        }
    }
    
    func saveProjects() {
        if let data = try? JSONEncoder().encode(self.projects) {
            UserDefaults.standard.set(data, forKey: "projects")
        }
    }
    
    func addProject(_ project: Project) {
        self.projects.append(project)
        self.saveProjects()
    }
}