import Foundation

class JiraService {
    static let shared = JiraService()
    private var baseUrl: String = ""
    private var username: String = ""
    private var apiKey: String = ""
    
    func configure(baseUrl: String, username: String, apiKey: String) {
        self.baseUrl = baseUrl
        self.username = username
        self.apiKey = apiKey
    }
    
    func fetchProjects() async throws -> [Project] {
        guard !baseUrl.isEmpty && !username.isEmpty && !apiKey.isEmpty else {
            throw URLError.missingCredentials
        }
        return []
    }
    
    func fetchIssues() async throws -> [Issue] {
        guard !baseUrl.isEmpty && !username.isEmpty && !apiKey.isEmpty else {
            throw URLError.missingCredentials
        }
        return []
    }
}

struct Project: Codable, Identifiable {
    var id: String
    var name: String
}

struct Issue: Codable, Identifiable {
    var id: String
    var summary: String
}
