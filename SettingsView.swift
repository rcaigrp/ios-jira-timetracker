import SwiftUI
import Security

struct SettingsView: View {
    @State private var baseUrl = ""
    @State private var username = ""
    @State private var apiToken = ""
    @State private var saved = false
    
    var saveCredentials: (String, String, String) -> Void
    
    init(saveCredentials: @escaping (String, String, String) -> Void) {
        self.saveCredentials = saveCredentials
        let (url, user, token) = KeychainHelper.loadJiraCredentials()
        self._baseUrl = State(initialValue: url)
        self._username = State(initialValue: user)
        self._apiToken = State(initialValue: token)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Jira Configuration")) {
                TextField("Base URL", text: $baseUrl)
                TextField("Username", text: $username)
                SecureField("API Token", text: $apiToken)
            }
            
            Button("Save Credentials") {
                saveCredentials(baseUrl, username, apiToken)
                saved = true
            }
            
            if saved {
                Text("Credentials Saved")
                    .foregroundColor(.green)
            }
        }
    }
}

struct KeychainHelper {
    static func save(url: String, username: String, token: String) {
        save(value: url, key: "jira_url")
        save(value: username, key: "jira_username")
        save(value: token, key: "jira_token")
    }
    
    static func save(value: String, key: String) {
        let data = value.data(using: .utf8)!
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ]
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSuccess {
            print("Saved to keychain")
        }
    }
    
    static func loadJiraCredentials() -> (String, String, String) {
        return (
            retrieveValue(for: "jira_url"),
            retrieveValue(for: "jira_username"),
            retrieveValue(for: "jira_token")
        )
    }
    
    static func retrieveValue(for key: String) -> String {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecReturnAttributes: true
        ]
        
        var itemRef: CFMutableDictionary?
        let status = SecItemCopyMatching(query as CFDictionary, &itemRef)
        guard status == errSuccess, let result = itemRef as? [String: Any],
              let data = result[kSecValueData as String] as? Data else {
            return ""
        }
        return String(data: data, encoding: .utf8) ?? ""
    }
}
