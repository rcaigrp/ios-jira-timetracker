import Foundation
import Security

class KeychainHelper {
    static func saveCredential(username: String, apiKey: String, baseURL: String) {
        let dictionary: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "jira_creds",
            kSecValueData as String: JSONSerialization.data(withValue: [
                "username": username,
                "apiKey": apiKey,
                "baseURL": baseURL
            ])
        ]
        
        SecItemDelete(dictionary as CFDictionary)
        let status = SecItemAdd(dictionary as CFDictionary, nil)
        assert(status == errSecSuccess, "Failed to save credentials")
    }
    
    static func loadCredential() -> (username: String, apiKey: String, baseURL: String)? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "jira_creds",
            kSecReturnData as String: true,
            kSecReturnAttributes as String: true
        ]
        
        var item: CFMutableDictionary?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess, let data = item?["tdata"] as? Data else { return nil }
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String] else { return nil }
        return (json["username"]!, json["apiKey"]!, json["baseURL"]!)
    }
}
