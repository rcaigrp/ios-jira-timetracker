import Foundation

class JiraService {
    static let shared = JiraService()
    private let session = URLSession.shared
    
    func fetchProjects(completion: @escaping ([String]) -> Void) {
        guard let creds = KeychainHelper.loadCredential() else {
            completion([])
            return
        }
        
        let url = URL(string: "\(creds.baseURL)/rest/api/2/project")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setBasicAuth(username: creds.username, apiKey: creds.apiKey)
        
        session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion([])
                return
            }
            do {
                let projects = try JSONDecoder().decode([Project].self, from: data)
                completion(projects.map { $0.name })
            } catch {
                completion([])
            }
        }.resume()
    }
}

extension URLRequest {
    func setBasicAuth(username: String, apiKey: String) -> URLRequest {
        let credentialData = Data((username + ":" + apiKey).utf8)
        let base64EncodedCredentials = credentialData.base64EncodedString()
        self.setValue("Basic \(base64EncodedCredentials)", forHTTPHeaderField: "Authorization")
        return self
    }
}

struct Project: Codable {
    let name: String
}
