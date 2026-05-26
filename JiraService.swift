import Foundation

struct JiraProject: Codable {
    let id: String
    let name: String
}

struct JiraService {
    static func fetchProjects(baseURL: String, username: String, apiToken: String) -> [JiraProject] {
        guard let url = URL(string: "\(baseURL)/rest/api/2/project") else { return [] }
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Basic Auth
        let credentials = "\(username):\(apiToken)".data(using: .utf8)!
        let base64EncodedCredentials = credentials.base64EncodedString()
        request.setValue("Bearer \(base64EncodedCredentials)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, _) = try await session.data(for: request)
            let projects = try JSONDecoder().decode([JiraProject].self, from: data)
            return projects
        } catch {
            return []
        }
    }
}
