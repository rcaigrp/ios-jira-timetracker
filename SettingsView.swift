import SwiftUI

struct SettingsView: View {
    @State var username: String = ""
    @State var apiKey: String = ""
    @State var baseURL: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("Jira Credentials")) {
                TextField("Base URL", text: $baseURL)
                TextField("Username", text: $username)
                SecureField("API Key", text: $apiKey)
                
                Button("Save") {
                    KeychainHelper.saveCredential(username: username, apiKey: apiKey, baseURL: baseURL)
                }
            }
        }
    }
}
